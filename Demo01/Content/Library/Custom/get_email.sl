namespace: Custom
flow:
  name: get_email
  workflow:
    - get_email:
        do:
          io.cloudslang.microsoft.office365.get_email:
            - tenant: 421a3522-a36e-43ad-aa5b-10d85a63dc1f
            - login_type: API
            - client_id: 0d5fa167-6a7d-4bcf-a9bf-574a90fedf37
            - client_secret:
                value: gRH8Q~~VeQsy4zPQAq0DqHbQUhqgYPA.XFu6zbxB
                sensitive: true
            - email_address: lfvootraning@materna.se
            - query: null
            - o_data_query: $search=pizza
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - response_character_set: UTF-8
        publish:
          - return_result
        navigate:
          - SUCCESS: get_email_body_content_type
          - FAILURE: on_failure
    - get_email_body_content:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: $.value..body.content
        publish:
          - email_body: '${return_result}'
        navigate:
          - SUCCESS: is_body_html
          - FAILURE: on_failure
    - get_email_body_content_type:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: $.value..body.contentType
        publish:
          - body_content_type: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_email_body_content
          - FAILURE: on_failure
    - is_body_html:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${body_content_type}'
            - second_string: html
            - ignore_case: 'true'
        navigate:
          - SUCCESS: remove_html_tags
          - FAILURE: on_failure
    - remove_html_tags:
        do:
          Custom.remove_html_tags:
            - input_string: '${email_body}'
        publish:
          - email_body_clean: '${clean_text}'
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_email:
        x: 40
        'y': 160
      get_email_body_content:
        x: 280
        'y': 160
      get_email_body_content_type:
        x: 160
        'y': 160
      is_body_html:
        x: 400
        'y': 160
      remove_html_tags:
        x: 520
        'y': 160
        navigate:
          b28d8b8e-56bc-de92-6205-cb93973598ac:
            targetId: ff7583ce-bba2-d983-1852-cef4bd4969a3
            port: SUCCESS
    results:
      SUCCESS:
        ff7583ce-bba2-d983-1852-cef4bd4969a3:
          x: 920
          'y': 160
