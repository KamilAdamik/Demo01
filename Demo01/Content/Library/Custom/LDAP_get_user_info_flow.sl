namespace: Custom
flow:
  name: LDAP_get_user_info_flow
  inputs:
    - search_field: displayName
    - search_filter: kamil
    - return_attributes: 'distinguishedName,displayName,sAMAccountName,mail,memberOf'
    - search_base: 'CN=Users,DC=materna,DC=corp'
    - ldap_server_address: ec2amaz-v2ornpe.materna.corp
    - ldap_username: 'CN=kamil,CN=Users,DC=materna,DC=corp'
    - ldap_password:
        default: Password123
        sensitive: true
    - dn_of_group_to_check: 'CN=Remote Desktop Users,CN=Builtin,DC=materna,DC=corp'
  workflow:
    - LDAP_get_user_info:
        do:
          Custom.LDAP_get_user_info:
            - search_field: '${search_field}'
            - search_filter: '${search_filter}'
            - return_attributes: '${return_attributes}'
            - search_base: '${search_base}'
            - ldap_server_address: '${ldap_server_address}'
            - ldap_username: '${ldap_username}'
            - ldap_password:
                value: '${ldap_password}'
                sensitive: true
        publish:
          - error
          - displayName
          - sAMAccountName
          - memberOf
          - attributes
          - distinguishedName
        navigate:
          - FAILURE: on_failure
          - SUCCESS: array_iterator
    - LDAP_assign_user_to_group:
        do:
          Custom.LDAP_assign_user_to_group:
            - host: '${ldap_server_address}'
            - protocol: https
            - username: '${ldap_username}'
            - password:
                value: '${ldap_password}'
                sensitive: true
            - group_distinguished_name: '${dn_of_group_to_check}'
            - user_distinguished_name: '${distinguishedName}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${memberOf}'
        publish:
          - current_group: '${result_string[1:-1]}'
        navigate:
          - HAS_MORE: string_equals
          - NO_MORE: LDAP_assign_user_to_group
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${current_group}'
            - second_string: '${dn_of_group_to_check}'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: ALREADY_IS_MEMBER
          - FAILURE: array_iterator
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
    - ALREADY_IS_MEMBER
extensions:
  graph:
    steps:
      LDAP_get_user_info:
        x: 80
        'y': 120
      LDAP_assign_user_to_group:
        x: 280
        'y': 200
        navigate:
          d70602ad-b44d-e061-b911-d2a5f3985185:
            targetId: 676df6f2-ff0e-89b5-776d-c0b1d4dbcb9c
            port: SUCCESS
      array_iterator:
        x: 80
        'y': 360
      string_equals:
        x: 280
        'y': 360
        navigate:
          84ab6973-2b72-137c-d301-f2e244e5c1c3:
            targetId: 1a4aa254-9c1d-f133-e0bc-6b4096b98fbd
            port: SUCCESS
    results:
      SUCCESS:
        676df6f2-ff0e-89b5-776d-c0b1d4dbcb9c:
          x: 440
          'y': 120
      ALREADY_IS_MEMBER:
        1a4aa254-9c1d-f133-e0bc-6b4096b98fbd:
          x: 440
          'y': 360
