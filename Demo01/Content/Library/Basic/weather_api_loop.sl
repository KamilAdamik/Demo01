namespace: Basic
flow:
  name: weather_api_loop
  inputs:
    - cities_list: 'Stockholm,Bratislava,Berlin'
  workflow:
    - weather_api:
        loop:
          for: city in cities_list
          do:
            Basic.weather_api:
              - city: '${city}'
              - temperature_list: '${temperature_list}'
          break:
            - FAILURE
            - UNAUTHORIZED
          publish:
            - temperature
            - temperature_list: "${cs_append(str(temperature_list).replace('None',''),' ' + city + ': ' + temperature)}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - UNAUTHORIZED: CUSTOM
  outputs:
    - temperature_list: '${temperature_list}'
  results:
    - FAILURE
    - CUSTOM
    - SUCCESS
extensions:
  graph:
    steps:
      weather_api:
        x: 160
        'y': 200
        navigate:
          92ab38cc-d103-b885-1167-8eaa517a803f:
            targetId: cee4142e-11f7-1ac2-de12-e89100b5e38d
            port: SUCCESS
          81693a47-9a20-11da-7daf-ff2b826e5605:
            targetId: 930c61ed-0d85-f4d7-ae77-0661b5a936fa
            port: UNAUTHORIZED
    results:
      CUSTOM:
        930c61ed-0d85-f4d7-ae77-0661b5a936fa:
          x: 400
          'y': 320
      SUCCESS:
        cee4142e-11f7-1ac2-de12-e89100b5e38d:
          x: 400
          'y': 160
