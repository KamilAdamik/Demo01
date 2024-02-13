########################################################################################################################
#!!
#! @input entity_type: The entity type to be queried.
#! @input query: The query filter Examples: IdentityCard > 100 or FirstName = 'EmployeeFirst11'
#! @input fields: The properties or sub-structure of a data resource should be returned by a service.
#!!#
########################################################################################################################
namespace: smax
flow:
  name: search_entities_and_jsonFilter
  inputs:
    - smax_url: 'https://us7-smax.saas.microfocus.com'
    - tenant_id: '209578404'
    - username: zowie.stenroos@materna.se
    - password:
        default: Password_123
        sensitive: true
    - entity_type: Person
    - query:
        required: false
    - fields: 'Id,Email'
  workflow:
    - get_sso_token:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_sso_token:
            - saw_url: '${smax_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - sso_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: query_entities
    - query_entities:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.query_entities:
            - saw_url: '${smax_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - entity_type: '${entity_type}'
            - query: '${query}'
            - fields: '${fields}'
            - size: '1000'
        publish:
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: smax_json_filter
          - NO_RESULTS: NO_ENTITIES_FOUND
    - smax_json_filter:
        do:
          smax.smax_json_filter:
            - json_data: '${return_result}'
            - match_key: Email
            - match_filter: materna
            - return_key: Id
        publish:
          - ids_to_update: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - ids_to_update: '${ids_to_update}'
  results:
    - FAILURE
    - NO_ENTITIES_FOUND
    - SUCCESS
extensions:
  graph:
    steps:
      get_sso_token:
        x: 120
        'y': 160
      query_entities:
        x: 320
        'y': 160
        navigate:
          15fe28f1-9683-3506-c673-8721d60b1324:
            targetId: 6e85f731-3109-9c26-7016-1c8878b4248e
            port: NO_RESULTS
      smax_json_filter:
        x: 480
        'y': 80
        navigate:
          d726300f-23e3-ba90-cae7-d308c5812d9f:
            targetId: 195e774e-8c08-a9a7-3e4b-4cda9b1846f0
            port: SUCCESS
    results:
      NO_ENTITIES_FOUND:
        6e85f731-3109-9c26-7016-1c8878b4248e:
          x: 120
          'y': 320
      SUCCESS:
        195e774e-8c08-a9a7-3e4b-4cda9b1846f0:
          x: 640
          'y': 160
