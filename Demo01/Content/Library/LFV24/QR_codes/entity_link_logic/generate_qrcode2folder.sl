namespace: LFV24.QR_codes.entity_link_logic
operation:
  name: generate_qrcode2folder
  inputs:
    - asset_tag
    - qr_codes_folder
  python_action:
    use_jython: false
    script: "# generate_qr_code2folder\r\nimport os\r\nimport qrcode\r\n\r\ndef execute(asset_tag, qr_codes_folder):\r\n    try:\r\n        # Check if asset_tag is provided and not empty\r\n        if not asset_tag:\r\n            raise ValueError(\"asset_tag not provided\")\r\n\r\n        # Check if qr_codes_folder is provided and not empty\r\n        if not qr_codes_folder:\r\n            raise ValueError(\"qr_codes_folder not provided\")\r\n\r\n        # Create the 'qr_codes_temp' subfolder as a subfolder of qr_codes_folder\r\n        if not os.path.exists(qr_codes_folder):\r\n            os.makedirs(qr_codes_folder)\r\n\r\n        # Generate QR code for asset tag and save it in the specified folder.\r\n        qr_code_path = os.path.join(qr_codes_folder, f\"{asset_tag}.png\")\r\n        qr = qrcode.QRCode(version=1, error_correction=qrcode.constants.ERROR_CORRECT_L, box_size=10, border=4)\r\n        qr.add_data(asset_tag)\r\n        qr.make(fit=True)\r\n        img = qr.make_image(fill_color=\"black\", back_color=\"white\")\r\n        img.save(qr_code_path)\r\n\r\n        return {\"result\": \"QR code for asset tag generated successfully.\", \"qr_code_path\": qr_code_path}\r\n\r\n    except Exception as e:\r\n        return {\"result\": f\"Error: {str(e)}\", \"qr_code_path\": qr_codes_folder}"
  outputs:
    - result
    - qr_code_path
  results:
    - SUCCESS
