namespace: LFV24
operation:
  name: json_to_html_table
  inputs:
    - json_obj_str
  python_action:
    use_jython: false
    script: "import json\r\n\r\ndef execute(json_obj_str):\r\n    try:\r\n        # Parse JSON string into a dictionary\r\n        data = json.loads(json_obj_str)\r\n\r\n        # Create HTML table header\r\n        table_html = '<table border=\"1\">'\r\n        \r\n        # Add thead section for table headers\r\n        table_html += '<thead><tr>'\r\n        for key in data.keys():\r\n            table_html += '<th scope=\"col\">{}</th>'.format(key)\r\n        table_html += '</tr></thead>'\r\n\r\n        # Add tbody section for table data rows\r\n        table_html += '<tbody>'\r\n        \r\n        # Add table rows\r\n        for i in range(len(list(data.values())[0])):\r\n            table_html += '<tr>'\r\n            for key, values in data.items():\r\n                table_html += '<td>{}</td>'.format(values[i])\r\n            table_html += '</tr>'\r\n        \r\n        # Close the tbody section\r\n        table_html += '</tbody>'\r\n\r\n        # Close the table\r\n        table_html += '</table>'\r\n\r\n        return {\"result\":table_html}\r\n    except Exception as e:\r\n        return {\"result\":\"Error: {}\".format(str(e))}"
  outputs:
    - result
  results:
    - SUCCESS
