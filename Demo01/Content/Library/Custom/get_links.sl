namespace: Custom
operation:
  name: get_links
  inputs:
    - html_content
  python_action:
    use_jython: false
    script: "import json\r\nfrom bs4 import BeautifulSoup\r\n\r\ndef execute(html_content):\r\n    soup = BeautifulSoup(html_content, 'html.parser')\r\n\r\n    link_title_pairs = []\r\n\r\n    for link in soup.find_all('a'):\r\n        href = link.get('href')\r\n        title = link.text.strip()\r\n\r\n        link_title_pair = {\"link\": href, \"title\": title}\r\n\r\n        link_title_pairs.append(link_title_pair)\r\n    \r\n    return link_title_pairs"
  outputs:
    - return_result
  results:
    - SUCCESS
