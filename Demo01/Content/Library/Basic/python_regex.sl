namespace: Basic
operation:
  name: python_regex
  inputs:
    - regex
    - text
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(text, regex):\n    # code goes here\n    import re\n    match = re.search(regex, text)\n    if match:\n        match_text = match.group()\n        found = True\n        return {\"match_text\": match_text, \"found\": found}\n    else:\n        found = False\n        return {\"match_text\": \"No text matching the regular expression has been found\", \"found\": found}\n    \n# you can add additional helper methods below."
  outputs:
    - match_text
  results:
    - FAILURE: '${found == False}'
    - SUCCESS
