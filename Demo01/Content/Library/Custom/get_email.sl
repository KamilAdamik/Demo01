namespace: Custom
flow:
  name: get_email
  workflow:
    - get_mail_message:
        do:
          io.cloudslang.base.mail.get_mail_message:
            - host: smtp.office365.com
            - port: '587'
            - username: kamil.adamik@materna.group
            - password:
                value: A1lanholdsworth
                sensitive: true
            - folder: inbox
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_mail_message:
        x: 80
        'y': 120
        navigate:
          b60ecf50-f1e9-8858-7654-0074dad22452:
            targetId: ff7583ce-bba2-d983-1852-cef4bd4969a3
            port: SUCCESS
    results:
      SUCCESS:
        ff7583ce-bba2-d983-1852-cef4bd4969a3:
          x: 360
          'y': 200
