########################################################################################################################
#!!
#! @input tenant: Your application tenant.
#! @input client_id: Service Client ID
#! @input client_secret: Service Client Secret
#!                       Optional
#!!#
########################################################################################################################
namespace: Custom
flow:
  name: get_email
  inputs:
    - tenant: 421a3522-a36e-43ad-aa5b-10d85a63dc1f
    - client_id: 0d5fa167-6a7d-4bcf-a9bf-574a90fedf37
    - client_secret:
        default: gRH8Q~~VeQsy4zPQAq0DqHbQUhqgYPA.XFu6zbxB
        sensitive: true
    - saw_url: 'https://ngsm.smax-materna.se'
    - tenant_id: '644815427'
    - username: kamil
    - password:
        default: Materna2023+
        sensitive: true
  workflow:
    - get_email:
        do:
          io.cloudslang.microsoft.office365.get_email:
            - tenant: '${tenant}'
            - login_type: API
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - email_address: lfvootraning@materna.se
            - query: null
            - o_data_query: $search=WORKSHOP
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - response_character_set: UTF-8
        publish:
          - return_result
        navigate:
          - SUCCESS: get_email_body_content_type
          - FAILURE: on_failure
    - get_email_body_content:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: $.value..body.content
        publish:
          - email_body: '${return_result}'
        navigate:
          - SUCCESS: is_body_html
          - FAILURE: on_failure
    - get_email_body_content_type:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: $.value..body.contentType
        publish:
          - body_content_type: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_email_body_content
          - FAILURE: on_failure
    - is_body_html:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${body_content_type}'
            - second_string: html
            - ignore_case: 'true'
        navigate:
          - SUCCESS: remove_html_tags
          - FAILURE: extract_info_from_text
    - remove_html_tags:
        do:
          Custom.remove_html_tags:
            - input_string: '${email_body}'
        publish:
          - email_body: '${clean_text}'
        navigate:
          - SUCCESS: extract_info_from_text
    - extract_info_from_text:
        do:
          Custom.extract_info_from_text:
            - input_string: '${email_body}'
            - template_mapping: '{"customer":["Customer: ", "PW Reference number"],"reference_number":["PW Reference number: ","Your affected"],"start_time":["Start Date and Time: ", " CET/CEST End Date "],"end_time":["End Date and Time: ","CET/CEST"], "reason_for_work":["Reason for work: ", "Location of work: "], "location_of_work":["Location of work: ", "The same information"], "service_ids":["Service ID: ","Product:"]}'
        publish:
          - extracted_info_json: '${return_result}'
        navigate:
          - SUCCESS: start_date_to_unix
    - search_location_id:
        do:
          smax.search_entities:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - entity_type: Location
            - query: "${\"ExactLocation eq '\" + (cs_json_query(extracted_info_json,'$.location_of_work'))[3:-3] + \"'\"}"
            - fields: Id
        publish:
          - location_id: "${(cs_json_query(return_result,'$.entities..properties.Id'))[2:-2]}"
          - sso_token
        navigate:
          - FAILURE: on_failure
          - NO_ENTITIES_FOUND: LOCATION_NOT_FOUND
          - SUCCESS: create_entity
    - create_entity:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.create_entity:
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - json_body: "${{\n\t\t\t\"entity_type\": \"Change\",\n\t\t\t\"properties\": {\n\t\t\t    \"DisplayLabel\":\"Test Change\",\n\t\t\t    \"Description\": \"Test Change\",\n\t\t\t    \"Justification\": \"Test Change\",\n\t\t\t\t\"PWReferenceNumber_c\":\"\" + (cs_json_query(extracted_info_json,'$.reference_number'))[3:-3] + \"\",\n\t\t\t\t\"RegisteredForLocation\":\"\" + location_id + \"\",\n\t\t\t\t\"ScheduledStartTime\": start_date_unix,\n\t\t\t\t\"ScheduledEndTime\": end_date_unix,\n\t\t\t\t\"ReasonForWork_c\":\"\" + (cs_json_query(extracted_info_json,'$.reason_for_work'))[3:-3] + \"\",\n\t\t\t\t\"AffectedServiceIds_c\":\"\" + (cs_json_query(extracted_info_json,'$.service_ids'))[3:-3] + \"\",\n\t\t\t\t\"ReasonForChange\":\"BusinessRequirement\",\n                \"AffectsActualService\":\"11545\",\n                \"BasedOnChangeModel\":\"11948\"\n\t\t\t}\n}}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - start_date_to_unix:
        do:
          Basic.date_to_unix:
            - date_str: "${(cs_json_query(extracted_info_json,'$.start_time'))[3:-3]}"
            - format_str: '%Y-%b-%d %H:%M'
        publish:
          - start_date_unix: '${unix_timestamp}'
        navigate:
          - SUCCESS: end_date_to_unix
    - end_date_to_unix:
        do:
          Basic.date_to_unix:
            - date_str: "${(cs_json_query(extracted_info_json,'$.end_time'))[3:-3]}"
            - format_str: '%Y-%b-%d %H:%M'
        publish:
          - end_date_unix: '${unix_timestamp}'
        navigate:
          - SUCCESS: search_location_id
  results:
    - SUCCESS
    - FAILURE
    - LOCATION_NOT_FOUND
extensions:
  graph:
    steps:
      create_entity:
        x: 720
        'y': 160
        navigate:
          1e389532-4a6e-bcd2-80cd-52326bd75c2c:
            targetId: ff7583ce-bba2-d983-1852-cef4bd4969a3
            port: SUCCESS
      get_email_body_content:
        x: 160
        'y': 360
      search_location_id:
        x: 720
        'y': 360
        navigate:
          430ef9c4-8aa2-dc68-7ff7-3a33a8fbe1db:
            targetId: d78d5798-dfc4-1065-b56c-6adfc8fa8a65
            port: NO_ENTITIES_FOUND
      extract_info_from_text:
        x: 400
        'y': 160
      get_email_body_content_type:
        x: 40
        'y': 360
      remove_html_tags:
        x: 320
        'y': 360
      get_email:
        x: 40
        'y': 160
      is_body_html:
        x: 240
        'y': 240
      start_date_to_unix:
        x: 480
        'y': 360
      end_date_to_unix:
        x: 600
        'y': 360
    results:
      SUCCESS:
        ff7583ce-bba2-d983-1852-cef4bd4969a3:
          x: 880
          'y': 280
      LOCATION_NOT_FOUND:
        d78d5798-dfc4-1065-b56c-6adfc8fa8a65:
          x: 840
          'y': 480
