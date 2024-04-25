########################################################################################################################
#!!
#! @input entity_type: The entity type to be queried.
#! @input query: The query filter Examples: IdentityCard > 100 or FirstName = 'EmployeeFirst11'
#! @input fields: The properties or sub-structure of a data resource should be returned by a service.
#!!#
########################################################################################################################
namespace: LFV24.QR_codes
flow:
  name: main_device_asset_tag2pdf_flow_2
  inputs:
    - entity_type: Device
    - query: "(PrintQRCode_c ne null and PrintQRCode_c ne '')"
    - fields: 'Id,AssetTag,PrintQRCode_c'
    - saw_url: "${get_sp('LFV24.smax_url')}"
    - tenant_id: "${get_sp('LFV24.smax_tenant')}"
    - username: "${get_sp('LFV24.smax_user')}"
    - password:
        default: "${get_sp('LFV24.smax_password')}"
        sensitive: true
    - folder_to_store_pdf: /tmp
  workflow:
    - search_devices:
        do:
          LFV24.smax.search_entities:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - entity_type: '${entity_type}'
            - query: '${query}'
            - fields: '${fields}'
        publish:
          - devices_json: '${entity_json}'
          - sso_token
          - update_field_content: '${(cs_json_query(return_result,"$.entities[0].properties.PrintQRCode_c"))[2:-2]}'
          - first_entity_id: '${(cs_json_query(entity_json,"$[0].properties.Id"))[2:-2]}'
        navigate:
          - FAILURE: on_failure
          - NO_ENTITIES_FOUND: NO_ENTITIES_FOUND
          - SUCCESS: get_asset_tags
    - get_asset_tags:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${devices_json}'
            - json_path: $..properties.AssetTag
        publish:
          - found_asset_tags: '${return_result}'
        navigate:
          - SUCCESS: get_smax_ids
          - FAILURE: on_failure
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - timezone: CET
            - date_format: yyyy-MM-dd_HH-mm-ss
        publish:
          - timestamp: '${output}'
        navigate:
          - SUCCESS: generate_qrcodes2folder_flow
          - FAILURE: on_failure
    - send_o365_mail_test:
        do:
          Basic.send_o365_mail_test:
            - file_path: '${pdf_output_path}'
            - body: Please find a generated Asset Tag Document attached to this email.
            - subject: Asset Tags Document Generated
            - to_recipients: '${update_field_content}'
            - client_secret:
                value: "${get_sp('LFV24.client_secret')}"
                sensitive: true
            - client_id: "${get_sp('LFV24.application_id')}"
            - login_type: API
            - tenant: "${get_sp('LFV24.tenant_id')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: mass_update_entities
    - get_smax_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${devices_json}'
            - json_path: $..properties.Id
        publish:
          - found_smax_ids: "${cs_replace(return_result,\"\\\"\",\"\")}"
          - found_smax_ids_arr: '${return_result}'
        navigate:
          - SUCCESS: get_time
          - FAILURE: on_failure
    - mass_update_entities:
        do:
          LFV24.smax.mass_update_entities:
            - entity_ids_array: '${found_smax_ids}'
            - entity_type: '${entity_type}'
            - field_to_update: PrintQRCode_c
            - smax_url: '${saw_url}'
            - smax_tenant: '${tenant_id}'
            - smax_user: '${username}'
            - smax_password: '${password}'
            - sso_token: '${sso_token}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - generate_qrcodes2folder_flow:
        do:
          LFV24.QR_codes.generate_qrcodes2folder_flow:
            - asset_tags_str: '${found_asset_tags}'
            - qr_codes_folder: '${folder_to_store_pdf + "/asset_tags_" + timestamp}'
        publish:
          - qrcodes_result: '${python_operation_result}'
          - qr_codes_path
        navigate:
          - SUCCESS: generate_pdf_from_qrcodes_folder_flow
          - FAILURE_PYTHON_OPERATION: FAILURE_PYTHON_OPERATION
    - generate_pdf_from_qrcodes_folder_flow:
        do:
          LFV24.QR_codes.generate_pdf_from_qrcodes_folder_flow:
            - asset_tags_str: '${found_asset_tags}'
            - qr_codes_folder: '${qr_codes_path}'
            - pdf_output_path: '${folder_to_store_pdf + "/asset_tags_" + timestamp + ".pdf"}'
            - bDelete: 'True'
        publish:
          - pdf_result: '${python_operation_result}'
          - generated_pdf
          - pdf_output_path
        navigate:
          - SUCCESS: is_email_address_provided
          - FAILURE_PYTHON_OPERATION: FAILURE_PYTHON_OPERATION
    - is_email_address_provided:
        do:
          io.cloudslang.base.strings.match_regex:
            - regex: "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b"
            - text: '${update_field_content}'
        navigate:
          - MATCH: send_o365_mail_test
          - NO_MATCH: get_last_updated_by
    - get_last_updated_by:
        do:
          LFV24.smax.get_last_updated_by:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - entity_type: Device
            - entity_id: '${first_entity_id}'
            - fields_to_get: Email
        publish:
          - update_field_content: '${(cs_json_query(last_updated_by,"$.properties.Email"))[2:-2]}'
        navigate:
          - FAILURE: NO_EMAIL_ADDRESS_AVAILABLE
          - SUCCESS: send_o365_mail_test
          - NOT_FOUND: NO_EMAIL_ADDRESS_AVAILABLE
  results:
    - FAILURE
    - NO_ENTITIES_FOUND
    - SUCCESS
    - FAILURE_PYTHON_OPERATION
    - NO_EMAIL_ADDRESS_AVAILABLE
