namespace: Basic
flow:
  name: download_o365_attachments
  inputs:
    - email_address
    - access_token
    - message_id
    - attachment_array
    - attachments_folder
  workflow:
    - iterate_attachment_array:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${attachment_array}'
        publish:
          - current_attachment: '${result_string}'
        navigate:
          - HAS_MORE: get_attachment_info
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_attachment_info:
        do:
          io.cloudslang.base.utils.do_nothing:
            - current_attachment: '${current_attachment}'
        publish:
          - current_attachment_id: '${(cs_json_query(current_attachment,"$.id"))[2:-2]}'
          - current_attachment_filename: '${(cs_json_query(current_attachment,"$.name"))[2:-2]}'
        navigate:
          - SUCCESS: http_client_get_custom
          - FAILURE: on_failure
    - http_client_get_custom:
        do:
          Basic.http_client_get_custom:
            - url: '${"https://graph.microsoft.com/v1.0/users/" + email_address + "/messages/" + message_id + "/attachments/" + current_attachment_id + "/$value"}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - destination_file: '${attachments_folder + "/" + current_attachment_filename}'
            - headers: "${\"Authorization: Bearer \" + access_token + \"\\r\\nAccept: application/octet-stream\"}"
        navigate:
          - SUCCESS: iterate_attachment_array
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      iterate_attachment_array:
        x: 80
        'y': 240
        navigate:
          afa32aa2-a77c-dda0-7ec2-0186fbd14289:
            targetId: 88749ea2-8c0a-67da-f945-94a0736df089
            port: NO_MORE
      get_attachment_info:
        x: 280
        'y': 80
      http_client_get_custom:
        x: 480
        'y': 240
    results:
      SUCCESS:
        88749ea2-8c0a-67da-f945-94a0736df089:
          x: 280
          'y': 400
