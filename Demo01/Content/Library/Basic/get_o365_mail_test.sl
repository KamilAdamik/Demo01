########################################################################################################################
#!!
#! @input tenant: Your application tenant.
#! @input login_type: Login method according to Microsoft application type.
#!                    Optional
#!                    Default: Native
#!                    Valid values: API, Native
#! @input client_id: Service Client ID
#! @input client_secret: Service Client Secret
#!                       Optional
#! @input email_address: The email address on which to perform the action,
#!                       Optional
#! @input o_data_query: Query parameters which can be used to specify and control the amount of data returned in a
#!                      response specified in 'key1=val1&key2=val2' format. $top and $select options should be not
#!                      passed for this input because the values for these options can be passed in topQuery and
#!                      selectQuery inputs. In order to customize the Office 365 response, modify or remove the default value.
#!                      Example: &filter=Subject eq 'Test' AND IsRead eq true
#!                      &filter=HasAttachments eq true
#!                      &search="from:help@contoso.com"
#!                      &search="subject:Test"
#!                      $select=subject,bodyPreview,sender,from
#!                      Optional
#!!#
########################################################################################################################
namespace: Basic
flow:
  name: get_o365_mail_test
  inputs:
    - tenant: "${get_sp('LFV24.tenant_id')}"
    - login_type: API
    - client_id: "${get_sp('LFV24.application_id')}"
    - client_secret:
        default: "${get_sp('LFV24.client_secret')}"
        sensitive: true
    - email_address: "${get_sp('LFV24.email_sender')}"
    - o_data_query: $search=AttachmentTest
    - attachments_folder: /tmp
  workflow:
    - get_o365_token:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://login.microsoftonline.com/' + tenant + '/oauth2/v2.0/token'}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - body: "${'client_id=' + client_id + '&scope=https://graph.microsoft.com/.default&client_secret=' + client_secret + '&grant_type=client_credentials'}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - access_token: '${(cs_json_query(return_result,"$.access_token"))[2:-2]}'
        navigate:
          - SUCCESS: get_email
          - FAILURE: on_failure
    - get_email:
        do:
          io.cloudslang.microsoft.office365.get_email:
            - tenant: '${tenant}'
            - login_type: '${login_type}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - email_address: '${email_address}'
            - o_data_query: '${o_data_query}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - message_id_list
          - has_attachments: '${(cs_json_query(return_result,"$.value..hasAttachments"))[1:-1]}'
        navigate:
          - SUCCESS: iterate_messages_list
          - FAILURE: on_failure
    - iterate_messages_list:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${message_id_list}'
        publish:
          - current_message_id: '${result_string}'
        navigate:
          - HAS_MORE: has_attachments
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_attachments:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${"https://graph.microsoft.com/v1.0/users/" + email_address + "/messages/" + current_message_id + "/attachments"}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: '${"Authorization: Bearer " + access_token}'
            - content_type: application/json
        publish:
          - attachment_array: '${(cs_json_query(return_result,"$.value"))[1:-1]}'
        navigate:
          - SUCCESS: iterate_attachment_array
          - FAILURE: on_failure
    - has_attachments:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${has_attachments}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_attachments
          - FAILURE: iterate_messages_list
    - iterate_attachment_array:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${attachment_array}'
        publish:
          - current_attachment: '${result_string}'
          - current_attachment_id: '${(cs_json_query(result_string,"$.id"))[2:-2]}'
          - current_attachment_filename: '${(cs_json_query(result_string,"$.name"))[2:-2]}'
        navigate:
          - HAS_MORE: http_client_get_custom
          - NO_MORE: iterate_messages_list
          - FAILURE: on_failure
    - http_client_get_custom:
        do:
          Basic.http_client_get_custom:
            - url: '${"https://graph.microsoft.com/v1.0/users/" + email_address + "/messages/" + current_message_id + "/attachments/" + current_attachment_id + "/$value"}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - destination_file: '${attachments_folder + "/" + current_attachment_filename}'
            - headers: "${\"Authorization: Bearer \" + access_token + \"\\r\\nAccept: application/octet-stream\"}"
        navigate:
          - SUCCESS: iterate_attachment_array
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_o365_token:
        x: 40
        'y': 200
      get_email:
        x: 200
        'y': 200
      iterate_messages_list:
        x: 360
        'y': 200
        navigate:
          b68a5996-7cce-a14e-d37e-95e23860c648:
            targetId: 889106e8-144e-1b6b-f270-2999cf628951
            port: NO_MORE
      get_attachments:
        x: 640
        'y': 40
      has_attachments:
        x: 480
        'y': 40
      iterate_attachment_array:
        x: 640
        'y': 200
      http_client_get_custom:
        x: 840
        'y': 200
    results:
      SUCCESS:
        889106e8-144e-1b6b-f270-2999cf628951:
          x: 520
          'y': 400
