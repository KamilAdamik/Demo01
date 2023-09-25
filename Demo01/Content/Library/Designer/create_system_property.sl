namespace: Designer
flow:
  name: create_system_property
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.oo.designer.authenticate.get_token:
            - ws_user: kamil
            - ws_password:
                value: Materna2023+
                sensitive: true
            - ws_tenant: sysbo
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 120
        'y': 160
        navigate:
          7fa3578e-55af-8010-d773-2c7635e10352:
            targetId: df7da4ac-f26d-d54f-1570-10e76b32ec30
            port: SUCCESS
    results:
      SUCCESS:
        df7da4ac-f26d-d54f-1570-10e76b32ec30:
          x: 280
          'y': 160
