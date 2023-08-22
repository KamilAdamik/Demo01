namespace: Custom
operation:
  name: LDAP_get_user_info
  inputs:
    - search_field: displayName
    - search_filter: kamil
    - return_attributes: 'displayName,mail,sAMAccountName,memberOf'
    - ldap_server_address: ec2amaz-v2ornpe.materna.corp
    - ldap_username: 'CN=kamil,CN=Users,DC=materna,DC=corp'
    - ldap_password:
        sensitive: true
        default: Password123
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function

      def execute(search_field, search_filter, return_attributes, ldap_server_address, ldap_username, ldap_password):
          from ldap3 import Server, Connection, ALL, SIMPLE, SYNC
          try:
              # Set up LDAP server and connection
              ldap_server = Server(ldap_server_address, get_info=ALL)
              ldap_connection = Connection(
                  ldap_server,
                  user=ldap_username,
                  password=ldap_password,
                  authentication=SIMPLE,  # You might need to adjust this based on your LDAP setup
                  auto_bind=True,
              )

              # Define the search filter and attributes to retrieve
              search_query = f"({search_field}=*{search_filter}*)"
              attributes = return_attributes.split(",") #attributes = ['displayName', 'mail', 'sAMAccountName', 'memberOf']#

              # Perform the search
              ldap_connection.search('CN=Users,DC=materna,DC=corp', search_query, attributes=attributes)

              result = {}  # Initialize result as a dictionary

              # Process search results
              for entry in ldap_connection.entries:
                  for attribute in attributes:
                      result[attribute] = entry[attribute].value

              ldap_connection.unbind()

              return result

              #return {"DisplayName":display_name, "Email": email, "SAMAccountName": sam_account_name, "MemberOf": member_of, "attributes": ','.join(attributes)}

          except Exception as e:
              return {"error": str(e)}
  outputs:
    - displayName
    - email
    - sAMAccountName
    - memberOf
    - attributes
  results:
    - SUCCESS
