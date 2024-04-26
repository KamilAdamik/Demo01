########################################################################################################################
#!!
#! @input saw_url: The Service Management Automation X URL to make the request to.
#!                 Examples: scheme://{serverAddress}.
#! @input tenant_id: The OpenText SMAX tenant Id.
#! @input username: The user name used for authentication.
#! @input password: The password used for authentication.
#! @input entity_type: The OpenText SMAX entity type.
#! @input entity_id: The OpenText SMAX entity Id.
#! @input fields: The entity fields to get, separated by ",".
#!                Examples: Id,Status,OwnedByPerson,OwnedByPerson.Name,OwnedByPerson.Email
#!!#
########################################################################################################################
namespace: LFV24.QR_codes.entity_link_logic
flow:
  name: generate_qr_code_for_device_and_user
  inputs:
    - saw_url: "${get_sp('LFV24.smax_url')}"
    - tenant_id: "${get_sp('LFV24.smax_tenant')}"
    - username: "${get_sp('LFV24.smax_user')}"
    - password:
        default: "${get_sp('LFV24.smax_password')}"
        sensitive: true
    - entity_type: Device
    - entity_id: '11796'
    - fields: 'Id,PrintQRCode_c,AssetTag'
    - base_qrcode_path: /tmp/qr_codes
    - field_to_update: PrintQRCode_c
    - value_to_field: 'null'
  workflow:
    - get_entity:
        do:
          LFV24.smax.get_entity:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - entity_type: '${entity_type}'
            - entity_id: '${entity_id}'
            - fields: '${fields}'
        publish:
          - entity_json
          - user_id: '${(cs_json_query(entity_json,"$.properties.PrintQRCode_c"))[2:-2]}'
          - asset_tag: '${(cs_json_query(entity_json,"$.properties.AssetTag"))[2:-2]}'
          - sso_token
        navigate:
          - FAILURE: on_failure
          - CUSTOM: NOT_FOUND
          - SUCCESS: generate_qrcode2folder_flow
    - generate_qrcode2folder_flow:
        do:
          LFV24.QR_codes.entity_link_logic.generate_qrcode2folder_flow:
            - qr_codes_folder: '${base_qrcode_path + "/" + user_id}'
            - asset_tag: '${asset_tag}'
        publish:
          - qr_code_generation_result: '${python_operation_result}'
          - qr_code_path
        navigate:
          - SUCCESS: set_input_json
          - FAILURE_PYTHON_OPERATION: FAILURE_PYTHON
    - update_entities:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.update_entities:
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - null_value: 'null'
            - json_body: '${json_body}'
            - trust_all_roots: 'true'
            - x509_hostname_verifier: allow_all
        publish:
          - return_result
          - error_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - set_input_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - field_to_update: '${field_to_update}'
            - value_to_field: '${value_to_field}'
            - entity_type: '${entity_type}'
            - entity_id: '${entity_id}'
        publish:
          - input_json: |-
              ${{
                  "entity_type": "" + entity_type + "",
                      "properties": {
                      "Id": entity_id,
                      "" + field_to_update + "": value_to_field
                      }
              }}
        navigate:
          - SUCCESS: search_and_replace
          - FAILURE: on_failure
    - search_and_replace:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${input_json}'
            - text_to_replace: '"null"'
            - replace_with: 'null'
        publish:
          - json_body: '${replaced_string}'
        navigate:
          - SUCCESS: update_entities
          - FAILURE: on_failure
  results:
    - FAILURE
    - NOT_FOUND
    - SUCCESS
    - FAILURE_PYTHON
extensions:
  graph:
    steps:
      get_entity:
        x: 80
        'y': 160
        navigate:
          d3778b62-33b3-c9c6-7f42-8c41ca2bd67e:
            targetId: 2a709692-b892-67e4-d6d9-a7a7c7fd6e73
            port: CUSTOM
      generate_qrcode2folder_flow:
        x: 280
        'y': 160
        navigate:
          0daec7c3-395c-fd75-47c5-0e9a7ef5a83c:
            targetId: ae1fabc5-e41a-a5dd-3b8f-0121a2c6926a
            port: FAILURE_PYTHON_OPERATION
      update_entities:
        x: 600
        'y': 160
        navigate:
          e9de1d46-b35e-0b0d-d810-dd8bd7026d13:
            targetId: 6dd539f3-705b-cdc5-47ff-b8e542d117d6
            port: SUCCESS
      set_input_json:
        x: 440
        'y': 80
      search_and_replace:
        x: 440
        'y': 280
    results:
      NOT_FOUND:
        2a709692-b892-67e4-d6d9-a7a7c7fd6e73:
          x: 280
          'y': 40
      SUCCESS:
        6dd539f3-705b-cdc5-47ff-b8e542d117d6:
          x: 760
          'y': 160
      FAILURE_PYTHON:
        ae1fabc5-e41a-a5dd-3b8f-0121a2c6926a:
          x: 280
          'y': 360
