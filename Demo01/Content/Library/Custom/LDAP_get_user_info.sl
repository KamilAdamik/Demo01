namespace: Custom
operation:
  name: LDAP_get_user_info
  inputs:
    - search_field: displayName
    - search_filter: kamil
    - return_attributes:
        required: true
        default: 'displayName,sAMAccountName,memberOf'
    - ldap_server_address: ec2amaz-v2ornpe.materna.corp
    - ldap_username: 'CN=kamil,CN=Users,DC=materna,DC=corp'
    - ldap_password:
        sensitive: true
        default: Password123
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\n\r\ndef execute(search_field, search_filter, return_attributes, ldap_server_address, ldap_username, ldap_password):\r\n    from ldap3 import Server, Connection, ALL, SIMPLE, SYNC\r\n    failed = False\r\n    try:\r\n        # Set up LDAP server and connection\r\n        ldap_server = Server(ldap_server_address, get_info=ALL)\r\n        ldap_connection = Connection(\r\n            ldap_server,\r\n            user=ldap_username,\r\n            password=ldap_password,\r\n            authentication=SIMPLE,  # You might need to adjust this based on your LDAP setup\r\n            auto_bind=True,\r\n        )\r\n       \r\n        # Define the search filter and attributes to retrieve\r\n        search_query = f\"({search_field}=*{search_filter}*)\"\r\n        attributes = return_attributes.split(\",\") #attributes = ['displayName', 'mail', 'sAMAccountName', 'memberOf']#\r\n\r\n        # Perform the search\r\n        ldap_connection.search('CN=Users,DC=materna,DC=corp', search_query, attributes=attributes)\r\n        \r\n        result = {}  # Initialize result as a dictionary\r\n\r\n        # Process search results\r\n        for entry in ldap_connection.entries:\r\n            for attribute in attributes:\r\n                result[attribute] = entry[attribute].value\r\n        \r\n        #return {\"displayName\":\"Line 31\",\"attributes\": ','.join(attributes)}\r\n        ldap_connection.unbind()\r\n        \r\n        result[\"attributes\"] =  ','.join(attributes)\r\n        result[\"failed\"] =  failed\r\n        \r\n        return result\r\n\r\n        #return {\"displayName\":display_name, \"Email\": email, \"SAMAccountName\": sam_account_name, \"MemberOf\": member_of, \"attributes\": ','.join(attributes)}\r\n\r\n    except Exception as e:\r\n        #return {\"displayName\":\"Line 41\", \"error\": str(e)}\r\n        failed = True\r\n        return {\"error\": str(e), \"failed\":failed}"
  outputs:
    - displayName
    - mail
    - sAMAccountName
    - memberOf
    - attributes
    - result
    - failed
    - error
  results:
    - FAILURE: '${failed == "True"}'
    - SUCCESS
