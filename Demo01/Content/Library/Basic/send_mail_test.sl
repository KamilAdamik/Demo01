namespace: Basic
flow:
  name: send_mail_test
  workflow:
    - send_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: smtp.office365.com
            - port: '587'
            - from: poc@materna.se
            - to: kamil.adamik@materna.group
            - subject: Test Designer Mail
            - body: Hey hou
            - username: kamil
            - password:
                value: 4AV6q5eHxM
                sensitive: true
            - enable_TLS: 'true'
            - tls_version: TLSv1.2
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      send_mail:
        x: 240
        'y': 160
        navigate:
          524627e6-452e-ab0a-cf36-537742d33ae3:
            targetId: 3b0c8bdb-5afd-b810-23ba-d8094650ff32
            port: SUCCESS
    results:
      SUCCESS:
        3b0c8bdb-5afd-b810-23ba-d8094650ff32:
          x: 400
          'y': 160
