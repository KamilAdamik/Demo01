namespace: LFV24
flow:
  name: generate_qrcodes2pdf_flow
  workflow:
    - generate_qrcodes2pdf:
        do:
          LFV24.generate_qrcodes2pdf:
            - asset_tags_str: '["HPSVR07111", "HPPC0023", "LRU10002","THC420","20DIS20D"]'
            - pdf_output_path: "C:\\Temp\\assets_qrcodes.pdf"
            - max_barcodes_per_page: '3'
        publish: []
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      generate_qrcodes2pdf:
        x: 160
        'y': 200
        navigate:
          3b163cad-210c-30b2-0827-bdf8f11d5d02:
            targetId: 7036dc58-9558-f041-4592-95848fb18dd7
            port: SUCCESS
    results:
      SUCCESS:
        7036dc58-9558-f041-4592-95848fb18dd7:
          x: 360
          'y': 200
