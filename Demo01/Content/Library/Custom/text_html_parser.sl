namespace: Custom
flow:
  name: text_html_parser
  workflow:
    - remove_html_tags:
        do:
          Custom.remove_html_tags:
            - input_string: "<p>This is <b>bold</b> text with <a href='#'>a link</a>.</p>"
        publish:
          - clean_text
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      remove_html_tags:
        x: 120
        'y': 120
        navigate:
          4200b5d8-91f7-17c3-95c6-cd0caed33642:
            targetId: c0db74d9-7904-93ba-ffe7-e15587c38c1b
            port: SUCCESS
    results:
      SUCCESS:
        c0db74d9-7904-93ba-ffe7-e15587c38c1b:
          x: 280
          'y': 120
