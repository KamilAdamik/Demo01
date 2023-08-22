namespace: Basic
flow:
  name: get_ad_user
  workflow:
    - powershell_script:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: localhost
            - script: "import-module ActiveDirectory Get-ADUser -Filter 'Name -like \"*kamil*\"'"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      powershell_script:
        x: 240
        'y': 160
        navigate:
          97fd685e-1941-a163-eb07-b5d2960e971b:
            targetId: 5fa163ec-c9d6-bf55-2092-738631ffa0e1
            port: SUCCESS
    results:
      SUCCESS:
        5fa163ec-c9d6-bf55-2092-738631ffa0e1:
          x: 440
          'y': 160
