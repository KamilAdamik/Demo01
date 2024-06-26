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
namespace: LFV24.smax
flow:
  name: get_entity
  inputs:
    - saw_url: 'https://us7-smax.saas.microfocus.com'
    - tenant_id: '209578404'
    - username: zowie.stenroos@materna.se
    - password:
        default: Password_123
        sensitive: true
    - entity_type: Request
    - entity_id: '26171'
    - fields: FULL_LAYOUT
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
          - SUCCESS: get_entity
    - get_entity:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_entity:
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - entity_type: '${entity_type}'
            - entity_id: '${entity_id}'
            - fields: '${fields}'
        publish:
          - entity_json
          - error_json
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - NO_RESULTS: CUSTOM
  outputs:
    - entity_json: '${entity_json}'
    - error_json: '${error_json}'
    - return_result: '${return_result}'
    - sso_token: '${sso_token}'
  results:
    - FAILURE
    - CUSTOM
    - SUCCESS
extensions:
  graph:
    steps:
      get_sso_token:
        x: 40
        'y': 80
      get_entity:
        x: 280
        'y': 160
        navigate:
          2bbb14c2-60a4-b19b-a28c-daae47871f72:
            targetId: 0fc55ac1-7d5b-7719-945b-e98eb810e569
            port: NO_RESULTS
          141577ab-11f0-091d-0215-1592255b99ad:
            targetId: 4f9fabf2-8587-7552-6dec-6cf32cc2d4cc
            port: SUCCESS
    results:
      CUSTOM:
        0fc55ac1-7d5b-7719-945b-e98eb810e569:
          x: 520
          'y': 360
      SUCCESS:
        4f9fabf2-8587-7552-6dec-6cf32cc2d4cc:
          x: 520
          'y': 120
