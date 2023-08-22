namespace: Custom
flow:
  name: LDAP_get_user_info_flow
  workflow:
    - LDAP_get_user_info:
        do:
          Custom.LDAP_get_user_info:
            - ldap_server_address: null
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      LDAP_get_user_info:
        x: 160
        'y': 160
        navigate:
          9e3f1a94-ac46-1818-407c-639b703501a5:
            targetId: 676df6f2-ff0e-89b5-776d-c0b1d4dbcb9c
            port: SUCCESS
    results:
      SUCCESS:
        676df6f2-ff0e-89b5-776d-c0b1d4dbcb9c:
          x: 400
          'y': 160
