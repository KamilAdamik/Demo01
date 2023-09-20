namespace: Custom
operation:
  name: remove_html_tags
  inputs:
    - input_string
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(input_string):\n    from bs4 import BeautifulSoup\n    \n    soup = BeautifulSoup(input_string, 'html.parser')\n    text = soup.get_text()\n\n    return {\"clean_text\": text}\n# you can add additional helper methods below.remove"
  outputs:
    - clean_text
  results:
    - SUCCESS
