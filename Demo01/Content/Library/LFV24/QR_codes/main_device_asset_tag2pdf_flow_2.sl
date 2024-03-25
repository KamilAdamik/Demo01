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
    - generate_qrcodes2pdf_flow:
        do:
          LFV24.QR_codes.generate_qrcodes2pdf_flow:
            - asset_tags_str: '${found_asset_tags}'
            - pdf_output_path: '${folder_to_store_pdf + "/asset_tags_" + timestamp + ".pdf"}'
        publish:
          - result: '${result + " - " + pdf_output_path}'
          - generated_pdf
          - pdf_output_path
        navigate:
          - FAILURE: on_failure
          - SUCCESS: send_o365_mail_test
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - timezone: CET
            - date_format: yyyy-MM-dd_HH-mm-ss
        publish:
          - timestamp: '${output}'
        navigate:
          - SUCCESS: generate_qrcodes2pdf_flow
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
  results:
    - FAILURE
    - NO_ENTITIES_FOUND
    - SUCCESS
extensions:
  graph:
    steps:
      search_devices:
        x: 80
        'y': 160
        navigate:
          94f37bff-939d-345b-baee-764c18db3015:
            targetId: 7acf7668-e0ea-2e04-95f2-35321c0f28e8
            port: NO_ENTITIES_FOUND
      get_asset_tags:
        x: 200
        'y': 240
      generate_qrcodes2pdf_flow:
        x: 600
        'y': 160
      get_time:
        x: 440
        'y': 160
      send_o365_mail_test:
        x: 760
        'y': 160
      get_smax_ids:
        x: 320
        'y': 240
      mass_update_entities:
        x: 920
        'y': 160
        navigate:
          0aabf612-5eb9-86b1-5255-efa07fc6d987:
            targetId: 4ccd7af6-66b2-815e-7924-2300ce33c197
            port: SUCCESS
    results:
      NO_ENTITIES_FOUND:
        7acf7668-e0ea-2e04-95f2-35321c0f28e8:
          x: 80
          'y': 320
      SUCCESS:
        4ccd7af6-66b2-815e-7924-2300ce33c197:
          x: 920
          'y': 320
