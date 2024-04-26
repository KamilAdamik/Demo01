########################################################################################################################
#!!
#! @input source_folder: The directory for which to get the children.
#! @input saw_url: The Service Management Automation X URL to make the request to.
#!                 Examples: scheme://{serverAddress}.
#! @input tenant_id: The OpenText SMAX tenant Id.
#! @input username: The user name used for authentication.
#! @input password: The password used for authentication.
#!!#
########################################################################################################################
namespace: LFV24.QR_codes.entity_link_logic
flow:
  name: main_qrcode_folders2pdf_flow
  inputs:
    - pdf_output_folder: /tmp
    - source_folder: /tmp/qr_codes
    - delete_pdf: 'true'
    - saw_url: "${get_sp('LFV24.smax_url')}"
    - tenant_id: "${get_sp('LFV24.smax_tenant')}"
    - username: "${get_sp('LFV24.smax_user')}"
    - password:
        default: "${get_sp('LFV24.smax_password')}"
        sensitive: true
  workflow:
    - get_children:
        do:
          io.cloudslang.base.filesystem.get_children:
            - source: '${source_folder}'
            - delimiter: ','
        publish:
          - folder_list: '${return_result}'
        navigate:
          - SUCCESS: folder_list_empty
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${folder_list}'
        publish:
          - current_qr_folder: '${result_string}'
        navigate:
          - HAS_MORE: get_user_id_from_path
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - timezone: CET
            - date_format: yyyy-MM-dd_HH-mm-ss
        publish:
          - timestamp: '${output}'
        navigate:
          - SUCCESS: generate_pdf_from_qrcodes_folder_image_names_flow
          - FAILURE: on_failure
    - generate_pdf_from_qrcodes_folder_image_names_flow:
        do:
          LFV24.QR_codes.entity_link_logic.generate_pdf_from_qrcodes_folder_image_names_flow:
            - qr_codes_folder: '${current_qr_folder}'
            - pdf_output_path: '${pdf_output_folder + "/asset_tags_" + timestamp + ".pdf"}'
            - bDelete: 'True'
        publish:
          - python_operation_result
          - generated_pdf
        navigate:
          - SUCCESS: send_o365_mail_test
          - FAILURE_PYTHON_OPERATION: FAILURE_PYTHON
    - send_o365_mail_test:
        do:
          Basic.send_o365_mail_test:
            - file_path: '${pdf_output_folder + "/asset_tags_" + timestamp + ".pdf"}'
            - body: Please find a generated Asset Tag Document attached to this email.
            - subject: Asset Tags Document Generated
            - to_recipients: '${user_email}'
            - client_secret:
                value: "${get_sp('LFV24.client_secret')}"
                sensitive: true
            - client_id: "${get_sp('LFV24.application_id')}"
            - login_type: API
            - tenant: "${get_sp('LFV24.tenant_id')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_pdf
    - get_user_id_from_path:
        do:
          io.cloudslang.base.strings.match_regex:
            - regex: "/(\\d+)$"
            - text: '${current_qr_folder}'
        publish:
          - user_id: '${cs_replace(match_text,"/","")}'
        navigate:
          - MATCH: get_user_email_address
          - NO_MATCH: list_iterator
    - get_user_email_address:
        do:
          LFV24.smax.get_entity:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - entity_type: Person
            - entity_id: '${user_id}'
            - fields: 'Id,Email'
        publish:
          - user_email: '${(cs_json_query(entity_json,"$.properties.Email"))[2:-2]}'
        navigate:
          - FAILURE: on_failure
          - CUSTOM: list_iterator
          - SUCCESS: get_time
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${pdf_output_folder + "/asset_tags_" + timestamp + ".pdf"}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - delete_pdf:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${delete_pdf}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: delete
          - FAILURE: list_iterator
    - folder_list_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${folder_list}'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: NO_FOLDER_FOUND
          - FAILURE: list_iterator
  results:
    - FAILURE
    - SUCCESS
    - FAILURE_PYTHON
    - NO_FOLDER_FOUND
extensions:
  graph:
    steps:
      get_user_id_from_path:
        x: 600
        'y': 280
      generate_pdf_from_qrcodes_folder_image_names_flow:
        x: 920
        'y': 280
        navigate:
          31681af0-f503-cc78-f748-2f37a29448cd:
            targetId: b92b1166-621f-bcfd-d9f4-b0751ad3ab11
            port: FAILURE_PYTHON_OPERATION
      get_user_email_address:
        x: 600
        'y': 440
      get_children:
        x: 40
        'y': 240
      delete:
        x: 680
        'y': 40
      list_iterator:
        x: 440
        'y': 160
        navigate:
          cde93f17-f677-580f-1174-5df34c448cde:
            targetId: 0816d738-94a4-5800-5adb-f06d4514ebb7
            port: NO_MORE
      send_o365_mail_test:
        x: 1080
        'y': 160
      get_time:
        x: 760
        'y': 280
      folder_list_empty:
        x: 240
        'y': 200
        navigate:
          c5cfb09f-ca63-c940-c1dc-29b522abef72:
            targetId: 4b455bb6-8b4a-f88b-c640-c2abc9e1552e
            port: SUCCESS
      delete_pdf:
        x: 840
        'y': 160
    results:
      SUCCESS:
        0816d738-94a4-5800-5adb-f06d4514ebb7:
          x: 440
          'y': 400
      FAILURE_PYTHON:
        b92b1166-621f-bcfd-d9f4-b0751ad3ab11:
          x: 920
          'y': 480
      NO_FOLDER_FOUND:
        4b455bb6-8b4a-f88b-c640-c2abc9e1552e:
          x: 240
          'y': 400
