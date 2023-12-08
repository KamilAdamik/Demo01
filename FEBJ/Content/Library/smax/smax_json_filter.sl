namespace: smax
operation:
  name: smax_json_filter
  inputs:
    - json_data
    - match_key
    - match_filter
    - return_key
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(json_data, match_key, match_filter, return_key):
          import json
          try:
              json_data_obj = json.loads(json_data)
              filtered_entries = []

              if "entities" in json_data_obj:
                  entities = json_data_obj["entities"]
                  for entity in entities:
                      if match_key in entity["properties"] and match_filter in entity["properties"][match_key]:
                          filtered_entries.append(entity["properties"][return_key])

              return {"return_result": filtered_entries}
          except Exception as e:
              return {"exception": str(e)}
      # you can add additional helper methods below.
  outputs:
    - return_result
    - exception
  results:
    - SUCCESS
