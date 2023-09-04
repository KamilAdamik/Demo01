########################################################################################################################
#!!
#! @input entity_type: The entity type to be queried.
#! @input query: The query filter Examples: IdentityCard > 100 or FirstName = 'EmployeeFirst11'
#! @input fields: The properties or sub-structure of a data resource should be returned by a service.
#!!#
########################################################################################################################
namespace: smax
flow:
  name: search_entities
  inputs:
    - saw_url: 'https://ngsm.smax-materna.se/'
    - tenant_id: '644815427'
    - username: oo.user
    - password:
        default: Password123+
        sensitive: true
    - entity_type: Person
    - query:
        required: false
    - fields: 'Id,Email'
  workflow:
    - get_sso_token:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_sso_token:
            - saw_url: '${saw_url}'
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
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - entity_type: '${entity_type}'
            - query: '${query}'
            - fields: '${fields}'
            - size: '1000'
        publish:
          - return_result
          - entity_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - NO_RESULTS: NO_ENTITIES_FOUND
  outputs:
    - return_result: '${return_result}'
    - entity_json: '${entity_json}'
    - sso_token: '${sso_token}'
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
          b144e798-fe45-8910-943c-d9dee486e595:
            targetId: 195e774e-8c08-a9a7-3e4b-4cda9b1846f0
            port: SUCCESS
    results:
      NO_ENTITIES_FOUND:
        6e85f731-3109-9c26-7016-1c8878b4248e:
          x: 120
          'y': 320
      SUCCESS:
        195e774e-8c08-a9a7-3e4b-4cda9b1846f0:
          x: 480
          'y': 160
