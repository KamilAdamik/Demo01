namespace: LFV24
flow:
  name: get_services_info
  workflow:
    - search_entities:
        do:
          LFV24.smax.search_entities: []
        navigate:
          - FAILURE: on_failure
          - NO_ENTITIES_FOUND: SUCCESS
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      search_entities:
        x: 240
        'y': 200
        navigate:
          5232689a-6b75-657c-b28a-f5ef79e01d31:
            targetId: 4323ac6f-a1e2-ad12-2924-480ab07a9799
            port: NO_ENTITIES_FOUND
          5ac5195d-0faf-e9d3-2552-cd015066bb5f:
            targetId: 4323ac6f-a1e2-ad12-2924-480ab07a9799
            port: SUCCESS
    results:
      SUCCESS:
        4323ac6f-a1e2-ad12-2924-480ab07a9799:
          x: 440
          'y': 240
