namespace: smax
flow:
  name: assign_attachment
  inputs:
    - sso_token
    - saw_url: "${get_sp('smax.smax_url')}"
    - tenant_id: "${get_sp('smax.smax_tenant')}"
    - username: "${get_sp('smax.smax_user')}"
    - password: "${get_sp('smax.smax_pass')}"
    - entity_type: Request
    - entity_id: '13029'
    - att_id: 68069230-2c24-4d51-943e-ed6915292069
    - att_file_name: AttachmentTest2.txt
    - att_file_extension: txt
    - att_size: '36'
    - att_mime_type:
        default: text/plain
        required: true
    - att_creator: '1000198'
  workflow:
    - is_token_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: get_sso_token
          - IS_NOT_NULL: build_complex_type_properties
    - get_sso_token:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_sso_token:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - trust_all_roots: 'true'
            - x509_hostname_verifier: allow_all
        publish:
          - sso_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: build_complex_type_properties
    - update_entities:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.update_entities:
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - json_body: |-
                ${{
                     "entity_type":"" + entity_type + "",
                     "properties":{
                        "Id":"" + entity_id + "",
                        "IncidentAttachments":"" + complex_type_properties + ""
                     }
                }}
            - trust_all_roots: 'true'
            - x509_hostname_verifier: allow_all
        publish:
          - return_result
          - error_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - build_complex_type_properties:
        do:
          io.cloudslang.base.utils.do_nothing:
            - att_id: '${att_id}'
            - file_name: '${att_file_name}'
            - file_extension: '${att_file_extension}'
            - size: '${att_size}'
            - mime_type: '${att_mime_type}'
            - Creator: '${att_creator}'
        publish:
          - complex_type_properties: "${'{\\\"complexTypeProperties\\\":[{\\\"properties\\\":{\\\"id\\\":\\\"' + att_id + '\\\",\\\"file_name\\\":\\\"' + file_name + '\\\",\\\"file_extension\\\":\\\"' + file_extension + '\\\",\\\"size\\\":\\\"' + size + '\\\",\\\"mime_type\\\":\\\"' + mime_type + '\\\",\\\"Creator\\\":\\\"' + Creator + '\"}}'}"
        navigate:
          - SUCCESS: update_entities
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - error_json: '${error_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_token_null:
        x: 160
        'y': 240
      get_sso_token:
        x: 360
        'y': 80
      update_entities:
        x: 560
        'y': 240
        navigate:
          a6c7a1f3-d4bc-f33b-352b-dfe5706d1e7b:
            targetId: 3ab11e83-3e90-6cbf-9b35-f9d9b758cab9
            port: SUCCESS
      build_complex_type_properties:
        x: 360
        'y': 240
    results:
      SUCCESS:
        3ab11e83-3e90-6cbf-9b35-f9d9b758cab9:
          x: 360
          'y': 400
