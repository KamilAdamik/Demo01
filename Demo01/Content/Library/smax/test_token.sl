namespace: smax
flow:
  name: test_token
  workflow:
    - get_sso_token:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_sso_token:
            - saw_url: 'https://us7-smax.saas.microfocus.com/'
            - tenant_id: '883420899'
            - username: Zowie.Stenroos@materna.se
            - password:
                value: Password_123
                sensitive: true
            - trust_all_roots: 'true'
            - x509_hostname_verifier: allow_all
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_sso_token:
        x: 280
        'y': 240
        navigate:
          17408677-e79f-5beb-f3df-add4d2bd8420:
            targetId: 634f51a8-1daa-409b-4e3a-204be1554822
            port: SUCCESS
    results:
      SUCCESS:
        634f51a8-1daa-409b-4e3a-204be1554822:
          x: 440
          'y': 240
