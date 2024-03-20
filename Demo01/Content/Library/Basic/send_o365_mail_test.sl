########################################################################################################################
#!!
#! @input file_path: The absolute path to the file that will be attached.
#!                   Optional
#! @input body: The body of the message. Updatable only if 'isDraft' = true.
#!              Optional
#! @input subject: The subject of the message. Updatable only if 'isDraft' = true.
#!                 Optional
#! @input to_recipients: The 'To recipients' for the message. Updatable only if 'isDraft' = true.
#! @input client_secret: Service Client Secret
#!                       Optional
#! @input client_id: Service Client ID
#! @input login_type: Login method according to Microsoft application type.
#!                    Optional
#!                    Default: Native
#!                    Valid values: API, Native
#! @input tenant: Your application tenant.
#!!#
########################################################################################################################
namespace: Basic
flow:
  name: send_o365_mail_test
  inputs:
    - file_path:
        required: false
    - body: Test oo Mail text
    - subject: Test OO mail
    - to_recipients: kamil.adamik@materna.group
    - client_secret:
        sensitive: true
    - client_id: 45bd1177-07e6-4877-bf6d-7eed253c0b2f
    - login_type: API
    - tenant: 421a3522-a36e-43ad-aa5b-10d85a63dc1f
  workflow:
    - send_email:
        do:
          io.cloudslang.microsoft.office365.send_email:
            - tenant: '${tenant}'
            - login_type: '${login_type}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - from_address: poc@materna.se
            - to_recipients: '${to_recipients}'
            - subject: '${subject}'
            - body: '${body}'
            - file_path: '${file_path}'
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
      send_email:
        x: 320
        'y': 200
        navigate:
          0245db7d-1ab0-065e-8547-a93aef383996:
            targetId: 96dbcf04-0ca5-50e3-9c45-d483b694a5f3
            port: SUCCESS
    results:
      SUCCESS:
        96dbcf04-0ca5-50e3-9c45-d483b694a5f3:
          x: 560
          'y': 200
