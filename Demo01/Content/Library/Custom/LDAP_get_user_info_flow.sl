namespace: Custom
flow:
  name: LDAP_get_user_info_flow
  inputs:
    - search_field: displayName
    - search_filter: kamil
    - return_attributes: 'displayName,sAMAccountName,mail,memberOf'
    - ldap_server_address: ec2amaz-v2ornpe.materna.corp
    - ldap_username: 'CN=kamil,CN=Users,DC=materna,DC=corp'
  workflow:
    - LDAP_get_user_info:
        do:
          Custom.LDAP_get_user_info:
            - search_field: '${search_field}'
            - search_filter: '${search_filter}'
            - return_attributes: '${return_attributes}'
            - ldap_server_address: '${ldap_server_address}'
            - ldap_username: '${ldap_username}'
        publish:
          - error
          - displayName
          - sAMAccountName
          - memberOf
          - attributes
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - displayName
    - mail
    - sAMAccountName
    - memberOf
    - attributes
    - error: '${error}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      LDAP_get_user_info:
        x: 80
        'y': 80
        navigate:
          2c23f5c3-4015-54a0-df1f-8f313c4a8271:
            targetId: 676df6f2-ff0e-89b5-776d-c0b1d4dbcb9c
            port: SUCCESS
    results:
      SUCCESS:
        676df6f2-ff0e-89b5-776d-c0b1d4dbcb9c:
          x: 280
          'y': 80
