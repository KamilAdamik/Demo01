namespace: Basic
flow:
  name: weather_api_iterate
  inputs:
    - cities_list: '[Stockholm,Bratislava,Berlin]'
    - temparatures_list:
        default: '[]'
        required: false
  workflow:
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${cities_list}'
        publish:
          - current_city: '${result_string[1:-1]}'
        navigate:
          - HAS_MORE: weather_api
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - weather_api:
        do:
          Basic.weather_api:
            - city: '${current_city}'
        publish:
          - temperature
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_object_into_json_array
          - UNAUTHORIZED: CUSTOM
    - add_object_into_json_array:
        do:
          io.cloudslang.base.json.add_object_into_json_array:
            - json_array: '${temparatures_list}'
            - json_object: "${'{\"' + current_city + '\": \"' + temperature + '\"}'}"
        publish:
          - temparatures_list: '${return_result}'
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      array_iterator:
        x: 80
        'y': 160
        navigate:
          830cb8de-9d23-8784-9aa1-84cdd3c0c9c1:
            targetId: f9478ca0-a480-5e2b-afb0-21a596d5edd9
            port: NO_MORE
      weather_api:
        x: 280
        'y': 160
        navigate:
          b97c1f2e-10d9-9816-eb21-d8d3c30ce68b:
            targetId: 01d0c70b-f6d6-4d36-5347-ec969b825393
            port: UNAUTHORIZED
      add_object_into_json_array:
        x: 480
        'y': 160
        navigate:
          f1656a6c-f69c-6d37-05c0-eb88eb9bf6a6:
            vertices:
              - x: 320
                'y': 120
            targetId: array_iterator
            port: SUCCESS
    results:
      SUCCESS:
        f9478ca0-a480-5e2b-afb0-21a596d5edd9:
          x: 280
          'y': 0
      CUSTOM:
        01d0c70b-f6d6-4d36-5347-ec969b825393:
          x: 480
          'y': 320
