namespace: Basic
operation:
  name: list_directory_content
  inputs:
    - folder_path
  python_action:
    use_jython: false
    script: "import os\r\n\r\ndef execute(folder_path):\r\n    try:\r\n        # Check if the provided path is a directory\r\n        if not os.path.isdir(folder_path):\r\n            raise ValueError(\"The provided path is not a directory.\")\r\n\r\n        # Get the list of all files and directories in the folder\r\n        content_list = os.listdir(folder_path)\r\n\r\n        return {\"content_list\":content_list}\r\n\r\n    except Exception as e:\r\n        return {\"content_list\":f\"Error: {str(e)}\"}"
  outputs:
    - content_list
  results:
    - SUCCESS
