namespace: Custom
flow:
  name: install_python_package_flow
  workflow:
    - install_a_python_package:
        do:
          Custom.install_a_python_package:
            - packages_list: reportlab
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      install_a_python_package:
        x: 160
        'y': 160
        navigate:
          61996fa3-6393-255d-3c6e-e6ff0c7ae0ba:
            targetId: e9c5269e-a9f1-e7b5-756f-f86ee0a41905
            port: SUCCESS
    results:
      SUCCESS:
        e9c5269e-a9f1-e7b5-756f-f86ee0a41905:
          x: 360
          'y': 160
