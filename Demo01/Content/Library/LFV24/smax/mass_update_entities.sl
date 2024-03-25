########################################################################################################################
#!!
#! @input entity_ids_array: Array of entity SMAX id that should be updated.
#! @input entity_type: Entity type of the entities that should be updated.
#! @input field_to_update: Field that the mass update should target
#! @input value_to_field: Value to set the updated field to. If the fields should be set to empty, choose null (without quotes) through expression editor not 'null' as a string.
#!!#
########################################################################################################################
namespace: LFV24.smax
flow:
  name: mass_update_entities
  inputs:
    - entity_ids_array: '[12345,34567,56789]'
    - entity_type: Device
    - field_to_update: PrintQRCode_c
    - value_to_field: 'null'
    - smax_url: "${get_sp('LFV24.smax_url')}"
    - smax_tenant: "${get_sp('LFV24.smax_tenant')}"
    - smax_user: "${get_sp('LFV24.smax_user')}"
    - smax_password: "${get_sp('LFV24.smax_password')}"
    - sso_token
  workflow:
    - set_entities_json_array:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_json: '${{"entities" : [], "operation":"UPDATE"}}'
        publish:
          - entities_array: "${(cs_json_query(input_json,'$.entities'))[1:-1]}"
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${entity_ids_array}'
        publish:
          - current_entity_id: '${result_string}'
        navigate:
          - HAS_MORE: add_object_into_json_array
          - NO_MORE: search_and_replace
          - FAILURE: on_failure
    - add_object_into_json_array:
        do:
          io.cloudslang.base.json.add_object_into_json_array:
            - json_array: '${entities_array}'
            - json_object: |-
                ${{
                      "entity_type": "" + entity_type + "",
                      "properties": {
                        "Id": current_entity_id,
                        "" + field_to_update + "": value_to_field
                      }
                }}
        publish:
          - entities_array: '${return_result}'
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
    - search_and_replace:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${entities_array}'
            - text_to_replace: '"null"'
            - replace_with: 'null'
        publish:
          - entities_array: '${replaced_string}'
        navigate:
          - SUCCESS: set_input_json
          - FAILURE: on_failure
    - set_input_json:
        do:
          io.cloudslang.base.utils.do_nothing:
            - entities_array: '${entities_array}'
        publish:
          - input_json: "${'[{\"entities\": '+ entities_array + ',\"operation\": \"UPDATE\"}]'}"
          - entities_input: '${entities_array[1:-1]}'
        navigate:
          - SUCCESS: sso_token_null
          - FAILURE: on_failure
    - update_entities:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.update_entities:
            - saw_url: '${smax_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${smax_tenant}'
            - json_body: '${entities_input}'
            - trust_all_roots: 'true'
            - x509_hostname_verifier: allow_all
        publish:
          - return_result
          - error_json
          - op_status
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - sso_token_null:
        do:
          io.cloudslang.base.utils.is_null: []
        navigate:
          - IS_NULL: get_sso_token
          - IS_NOT_NULL: update_entities
    - get_sso_token:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_sso_token:
            - saw_url: '${smax_url}'
            - tenant_id: '${smax_tenant}'
            - username: '${smax_user}'
            - password:
                value: '${smax_password}'
                sensitive: true
            - trust_all_roots: 'true'
            - x509_hostname_verifier: allow_all
        publish:
          - sso_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_entities
  outputs:
    - return_result: '${return_result}'
    - error_json: '${error_json}'
    - op_status: '${op_status}'
    - input_json: '${input_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_entities_json_array:
        x: 80
        'y': 120
      array_iterator:
        x: 240
        'y': 280
      add_object_into_json_array:
        x: 440
        'y': 120
      search_and_replace:
        x: 440
        'y': 440
      set_input_json:
        x: 640
        'y': 280
      update_entities:
        x: 840
        'y': 320
        navigate:
          56168add-dfaf-a89d-a2e6-582087688418:
            targetId: 0a562db3-779f-9c36-135e-3dbbde281cb4
            port: SUCCESS
      sso_token_null:
        x: 640
        'y': 120
      get_sso_token:
        x: 840
        'y': 120
    results:
      SUCCESS:
        0a562db3-779f-9c36-135e-3dbbde281cb4:
          x: 840
          'y': 480
