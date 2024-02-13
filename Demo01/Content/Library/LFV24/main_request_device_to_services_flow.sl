namespace: LFV24
flow:
  name: main_request_device_to_services_flow
  inputs:
    - request_id
    - merged_json:
        default: '${{"DisplayLabel":[],"Environment":[]}}'
        required: false
  workflow:
    - get_devices_affected_by_request:
        do:
          LFV24.get_devices_affected_by_request:
            - request_id: '${request_id}'
        publish:
          - devices_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: iterate_devices
          - NO_DEVICES_FOUND: NO_DEVICES_AFFECTED
    - iterate_devices:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${devices_json}'
        publish:
          - current_device: '${result_string}'
        navigate:
          - HAS_MORE: get_device_info
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_device_info:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${current_device}'
            - json_path: $.properties.GlobalId
        publish:
          - cur_device_GlobalId: '${return_result[1:-1]}'
          - cur_device_DisplayLabel: "${(cs_json_query(json_object,'$.properties.DisplayLabel'))[2:-2]}"
          - cur_device_SmaxId: "${(cs_json_query(json_object,'$.properties.Id'))[2:-2]}"
        navigate:
          - SUCCESS: get_entities_impacted_by_globalId
          - FAILURE: on_failure
    - get_entities_impacted_by_globalId:
        do:
          LFV24.get_entities_impacted_by_globalId:
            - global_id: '${cur_device_GlobalId}'
            - json_path_to_filter: "$[?(@.type == 'business_application')].ucmdbId"
        publish:
          - impacted_global_ids: "${cs_replace(impacted_global_ids[1:-1],'\"',\"'\")}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_services_info
    - get_services_info:
        do:
          LFV24.smax.search_entities:
            - entity_type: ActualService
            - query: '${"GlobalId in (" + impacted_global_ids + ")"}'
            - fields: 'FULL_LAYOUT,RELATION_LAYOUT.item'
        publish:
          - entity_json
          - display_label: "${cs_replace((cs_json_query(entity_json,'$..properties.DisplayLabel'))[1:-1],'\"','')}"
          - environment: "${cs_replace((cs_json_query(entity_json,'$..properties.Environment'))[1:-1],'\"','')}"
          - additional_json: '${{"DisplayLabel":[display_label],"Environment":[environment]}}'
        navigate:
          - FAILURE: on_failure
          - NO_ENTITIES_FOUND: iterate_devices
          - SUCCESS: iterate_devices
  results:
    - FAILURE
    - NO_DEVICES_AFFECTED
    - SUCCESS
extensions:
  graph:
    steps:
      get_devices_affected_by_request:
        x: 80
        'y': 160
        navigate:
          a0aeb6b4-7731-1313-542f-e823237034fd:
            targetId: 6c3f217f-f632-d23c-77eb-e14d3699090f
            port: NO_DEVICES_FOUND
      iterate_devices:
        x: 240
        'y': 160
        navigate:
          ab09683b-c6e6-ed4a-2aa1-57770383f3ae:
            targetId: 7eed04cd-d07a-0537-5c81-110c320209fb
            port: NO_MORE
      get_device_info:
        x: 400
        'y': 40
      get_entities_impacted_by_globalId:
        x: 560
        'y': 40
      get_services_info:
        x: 720
        'y': 160
    results:
      NO_DEVICES_AFFECTED:
        6c3f217f-f632-d23c-77eb-e14d3699090f:
          x: 200
          'y': 320
      SUCCESS:
        7eed04cd-d07a-0537-5c81-110c320209fb:
          x: 400
          'y': 320
