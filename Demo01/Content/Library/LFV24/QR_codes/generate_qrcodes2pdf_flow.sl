namespace: LFV24.QR_codes
flow:
  name: generate_qrcodes2pdf_flow
  inputs:
    - asset_tags_str: '["HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789", "HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789","HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789", "HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789","HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789", "HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789","HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789", "HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789","HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789", "HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789","HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789", "HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789","HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789", "HPSVR07111", "HPPC0023", "LRU10002", "THC420", "20DIS20D", "ABC123", "XYZ789"]'
    - pdf_output_path: "C:\\Temp\\qr_codes_output.pdf"
  workflow:
    - generate_qrcodes2pdf:
        do:
          LFV24.QR_codes.generate_qrcodes2pdf:
            - asset_tags_str: '${asset_tags_str}'
            - pdf_output_path: '${pdf_output_path}'
        publish:
          - result
          - generated_pdf
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - result: '${result}'
    - generated_pdf: '${generated_pdf}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      generate_qrcodes2pdf:
        x: 240
        'y': 160
        navigate:
          478d999a-bcca-42d4-2769-8e114546ba0b:
            targetId: d6aade06-6735-76a8-babc-4180fcc3a63a
            port: SUCCESS
    results:
      SUCCESS:
        d6aade06-6735-76a8-babc-4180fcc3a63a:
          x: 480
          'y': 160
