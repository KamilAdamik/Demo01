namespace: Custom
flow:
  name: text_extraction_2
  workflow:
    - extract_info_from_text:
        do:
          Custom.extract_info_from_text:
            - input_string: 'tstZowie Stenroos Senior Service Management Specialist MATERNA Information & Communications AB Phone:  +46 (0)8 626 42 00 Mobile:  +46 (0)708 36 49 56______________________________________________________________ Vi brinner för att utveckla verksamheter. Vi vill se våra kunder lyckas genom att  erbjuda rätt processer, teknologi och tjänster. Det är det vi kallar digitalisering.   Utmaningar med ärendeflöden och intern samverkan? Läs om hur vi ser på området Smartare Ärendehantering  Kontakta oss gärna så berättar vi mer eller lär känna oss bättre på www.materna.se.  Du kan också följa oss på LinkedIn From: Micro Focus <noreply@support.microfocus.com>Sent: Thursday, February 8, 2024 02:07To: Zowie Stenroos <Zowie.Stenroos@materna.se>Subject: Micro Focus Knowledge Base Notification   Dear Zowie Stenroos, OpenText has released new or updated information related to your requested notifications. Below are the links of articles you subscribed to: Product: Service Management Automation (SMA/SMAX)Title: What is the default network performance indicator threshold?Document Type: KnowledgeSubscriptionID: a7R8e00000007HGEAYLast Updated: 2024-02-07 02:02:34Product: Service Management Automation (SMA/SMAX)Title: How to validate that field B must be greater than field ADocument Type: KnowledgeSubscriptionID: a7R8e00000007HGEAYLast Updated: 2024-02-07 02:06:23Product: Service Management Automation (SMA/SMAX)Title: Firewall breaking OMT/CDF communication of SMA-SM. Some pods will fail.Document Type: KnowledgeSubscriptionID: a7R8e00000007HGEAYLast Updated: 2024-02-07 02:00:30Product: Service Management Automation (SMA/SMAX)Title: Error: UnmountVolume.TearDown failed for volume "itom-vol" constantly appears in /var/log/messages of AMX master and worker nodesDocument Type: KnowledgeSubscriptionID: a7R8e00000007HGEAYLast Updated: 2024-02-07 00:18:54Product: Service Management Automation (SMA/SMAX)Title: How to display multiple fields in one field and display characters of a specified length?Document Type: KnowledgeSubscriptionID: a7R8e00000007HGEAYLast Updated: 2024-02-07 02:09:01Thank you, OpenText Email Notification.Please do not reply. Notifications are sent from an unmonitored email address.If you wish to change your notification details, please visit our website at: support website  [Extern avsändare] Klicka inte på länkar och ladda inte ner filer om du inte känner igen avsändaren och vet att innehållet är säkert. '
            - template_mapping: '{"product":["Product: ", "Title"],"title":["Title: ","Document Type:"],"document_type":["Document Type: ", "SubscriptionID:"],"subscription_id":["SubscriptionID: ","Last Updated:"]}'
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      extract_info_from_text:
        x: 320
        'y': 200
        navigate:
          7067fd53-de50-df64-a65a-3a79beb6b4ac:
            targetId: 47a1b32e-aa4b-1c24-1d98-9954fb0b7f8c
            port: SUCCESS
    results:
      SUCCESS:
        47a1b32e-aa4b-1c24-1d98-9954fb0b7f8c:
          x: 480
          'y': 200
