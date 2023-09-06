namespace: Custom
flow:
  name: text_extraction
  workflow:
    - extract_info_from_text:
        do:
          Custom.extract_info_from_text:
            - input_string: 'Planned work (PW) Notification from Telia Company Customer: McDonalds PW Reference number: NMCP179847 Your affected services are listed further below - Maintenance Window: Start Date and Time: 2022-Feb-09 00:00 CET/CEST End Date and Time: 2022-Feb-09 04:00 CET/CESTReason for work: Software upgrading due to the introduction of the new services/ featuresLocation of work: Lund, SwedenThe same information can also be found in the form of tables in the attached files.----------------------------------------------------------------------Affected service(s) and impact at any time during the maintenance window given above:Service ID: DNI-61331 (Alias: Malmö/Sturup Backup) (LUFTLEDNINGSVÄGEN 3, STURUP) Product: Telia DataNet Impact: 1 x 15 minutes interruptionService ID: DNI-61331-100 Product:  Impact: 1 x 15 minutes interruption'
            - template_mapping: '{"customer":["Customer: ", "PW Reference number"],"reference_number":["PW Reference number: ","Your affected"],"start_time":["Start Date and Time: ", " End Date and Time"],"end_time":["End Date and Time: ","Reason for work:"], "service_ids":["Service ID: ","Product:"]}'
            - input_string_1: null
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      extract_info_from_text:
        x: 320
        'y': 200
        navigate:
          7067fd53-de50-df64-a65a-3a79beb6b4ac:
            targetId: 47a1b32e-aa4b-1c24-1d98-9954fb0b7f8c
            port: SUCCESS
    results:
      SUCCESS:
        47a1b32e-aa4b-1c24-1d98-9954fb0b7f8c:
          x: 480
          'y': 200
