namespace: LFV24.QR_codes.entity_link_logic
operation:
  name: generate_pdf_from_qrcodes_folder_image_names
  inputs:
    - qr_codes_folder
    - pdf_output_path
    - bDelete: 'True'
  python_action:
    use_jython: false
    script: "# generate_pdf_from_qrcodes_folder\r\nfrom reportlab.lib.pagesizes import A4\r\nfrom reportlab.lib.units import mm\r\nfrom reportlab.pdfgen import canvas\r\nimport os\r\nimport shutil\r\n\r\ndef execute(qr_codes_folder, pdf_output_path, bDelete):\r\n    generated_pdf = ''\r\n    try:\r\n        # Check if qr_codes_folder is provided\r\n        if not qr_codes_folder:\r\n            raise ValueError(\"qr_codes_folder not provided\")\r\n\r\n        # List all files in the qr_codes_folder\r\n        qr_code_files = [file for file in os.listdir(qr_codes_folder) if file.endswith('.png')]\r\n\r\n        # Extract asset tags from the file names (without file extension)\r\n        asset_tags = [os.path.splitext(file)[0] for file in qr_code_files]\r\n\r\n        # Define page size and margins\r\n        page_width, page_height = A4\r\n        top_margin = 12 * mm\r\n        bottom_margin = 12 * mm\r\n        left_margin = 17 * mm\r\n        right_margin = 17 * mm\r\n\r\n        # Define label size and spacing\r\n        label_width = 39 * mm\r\n        label_height = 17.6 * mm\r\n        qr_size = 10 * mm  # QR code size\r\n        horizontal_spacing = 7 * mm\r\n        vertical_spacing = 0 * mm\r\n\r\n        # Create the PDF file\r\n        c = canvas.Canvas(pdf_output_path, pagesize=A4)\r\n\r\n        # Calculate number of rows and columns per page\r\n        rows_per_page = 16\r\n        columns_per_page = 4\r\n\r\n        # Calculate total number of pages\r\n        total_pages = (len(asset_tags) + rows_per_page * columns_per_page - 1) // (rows_per_page * columns_per_page)\r\n\r\n        # Loop through each page\r\n        for page_num in range(total_pages):\r\n            # Calculate starting index and ending index for asset tags on this page\r\n            start_index = page_num * rows_per_page * columns_per_page\r\n            end_index = min((page_num + 1) * rows_per_page * columns_per_page, len(asset_tags))\r\n\r\n            # Generate QR codes for the asset tags on this page\r\n            qr_code_paths = [os.path.join(qr_codes_folder, f\"{asset_tag}.png\") for asset_tag in asset_tags[start_index:end_index]]\r\n\r\n            # Loop through each row\r\n            for i in range(rows_per_page):\r\n                # Calculate starting Y-coordinate for the row\r\n                y_position = page_height - top_margin - (i + 1) * (label_height + vertical_spacing)\r\n\r\n                # Loop through each column\r\n                for j in range(columns_per_page):\r\n                    # Calculate starting X-coordinate for the column\r\n                    x_position = left_margin + j * (label_width + horizontal_spacing)\r\n\r\n                    # Calculate index of the asset tag\r\n                    index = i * columns_per_page + j\r\n\r\n                    # Check if index is within the range of asset tags\r\n                    if index < end_index - start_index:\r\n                        # Get the asset tag\r\n                        asset_tag = asset_tags[start_index:end_index][index]\r\n\r\n                        # Truncate the asset tag if it's longer than 20 characters\r\n                        asset_tag = asset_tag[:20]\r\n\r\n                        # Split the asset tag into two rows if it's longer than 10 characters\r\n                        if len(asset_tag) > 10:\r\n                            asset_tag_row1 = asset_tag[:10]\r\n                            asset_tag_row2 = asset_tag[10:]\r\n                        else:\r\n                            asset_tag_row1 = asset_tag\r\n                            asset_tag_row2 = \"\"\r\n\r\n                        # Draw asset tag text with adjusted font size\r\n                        c.setFont(\"Helvetica\", 10 if not asset_tag_row2 else 9)\r\n                        if asset_tag_row2 == \"\":\r\n                            c.drawString(x_position + 2 * mm, y_position + label_height / 2 - 1 * mm, asset_tag)  # Adjusted position\r\n                        else:\r\n                            c.drawString(x_position + 2 * mm, y_position + label_height / 2 + 1 * mm, asset_tag_row1)  # Draw first row\r\n                            c.drawString(x_position + 2 * mm, y_position + label_height / 3 - 0.5 * mm, asset_tag_row2)  # Draw second row    \r\n\r\n                        # Draw QR code with adjusted position and size\r\n                        c.drawImage(qr_code_paths[index], x_position + 39 * mm / 2 - qr_size / 2 + 10 * mm,  # Adjusted position\r\n                                    y_position + label_height / 2 - qr_size / 2, \r\n                                    width=qr_size, height=qr_size)\r\n\r\n            # Add a new page if there are more pages remaining\r\n            if page_num < total_pages - 1:\r\n                c.showPage()\r\n\r\n        # Save the PDF file\r\n        c.save()\r\n        generated_pdf = 'True'\r\n        # If bDelete is True and PDF generated successfully, delete qr_codes_folder\r\n        if bDelete and len(qr_code_paths) > 0:\r\n            shutil.rmtree(qr_codes_folder)\r\n\r\n        return {\"result\": \"PDF with QR codes and asset tags generated successfully.\",\"generated_pdf\":generated_pdf}\r\n\r\n    except Exception as e:\r\n        if generated_pdf != 'True':\r\n            generated_pdf = 'False'\r\n\r\n        return {\"result\": f\"Error: {str(e)}\",\"generated_pdf\":generated_pdf}"
  outputs:
    - result
    - generated_pdf
  results:
    - SUCCESS
