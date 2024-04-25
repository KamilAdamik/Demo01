########################################################################################################################
#!!
#! @input saw_url: The Service Management Automation X URL to make the request to.
#!                 Examples: scheme://{serverAddress}.
#! @input tenant_id: The OpenText SMAX tenant Id.
#! @input username: The user name used for authentication.
#! @input password: The password used for authentication.
#!!#
########################################################################################################################
namespace: LFV24.smax
flow:
  name: get_last_updated_by
  inputs:
    - saw_url: "${get_sp('LFV24.smax_url')}"
    - tenant_id: "${get_sp('LFV24.smax_tenant')}"
    - username: "${get_sp('LFV24.smax_user')}"
    - password:
        default: "${get_sp('LFV24.smax_password')}"
        sensitive: true
    - entity_type: Device
    - entity_id: '11796'
    - fields_to_get: Email
  workflow:
    - get_history:
        do:
          LFV24.smax.get_history:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - entity_type: '${entity_type}'
            - entity_id: '${entity_id}'
        publish:
          - user_id: '${(cs_json_query(entity_history,"$.results[0].userId"))[2:-2]}'
          - entity_history
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_entity
    - get_entity:
        do:
          LFV24.smax.get_entity:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - entity_type: Person
            - entity_id: '${user_id}'
            - fields: Email
        publish:
          - entity_json
        navigate:
          - FAILURE: on_failure
          - CUSTOM: NOT_FOUND
          - SUCCESS: SUCCESS
  outputs:
    - last_updated_by: '${entity_json}'
  results:
    - FAILURE
    - SUCCESS
    - NOT_FOUND
extensions:
  graph:
    steps:
      get_history:
        x: 80
        'y': 160
      get_entity:
        x: 280
        'y': 160
        navigate:
          0f1c38bf-37e3-f4ca-4ef5-2357f600da9b:
            targetId: 632a08a4-1f7d-14e7-7d30-674775a9db35
            port: SUCCESS
          da6dfa72-34f8-cdb0-7fb5-d1e22741fb44:
            targetId: a6a545d8-7165-109f-2123-1cbcb9bf1ef0
            port: CUSTOM
    results:
      SUCCESS:
        632a08a4-1f7d-14e7-7d30-674775a9db35:
          x: 520
          'y': 240
      NOT_FOUND:
        a6a545d8-7165-109f-2123-1cbcb9bf1ef0:
          x: 520
          'y': 80
