namespace: LFV24.QR_codes.entity_link_logic
flow:
  name: get_children_flow
  inputs:
    - source: "C:\\Temp"
    - delimiter: ;
  workflow:
    - get_children:
        do:
          LFV24.QR_codes.entity_link_logic.get_children:
            - source: '${source}'
            - delimiter: '${delimiter}'
        publish:
          - return_result
          - error
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      get_children:
        x: 160
        'y': 160
        navigate:
          22cba049-5189-ffe0-4373-a213e506ae10:
            targetId: 782517d7-2e5a-fb4f-8837-c4f9da5ffc8c
            port: SUCCESS
    results:
      SUCCESS:
        782517d7-2e5a-fb4f-8837-c4f9da5ffc8c:
          x: 400
          'y': 160
