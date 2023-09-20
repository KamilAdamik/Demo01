########################################################################################################################
#!!
#! @input host: The domain controller to connect to.
#! @input protocol: The protocol to use when connecting to the Active Directory server.
#!                  Valid values: 'HTTP' and 'HTTPS'.
#!                  Optional
#! @input username: The user to connect to Active Directory as.
#! @input password: The password of the user to connect to Active Directory.
#! @input group_distinguished_name: The Distinguished Name of the group.
#! @input user_distinguished_name: The Distinguished Name of the user to add.
#!!#
########################################################################################################################
namespace: Custom
flow:
  name: LDAP_assign_user_to_group
  inputs:
    - host: ec2amaz-v2ornpe.materna.corp
    - protocol:
        required: false
    - username: kamil
    - password:
        default: Password123
        sensitive: true
    - group_distinguished_name: 'CN=Remote Desktop Users,CN=Builtin,DC=materna,DC=corp'
    - user_distinguished_name: 'CN=kamil,CN=Users,DC=materna,DC=corp'
  workflow:
    - add_user_to_group:
        do:
          io.cloudslang.base.active_directory.groups.add_user_to_group:
            - host: '${host}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - group_distinguished_name: '${group_distinguished_name}'
            - user_distinguished_name: '${user_distinguished_name}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_user_to_group:
        x: 320
        'y': 120
        navigate:
          2a9066d6-cc39-d1d5-a8f1-c0ed393e0079:
            targetId: 95ed5bb2-e137-048d-ca18-ca501141be93
            port: SUCCESS
    results:
      SUCCESS:
        95ed5bb2-e137-048d-ca18-ca501141be93:
          x: 560
          'y': 160
