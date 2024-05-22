########################################################################################################################
#!!
#! @input source: Path of source file or folder to be deleted.
#!!#
########################################################################################################################
namespace: Basic
flow:
  name: delete_fs
  inputs:
    - source: /tmp/pnmtk.jpg
  workflow:
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${source}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete:
        x: 120
        'y': 160
        navigate:
          f93443d5-37ab-ddfe-8dbf-2202e2802c3c:
            targetId: c7b87c79-9543-b2ab-a334-1219da332cb1
            port: SUCCESS
    results:
      SUCCESS:
        c7b87c79-9543-b2ab-a334-1219da332cb1:
          x: 400
          'y': 160