extensions:
  graph:
    steps:
      search_devices:
        x: 40
        'y': 80
        navigate:
          94f37bff-939d-345b-baee-764c18db3015:
            targetId: 7acf7668-e0ea-2e04-95f2-35321c0f28e8
            port: NO_ENTITIES_FOUND
      is_email_address_provided:
        x: 520
        'y': 80
      generate_pdf_from_qrcodes_folder_flow:
        x: 520
        'y': 240
        navigate:
          8746ae95-7727-c372-a816-d9dcdce97ccd:
            targetId: d8ea327c-e715-d71f-bef3-8c6b7285cd4b
            port: FAILURE_PYTHON_OPERATION
      generate_qrcodes2folder_flow:
        x: 400
        'y': 240
        navigate:
          a6ae4f13-4aeb-7804-28d2-69692b3d37ef:
            targetId: d8ea327c-e715-d71f-bef3-8c6b7285cd4b
            port: FAILURE_PYTHON_OPERATION
      mass_update_entities:
        x: 920
        'y': 240
        navigate:
          0aabf612-5eb9-86b1-5255-efa07fc6d987:
            targetId: 4ccd7af6-66b2-815e-7924-2300ce33c197
            port: SUCCESS
      get_asset_tags:
        x: 160
        'y': 80
      get_smax_ids:
        x: 160
        'y': 240
      send_o365_mail_test:
        x: 720
        'y': 240
      get_time:
        x: 280
        'y': 240
      get_last_updated_by:
        x: 720
        'y': 80
        navigate:
          8e444abe-8a56-c0ba-bbfb-119fabf9cfb1:
            targetId: f97864a2-43a5-c7ab-df9c-6e89f22e2616
            port: FAILURE
          b077cd8d-077f-91b0-cfa3-da0e1a073823:
            targetId: f97864a2-43a5-c7ab-df9c-6e89f22e2616
            port: NOT_FOUND
    results:
      NO_ENTITIES_FOUND:
        7acf7668-e0ea-2e04-95f2-35321c0f28e8:
          x: 40
          'y': 280
      SUCCESS:
        4ccd7af6-66b2-815e-7924-2300ce33c197:
          x: 920
          'y': 400
      FAILURE_PYTHON_OPERATION:
        d8ea327c-e715-d71f-bef3-8c6b7285cd4b:
          x: 440
          'y': 400
      NO_EMAIL_ADDRESS_AVAILABLE:
        f97864a2-43a5-c7ab-df9c-6e89f22e2616:
          x: 920
          'y': 80
