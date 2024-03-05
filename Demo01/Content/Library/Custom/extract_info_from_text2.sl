namespace: Custom
operation:
  name: extract_info_from_text2
  inputs:
    - input_string
    - template_mapping
  python_action:
    use_jython: false
    script: "def execute(input_string, template_mapping):\r\n    import json\r\n    import re\r\n\r\n    try:\r\n        # Parse the template_mapping JSON string into a dictionary\r\n        mapping_dict = json.loads(template_mapping)\r\n\r\n        # Initialize the result dictionary\r\n        result_dict = {}\r\n\r\n        # Iterate over each variable in the mapping_dict\r\n        for variable, [start_pattern, end_pattern] in mapping_dict.items():\r\n            # Construct regex pattern to find the content between start and end patterns\r\n            pattern = re.compile(start_pattern + r'(.*?)' + end_pattern)\r\n            matches = re.findall(pattern, input_string)\r\n\r\n            # Extract values for the current variable\r\n            extracted_values = [match.strip() for match in matches]\r\n\r\n            # Store the extracted values in the result dictionary\r\n            result_dict[variable] = extracted_values if extracted_values else None\r\n\r\n        return {\"return_result\": json.dumps(result_dict)}\r\n\r\n    except Exception as e:\r\n        return json.dumps({\"error\": str(e)})"
  outputs:
    - return_result
    - error
  results:
    - SUCCESS
