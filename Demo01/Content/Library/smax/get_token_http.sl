namespace: smax
flow:
  name: get_token_http
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: 'https://us7-smax.saas.microfocus.com//auth/authentication-endpoint/authenticate/token?TENANTID=883420899'
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
      http_client_post:
        x: 280
        'y': 160
        navigate:
          40706d1e-b29c-2d3f-697d-beb45606157a:
            targetId: ed64fbcc-4dea-2ed0-b599-2502ee93202f
            port: SUCCESS
    results:
      SUCCESS:
        ed64fbcc-4dea-2ed0-b599-2502ee93202f:
          x: 480
          'y': 160
