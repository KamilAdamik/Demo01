namespace: Custom
flow:
  name: LDAP_get_user_info_flow2
  inputs:
    - search_field: displayName
    - search_filter: kamil
    - return_attributes: 'displayName, mail, sAMAccountName, memberOf'
    - ldap_server_address: ec2amaz-v2ornpe.materna.corp
    - ldap_username: 'CN=kamil,CN=Users,DC=materna,DC=corp'
  workflow:
    - LDAP_get_user_info2:
        do:
          Custom.LDAP_get_user_info2: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - displayName
    - email
    - sAMAccountName
    - memberOf
    - attributes
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      LDAP_get_user_info2:
        x: 120
        'y': 160
        navigate:
          cc87b624-0a7d-0169-ab33-aa6b4a44d37f:
            targetId: 676df6f2-ff0e-89b5-776d-c0b1d4dbcb9c
            port: SUCCESS
    results:
      SUCCESS:
        676df6f2-ff0e-89b5-776d-c0b1d4dbcb9c:
          x: 400
          'y': 160
