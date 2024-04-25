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
  name: get_history
  inputs:
    - saw_url: "${get_sp('LFV24.smax_url')}"
    - tenant_id: "${get_sp('LFV24.smax_tenant')}"
    - username: "${get_sp('LFV24.smax_user')}"
    - password:
        default: "${get_sp('LFV24.smax_password')}"
        sensitive: true
    - entity_type: Device
    - entity_id: '11796'
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
            - trust_all_roots: 'true'
            - x509_hostname_verifier: allow_all
        publish:
          - sso_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: http_client_get
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${saw_url + "/rest/" + tenant_id + "/audit/ems-history-service/" + entity_type + "?changeType=ALL&entityId=" + entity_id + "&meta=Count.Response&order=time+desc&size=50&skip="}'
            - headers: '${"Cookie:LWSSO_COOKIE_KEY=" + sso_token + "; TENANTID=" + tenant_id}'
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '200'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - entity_history: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_sso_token:
        x: 120
        'y': 120
      http_client_get:
        x: 280
        'y': 120
      string_equals:
        x: 440
        'y': 120
        navigate:
          c6077fe8-c14c-5653-554c-bb693c6f121a:
            targetId: cd2b26eb-bb30-b48b-b840-7ca661f9f5dd
            port: SUCCESS
    results:
      SUCCESS:
        cd2b26eb-bb30-b48b-b840-7ca661f9f5dd:
          x: 600
          'y': 120
