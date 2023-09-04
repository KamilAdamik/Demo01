########################################################################################################################
#!!
#! @input saw_url: The Service Management Automation X URL to make the request to.
#!                 Examples: scheme://{serverAddress}.
#! @input tenant_id: The OpenText SMAX tenant Id.
#! @input username: The user name used for authentication.
#! @input password: The password used for authentication.
#!!#
########################################################################################################################
namespace: smax
flow:
  name: get_entity
  inputs:
    - saw_url: 'https://ngsm.smax-materna.se/'
    - tenant_id: '644815427'
    - username: oo.user
    - password:
        default: Password123+
        sensitive: true
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
            - entity_type: Person
            - entity_id: '22375'
            - fields: Email
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - NO_RESULTS: CUSTOM
  results:
    - FAILURE
    - CUSTOM
    - SUCCESS
extensions:
  graph:
    steps:
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
      get_sso_token:
        x: 40
        'y': 80
    results:
      CUSTOM:
        0fc55ac1-7d5b-7719-945b-e98eb810e569:
          x: 520
          'y': 360
      SUCCESS:
        4f9fabf2-8587-7552-6dec-6cf32cc2d4cc:
          x: 520
          'y': 120
