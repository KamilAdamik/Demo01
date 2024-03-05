########################################################################################################################
#!!
#! @input smax_url: url of the SMAX instance to which the CMS gateway is connected
#! @input smax_tenant: tenant of the SMAX instance to which the cms gateway is connected
#! @input global_id: globalId/UcmdbId of the entity which impact needs to be found out
#!!#
########################################################################################################################
namespace: LFV24
flow:
  name: get_entities_impacted_by_globalId
  inputs:
    - smax_url: 'https://us7-smax.saas.microfocus.com'
    - smax_tenant: '209578404'
    - global_id: 4c65fc1287ae72c09954fe55cfc73ccd
    - json_path_to_filter: "$[?(@.type == 'business_service')].ucmdbId"
    - retry_count: '0'
    - max_retry: '10'
  workflow:
    - get_sso_token:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_sso_token:
            - saw_url: '${smax_url}'
            - tenant_id: '${smax_tenant}'
            - username: "${get_sp('LFV24.smax_user')}"
            - password:
                value: "${get_sp('LFV24.smax_password')}"
                sensitive: true
        publish:
          - sso_token
        navigate:
          - FAILURE: FAILURE_REST_CALL
          - SUCCESS: http_client_post
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${smax_url + '/rest/' + smax_tenant + '/cmsx/gateway/graphql'}"
            - headers: "${'Cookie: TENANTID=' + smax_tenant + '; LWSSO_COOKIE_KEY=' + sso_token + ';'}"
            - body: |-
                ${{
                  "query":"query($impactDefinition: json) {impact(impactDefinition: $impactDefinition) {affectedCIs affectedRelations}}",
                  "variables":{
                    "impactDefinition":{
                      "bundles":[
                        "SMAX_Generic_Impact"
                      ],
                      "triggerCIs":[
                        {
                          "triggerId":"" + global_id + "",
                          "severity":"Critical"
                        }
                      ],
                      "properties":[
                          "global_id","name","sd_type","display_label","root_class"
                      ]
                    }
                  }
                }}
        publish:
          - impact_data: '${return_result}'
          - status_code
        navigate:
          - SUCCESS: status_code_200
          - FAILURE: FAILURE_REST_CALL
    - get_cis:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${impact_data}'
            - json_path: $.data.impact.affectedCIs
        publish:
          - impact_cis: '${return_result}'
        navigate:
          - SUCCESS: get_filtered_global_ids
          - FAILURE: on_failure
    - get_filtered_global_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${impact_cis}'
            - json_path: '${json_path_to_filter}'
        publish:
          - impacted_global_ids: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - status_code_200:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '200'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_cis
          - FAILURE: status_code_204
    - status_code_204:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '204'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: retry_check
          - FAILURE: status_code_401
    - retry_check:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${retry_count}'
            - value2: '${max_retry}'
        publish:
          - retry_count: '${value1 + 1}'
        navigate:
          - GREATER_THAN: FAILURE_REST_CALL
          - EQUALS: http_client_post
          - LESS_THAN: http_client_post
    - status_code_401:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '401'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: retry_check_1
          - FAILURE: on_failure
    - retry_check_1:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${retry_count}'
            - value2: '${max_retry}'
        publish:
          - retry_count: '${value1 + 1}'
        navigate:
          - GREATER_THAN: FAILURE_REST_CALL
          - EQUALS: get_sso_token
          - LESS_THAN: get_sso_token
  outputs:
    - impact_cis: '${impact_cis}'
    - impacted_global_ids: '${impacted_global_ids}'
  results:
    - FAILURE
    - SUCCESS
    - FAILURE_REST_CALL
extensions:
  graph:
    steps:
      get_sso_token:
        x: 120
        'y': 360
        navigate:
          3cdf5001-ae2e-8dfd-edc7-e491645bdf66:
            targetId: 31de2bfc-3ef7-68eb-d419-7f62e239052c
            port: FAILURE
      retry_check_1:
        x: 120
        'y': 200
        navigate:
          8a558737-c1df-b684-4bf3-39a9ca86a3c7:
            targetId: 31de2bfc-3ef7-68eb-d419-7f62e239052c
            port: GREATER_THAN
      get_cis:
        x: 720
        'y': 360
      status_code_200:
        x: 720
        'y': 40
      status_code_401:
        x: 120
        'y': 40
      retry_check:
        x: 520
        'y': 200
        navigate:
          a7258eb3-6398-b3b4-c029-0e7ea97a1ac0:
            targetId: 31de2bfc-3ef7-68eb-d419-7f62e239052c
            port: GREATER_THAN
      status_code_204:
        x: 520
        'y': 40
      get_filtered_global_ids:
        x: 880
        'y': 360
        navigate:
          605657da-c3df-fd23-7188-93795099354a:
            targetId: fbe6b953-a18d-c050-8606-00e119d9c4f8
            port: SUCCESS
      http_client_post:
        x: 520
        'y': 360
        navigate:
          f0fe559b-0dd7-9e58-877b-7187e4c132eb:
            targetId: 31de2bfc-3ef7-68eb-d419-7f62e239052c
            port: FAILURE
    results:
      SUCCESS:
        fbe6b953-a18d-c050-8606-00e119d9c4f8:
          x: 1040
          'y': 360
      FAILURE_REST_CALL:
        31de2bfc-3ef7-68eb-d419-7f62e239052c:
          x: 320
          'y': 200
