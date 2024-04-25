namespace: LFV24.QR_codes
operation:
  name: generate_qrcodes2folder
  inputs:
    - asset_tags_str
    - qr_codes_folder
  python_action:
    use_jython: false
    script: "# generate_qr_codes2folder\r\nimport os\r\nimport json\r\nimport qrcode\r\n\r\ndef execute(asset_tags_str, qr_codes_folder):\r\n    try:\r\n        # Check if asset_tags_str is provided and not empty\r\n        if not asset_tags_str:\r\n            raise ValueError(\"asset_tags_str not provided\")\r\n\r\n        # Check if qr_codes_folder is provided and not empty\r\n        if not qr_codes_folder:\r\n            raise ValueError(\"qr_codes_folder not provided\")\r\n\r\n        # Parse the JSON string to extract the asset tags list\r\n        asset_tags = json.loads(asset_tags_str)\r\n\r\n        # Create the 'qr_codes_temp' subfolder as a subfolder of qr_codes_folder\r\n        if not os.path.exists(qr_codes_folder):\r\n            os.makedirs(qr_codes_folder)\r\n\r\n        # Generate QR codes for asset tags and save them in the specified folder.\r\n        qr_code_paths = []\r\n        for asset_tag in asset_tags:\r\n            qr_code_path = os.path.join(qr_codes_folder, f\"{asset_tag}.png\")\r\n            qr = qrcode.QRCode(version=1, error_correction=qrcode.constants.ERROR_CORRECT_L, box_size=10, border=4)\r\n            qr.add_data(asset_tag)\r\n            qr.make(fit=True)\r\n            img = qr.make_image(fill_color=\"black\", back_color=\"white\")\r\n            img.save(qr_code_path)\r\n            qr_code_paths.append(qr_code_path)\r\n\r\n        return {\"result\": \"QR codes for asset tags generated successfully.\", \"qr_codes_path\": qr_codes_folder}\r\n\r\n    except Exception as e:\r\n        return {\"result\": f\"Error: {str(e)}\", \"qr_codes_path\": qr_codes_folder}"
  outputs:
    - result
    - qr_codes_path
  results:
    - SUCCESS
