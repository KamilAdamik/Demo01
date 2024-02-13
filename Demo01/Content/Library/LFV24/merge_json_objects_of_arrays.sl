namespace: LFV24
operation:
  name: merge_json_objects_of_arrays
  inputs:
    - original_json
    - additional_json
  python_action:
    use_jython: false
    script: "import json\r\n\r\ndef execute(original_json, additional_json):\r\n    try:\r\n        # Load JSON strings into dictionaries\r\n        original_data = json.loads(original_json)\r\n        additional_data = json.loads(additional_json)\r\n\r\n        # Check if original_json is an empty object\r\n        if original_data == {}:\r\n            return {\"result\": additional_json}\r\n\r\n        # Merge additional data into original data\r\n        for key, values in additional_data.items():\r\n            if key in original_data:\r\n                # Remove duplicates by converting both lists to sets\r\n                original_data[key] = list(set(original_data[key] + values))\r\n            else:\r\n                # If key does not exist in original data, add it\r\n                original_data[key] = values\r\n\r\n        # Convert merged data back to JSON string\r\n        merged_json = json.dumps(original_data)\r\n        return {\"result\": merged_json}\r\n    except Exception as e:\r\n        return {\"result\":\"Error: {}\".format(str(e))}"
  outputs:
    - result
  results:
    - SUCCESS
