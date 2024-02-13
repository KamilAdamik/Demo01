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
    - json_path_to_filter: "$[?(@.type == 'business_application')].ucmdbId"
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
          - FAILURE: on_failure
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
        navigate:
          - SUCCESS: get_cis
          - FAILURE: on_failure
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
  outputs:
    - impact_cis: '${impact_cis}'
    - impacted_global_ids: '${impacted_global_ids}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_sso_token:
        x: 100
        'y': 250
      http_client_post:
        x: 280
        'y': 240
      get_cis:
        x: 480
        'y': 240
      get_filtered_global_ids:
        x: 640
        'y': 240
        navigate:
          605657da-c3df-fd23-7188-93795099354a:
            targetId: fbe6b953-a18d-c050-8606-00e119d9c4f8
            port: SUCCESS
    results:
      SUCCESS:
        fbe6b953-a18d-c050-8606-00e119d9c4f8:
          x: 800
          'y': 240
