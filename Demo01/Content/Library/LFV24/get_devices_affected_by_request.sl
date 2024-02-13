########################################################################################################################
#!!
#! @input fields: The properties or sub-structure of a data resource should be returned by a service.
#!!#
########################################################################################################################
namespace: LFV24
flow:
  name: get_devices_affected_by_request
  inputs:
    - request_id
    - fields: 'Id,DisplayLabel,GlobalId'
  workflow:
    - search_entities:
        do:
          LFV24.smax.search_entities:
            - entity_type: Device
            - query: "${'(DeviceAffectedByRequest[Id = ''26171''])'}"
            - fields: '${fields}'
            - request_id: '${request_id}'
        publish:
          - devices_json: '${entity_json}'
        navigate:
          - FAILURE: on_failure
          - NO_ENTITIES_FOUND: number_of_devices_found
          - SUCCESS: number_of_devices_found
    - number_of_devices_found:
        do:
          io.cloudslang.opentext.service_management_automation_x.utils.get_array_size:
            - array: '${devices_json}'
        publish:
          - devices_found: '${str(int(size) > 0)}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${devices_found}'
            - second_string: 'True'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: NO_DEVICES_FOUND
  outputs:
    - devices_json: '${devices_json}'
  results:
    - FAILURE
    - SUCCESS
    - NO_DEVICES_FOUND
extensions:
  graph:
    steps:
      search_entities:
        x: 100
        'y': 250
      number_of_devices_found:
        x: 280
        'y': 240
      string_equals:
        x: 440
        'y': 240
        navigate:
          253234ae-5b2c-fbd3-6c75-e84e5f33f0c2:
            targetId: 8eb9d8ee-a335-20f3-a4f9-8ff64f1f2d70
            port: FAILURE
          d4a1cd42-0c39-ae9b-818b-4781c27796c9:
            targetId: 98a3c52f-1fff-4ce3-bc1b-130f76d56d57
            port: SUCCESS
    results:
      SUCCESS:
        98a3c52f-1fff-4ce3-bc1b-130f76d56d57:
          x: 560
          'y': 120
      NO_DEVICES_FOUND:
        8eb9d8ee-a335-20f3-a4f9-8ff64f1f2d70:
          x: 560
          'y': 360
