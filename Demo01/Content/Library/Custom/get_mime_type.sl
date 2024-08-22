namespace: Custom
flow:
  name: get_mime_type
  workflow:
    - get_mime_type_from_file_name:
        do:
          Custom.get_mime_type_from_file_name:
            - file_name: my_file.mp3
        publish:
          - mime_type
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - mime_type: '${mime_type}'
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      get_mime_type_from_file_name:
        x: 280
        'y': 200
        navigate:
          95eb6527-1ccb-32f0-90fa-b765b49cc845:
            targetId: f2862fd1-5894-74c1-7d5d-d5904bc6d2ec
            port: SUCCESS
    results:
      SUCCESS:
        f2862fd1-5894-74c1-7d5d-d5904bc6d2ec:
          x: 520
          'y': 200
