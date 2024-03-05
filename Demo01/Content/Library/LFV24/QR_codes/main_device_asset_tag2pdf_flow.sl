########################################################################################################################
#!!
#! @input entity_type: The entity type to be queried.
#! @input query: The query filter Examples: IdentityCard > 100 or FirstName = 'EmployeeFirst11'
#! @input fields: The properties or sub-structure of a data resource should be returned by a service.
#!!#
########################################################################################################################
namespace: LFV24.QR_codes
flow:
  name: main_device_asset_tag2pdf_flow
  inputs:
    - entity_type: Device
    - query: "(PrintQRCode_c ne null and PrintQRCode_c ne '')"
    - fields: 'Id,AssetTag,PrintQRCode_c'
    - saw_url: "${get_sp('LFV24.smax_url')}"
    - tenant_id: "${get_sp('LFV24.smax_tenant')}"
    - username: "${get_sp('LFV24.smax_user')}"
    - password:
        default: "${get_sp('LFV24.smax_password')}"
        sensitive: true
  workflow:
    - search_devices:
        do:
          LFV24.smax.search_entities:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - entity_type: '${entity_type}'
            - query: '${query}'
            - fields: '${fields}'
        publish:
          - devices_json: '${entity_json}'
        navigate:
          - FAILURE: on_failure
          - NO_ENTITIES_FOUND: NO_ENTITIES_FOUND
          - SUCCESS: get_asset_tags
    - get_asset_tags:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${devices_json}'
            - json_path: $.data.entities..properties.AssetTag
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - NO_ENTITIES_FOUND
    - SUCCESS
extensions:
  graph:
    steps:
      search_devices:
        x: 80
        'y': 160
        navigate:
          94f37bff-939d-345b-baee-764c18db3015:
            targetId: 7acf7668-e0ea-2e04-95f2-35321c0f28e8
            port: NO_ENTITIES_FOUND
      get_asset_tags:
        x: 280
        'y': 160
        navigate:
          c69451ea-c70e-d973-5220-55b7592d99be:
            targetId: 4ccd7af6-66b2-815e-7924-2300ce33c197
            port: SUCCESS
    results:
      NO_ENTITIES_FOUND:
        7acf7668-e0ea-2e04-95f2-35321c0f28e8:
          x: 200
          'y': 320
      SUCCESS:
        4ccd7af6-66b2-815e-7924-2300ce33c197:
          x: 520
          'y': 200
