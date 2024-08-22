########################################################################################################################
#!!
#! @input saw_url: The Service Management Automation X URL to make the request to.
#!                 Examples: scheme://{serverAddress}.
#! @input tenant_id: The OpenText SMAX tenant Id.
#! @input username: The user name used for authentication.
#! @input password: The password used for authentication.
#!!#
########################################################################################################################
namespace: smax
flow:
  name: upload_attachment
  inputs:
    - sso_token:
        required: false
    - saw_url: "${get_sp('smax.smax_url')}"
    - tenant_id: "${get_sp('smax.smax_tenant')}"
    - username: "${get_sp('smax.smax_user')}"
    - password:
        default: "${get_sp('smax.smax_pass')}"
        sensitive: true
    - attachment_path: /tmp/AttachmentTest.txt
  workflow:
    - is_token_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: get_sso_token
          - IS_NOT_NULL: post_ces_api_request
    - get_sso_token:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_sso_token:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - trust_all_roots: 'true'
            - x509_hostname_verifier: allow_all
        publish:
          - sso_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: post_ces_api_request
    - post_ces_api_request:
        do:
          Basic.http_client_post_custom:
            - url: '${saw_url + "/rest/" + tenant_id + "/ces/attachment/"}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: '${"Cookie:LWSSO_COOKIE_KEY=" + sso_token + "; TENANTID=" + tenant_id}'
            - multipart_files: '${"files[]=" + attachment_path}'
            - multipart_files_content_type: application/octet-stream
        publish:
          - att_id: '${(cs_json_query(return_result,"$.guid"))[2:-2]}'
          - att_file_name: '${(cs_json_query(return_result,"$.name"))[2:-2]}'
          - att_file_extension: "${att_name.split('.')[-1]}"
          - att_size: '${(cs_json_query(return_result,"$.contentLength"))[2:-2]}'
          - att_mime_type: '${(cs_json_query(return_result,"$.contentType"))[2:-2]}'
          - att_creator: '${(cs_json_query(return_result,"$.creator"))[2:-2]}'
          - attachment_json: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - att_id: '${att_id}'
    - att_file_name: '${att_file_name}'
    - att_file_extension: '${att_file_extension}'
    - att_size: '${att_size}'
    - att_mime_type: '${att_mime_type}'
    - att_creator: '${att_creator}'
    - attachment_json: '${attachment_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_token_null:
        x: 160
        'y': 200
      get_sso_token:
        x: 320
        'y': 40
      post_ces_api_request:
        x: 480
        'y': 200
        navigate:
          ea5902d1-7f96-cd95-6b1b-6dbdcb1a37f3:
            targetId: 73d61c50-02f7-f261-e880-13858c2c6aa9
            port: SUCCESS
    results:
      SUCCESS:
        73d61c50-02f7-f261-e880-13858c2c6aa9:
          x: 320
          'y': 320
