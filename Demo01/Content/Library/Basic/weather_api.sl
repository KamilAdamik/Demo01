namespace: Basic
flow:
  name: weather_api
  inputs:
    - base_url: 'https://api.openweathermap.org/data/2.5/weather'
    - city: Stockholm
    - app_id: "${get_sp('Basic.app_id')}"
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${base_url}'
            - base_url: '${base_url}'
            - trust_all_roots: 'true'
            - query_params: "${'q=' + city + '&units=metric&appid=' + app_id}"
            - x_509_hostname_verifier: allow_all
            - content_type: application/json
            - city: '${city}'
            - app_id: '${app_id}'
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: compare_numbers
    - compare_numbers:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${status_code}'
            - value2: '401'
        navigate:
          - GREATER_THAN: FAILURE
          - EQUALS: UNAUTHORIZED
          - LESS_THAN: FAILURE
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: $.main.temp
        publish:
          - temperature: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - temperature: '${temperature}'
  results:
    - FAILURE
    - SUCCESS
    - UNAUTHORIZED
extensions:
  graph:
    steps:
      http_client_get:
        x: 40
        'y': 160
      compare_numbers:
        x: 240
        'y': 320
        navigate:
          6f96030f-94eb-4bb6-48e0-8bc1abe3e144:
            targetId: c0ca6d88-d3e1-665e-9a62-bb944f6d8131
            port: GREATER_THAN
          58b6afd7-7f5e-432a-2973-a9755f5b3536:
            targetId: c0ca6d88-d3e1-665e-9a62-bb944f6d8131
            port: LESS_THAN
          3d87e150-21d5-8a56-8bdc-6898fb92e03d:
            targetId: 5e919936-5a8a-25cf-8466-8a4b86d39c67
            port: EQUALS
      json_path_query:
        x: 280
        'y': 120
        navigate:
          2add7773-cfe4-25c9-7e93-a961bd004673:
            targetId: b4758e5a-ba81-fcbd-7b31-477dd5f931be
            port: SUCCESS
    results:
      FAILURE:
        c0ca6d88-d3e1-665e-9a62-bb944f6d8131:
          x: 440
          'y': 440
      SUCCESS:
        b4758e5a-ba81-fcbd-7b31-477dd5f931be:
          x: 520
          'y': 160
      UNAUTHORIZED:
        5e919936-5a8a-25cf-8466-8a4b86d39c67:
          x: 480
          'y': 320
