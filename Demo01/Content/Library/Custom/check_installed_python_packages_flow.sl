namespace: Custom
flow:
  name: check_installed_python_packages_flow
  workflow:
    - check_installed_python_packages:
        do:
          Custom.check_installed_python_packages: []
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      check_installed_python_packages:
        x: 80
        'y': 160
        navigate:
          894f4a70-f81d-d392-7c38-9abeb7c40d35:
            targetId: d2986c27-216e-2bad-a044-12536b7ea0ec
            port: SUCCESS
    results:
      SUCCESS:
        d2986c27-216e-2bad-a044-12536b7ea0ec:
          x: 280
          'y': 160
