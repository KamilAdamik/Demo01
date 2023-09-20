namespace: Custom
flow:
  name: LDAP_add_user_to_group_flow
  workflow:
    - LDAP_add_user_to_group:
        do:
          Custom.LDAP_add_user_to_group:
            - group_distinguished_name: 'CN=Remote Desktop Users,CN=Builtin,DC=materna,DC=corp'
            - user_distinguished_name: 'CN=kamil,CN=Users,DC=materna,DC=corp'
            - ldap_server_address: ec2amaz-v2ornpe.materna.corp
            - ldap_username: 'CN=kamil,CN=Users,DC=materna,DC=corp'
            - ldap_password: Password123
            - use_ssl: 'False'
        publish:
          - ldap_addition_result: '${result}'
          - group_members
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      LDAP_add_user_to_group:
        x: 240
        'y': 160
        navigate:
          6cf85bcb-6c87-cfae-8404-e56a10d15a11:
            targetId: 729ab297-65d8-94e0-64ac-9130ad71e759
            port: SUCCESS
    results:
      SUCCESS:
        729ab297-65d8-94e0-64ac-9130ad71e759:
          x: 400
          'y': 160
