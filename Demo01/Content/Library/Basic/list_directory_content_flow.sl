namespace: Basic
flow:
  name: list_directory_content_flow
  inputs:
    - folder_path: /tmp
  workflow:
    - list_directory_content:
        do:
          Basic.list_directory_content:
            - folder_path: '${folder_path}'
        publish:
          - content_list
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - content_list: '${content_list}'
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      list_directory_content:
        x: 280
        'y': 80
        navigate:
          34c38145-b17b-8be1-c298-585e2ef3b841:
            targetId: 07ae263d-bb7a-360e-4d39-47a4b7961037
            port: SUCCESS
    results:
      SUCCESS:
        07ae263d-bb7a-360e-4d39-47a4b7961037:
          x: 320
          'y': 240
