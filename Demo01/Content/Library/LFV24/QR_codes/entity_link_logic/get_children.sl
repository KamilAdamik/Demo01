namespace: LFV24.QR_codes.entity_link_logic
operation:
  name: get_children
  inputs:
    - source
    - delimiter
  python_action:
    use_jython: false
    script: "import os\r\n\r\ndef execute(source, delimiter):\r\n    try:\r\n        # Check if the source directory exists\r\n        if not os.path.isdir(source):\r\n            raise ValueError(f\"The source directory '{source}' does not exist or is not a directory.\")\r\n        \r\n        # Get a list of files and folders in the source directory\r\n        children = os.listdir(source)\r\n        \r\n        # Join the children list using the specified delimiter\r\n        result = delimiter.join(children)\r\n        \r\n        # Return the result as a JSON object\r\n        return {\"return_result\": result}\r\n    \r\n    except Exception as e:\r\n        # Return the error as a JSON object in case of any issues\r\n        return {\"error\": str(e)}"
  outputs:
    - return_result
    - error
  results:
    - SUCCESS
