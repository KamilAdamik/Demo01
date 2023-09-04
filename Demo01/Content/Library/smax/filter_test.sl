namespace: smax
flow:
  name: filter_test
  workflow:
    - smax_json_filter:
        do:
          smax.smax_json_filter:
            - json_data: '{"entities":[{"entity_type":"Person","properties":{"Email":"zowie.stenroos@materna.se","LastUpdateTime":1684771202474,"FirstName":"Zowie","Id":"10015","LastName":"Stenroos"},"related_properties":{}},{"entity_type":"Person","properties":{"Email":"susanne.g.johansson@materna.se","LastUpdateTime":1693389601476,"FirstName":"Susanne","Id":"24667","LastName":"GJohansson"},"related_properties":{}}]}'
            - match_key: Email
            - match_filter: materna
            - return_key: Id
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      smax_json_filter:
        x: 280
        'y': 120
        navigate:
          9ab3020d-53d5-1722-631b-c13385c209ee:
            targetId: fc545667-b90d-468a-8d08-a3b0ae806542
            port: SUCCESS
    results:
      SUCCESS:
        fc545667-b90d-468a-8d08-a3b0ae806542:
          x: 360
          'y': 240
