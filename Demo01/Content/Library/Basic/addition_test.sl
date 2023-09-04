namespace: Basic
flow:
  name: addition_test
  workflow:
    - python_addition:
        do:
          Basic.python_addition:
            - number1: '2'
            - number2: '3'
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      python_addition:
        x: 240
        'y': 160
        navigate:
          4faee99b-ca96-12f6-5baf-154b447198f5:
            targetId: 0a559da1-34dc-f4c8-11a8-43912696da4b
            port: SUCCESS
    results:
      SUCCESS:
        0a559da1-34dc-f4c8-11a8-43912696da4b:
          x: 440
          'y': 200
