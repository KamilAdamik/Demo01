namespace: Custom
operation:
  name: calculate_mean
  python_action:
    use_jython: false
    script: "import numpy\r\n\r\ndef execute():\r\n    # Create a simple NumPy array\r\n    array = numpy.array([1, 2, 3, 4, 5])\r\n    \r\n    # Calculate the mean of the array\r\n    mean_value = numpy.mean(array)\r\n    \r\n    return {\"mean_value\": mean_value}"
  outputs:
    - mean_value
  results:
    - SUCCESS
