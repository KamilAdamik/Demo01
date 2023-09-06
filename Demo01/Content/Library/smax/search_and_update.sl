########################################################################################################################
#!!
#! @input entity_type: The entity type to be queried.
#! @input fields: The properties or sub-structure of a data resource should be returned by a service.
#!!#
########################################################################################################################
namespace: smax
flow:
  name: search_and_update
  inputs:
    - saw_url: 'https://ngsm.smax-materna.se'
    - tenant_id: '644815427'
    - username: kamil
    - password:
        default: Materna2023+
        sensitive: true
    - entity_type: Request
    - fields: 'Id,DisplayLabel,Status,Description'
  workflow:
    - search_entities:
        do:
          smax.search_entities:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - entity_type: '${entity_type}'
            - query: "DisplayLabel = 'NT Password Expired' and Status != 'RequestStatusComplete'"
            - fields: '${fields}'
        publish:
          - entity_json
          - sso_token
        navigate:
          - FAILURE: on_failure
          - NO_ENTITIES_FOUND: CUSTOM
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${entity_json}'
            - json_path: $..properties.Id
        publish:
          - ids_to_update: '${return_result}'
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${ids_to_update}'
        publish:
          - entity_id: '${result_string[1:-1]}'
        navigate:
          - HAS_MORE: update_entities
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - update_entities:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.update_entities:
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - json_body: |-
                ${{
                 "entity_type":"Request",
                 "properties":{
                    "Id":"" + entity_id + "",
                    "Description":"Now Updated"
                 }
                }}
        navigate:
          - FAILURE: on_failure
          - SUCCESS: array_iterator
  results:
    - FAILURE
    - CUSTOM
    - SUCCESS
extensions:
  graph:
    steps:
      search_entities:
        x: 80
        'y': 160
        navigate:
          3fc4621f-dd51-014c-6420-11c281fc5b77:
            targetId: 539d21ed-b672-0b8e-8824-06a937497271
            port: NO_ENTITIES_FOUND
      json_path_query:
        x: 360
        'y': 80
      array_iterator:
        x: 600
        'y': 160
        navigate:
          0d6536c9-4bd3-e2ee-4228-dff3cba0f9d1:
            targetId: c836af80-669f-82e2-b435-36c79bcbfa37
            port: NO_MORE
      update_entities:
        x: 600
        'y': 360
    results:
      CUSTOM:
        539d21ed-b672-0b8e-8824-06a937497271:
          x: 360
          'y': 360
      SUCCESS:
        c836af80-669f-82e2-b435-36c79bcbfa37:
          x: 680
          'y': 100
