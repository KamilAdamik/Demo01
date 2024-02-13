namespace: LFV24
flow:
  name: generate_barcodes2pdf_flow
  workflow:
    - generate_barcodes2pdf:
        do:
          LFV24.generate_barcodes2pdf:
            - asset_tags_str: '["HPSVR07111", "HPPC0023", "LRU10002","THC420","20DIS20D"]'
            - pdf_output_path: "C:\\Temp\\assets_barcodes.pdf"
            - max_barcodes_per_page: '5'
        publish:
          - result
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      generate_barcodes2pdf:
        x: 240
        'y': 280
        navigate:
          30dd2d1d-a628-85de-cb6a-234d35773393:
            targetId: 5264a705-7bef-7cfb-44c5-34cf78cba8d3
            port: SUCCESS
    results:
      SUCCESS:
        5264a705-7bef-7cfb-44c5-34cf78cba8d3:
          x: 480
          'y': 280
