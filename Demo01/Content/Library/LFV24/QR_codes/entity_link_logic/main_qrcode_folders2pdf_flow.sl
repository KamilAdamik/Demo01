namespace: LFV24.QR_codes.entity_link_logic
flow:
  name: main_qrcode_folders2pdf_flow
  workflow:
    - get_children:
        do:
          io.cloudslang.base.filesystem.get_children:
            - source: /tmp/qr_codes
            - delimiter: ','
        publish:
          - folder_list: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${folder_list}'
        navigate:
          - HAS_MORE: list_iterator
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_children:
        x: 40
        'y': 160
      list_iterator:
        x: 200
        'y': 120
        navigate:
          c051aea1-6641-aec1-8be1-96ca701e919e:
            targetId: 0816d738-94a4-5800-5adb-f06d4514ebb7
            port: NO_MORE
    results:
      SUCCESS:
        0816d738-94a4-5800-5adb-f06d4514ebb7:
          x: 320
          'y': 160
