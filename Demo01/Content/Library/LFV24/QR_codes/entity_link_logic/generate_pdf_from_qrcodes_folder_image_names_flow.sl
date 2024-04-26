namespace: LFV24.QR_codes.entity_link_logic
flow:
  name: generate_pdf_from_qrcodes_folder_image_names_flow
  inputs:
    - qr_codes_folder: /tmp/qr_codes
    - pdf_output_path: '${pdf_output_path}'
    - bDelete: 'True'
  workflow:
    - generate_pdf_from_qrcodes_folder_image_names:
        do:
          LFV24.QR_codes.entity_link_logic.generate_pdf_from_qrcodes_folder_image_names:
            - qr_codes_folder: '${qr_codes_folder}'
            - pdf_output_path: '${pdf_output_path}'
            - bDelete: '${bDelete}'
        publish:
          - python_operation_result: '${result}'
          - generated_pdf
          - pdf_output_path
        navigate:
          - SUCCESS: check_for_error
    - check_for_error:
        do:
          io.cloudslang.base.strings.match_regex:
            - regex: Error
            - text: '${python_operation_result}'
        navigate:
          - MATCH: FAILURE_PYTHON_OPERATION
          - NO_MATCH: SUCCESS
  outputs:
    - python_operation_result: '${python_operation_result}'
    - generated_pdf: '${generated_pdf}'
  results:
    - SUCCESS
    - FAILURE_PYTHON_OPERATION
extensions:
  graph:
    steps:
      generate_pdf_from_qrcodes_folder_image_names:
        x: 160
        'y': 160
      check_for_error:
        x: 360
        'y': 160
        navigate:
          a47c21f2-d193-d4f3-0ac1-26123de022e6:
            targetId: d3333308-b9fb-e3e4-4e61-34db1996aa80
            port: MATCH
          1e6f4581-2023-ce9f-c105-7a7f1234bfc6:
            targetId: 03851ab8-9693-e499-8f98-fe6236fc2fc8
            port: NO_MATCH
    results:
      SUCCESS:
        03851ab8-9693-e499-8f98-fe6236fc2fc8:
          x: 600
          'y': 80
      FAILURE_PYTHON_OPERATION:
        d3333308-b9fb-e3e4-4e61-34db1996aa80:
          x: 600
          'y': 280
