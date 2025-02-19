﻿<#
Name:           M365/Exchange script for task activities with Powershell
Description:    This script can perform 365 admin and Exchange Online admin activities.
Script By:      Michael Ryan Respicio
#>

param(
[string]$TenantId,
[string]$ClientId,
[string]$CertificateThumbprint,
[string]$CSVFilePath,
[String]$UPNs
)

Function ListOfSKU{
    $LicenseMap = @{
        "c2e41e49-e2a2-4c55-832a-cf13ffba1d6a" = "10-Year Audit Log Retention Add On"
        "e4654015-5daf-4a48-9b37-4f309dddd88b" = "Advanced Communications"
        "d2dea78b-507c-4e56-b400-39447f4738f8" = "AI Builder Capacity add-on"
        "8f0c5670-4e56-4892-b06d-91c085d7004f" = "App Connect IW"
        "9706eed9-966f-4f1b-94f6-bb2b4af99a5b" = "App governance add-on to Microsoft Defender for Cloud Apps"
        "0c266dff-15dd-4b49-8397-2bb16070ed52" = "Microsoft 365 Audio Conferencing"
        "c2cda955-3359-44e5-989f-852ca0cfa02f" = "Microsoft 365 Audio Conferencing for faculty"
        "2b9c8e7c-319c-43a2-a2a0-48c5c6161de7" = "Microsoft Entra Basic"
        "078d2b04-f1bd-4111-bbd4-b4b1b354cef4" = "Microsoft Entra ID P1"
        "30fc3c36-5a95-4956-ba57-c09c2a600bb9" = "Microsoft Entra ID P1 for faculty"
        "de597797-22fb-4d65-a9fe-b7dbe8893914" = "Microsoft Entra ID P1_USGOV_GCCHIGH"
        "84a661c4-e949-4bd2-a560-ed7766fcaf2b" = "Microsoft Entra ID P2"
        "c52ea49f-fe5d-4e95-93ba-1de91d380f89" = "Azure Information Protection Plan 1"
        "a0e6a48f-b056-4037-af70-b9ac53504551" = "Azure Information Protection Plan 1"
        "78362de1-6942-4bb8-83a1-a32aa67e6e2c" = "Azure Information Protection Premium P1 for Government"
        "c57afa2a-d468-46c4-9a90-f86cb1b3c54a" = "Azure Information Protection Premium P1_USGOV_GCCHIGH"
        "4468c39a-28b2-42fb-9094-840bcf28771f" = "Basic Collaboration"
        "90d8b3f8-712e-4f7b-aa1e-62e7ae6cbe96" = "Business Apps (free)"
        "95de1760-7682-406d-98c9-52ef14e51e2b" = "Career Coach for faculty"
        "01c8007a-57d2-41e0-a3c3-0b46ead16cc4" = "Career Coach for students"
        "0fe440c5-f2bf-442b-a4f4-9a7af77a200b" = "Clipchamp Premium"
        "481f3bc2-5756-4b28-9375-5c8c86b99e6b" = "Clipchamp Standard"
        "631d5fb1-a668-4c2a-9427-8830665a742e" = "Common Data Service for Apps File Capacity"
        "e612d426-6bc3-4181-9658-91aa906b0ac0" = "Common Data Service Database Capacity"
        "eddf428b-da0e-4115-accf-b29eb0b83965" = "Common Data Service Database Capacity for Government"
        "448b063f-9cc6-42fc-a0e6-40e08724a395" = "Common Data Service Log Capacity"
        "47794cd0-f0e5-45c5-9033-2eb6b5fc84e0" = "Communications Credits"
        "8a5fbbed-8b8c-41e5-907e-c50c471340fd" = "Compliance Manager Premium Assessment Add-On"
        "a9d7ef53-9bea-4a2a-9650-fa7df58fe094" = "Compliance Manager Premium Assessment Add-On for GCC"
        "639dec6b-bb19-468b-871c-c5c441c4b0cb" = "Copilot for Microsoft 365"
        "a9c51c15-ffad-4c66-88c0-8771455c832d" = "Defender Threat Intelligence"
        "064a9707-9dba-4cc1-9902-38bfcfda6328" = "Digital Messaging for GCC Test SKU"
        "328dc228-00bc-48c6-8b09-1fbc8bc3435d" = "Dynamics 365 - Additional Database Storage (Qualified Offer)"
        "9d776713-14cb-4697-a21d-9a52455c738a" = "Dynamics 365 - Additional Production Instance (Qualified Offer)"
        "e06abcc2-7ec5-4a79-b08b-d9c282376f72" = "Dynamics 365 - Additional Non-Production Instance (Qualified Offer)"
        "c6df1e30-1c9f-427f-907c-3d913474a1c7" = "Dynamics 365 AI for Market Insights (Preview)"
        "673afb9d-d85b-40c2-914e-7bf46cd5cd75" = "Dynamics 365 Asset Management Addl Assets"
        "a58f5506-b382-44d4-bfab-225b2fbf8390" = "Dynamics 365 Business Central Additional Environment Addon"
        "7d0d4f9a-2686-4cb8-814c-eff3fdab6d74" = "Dynamics 365 Business Central Database Capacity"
        "2880026b-2b0c-4251-8656-5d41ff11e3aa" = "Dynamics 365 Business Central Essentials"
        "1d506c23-1702-46f1-b940-160c55f98d05" = "Dynamics 365 Business Central Essentials Attach"
        "9a1e33ed-9697-43f3-b84c-1b0959dbb1d4" = "Dynamics 365 Business Central External Accountant"
        "6a4a1628-9b9a-424d-bed5-4118f0ede3fd" = "Dynamics 365 Business Central for IWs"
        "f991cecc-3f91-4cd0-a9a8-bf1c8167e029" = "Dynamics 365 Business Central Premium"
        "2e3c4023-80f6-4711-aa5d-29e0ecb46835" = "Dynamics 365 Business Central Team Members"
        "79909bd8-4c69-4202-939e-11bc4385b134" = "Dynamics 365 Commerce"
        "1508ad2d-5802-44e6-bfe8-6fb65de63d28" = "Dynamics 365 Commerce Trial"
        "ea126fc5-a19e-42e2-a731-da9d437bffcf" = "Dynamics 365 Plan 1 Enterprise Edition"
        "a3d0cd86-8068-4071-ad40-4dc5b5908c4b" = "Dynamics 365 Customer Insights Attach"
        "0c250654-c7f7-461f-871a-7222f6592cf2" = "Dynamics 365 Customer Insights Standalone"
        "036c2481-aa8a-47cd-ab43-324f0c157c2d" = "Dynamics 365 Customer Insights vTrial"
        "1b399f66-be2a-479c-a79d-84a43a46f79e" = "Dynamics 365 for Customer Service Chat for Government"
        "336dfe1f-3b33-4ab4-b395-cba8f614976d" = "Dynamics 365 for Customer Service Digital Messaging add-on for Government"
        "6ec542c9-2a86-4d4a-8a52-d233eb58ef0a" = "Dynamics 365 Customer Service Digital Messaging and Voice Add-in for Government"
        "ea9ba490-50b8-474e-8671-9fec0f1268f3" = "Dynamics 365 Customer Service Digital Messaging and Voice Add-in for Government for Test"
        "1e615a51-59db-4807-9957-aa83c3657351" = "Dynamics 365 Customer Service Enterprise Viral Trial"
        "eb18b715-ea9d-4290-9994-2ebf4b5042d2" = "Dynamics 365 for Customer Service Enterprise Attach to Qualifying Dynamics 365 Base Offer A"
        "61e6bd70-fbdb-4deb-82ea-912842f39431" = "Dynamics 365 Customer Service Insights Trial"
        "bc946dac-7877-4271-b2f7-99d2db13cd2c" = "Dynamics 365 Customer Voice Trial"
        "1439b6e2-5d59-4873-8c59-d60e2a196e92" = "Dynamics 365 Customer Service Professional"
        "359ea3e6-8130-4a57-9f8f-ad897a0342f1" = "Dynamics 365 Customer Voice"
        "446a86f8-a0cb-4095-83b3-d100eb050e3d" = "Dynamics 365 Customer Voice Additional Responses"
        "65f71586-ade3-4ce1-afc0-1b452eaf3782" = "Dynamics 365 Customer Voice Additional Responses"
        "e2ae107b-a571-426f-9367-6d4c8f1390ba" = "Dynamics 365 Customer Voice USL"
        "4aed5dd6-eb9c-4143-8f14-368d70287121" = "Dynamics 365 Enterprise Edition - Additional Database Storage for Government"
        "2cf302fe-62db-4e20-b573-e0998b1208b5" = "Dynamics 365 - Additional Non-Production Instance for Government"
        "1d2756cb-2147-4b05-b4d5-f013c022dcb9" = "Dynamics 365 Enterprise Edition - Additional Non-Production Instance for Government"
        "a4bfb28e-becc-41b0-a454-ac680dc258d3" = "Dynamics 365 Enterprise Edition - Additional Portal (Qualified Offer)"
        "cb9bc974-a47b-4123-998d-a383390168cc" = "Dynamics 365 Enterprise Edition - Additional Portal for Government"
        "67f58b51-af53-4344-9663-9a2beb1d8a8e" = "Dynamics 365 Enterprise Edition - Additional Portal for Government"
        "2bd3cb20-1bb6-446b-b4d0-089af3a05c52" = "Dynamics 365 Enterprise Edition - Additional Production Instance for Government"
        "29fcd665-d8d1-4f34-8eed-3811e3fca7b3" = "Dynamics 365 Field Service Viral Trial"
        "55c9eb4e-c746-45b4-b255-9ab6b19d5c62" = "Dynamics 365 Finance"
        "d39fb075-21ae-42d0-af80-22a2599749e0" = "Dynamics 365 for Case Management Enterprise Edition"
        "5cd0b796-9ac8-4792-9f0b-796ca9044e4a" = "Dynamics 365 for Case Management, Enterprise Edition for Government"
        "ff5a82be-1edd-4d48-94e0-52527825b589" = "Dynamics 365 for Case Management, Enterprise Edition for Government"
        "94a6fbd4-6a2f-4990-b356-dc7dd8bed08a" = "Dynamics 365 Customer Service Enterprise Admin"
        "749742bf-0d37-4158-a120-33567104deeb" = "Dynamics 365 for Customer Service Enterprise Edition"
        "3c74d823-8f01-4fe8-82d5-f089a5504cec" = "Dynamics 365 for Customer Service, Enterprise Edition for Government"
        "65758a5f-2e16-43b3-a8cb-296cd8f69e09" = "Dynamics 365 for Customer Service Enterprise for Government"
        "7d7af6c2-0be6-46df-84d1-c181b0272909" = "Dynamics 365 for Customer Service Chat"
        "19dec69d-d9f3-4792-8a39-d8ecdf51937b" = "Dynamics 365 for Customer Service Professional Attach to Qualifying Dynamics 365 Base Offer"
        "a36cdaa2-a806-4b6e-9ae0-28dbd993c20e" = "Dynamics 365 for Field Service Attach to Qualifying Dynamics 365 Base Offer"
        "c7d15985-e746-4f01-b113-20b575898250" = "Dynamics 365 for Field Service Enterprise Edition"
        "e7965e3a-1f49-4d67-a3de-ad1ce460bbcc" = "Dynamics 365 Field Service Contractor for Government"
        "977464c4-bfaf-4b67-b761-a9bb735a2196" = "Dynamics 365 Field Service, Enterprise Edition - Resource Scheduling Optimization"
        "8eac9119-7e6b-4278-9dc4-e3458993b08a" = "Dynamics 365 for Field Service for Government"
        "c3d74ead-70b7-4513-8dce-797be3fbe07a" = "Dynamics 365 for Field Service Enterprise Edition for Government"
        "cc13a803-544e-4464-b4e4-6d6169a138fa" = "Dynamics 365 for Financials Business Edition"
        "99cb3f83-fbec-4aa1-8262-9679e6df7c53" = "Dynamics 365 Guides vTrial"
        "de176c31-616d-4eae-829a-718918d7ec23" = "Dynamics 365 Hybrid Connector"
        "99c5688b-6c75-4496-876f-07f0fbd69add" = "Dynamics 365 for Marketing Additional Application"
        "23053933-0fda-431f-9a5b-a00fd78444c1" = "Dynamics 365 for Marketing Additional Contacts Tier 3"
        "c393e9bd-2335-4b46-8b88-9e2a86a85ec1" = "Dynamics 365 for Marketing Additional Non-Prod Application"
        "d8eec316-778c-4f14-a7d1-a0aca433b4e7" = "Dynamics 365 for Marketing Addnl Contacts Tier 5"
        "85430fb9-02e8-48be-9d7e-328beb41fa29" = "Dynamics 365 for Marketing Attach"
        "238e2f8d-e429-4035-94db-6926be4ffe7b" = "Dynamics 365 for Marketing Business Edition"
        "4b32a493-9a67-4649-8eb9-9fc5a5f75c12" = "Dynamics 365 for Marketing USL"
        "b75074f1-4c54-41bf-970f-c9ac871567f5" = "Dynamics 365 Operations – Activity"
        "af739e8e-dd11-4eb5-a986-5908f595c603" = "Dynamics 365 Project Operations Attach"
        "6c827f0a-42cb-4cff-b1cd-f4104c16ede3" = "Dynamics 365 for Project Service Automation for Government"
        "1ec19b5f-7542-4b20-b01f-fb5d3f040e2d" = "Dynamics 365 for Project Service Automation Enterprise Edition for Government"
        "8edc2cf8-6438-4fa9-b6e3-aa1660c640cc" = "Dynamics 365 for Sales and Customer Service Enterprise Edition"
        "1e1a282c-9c54-43a2-9310-98ef728faace" = "Dynamics 365 for Sales Enterprise Edition"
        "28b275ce-aec7-4c26-82e2-1ffbc2746ad4" = "Dynamics 365 for Sales, Enterprise Edition for Government"
        "e85b3345-2fd5-45cf-a196-7968d3e18e56" = "Dynamics 365 for Sales Enterprise for Government"
        "494721b8-1f30-4315-aba6-70ca169358d9" = "Dynamics 365 Sales, Field Service and Customer Service Partner Sandbox"
        "2edaa1dc-966d-4475-93d6-8ee8dfd96877" = "Dynamics 365 Sales Premium"
        "be9f9771-1c64-4618-9907-244325141096" = "Dynamics 365 for Sales Professional"
        "229fa362-9d30-4dbc-8110-21b77a7f9b26" = "Dynamics 365 for Sales Professional for Government"
        "9c7bff7a-3715-4da7-88d3-07f57f8d0fb6" = "Dynamics 365 for Sales Professional Trial"
        "245e6bf9-411e-481e-8611-5c08595e2988" = "Dynamics 365 for Sales Professional Attach to Qualifying Dynamics 365 Base Offer"
        "f2e48cb3-9da0-42cd-8464-4a54ce198ad0" = "Dynamics 365 for Supply Chain Management"
        "3a256e9a-15b6-4092-b0dc-82993f4debc6" = "Dynamics 365 for Talent"
        "8e7a3d30-d97d-43ab-837c-d7701cef83dc" = "Dynamics 365 for Team Members Enterprise Edition"
        "ba05762f-32ff-4fac-a096-55309b3700a3" = "Dynamics 365 for Team Members Enterprise Edition for Government"
        "0a389a77-9850-4dc4-b600-bc66fdfefc60" = "Dynamics 365 Guides"
        "3bbd44ed-8a70-4c07-9088-6232ddbd5ddd" = "Dynamics 365 Operations - Device"
        "e485d696-4c87-4aac-bf4a-91b2fb6f0fa7" = "Dynamics 365 Operations - Sandbox Tier 2:Standard Acceptance Testing"
        "f7ad4bca-7221-452c-bdb6-3e6089f25e06" = "Dynamics 365 Operations - Sandbox Tier 4:Standard Performance Testing"
        "338148b6-1b11-4102-afb9-f92b6cdc0f8d" = "Dynamics 365 P1 Trial for Information Workers"
        "98619618-9dc8-48c6-8f0c-741890ba5f93" = "Dynamics 365 Project Operations"
        "7ed4877c-0863-4f69-9187-245487128d4f" = "Dynamics 365 Regulatory Service - Enterprise Edition Trial"
        "7a551360-26c4-4f61-84e6-ef715673e083" = "Dynamics 365 Remote Assist"
        "e48328a2-8e98-4484-a70f-a99f8ac9ec89" = "Dynamics 365 Remote Assist HoloLens"
        "5b22585d-1b71-4c6b-b6ec-160b1a9c2323" = "Dynamics 365 Sales Enterprise Attach to Qualifying Dynamics 365 Base Offer"
        "6ec92958-3cc1-49db-95bd-bc6b3798df71" = "Dynamics 365 Sales Premium Viral Trial"
        "090b4a96-8114-4c95-9c91-60e81ef53302" = "Dynamics 365 for Supply Chain Management Attach to Qualifying Dynamics 365 Base Offer"
        "e561871f-74fa-4f02-abee-5b0ef54dd36d" = "Dynamics 365 Talent: Attract"
        "b56e7ccc-d5c7-421f-a23b-5c18bdbad7c0" = "Dynamics 365 Talent: Onboard"
        "7ac9fe77-66b7-4e5e-9e46-10eed1cff547" = "Dynamics 365 Team Members_wDynamicsRetail"
        "ccba3cfe-71ef-423a-bd87-b6df3dce59a9" = "Dynamics 365 UNF OPS Plan ENT Edition"
        "aedfac18-56b8-45e3-969b-53edb4ba4952" = "Enterprise Mobility + Security A3 for Faculty"
        "efccb6f7-5641-4e0e-bd10-b4976e1bf68e" = "Enterprise Mobility + Security E3"
        "b05e124f-c7cc-45a0-a6aa-8cf78c946968" = "Enterprise Mobility + Security E5"
        "a461b89c-10e3-471c-82b8-aae4d820fccb" = "Enterprise Mobility + Security E5_USGOV_GCCHIGH"
        "c793db86-5237-494e-9b11-dcd4877c2c8c" = "Enterprise Mobility + Security G3 GCC"
        "8a180c2b-f4cf-4d44-897c-3d32acc4a60b" = "Enterprise Mobility + Security G5 GCC"
        "e8ecdf70-47a8-4d39-9d15-093624b7f640" = "Exchange Enterprise CAL Services (EOP, DLP)"
        "4b9405b0-7788-4568-add1-99614e613b69" = "Exchange Online (Plan 1)"
        "ad2fe44a-915d-4e2b-ade1-6766d50a9d9c" = "Exchange Online (Plan 1) for Students"
        "aa0f9eb7-eff2-4943-8424-226fb137fcad" = "Exchange Online (Plan 1) for Alumni with Yammer"
        "19ec0d23-8335-4cbd-94ac-6050e30712fa" = "Exchange Online (PLAN 2)"
        "0b7b15a8-7fd2-4964-bb96-5a566d4e3c15" = "Exchange Online (Plan 2) for Faculty"
        "7be8dc28-4da4-4e6d-b9b9-c60f2806df8a" = "Exchange Online (Plan 2) for GCC"
        "ee02fd1b-340e-4a4b-b355-4a514e4c8943" = "Exchange Online Archiving for Exchange Online"
        "90b5e015-709a-4b8b-b08e-3200f994494c" = "Exchange Online Archiving for Exchange Server"
        "7fc0182e-d107-4556-8329-7caaa511197b" = "Exchange Online Essentials (ExO P1 Based)"
        "e8f81a67-bd96-4074-b108-cf193eb9433b" = "Exchange Online Essentials"
        "80b2d799-d2ba-4d2a-8842-fb0d0f3a4b82" = "Exchange Online Kiosk"
        "f37d5ebf-4bf1-4aa2-8fa3-50c51059e983" = "Exchange Online (Plan 1) for GCC"
        "cb0a98a8-11bc-494c-83d9-c1b1ac65327e" = "Exchange Online POP"
        "45a2423b-e884-448d-a831-d9e139c52d2f" = "Exchange Online Protection"
        "061f9ace-7d42-4136-88ac-31dc755f143f" = "Intune"
        "d9d89b70-a645-4c24-b041-8d3cb1884ec7" = "Intune for Education"
        "fcecd1f9-a91e-488d-a918-a96cdb6ce2b0" = "Microsoft Dynamics AX7 User Trial"
        "cb2020b1-d8f6-41c0-9acd-8ff3d6d7831b" = "Microsoft Azure Multi-Factor Authentication"
        "3dd6cf57-d688-4eed-ba52-9e40b5468c3e" = "Microsoft Defender for Office 365 (Plan 2)"
        "b17653a4-2443-4e8c-a550-18249dda78bb" = "Microsoft 365 A1"
        "4b590615-0888-425a-a965-b3bf7789848d" = "Microsoft 365 A3 for faculty"
        "7cfd9a2b-e110-4c39-bf20-c6a3f36a3121" = "Microsoft 365 A3 for students"
        "18250162-5d87-4436-a834-d795c15c80f3" = "Microsoft 365 A3 student use benefits"
        "32a0e471-8a27-4167-b24f-941559912425" = "Microsoft 365 A3 Suite features for faculty"
        "1aa94593-ca12-4254-a738-81a5972958e8" = "Microsoft 365 A3 - Unattended License for students use benefit"
        "e97c048c-37a4-45fb-ab50-922fbf07a370" = "Microsoft 365 A5 for Faculty"
        "46c119d4-0379-4a9d-85e4-97c66d3f909e" = "Microsoft 365 A5 for students"
        "31d57bc7-3a05-4867-ab53-97a17835a411" = "Microsoft 365 A5 student use benefits"
        "9b8fe788-6174-4c4e-983b-3330c93ec278" = "Microsoft 365 A5 Suite features for faculty"
        "81441ae1-0b31-4185-a6c0-32b6b84d419f" = "Microsoft 365 A5 without Audio Conferencing for students use benefit"
        "cdd28e44-67e3-425e-be4c-737fab2899d3" = "Microsoft 365 Apps for Business"
        "b214fe43-f5a3-4703-beeb-fa97188220fc" = "Microsoft 365 Apps for Business"
        "c2273bd0-dff7-4215-9ef5-2c7bcfb06425" = "Microsoft 365 Apps for enterprise"
        "ea4c5ec8-50e3-4193-89b9-50da5bd4cdc7" = "Microsoft 365 Apps for enterprise (device)"
        "12b8c807-2e20-48fc-b453-542b6ee9d171" = "Microsoft 365 Apps for Faculty"
        "c32f9321-a627-406d-a114-1f9c81aaafac" = "Microsoft 365 Apps for Students"
        "2d3091c7-0712-488b-b3d8-6b97bde6a1f5" = "Microsoft 365 Audio Conferencing for GCC"
        "170ba00c-38b2-468c-a756-24c05037160a" = "Microsoft 365 Audio Conferencing - GCCHigh Tenant (AR)_USGOV_GCCHIGH"
        "4dee1f32-0808-4fd2-a2ed-fdd575e3a45f" = "Microsoft 365 Audio Conferencing_USGOV_GCCHIGH"
        "df9561a4-4969-4e6a-8e73-c601b68ec077" = "Microsoft 365 Audio Conferencing Pay-Per-Minute - EA"
        "3b555118-da6a-4418-894f-7df1e2096870" = "Microsoft 365 Business Basic"
        "dab7782a-93b1-4074-8bb1-0e61318bea0b" = "Microsoft 365 Business Basic"
        "b1f3042b-a390-4b56-ab61-b88e7e767a97" = "Microsoft 365 Business Basic EEA (no Teams)"
        "f245ecc8-75af-4f8e-b61f-27d8114de5f3" = "Microsoft 365 Business Standard"
        "ffa3a2a0-3820-462a-aa81-8a4d741f0cba" = "Microsoft 365 Business Standard EEA (no Teams)"
        "c1f79c29-5d7a-4bec-a2c1-1a76774864c0" = "Microsoft 365 Business Standard EEA (no Teams)"
        "ac5cef5d-921b-4f97-9ef3-c99076e5470f" = "Microsoft 365 Business Standard - Prepaid Legacy"
        "cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46" = "Microsoft 365 Business Premium"
        "a3f586b6-8cce-4d9b-99d6-55238397f77a" = "Microsoft 365 Business Premium EEA (no Teams)"
        "08d7bce8-6e16-490e-89db-1d508e5e9609" = "Microsoft 365 Business Voice (US)"
        "d52db95a-5ecb-46b6-beb0-190ab5cda4a8" = "Microsoft 365 Business Voice (without Calling Plan)"
        "a6051f20-9cbc-47d2-930d-419183bf6cf1" = "Microsoft 365 Business Voice"
        "e5a17adf-8f0d-4b57-bc14-d331235f9307" = "Microsoft 365 Business Voice (UK)"
        "d13e9d1b-316a-4946-98c6-362c97a4fdfe" = "Microsoft 365 Domestic Calling Plan (120 minutes) – US"
        "923f58ab-fca1-46a1-92f9-89fda21238a8" = "Microsoft 365 Domestic Calling Plan for GCC"
        "05e9a617-0261-4cee-bb44-138d3ef5d965" = "Microsoft 365 E3"
        "dcf0408c-aaec-446c-afd4-43e3683943ea" = "Microsoft 365 E3 (no Teams)"
        "c2fe850d-fbbb-4858-b67d-bd0c6e746da3" = "Microsoft 365 E3 EEA (no Teams)"
        "a23dbafb-3396-48b3-ad9c-a304fe206043" = "Microsoft 365 E3 EEA (no Teams) - Unattended License"
        "602e6573-55a3-46b1-a1a0-cc267991501a" = "Microsoft 365 E3 EEA (no Teams) (500 seats min)_HUB"
        "f5b15d67-b99e-406b-90f1-308452f94de6" = "Microsoft 365 E3 Extra Features"
        "c2ac2ee4-9bb1-47e4-8541-d689c7e83371" = "Microsoft 365 E3 - Unattended License"
        "0c21030a-7e60-4ec7-9a0f-0042e0e0211a" = "Microsoft 365 E3 (500 seats min)_HUB"
        "d61d61cc-f992-433f-a577-5bd016037eeb" = "Microsoft 365 E3_USGOV_DOD"
        "ca9d1dd9-dfe9-4fef-b97c-9bc1ea3c3658" = "Microsoft 365 E3_USGOV_GCCHIGH"
        "06ebc4ee-1bb5-47dd-8120-11324bc54e06" = "Microsoft 365 E5"
        "db684ac5-c0e7-4f92-8284-ef9ebde75d33" = "Microsoft 365 E5 (500 seats min)_HUB"
        "c42b9cae-ea4f-4ab7-9717-81576235ccac" = "Microsoft 365 E5 Developer (without Windows and Audio Conferencing)"
        "184efa21-98c3-4e5d-95ab-d07053a96e67" = "Microsoft 365 E5 Compliance"
        "3271cf8e-2be5-4a09-a549-70fd05baaa17" = "Microsoft 365 E5 EEA (no Teams)"
        "1e988bf3-8b7c-4731-bec0-4e2a2946600c" = "Microsoft 365 E5 EEA (no Teams) (500 seats min)_HUB"
        "6ee4114a-9b2d-4577-9e7a-49fa43d222d3" = "Microsoft 365 E5 EEA (no Teams) with Calling Minutes"
        "90277bc7-a6fe-4181-99d8-712b08b8d32b" = "Microsoft 365 E5 EEA (no Teams) without Audio Conferencing"
        "a640eead-25f6-4bec-97e3-23cfd382d7c2" = "Microsoft 365 E5 EEA (no Teams) without Audio Conferencing (500 seats min)_HUB"
        "26124093-3d78-432b-b5dc-48bf992543d5" = "Microsoft 365 E5 Security"
        "44ac31e7-2999-4304-ad94-c948886741d4" = "Microsoft 365 E5 Security for EMS E5"
        "a91fc4e0-65e5-4266-aa76-4037509c1626" = "Microsoft 365 E5 with Calling Minutes"
        "cd2925a3-5076-4233-8931-638a8c94f773" = "Microsoft 365 E5 without Audio Conferencing"
        "2113661c-6509-4034-98bb-9c47bd28d63c" = "Microsoft 365 E5 without Audio Conferencing (500 seats min)_HUB"
        "44575883-256e-4a79-9da4-ebe9acabe2b2" = "Microsoft 365 F1"
        "0666269f-b167-4c5b-a76f-fc574f2b1118" = "Microsoft 365 F1 EEA (no Teams)"
        "66b55226-6b4f-492c-910c-a3b7a3c9d993" = "Microsoft 365 F3"
        "f7ee79a7-7aec-4ca4-9fb9-34d6b930ad87" = "Microsoft 365 F3 EEA (no Teams)"
        "91de26be-adfa-4a3d-989e-9131cc23dda7" = "Microsoft 365 F5 Compliance Add-on"
        "9cfd6bc3-84cd-4274-8a21-8c7c41d6c350" = "Microsoft 365 F5 Compliance Add-on AR DOD_USGOV_DOD"
        "9f436c0e-fb32-424b-90be-6a9f2919d506" = "Microsoft 365 F5 Compliance Add-on AR_USGOV_GCCHIGH"
        "3f17cf90-67a2-4fdb-8587-37c1539507e1" = "Microsoft 365 F5 Compliance Add-on GCC"
        "67ffe999-d9ca-49e1-9d2c-03fb28aa7a48" = "Microsoft 365 F5 Security Add-on"
        "32b47245-eb31-44fc-b945-a8b1576c439f" = "Microsoft 365 F5 Security + Compliance Add-on"
        "f30db892-07e9-47e9-837c-80727f46fd3d" = "Microsoft Power Automate Free"
        "99cc8282-2f74-4954-83b7-c6a9a1999067" = "Microsoft 365 E5 Extra Features"
        "50f60901-3181-4b75-8a2c-4c8e4c1d5a72" = "Microsoft 365 F1"
        "4eb45c5b-0d19-4e33-b87c-adfc25268f20" = "Microsoft 365 E5_USGOV_GCCHIGH"
        "2a914830-d700-444a-b73c-e3f31980d833" = "Microsoft 365 F3 GCC"
        "e823ca47-49c4-46b3-b38d-ca11d5abe3d2" = "Microsoft 365 G3 GCC"
        "5c739a73-651d-4c2c-8a4e-fe4ba12253b0" = "Microsoft 365 G3 - Unattended License for GCC"
        "e2be619b-b125-455f-8660-fb503e431a5d" = "Microsoft 365 GCC G5"
        "b0f809d5-a662-4391-a5aa-136e9c565b9d" = "Microsoft 365 GCC G5 w/o WDATP/CAS Unified"
        "9c0587f3-8665-4252-a8ad-b7a5ade57312" = "Microsoft 365 Lighthouse"
        "2347355b-4e81-41a4-9c22-55057a399791" = "Microsoft 365 Security and Compliance for Firstline Workers"
        "726a0894-2c77-4d65-99da-9775ef05aad1" = "Microsoft Business Center"
        "556640c0-53ea-4773-907d-29c55332983f" = "Microsoft Cloud for Sustainability vTrial"
        "df845ce7-05f9-4894-b5f2-11bbfbcfd2b6" = "Microsoft Cloud App Security"
        "111046dd-295b-4d6d-9724-d52ac90bd1f2" = "Microsoft Defender for Endpoint"
        "e430a580-c37b-4d16-adba-d881d7cd0364" = "Microsoft Defender for Endpoint F2"
        "16a55f2f-ff35-4cd5-9146-fb784e3761a5" = "Microsoft Defender for Endpoint P1"
        "bba890d4-7881-4584-8102-0c3fdfb739a7" = "Microsoft Defender for Endpoint P1 for EDU"
        "b126b073-72db-4a9d-87a4-b17afe41d4ab" = "Microsoft Defender for Endpoint P2_XPLAT"
        "509e8ab6-0274-4cda-bcbd-bd164fd562c4" = "Microsoft Defender for Endpoint Server"
        "26ad4b5c-b686-462e-84b9-d7c22b46837f" = "Microsoft Defender for Office 365 (Plan 1) Faculty"
        "906af65a-2970-46d5-9b58-4e9aa50f0657" = "Microsoft Dynamics CRM Online Basic"
        "98defdf7-f6c1-44f5-a1f6-943b6764e7a5" = "Microsoft Defender for Identity"
        "d0d1ca43-b81a-4f51-81e5-a5b1ad7bb005" = "Microsoft Defender for Office 365 (Plan 1) GCC"
        "917fb2b4-f71c-43a1-8edc-75532b554bb5" = "Microsoft Defender for Office 365 (Plan 1) Student"
        "a237b6d8-572e-4839-bffd-7786d32a5d0e" = "Microsoft Defender for Office 365 (Plan 1) Student use benefit"
        "550f19ba-f323-4a7d-a8d2-8971b0d9ea85" = "Microsoft Defender for Office 365 (Plan 1)_USGOV_GCCHIGH"
        "56a59ffb-9df1-421b-9e61-8b568583474d" = "Microsoft Defender for Office 365 (Plan 2) GCC"
        "1925967e-8013-495f-9644-c99f8b463748" = "Microsoft Defender Vulnerability Management"
        "ad7a56e0-6903-4d13-94f3-5ad491e78960" = "Microsoft Defender Vulnerability Management Add-on"
        "d17b27af-3f49-4822-99f9-56a661538792" = "Microsoft Dynamics CRM Online"
        "3856cd1b-8033-458e-8d0f-9909ec6e6e6d" = "Microsoft Dynamics CRM Online Basic for Government"
        "ba051a1a-4c3d-4ccd-9890-6fa6a4e696e7" = "Microsoft Dynamics CRM Online for Government"
        "cf6b0d46-4093-4546-a0ab-0b1546dcc10e" = "Microsoft Entra ID Governance"
        "a403ebcc-fae0-4ca2-8c8c-7a907fd6c235" = "Microsoft Fabric (Free)"
        "ade29b5f-397e-4eb9-a287-0344bd46c68d" = "Microsoft Fabric (Free) for faculty"
        "bdcaf6aa-04c1-4b8f-b64e-6e3bd505ac64" = "Microsoft Fabric (Free) for student"
        "ba9a34de-4489-469d-879c-0f0f145321cd" = "Microsoft Imagine Academy"
        "2b317a4a-77a6-4188-9437-b68a77b4e2c6" = "Microsoft Intune Device"
        "2c21e77a-e0d6-4570-b38a-7ff2dc17d2ca" = "Microsoft Intune Device for Government"
        "2b26f637-35a0-4dbc-b69e-ff674782be9d" = "Microsoft Intune Government"
        "b4288abe-01be-47d9-ad20-311d6e83fc24" = "Microsoft Intune Plan 1 A VL_USGOV_GCCHIGH"
        "a929cd4d-8672-47c9-8664-159c1f322ba8" = "Microsoft Intune Suite"
        "dcb1a3ae-b33f-4487-846a-a640262fadf4" = "Microsoft Power Apps Plan 2 Trial"
        "4755df59-3f73-41ab-a249-596ad72b5504" = "Microsoft Power Automate Plan 2"
        "e6025b08-2fa5-4313-bd0a-7e5ffca32958" = "Microsoft Intune SMB"
        "5b631642-bd26-49fe-bd20-1daaa972ef80" = "Microsoft PowerApps for Developer"
        "ddfae3e3-fcb2-4174-8ebd-3023cb213c8b" = "Microsoft Power Apps Plan 2 (Qualified Offer)"
        "4f05b1a3-a978-462c-b93f-781c6bee998f" = "Microsoft Relationship Sales solution"
        "1f2f344a-700d-42c9-9427-5cea1d5d7ba6" = "Microsoft Stream"
        "ec156933-b85b-4c50-84ec-c9e5603709ef" = "Microsoft Stream Plan 2"
        "9bd7c846-9556-4453-a542-191d527209e8" = "Microsoft Stream Storage Add-On (500 GB)"
        "ece037b4-a52b-4cf8-93ea-649e5d83767a" = "Microsoft Sustainability Manager USL Essentials"
        "1c27243e-fb4d-42b1-ae8c-fe25c9616588" = "Microsoft Teams Audio Conferencing with dial-out to USA/CAN"
        "16ddbbfc-09ea-4de2-b1d7-312db6112d70" = "Microsoft Teams (Free)"
        "9b196e97-5830-4c2e-adc2-1e10ebf5dee5" = "Microsoft Teams Calling Plan pay-as-you-go (country zone 1 - US)"
        "729dbb8f-8d56-4994-8e33-2f218f549544" = "Microsoft Teams Domestic Calling Plan (240 min)"
        "7e74bd05-2c47-404e-829a-ba95c66fe8e5" = "Microsoft Teams EEA"
        "fde42873-30b6-436b-b361-21af5a6b84ae" = "Microsoft Teams Essentials"
        "3ab6abff-666f-4424-bfb7-f0bc274ec7bc" = "Microsoft Teams Essentials (Microsoft Entra identity)"
        "710779e8-3d4a-4c88-adb9-386c958d1fdf" = "Microsoft Teams Exploratory"
        "e0dfc8b9-9531-4ec8-94b4-9fec23b05fc8" = "Microsoft Teams Exploratory Dept"
        "e43b5b99-8dfb-405f-9987-dc307f34bcbd" = "Microsoft Teams Phone Standard"
        "d01d9287-694b-44f3-bcc5-ada78c8d953e" = "Microsoft Teams Phone Standard for DOD"
        "d979703c-028d-4de5-acbf-7955566b69b9" = "Microsoft Teams Phone Standard for Faculty"
        "a460366a-ade7-4791-b581-9fbff1bdaa85" = "Microsoft Teams Phone Standard for GCC"
        "7035277a-5e49-4abc-a24f-0ec49c501bb5" = "Microsoft Teams Phone Standard for GCCHIGH"
        "aa6791d3-bb09-4bc2-afed-c30c3fe26032" = "Microsoft Teams Phone Standard for Small and Medium Business"
        "1f338bbc-767e-4a1e-a2d4-b73207cc5b93" = "Microsoft Teams Phone Standard for Student"
        "ffaf2d68-1c95-4eb3-9ddd-59b81fba0f61" = "Microsoft Teams Phone Standard for TELSTRA"
        "b0e7de67-e503-4934-b729-53d595ba5cd1" = "Microsoft Teams Phone Standard_System_USGOV_DOD"
        "985fcb26-7b94-475b-b512-89356697be71" = "Microsoft Teams Phone Standard_USGOV_GCCHIGH"
        "440eaaa8-b3e0-484b-a8be-62870b9ba70a" = "Microsoft Teams Phone Resource Account"
        "0e142028-345e-45da-8d92-8bfd4093bbb9" = "Microsoft Teams Phone Resource Account for Faculty"
        "2cf22bcb-0c9e-4bc6-8daf-7e7654c0f285" = "Microsoft Teams Phone Resource Account for GCC"
        "e3f0522e-ebb7-4561-9f90-b44516d65b77" = "Microsoft Teams Phone Resource Account_USGOV_GCCHIGH"
        "36a0f3b3-adb5-49ea-bf66-762134cf063a" = "Microsoft Teams Premium Introductory Pricing"
        "6af4b3d6-14bb-4a2a-960c-6c902aad34f3" = "Microsoft Teams Rooms Basic"
        "a4e376bd-c61e-4618-9901-3fc0cb1b88bb" = "Microsoft Teams Rooms Basic for EDU"
        "50509a35-f0bd-4c5e-89ac-22f0e16a00f8" = "Microsoft Teams Rooms Basic without Audio Conferencing"
        "4cde982a-ede4-4409-9ae6-b003453c8ea6" = "Microsoft Teams Rooms Pro"
        "c25e2b36-e161-4946-bef2-69239729f690" = "Microsoft Teams Rooms Pro for EDU"
        "31ecb341-2a17-483e-9140-c473006d1e1a" = "Microsoft Teams Rooms Pro for GCC"
        "21943e3a-2429-4f83-84c1-02735cd49e78" = "Microsoft Teams Rooms Pro without Audio Conferencing"
        "6070a4c8-34c6-4937-8dfb-39bbc6397a60" = "Microsoft Teams Rooms Standard"
        "9571e9ac-2741-4b63-95fd-a79696f0d0ac" = "Microsoft Teams Rooms Standard for GCC"
        "b4348f75-a776-4061-ac6c-36b9016b01d1" = "Microsoft Teams Rooms Standard for GCC without Audio Conferencing"
        "295a8eb0-f78d-45c7-8b5b-1eed5ed02dff" = "Microsoft Teams Shared Devices"
        "420c7602-7f70-4895-9394-d3d679ea36fb" = "Microsoft Teams Shared Devices for Faculty"
        "b1511558-69bd-4e1b-8270-59ca96dba0f3" = "Microsoft Teams Shared Devices for GCC"
        "74fbf1bb-47c6-4796-9623-77dc7371723b" = "Microsoft Teams Trial"
        "9fa2f157-c8e4-4351-a3f2-ffa506da1406" = "Microsoft Threat Experts - Experts on Demand"
        "3d957427-ecdc-4df2-aacd-01cc9d519da8" = "Microsoft Workplace Analytics"
        "ba929637-f158-4dee-927c-eb7cdefcd955" = "Microsoft Viva Goals"
        "3dc7332d-f0fa-40a3-81d3-dd6b84469b78" = "Microsoft Viva Glint"
        "61902246-d7cb-453e-85cd-53ee28eec138" = "Microsoft Viva Suite"
        "984df360-9a74-4647-8cf8-696749f6247a" = "Minecraft Education Faculty"
        "533b8f26-f74b-4e9c-9c59-50fc4b393b63" = "Minecraft Education Student"
        "84951599-62b7-46f3-9c9d-30551b2ad607" = "Office 365 Multi-Geo Capabilities"
        "aa2695c9-8d59-4800-9dc8-12e01f1735af" = "Nonprofit Portal"
        "94763226-9b3c-4e75-a931-5c89701abe66" = "Office 365 A1 for Faculty"
        "78e66a63-337a-4a9a-8959-41c6654dfb56" = "Office 365 A1 Plus for Faculty"
        "314c4481-f395-4525-be8b-2ec4bb1e9d91" = "Office 365 A1 for Students"
        "e82ae690-a2d5-4d76-8d30-7c6e01e6022e" = "Office 365 A1 Plus for Students"
        "e578b273-6db4-4691-bba0-8d691f4da603" = "Office 365 A3 for Faculty"
        "98b6e773-24d4-4c0d-a968-6e787a1f8204" = "Office 365 A3 for Students"
        "a4585165-0533-458a-97e3-c400570268c4" = "Office 365 A5 for faculty"
        "ee656612-49fa-43e5-b67e-cb1fdf7699df" = "Office 365 A5 for students"
        "1b1b1f7a-8355-43b6-829f-336cfccb744c" = "Office 365 Advanced Compliance"
        "a809996b-059e-42e2-9866-db24b99a9782" = "Microsoft Copilot for Microsoft 365"
        "4ef96642-f096-40de-a3e9-d83fb2f90211" = "Microsoft Defender for Office 365 (Plan 1)"
        "e5788282-6381-469f-84f0-3d7d4021d34d" = "Office 365 Extra File Storage for GCC"
        "29a2f828-8f39-4837-b8ff-c957e86abe3c" = "Microsoft Teams Commercial Cloud"
        "3227bcb2-8448-4f81-b3c2-8c2074e15a2a" = "Microsoft Sales Copilot"
        "84d5f90f-cd0d-4864-b90b-1c7ba63b4808" = "Office 365 Cloud App Security"
        "99049c9c-6011-4908-bf17-15f496e6519d" = "Office 365 Extra File Storage"
        "18181a46-0d4e-45cd-891e-60aabd171b4e" = "Office 365 E1"
        "b57282e3-65bd-4252-9502-c0eae1e5ab7f" = "Office 365 E1 EEA (no Teams)"
        "f698ca06-024f-4562-b029-9cb1f1e02646" = "Office 365 E1_USGOV_GCCHIGH"
        "6634e0ce-1a9f-428c-a498-f84ec7b8aa2e" = "Office 365 E2"
        "6fd2c87f-b296-42f0-b197-1e91e994b900" = "Office 365 E3"
        "46c3a859-c90d-40b3-9551-6178a48d5c18" = "Office 365 E3 (no Teams)"
        "d711d25a-a21c-492f-bd19-aae1e8ebaf30" = "Office 365 E3 EEA (no Teams)"
        "189a915c-fe4f-4ffa-bde4-85b9628d07a0" = "Office 365 E3 Developer"
        "b107e5a3-3e60-4c0d-a184-a7e4395eb44c" = "Office 365 E3_USGOV_DOD"
        "aea38a85-9bd5-4981-aa00-616b411205bf" = "Office 365 E3_USGOV_GCCHIGH"
        "1392051d-0cb9-4b7a-88d5-621fee5e8711" = "Office 365 E4"
        "c7df2760-2c81-4ef7-b578-5b5392b571df" = "Office 365 E5"
        "cf50bae9-29e8-4775-b07c-56ee10e3776d" = "Office 365 E5 EEA (no Teams)"
        "71772aeb-4bb8-4f74-9dd4-36c7a9b5ca74" = "Office 365 E5 EEA (no Teams) without Audio Conferencing"
        "26d45bd9-adf1-46cd-a9e1-51e9a5524128" = "Office 365 E5 without Audio Conferencing"
        "4b585984-651b-448a-9e53-3b10f069cf7f" = "Office 365 F3"
        "d1f0495b-cb7b-4e11-8b85-daee7e7e5664" = "Office 365 F3 EEA (no Teams)"
        "74039b88-bd62-4b5c-9d9c-7a92bbc0bfdf" = "Office 365 F3_USGOV_GCCHIGH"
        "3f4babde-90ec-47c6-995d-d223749065d1" = "Office 365 G1 GCC"
        "535a3a29-c5f0-42fe-8215-d3b9e1f38c4a" = "Office 365 G3 GCC"
        "24aebea8-7fac-48d0-8750-de4ee1fde205" = "Office 365 G3 without Microsoft 365 Apps GCC"
        "8900a2c0-edba-4079-bdf3-b276e293b6a8" = "Office 365 G5 GCC"
        "2f105cc2-c2c1-435b-a955-c5e82156c05d" = "Office 365 GCC G5 without Power BI and Phone System"
        "1341559b-49df-443c-8e79-fa604fed2d82" = "Office 365 GCC G5 without Audio Conferencing"
        "1a585bba-1ce3-416e-b1d6-9c482b52fcf6" = "Office 365 Advanced Compliance for GCC"
        "04a7fb0d-32e0-4241-b4f5-3f7618cd1162" = "Office 365 Midsize Business"
        "bd09678e-b83c-4d3f-aaba-3dad4abd128b" = "Office 365 Small Business"
        "fc14ec4a-4169-49a4-a51e-2c852931814b" = "Office 365 Small Business Premium"
        "64fca79f-c471-4e13-a335-9069cddf8aeb" = "Office Mobile Apps for Office 365 for GCC"
        "e6778190-713e-4e4f-9119-8b8238de25df" = "OneDrive for Business (Plan 1)"
        "ed01faf2-1d88-4947-ae91-45ca18703a96" = "OneDrive for Business (Plan 2)"
        "0f13a262-dc6f-4800-8dc6-a62f72c95fad" = "PowerApps & Flow GCC Test - O365 & Dyn365 Plans"
        "87bbbc60-4754-4998-8c88-227dca264858" = "Power Apps and Logic Flows"
        "bf666882-9c9b-4b2e-aa2f-4789b0a52ba2" = "Power Apps per app baseline access"
        "a8ad7d2b-b8cf-49d6-b25a-69094a0be206" = "Power Apps per app Plan"
        "b4d7b828-e8dc-4518-91f9-e123ae48440d" = "Power Apps per app Plan (1 app or portal)"
        "cdc8d0fc-fd16-4954-aae6-ed89a99f5620" = "Power Apps Per App BD Only for GCC"
        "816ee058-f70c-42ad-b433-d6171984ea20" = "Power Apps per app plan (1 app or website) BD Only – GCC"
        "c14d7f00-457c-4e3e-8960-48f35459b3c9" = "Power Apps per app plan (1 app or website) for Government"
        "8623b2d7-5e24-4281-b6b7-086a5f3b0b1c" = "Power Apps per app plan for Government"
        "2ced8a00-3ed1-4295-ab7c-57170ff28e58" = "Power Apps Per User BD Only"
        "b30411f5-fea1-4a59-9ad9-3db7c7ead579" = "Power Apps Premium"
        "8e4c6baa-f2ff-4884-9c38-93785d0d7ba1" = "Power Apps Premium for Government"
        "eca22b68-b31f-4e9c-a20c-4d40287bc5dd" = "Power Apps Plan 1 for Government"
        "57f3babd-73ce-40de-bcb2-dadbfbfff9f7" = "Power Apps Portals login capacity add-on Tier 2 (10 unit min)"
        "26c903d5-d385-4cb1-b650-8d81a643b3c4" = "Power Apps Portals login capacity add-on Tier 2 (10 unit min) for Government"
        "927d8402-8d3b-40e8-b779-34e859f7b497" = "Power Apps Portals login capacity add-on Tier 3 (50 unit min)"
        "a0de5e3a-2500-4a19-b8f4-ec1c64692d22" = "Power Apps Portals page view capacity add-on"
        "15a64d3e-5b99-4c4b-ae8f-aa6da264bfe7" = "Power Apps Portals page view capacity add-on for Government"
        "b3a42176-0a8c-4c3f-ba4e-f2b37fe5be6b" = "Power Automate per flow plan"
        "d9de51e5-d8cd-45bb-8da3-1d55e28c52e6" = "Power Automate per flow plan for Government"
        "4a51bf65-409c-4a91-b845-1121b571cc9d" = "Power Automate per user plan"
        "d80a4c5d-8f05-4b64-9926-6574b9e6aee4" = "Power Automate per user plan dept"
        "c8803586-c136-479a-8ff3-f5f32d23a68e" = "Power Automate per user plan for Government"
        "eda1941c-3c4f-4995-b5eb-e85a42175ab9" = "Power Automate Premium"
        "2b3b0c87-36af-4d15-8124-04a691cc2546" = "Power Automate Plan 1 for Government (Qualified Offer)"
        "d3987516-4b53-4dc0-8335-411260bf5626" = "Power Automate Premium for Government"
        "3539d28c-6e35-4a30-b3a9-cd43d5d3e0e2" = "Power Automate unattended RPA add-on"
        "086e9b70-4720-4442-ab6d-3ef32bfb4721" = "Power Automate unattended RPA add-on for Government"
        "e2767865-c3c9-4f09-9f99-6eee6eef861a" = "Power BI"
        "45bc2c81-6072-436a-9b0b-3b12eefbc402" = "Power BI for Office 365 Add-On"
        "7b26f5ab-a763-4c00-a1ac-f6c4b5506945" = "Power BI Premium P1"
        "f59b22a0-9819-48bf-b01d-715ef2b31027" = "Power BI Premium P1 GCC"
        "c1d032e0-5619-4761-9b5c-75b6831e1711" = "Power BI Premium Per User"
        "de376a03-6e5b-42ec-855f-093fb50b8ca5" = "Power BI Premium Per User Add-On"
        "1b572d5e-1bf8-4b19-9259-f9eda31a6972" = "Power BI Premium Per User Add-On for GCC"
        "66024bbf-4cd4-4329-95c8-c932e2ae01a8" = "Power BI Premium Per User Add-On for GCC"
        "060d8061-f606-4e69-a4e7-e8fff75ea1f5" = "Power BI Premium Per User for Faculty"
        "f168a3fb-7bcf-4a27-98c3-c235ea4b78b4" = "Power BI Premium Per User Dept"
        "e53d92fc-778b-4a8b-83de-791240ebf88d" = "Power BI Premium Per User for Government"
        "f8a1db68-be16-40ed-86d5-cb42ce701560" = "Power BI Pro"
        "420af87e-8177-4146-a780-3786adaffbca" = "Power BI Pro CE"
        "3a6a908c-09c5-406a-8170-8ebb63c42882" = "Power BI Pro Dept"
        "de5f128b-46d7-4cfc-b915-a89ba060ea56" = "Power BI Pro for Faculty"
        "f0612879-44ea-47fb-baf0-3d76d9235576" = "Power BI Pro for GCC"
        "debc9e58-f2d7-412c-a0b6-575608564228" = "Power Pages authenticated users T1 100 users/per site/month capacity pack"
        "9a3c2a19-06c0-41b1-b2ea-13528d7b2e17" = "Power Pages authenticated users T1 100 users/per site/month capacity pack CN_CN"
        "27cb5f12-2e3f-4997-a649-45298673e6a1" = "Power Pages authenticated users T1 100 users/per site/month capacity pack_GCC"
        "b54f012e-69e1-43b1-87d0-666def064940" = "Power Pages authenticated users T1 100 users/per site/month capacity pack_USGOV_DOD"
        "978ec396-f930-4ee1-85f3-e1d82e8f73a4" = "Power Pages authenticated users T1 100 users/per site/month capacity pack_USGOV_GCCHIGH"
        "6fe1e61a-91e5-40d7-a547-0d2dcc81bce8" = "Power Pages authenticated users T2 min 100 units - 100 users/per site/month capacity pack"
        "7d2bb54a-a870-41c2-98d1-1f3b5b523275" = "Power Pages authenticated users T2 min 100 units - 100 users/per site/month capacity pack CN_CN"
        "5f43d48c-dd3d-4dd8-a059-70c2f040f979" = "Power Pages authenticated users T2 min 100 units - 100 users/per site/month capacity pack_GCC"
        "f3d55e2d-4367-44fa-952e-83d0b5dd53fc" = "Power Pages authenticated users T2 min 100 units - 100 users/per site/month capacity pack_USGOV_DOD"
        "7cae5432-61bb-48c3-b75c-831394ec13a0" = "Power Pages authenticated users T2 min 100 units - 100 users/per site/month capacity pack_USGOV_GCCHIGH"
        "878b8bbd-3cd0-4b44-9a56-3406741e65e0" = "Power Pages authenticated users T3 min 1,000 units - 100 users/per site/month capacity pack"
        "2cfd692f-a352-4fa8-b960-e3ad0c9b1178" = "Power Pages authenticated users T3 min 1,000 units - 100 users/per site/month capacity pack CN_CN"
        "53265c61-c78c-4223-ab30-422da0c97fbb" = "Power Pages authenticated users T3 min 1,000 units - 100 users/per site/month capacity pack_GCC"
        "398d37b5-8deb-48db-8f7f-703eb2fb7c72" = "Power Pages authenticated users T3 min 1,000 units - 100 users/per site/month capacity pack_USGOV_DOD"
        "01d46c34-3525-47d5-bd1a-5f19979938a0" = "Power Pages authenticated users T3 min 1,000 units - 100 users/per site/month capacity pack_USGOV_GCCHIGH"
        "3f9f06f5-3c31-472c-985f-62d9c10ec167" = "Power Pages vTrial for Makers"
        "bc757c42-5622-4583-a483-a9e537fcb71c" = "Power BI Premium EM1"
        "8ecbd3c1-b108-437c-a859-e3c125e3f83f" = "Power BI Premium EM2"
        "e4e55366-9635-46f4-a907-fc8c3b5ec81f" = "Power Virtual Agent"
        "9900a3e2-6660-4c52-9074-60c949991389" = "Power Virtual Agent for GCC"
        "4b74a65c-8b4a-4fc8-9f6b-5177ed11ddfa" = "Power Virtual Agent User License"
        "f1de227b-f1bd-4959-bd80-b80547095e6d" = "Power Virtual Agent User License for GCC"
        "606b54a9-78d8-4298-ad8b-df6ef4481c80" = "Power Virtual Agents Viral Trial"
        "e42bc969-759a-4820-9283-6b73085b68e6" = "Privacy Management – risk"
        "dcdbaae7-d8c9-40cb-8bb1-62737b9e5a86" = "Privacy Management - risk for EDU"
        "046f7d3b-9595-4685-a2e8-a2832d2b26aa" = "Privacy Management - risk GCC"
        "83b30692-0d09-435c-a455-2ab220d504b9" = "Privacy Management - risk_USGOV_DOD"
        "787d7e75-29ca-4b90-a3a9-0b780b35367c" = "Privacy Management - risk_USGOV_GCCHIGH"
        "d9020d1c-94ef-495a-b6de-818cbbcaa3b8" = "Privacy Management - subject rights request (1)"
        "475e3e81-3c75-4e07-95b6-2fed374536c8" = "Privacy Management - subject rights request (1) for EDU"
        "017fb6f8-00dd-4025-be2b-4eff067cae72" = "Privacy Management - subject rights request (1) GCC"
        "d3c841f3-ea93-4da2-8040-6f2348d20954" = "Privacy Management - subject rights request (1) USGOV_DOD"
        "706d2425-6170-4818-ba08-2ad8f1d2d078" = "Privacy Management - subject rights request (1) USGOV_GCCHIGH"
        "78ea43ac-9e5d-474f-8537-4abb82dafe27" = "Privacy Management - subject rights request (10)"
        "e001d9f1-5047-4ebf-8927-148530491f83" = "Privacy Management - subject rights request (10) for EDU"
        "a056b037-1fa0-4133-a583-d05cff47d551" = "Privacy Management - subject rights request (10) GCC"
        "ab28dfa1-853a-4f54-9315-f5146975ac9a" = "Privacy Management - subject rights request (10) USGOV_DOD"
        "f6aa3b3d-62f4-4c1d-a44f-0550f40f729c" = "Privacy Management - subject rights request (10) USGOV_GCCHIGH"
        "c416b349-a83c-48cb-9529-c420841dedd6" = "Privacy Management - subject rights request (50)"
        "f6c82f13-9554-4da1-bed3-c024cc906e02" = "Privacy Management - subject rights request (50)"
        "ed45d397-7d61-4110-acc0-95674917bb14" = "Privacy Management - subject rights request (50) for EDU"
        "cf4c6c3b-f863-4940-97e8-1d25e912f4c4" = "Privacy Management - subject rights request (100)"
        "9b85b4f0-92d9-4c3d-b230-041520cb1046" = "Privacy Management - subject rights request (100) for EDU"
        "91bbc479-4c2c-4210-9c88-e5b468c35b83" = "Privacy Management - subject rights request (100) GCC"
        "ba6e69d5-ba2e-47a7-b081-66c1b8e7e7d4" = "Privacy Management - subject rights request (100) USGOV_DOD"
        "cee36ce4-cc31-481f-8cab-02765d3e441f" = "Privacy Management - subject rights request (100) USGOV_GCCHIGH"
        "a10d5e58-74da-4312-95c8-76be4e5b75a0" = "Project for Office 365"
        "776df282-9fc0-4862-99e2-70e561b9909e" = "Project Online Essentials"
        "e433b246-63e7-4d0b-9efa-7940fa3264d6" = "Project Online Essentials for Faculty"
        "ca1a159a-f09e-42b8-bb82-cb6420f54c8e" = "Project Online Essentials for GCC"
        "09015f9f-377f-4538-bbb5-f75ceb09358a" = "Project Online Premium"
        "2db84718-652c-47a7-860c-f10d8abbdae3" = "Project Online Premium without Project Client"
        "f82a60b8-1ee3-4cfb-a4fe-1c6a53c2656c" = "Project Online with Project for Office 365"
        "beb6439c-caad-48d3-bf46-0c82871e12be" = "Planner Plan 1"
        "84cd610f-a3f8-4beb-84ab-d9d2c902c6c9" = "Project Plan 1 (for Department)"
        "53818b1b-4a27-454b-8896-0dba576410e6" = "Planner and Project Plan 3"
        "46102f44-d912-47e7-b0ca-1bd7b70ada3b" = "Project Plan 3 (for Department)"
        "46974aed-363e-423c-9e6a-951037cec495" = "Project Plan 3 for Faculty"
        "074c6829-b3a0-430a-ba3d-aca365e57065" = "Project Plan 3 for GCC"
        "5d505572-203c-4b83-aa9b-dab50fb46277" = "Project Plan 3 for GCC TEST"
        "64758d81-92b7-4855-bcac-06617becb3e8" = "Project Plan 3_USGOV_GCCHIGH"
        "930cc132-4d6b-4d8c-8818-587d17c50d56" = "Project Plan 5 for faculty"
        "f2230877-72be-4fec-b1ba-7156d6f75bd6" = "Project Plan 5 for GCC"
        "b732e2a7-5694-4dff-a0f2-9d9204c794ac" = "Project Plan 5 without Project Client for Faculty"
        "8c4ce438-32a7-4ac5-91a6-e22ae08d9c8b" = "Rights Management Adhoc"
        "093e8d14-a334-43d9-93e3-30589a8b47d0" = "Rights Management Service Basic Content Protection"
        "08e18479-4483-4f70-8f17-6f92156d8ea9" = "Sensor Data Intelligence Additional Machines Add-in for Dynamics 365 Supply Chain Management"
        "9ea4bdef-a20b-4668-b4a7-73e1f7696e0a" = "Sensor Data Intelligence Scenario Add-in for Dynamics 365 Supply Chain Management"
        "1fc08a02-8b3d-43b9-831e-f76859e04e1a" = "SharePoint Online (Plan 1)"
        "a9732ec9-17d9-494c-a51c-d6b45b384dcb" = "SharePoint Online (Plan 2)"
        "f61d4aba-134f-44e9-a2a0-f81a5adb26e4" = "SharePoint Syntex"
        "b8b749f8-a4ef-4887-9539-c95b1eaa5db7" = "Skype for Business Online (Plan 1)"
        "d42c793f-6c78-4f43-92ca-e8f6a02b035f" = "Skype for Business Online (Plan 2)"
        "d3b4fe1f-9992-4930-8acb-ca6ec609365e" = "Skype for Business PSTN Domestic and International Calling"
        "0dab259f-bf13-4952-b7f8-7db8f131b28d" = "Skype for Business PSTN Domestic Calling"
        "54a152dc-90de-4996-93d2-bc47e670fc06" = "Skype for Business PSTN Domestic Calling (120 Minutes)"
        "d43177b5-475b-4880-92d4-d54c27b5efbd" = "Skype for Business PSTN Calling Domestic Small"
        "06b48c5f-01d9-4b18-9015-03b52040f51a" = "Skype for Business PSTN Usage Calling Plan"
        "b84d58c9-0a0d-46cf-8a4b-d9f23c1674d5" = "Teams Phone Mobile"
        "ae2343d1-0999-43f6-ae18-d816516f6e78" = "Teams Phone with Calling Plan"
        "52ea0e27-ae73-4983-a08f-13561ebdb823" = "Teams Premium (for Departments)"
        "de3312e1-c7b0-46e6-a7c3-a515ff90bc86" = "TELSTRA Calling for O365"
        "9f3d9c1d-25a5-4aaa-8e59-23a1e6450a67" = "Universal Print"
        "ca7f3140-d88c-455b-9a1c-7f0679e31a76" = "Visio Plan 1"
        "38b434d2-a15e-4cde-9a98-e737c75623e1" = "Visio Plan 2"
        "4b244418-9658-4451-a2b8-b5e2b364e9bd" = "Visio Plan 1"
        "bf95fd32-576a-4742-8d7a-6dc4940b9532" = "Visio Plan 2 for Faculty"
        "c5928f49-12ba-48f7-ada3-0d743a3601d5" = "Visio Plan 2"
        "4ae99959-6b0f-43b0-b1ce-68146001bdba" = "Visio Plan 2 for GCC"
        "80e52531-ad7f-44ea-abc3-28e389462f1b" = "Visio Plan 2_USGOV_GCCHIGH"
        "3a349c99-ffec-43d2-a2e8-6b97fcb71103" = "Viva Goals User-led"
        "4016f256-b063-4864-816e-d818aad600c9" = "Viva Topics"
        "c9d442fc-21fb-4bd7-89e0-a710d74987f6" = "Viva Learning"
        "1e7e1070-8ccb-4aca-b470-d7cb538cb07e" = "Windows 10/11 Enterprise E5 (Original)"
        "8efbe2f6-106e-442f-97d4-a59aa6037e06" = "Windows 10/11 Enterprise A3 for faculty"
        "d4ef921e-840b-4b48-9a90-ab6698bc7b31" = "Windows 10/11 Enterprise A3 for students"
        "7b1a89a9-5eb9-4cf8-9467-20c943f1122c" = "Windows 10/11 Enterprise A5 for faculty"
        "cb10e6cd-9da4-4992-867b-67546b1db821" = "WINDOWS 10/11 ENTERPRISE E3"
        "6a0f6da5-0b87-4190-a6ae-9bb5a2b9546a" = "WINDOWS 10/11 ENTERPRISE E3"
        "488ba24a-39a9-4473-8ee5-19291e71b002" = "Windows 10/11 Enterprise E5"
        "938fd547-d794-42a4-996c-1cc206619580" = "Windows 10/11 Enterprise E5 Commercial (GCC Compatible)"
        "d13ef257-988a-46f3-8fce-f47484dd4550" = "Windows 10/11 Enterprise VDA"
        "816eacd3-e1e3-46b3-83c8-1ffd37e053d9" = "Windows 365 Business 1 vCPU 2 GB 64 GB"
        "135bee78-485b-4181-ad6e-40286e311850" = "Windows 365 Business 2 vCPU 4 GB 128 GB"
        "805d57c3-a97d-4c12-a1d0-858ffe5015d0" = "Windows 365 Business 2 vCPU 4 GB 256 GB"
        "42e6818f-8966-444b-b7ac-0027c83fa8b5" = "Windows 365 Business 2 vCPU 4 GB 64 GB"
        "71f21848-f89b-4aaa-a2dc-780c8e8aac5b" = "Windows 365 Business 2 vCPU 8 GB 128 GB"
        "750d9542-a2f8-41c7-8c81-311352173432" = "Windows 365 Business 2 vCPU 8 GB 256 GB"
        "ad83ac17-4a5a-4ebb-adb2-079fb277e8b9" = "Windows 365 Business 4 vCPU 16 GB 128 GB"
        "439ac253-bfbc-49c7-acc0-6b951407b5ef" = "Windows 365 Business 4 vCPU 16 GB 128 GB (with Windows Hybrid Benefit)"
        "b3891a9f-c7d9-463c-a2ec-0b2321bda6f9" = "Windows 365 Business 4 vCPU 16 GB 256 GB"
        "1b3043ad-dfc6-427e-a2c0-5ca7a6c94a2b" = "Windows 365 Business 4 vCPU 16 GB 512 GB"
        "3cb45fab-ae53-4ff6-af40-24c1915ca07b" = "Windows 365 Business 8 vCPU 32 GB 128 GB"
        "fbc79df2-da01-4c17-8d88-17f8c9493d8f" = "Windows 365 Business 8 vCPU 32 GB 256 GB"
        "8ee402cd-e6a8-4b67-a411-54d1f37a2049" = "Windows 365 Business 8 vCPU 32 GB 512 GB"
        "93d9955a-ec70-44d5-8faa-a194492390f7" = "Windows 365 Business 16 vCPU, 64 GB, 512 GB"
        "24be3cd7-82ca-41a5-94a7-4903373cdcae" = "Windows 365 Business 16 vCPU, 64 GB, 1 TB"
        "0c278af4-c9c1-45de-9f4b-cd929e747a2c" = "Windows 365 Enterprise 1 vCPU 2 GB 64 GB"
        "226ca751-f0a4-4232-9be5-73c02a92555e" = "Windows 365 Enterprise 2 vCPU 4 GB 128 GB"
        "5265a84e-8def-4fa2-ab4b-5dc278df5025" = "Windows 365 Enterprise 2 vCPU 4 GB 256 GB"
        "7bb14422-3b90-4389-a7be-f1b745fc037f" = "Windows 365 Enterprise 2 vCPU 4 GB 64 GB"
        "e2aebe6c-897d-480f-9d62-fff1381581f7" = "Windows 365 Enterprise 2 vCPU 8 GB 128 GB"
        "1c79494f-e170-431f-a409-428f6053fa35" = "Windows 365 Enterprise 2 vCPU 8 GB 256 GB"
        "d201f153-d3b2-4057-be2f-fe25c8983e6f" = "Windows 365 Enterprise 4 vCPU 16 GB 128 GB"
        "96d2951e-cb42-4481-9d6d-cad3baac177e" = "Windows 365 Enterprise 4 vCPU, 16 GB, 256 GB"
        "0da63026-e422-4390-89e8-b14520d7e699" = "Windows 365 Enterprise 4 vCPU 16 GB 512 GB"
        "c97d00e4-0c4c-4ec2-a016-9448c65de986" = "Windows 365 Enterprise 8 vCPU 32 GB 128 GB"
        "7818ca3e-73c8-4e49-bc34-1276a2d27918" = "Windows 365 Enterprise 8 vCPU 32 GB 256 GB"
        "9fb0ba5f-4825-4e84-b239-5167a3a5d4dc" = "Windows 365 Enterprise 8 vCPU 32 GB 512 GB"
        "bce09f38-1800-4a51-8d50-5486380ba84a" = "Windows 365 Enterprise 2 vCPU 4 GB 128 GB (Preview)"
        "1f9990ca-45d9-4c8d-8d04-a79241924ce1" = "Windows 365 Shared Use 2 vCPU 4 GB 64 GB"
        "90369797-7141-4e75-8f5e-d13f4b6092c1" = "Windows 365 Shared Use 2 vCPU 4 GB 128 GB"
        "8fe96593-34d3-49bb-aeee-fb794fed0800" = "Windows 365 Shared Use 2 vCPU 4 GB 256 GB"
        "2d21fc84-b918-491e-ad84-e24d61ccec94" = "Windows 365 Shared Use 2 vCPU 8 GB 128 GB"
        "2eaa4058-403e-4434-9da9-ea693f5d96dc" = "Windows 365 Shared Use 2 vCPU 8 GB 256 GB"
        "1bf40e76-4065-4530-ac37-f1513f362f50" = "Windows 365 Shared Use 4 vCPU 16 GB 128 GB"
        "a9d1e0df-df6f-48df-9386-76a832119cca" = "Windows 365 Shared Use 4 vCPU 16 GB 256 GB"
        "469af4da-121c-4529-8c85-9467bbebaa4b" = "Windows 365 Shared Use 4 vCPU 16 GB 512 GB"
        "f319c63a-61a9-42b7-b786-5695bc7edbaf" = "Windows 365 Shared Use 8 vCPU 32 GB 128 GB"
        "fb019e88-26a0-4218-bd61-7767d109ac26" = "Windows 365 Shared Use 8 vCPU 32 GB 256 GB"
        "f4dc1de8-8c94-4d37-af8a-1fca6675590a" = "Windows 365 Shared Use 8 vCPU 32 GB 512 GB"
        "6470687e-a428-4b7a-bef2-8a291ad947c9" = "Windows Store for Business"
        "c7e9d9e6-1981-4bf3-bb50-a5bdfaa06fb2" = "Windows Store for Business EDU Faculty"
        "73fa80b5-689f-4db9-bbe4-bd414bc41e44" = "Workload Identities Premium"
  
    }
    
    return $LicenseMap
}

#Preinstalling Microsoft Graph and Exchange Online modules if required
Function ConnectModules{
    $MsGraphModule =  Get-Module Microsoft.Graph -ListAvailable
    if($MsGraphModule -eq $null)
    { 
        Write-host "Important: Microsoft Graph module is unavailable. It is mandatory to have this module installed in the system to run the script successfully." 
        $confirm = Read-Host Are you sure you want to install Microsoft Graph module? [Y] Yes [N] No  
        if($confirm -match "[yY]") 
        { 
            Write-host "Installing Microsoft Graph module..."
            Install-Module Microsoft.Graph -Scope CurrentUser -AllowClobber
            Write-host "Microsoft Graph module is installed in the machine successfully" -ForegroundColor Magenta 
        } 
        else
        { 
            Write-host "Exiting. `nNote: Microsoft Graph module must be available in your system to run the script" -ForegroundColor Red
            Exit 
        } 
    }

    $MsGraphBetaModule =  Get-Module Microsoft.Graph.Beta -ListAvailable
    if($MsGraphBetaModule -eq $null)
    { 
        Write-host "Important: Microsoft Graph Beta module is unavailable. It is mandatory to have this module installed in the system to run the script successfully." 
        $confirm = Read-Host Are you sure you want to install Microsoft Graph Beta module? [Y] Yes [N] No  
        if($confirm -match "[yY]") 
        { 
            Write-host "Installing Microsoft Graph Beta module..."
            Install-Module Microsoft.Graph.Beta -Scope CurrentUser -AllowClobber
            Write-host "Microsoft Graph Beta module is installed in the machine successfully" -ForegroundColor Magenta 
        } 
        else
        { 
            Write-host "Exiting. `nNote: Microsoft Graph Beta module must be available in your system to run the script" -ForegroundColor Red
            Exit 
        } 
    }
    
    $ExchangeOnlineModule =  Get-Module ExchangeOnlineManagement -ListAvailable
    if($ExchangeOnlineModule -eq $null)
    { 
        Write-host "Important: Exchange Online module is unavailable. It is mandatory to have this module installed in the system to run the script successfully." 
        $confirm = Read-Host Are you sure you want to install Exchange Online module? [Y] Yes [N] No  
        if($confirm -match "[yY]") 
        { 
            Write-host "Installing Exchange Online module..."
            Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser
            Write-host "Exchange Online Module is installed in the machine successfully" -ForegroundColor Magenta 
        } 
        else
        { 
            Write-host "Exiting. `nNote: Exchange Online module must be available in your system to run the script" 
            Exit 
        } 
    }
    
    Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
    Disconnect-ExchangeOnline -Confirm:$false
    Write-Host "Connecting modules(Microsoft Graph and Exchange Online module)...`n"
    try{
        if($TenantId -ne "" -and $ClientId -ne "" -and $CertificateThumbprint -ne "")
        {
            Connect-MgGraph  -TenantId $TenantId -ClientId $ClientId -CertificateThumbprint $CertificateThumbprint -ErrorAction SilentlyContinue -ErrorVariable ConnectionError|Out-Null
            if($ConnectionError -ne $null)
            {    
                Write-Host $ConnectionError -Foregroundcolor Red
                Exit
            }
            $Scopes = (Get-MgContext).Scopes
            $ApplicationPermissions=@("Directory.ReadWrite.All","AppRoleAssignment.ReadWrite.All","User.EnableDisableAccount.All","RoleManagement.ReadWrite.Directory")
            foreach($Permission in $ApplicationPermissions)
            {
                if($Scopes -notcontains $Permission)
                {
                    Write-Host "Note: Your application required the following graph application permissions: Directory.ReadWrite.All,AppRoleAssignment.ReadWrite.All,User.EnableDisableAccount.All,RoleManagement.ReadWrite.Directory" -ForegroundColor Yellow
                    Exit
                }
            }
            Connect-ExchangeOnline -AppId $ClientId -CertificateThumbprint $CertificateThumbprint  -Organization (Get-MgBetaDomain | Where-Object {$_.isInitial}).Id -ShowBanner:$false
        }
        else
        {
            Connect-MgGraph -Scopes Directory.ReadWrite.All,AppRoleAssignment.ReadWrite.All,User.EnableDisableAccount.All,Directory.AccessAsUser.All,RoleManagement.ReadWrite.Directory -ErrorAction SilentlyContinue -Errorvariable ConnectionError |Out-Null
            if($ConnectionError -ne $null)
            {
                Write-Host $ConnectionError -Foregroundcolor Red
                Exit
            }
            Connect-ExchangeOnline -UserPrincipalName (Get-MgContext).Account -ShowBanner:$false
        }
    }
    catch
    {
        Write-Host $_.Exception.message -ForegroundColor Red
        Exit
    }
    Write-Host "Microsoft Graph Beta PowerShell module is connected successfully" -ForegroundColor Cyan
    Write-Host "Exchange Online module is connected successfully" -ForegroundColor Cyan
         
}

Function DisconnectModules{
    # Disconnect Microsoft Graph
    try {
        Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Microsoft Graph disconnected successfully." -ForegroundColor Green
    } catch {
        Write-Host "No Microsoft Graph session found or already disconnected." -ForegroundColor Yellow
    }

    # Disconnect Exchange Online
    try {
        Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Exchange Online disconnected successfully." -ForegroundColor Green
    } catch {
        Write-Host "No Exchange Online session found or already disconnected." -ForegroundColor Yellow
    }

    Exit
}

#Getting the all details of email address provided
Function GetUPN{
    $UPN = Read-Host "`nEnter the UserPrincipalName of the user you want to action"
    if ($UPN -eq "") {
        Write-Host "You must provide UPN of the user." -ForegroundColor Red
        DisconnectModules
        return $null
    }

    $UPN = $UPN.Trim()
    Write-Host "UPN acquired: $UPN"
    Write-Progress "Processing $UPN"
    $Script:Status = "$UPN - "
    
    # Get user details
    $User = Get-MgBetaUser -UserId $UPN -ErrorAction SilentlyContinue 
    if ($User -eq $null) {
        $InvalidUser = "$UPN"
        $InvalidUser >> $InvalidUserLogFile
        return $null
    }
    $UserId = $User.Id

    # Get mailbox details
    $MailBox = Get-Mailbox -Identity $UPN -RecipientTypeDetails UserMailbox -ErrorAction SilentlyContinue
    if ($MailBox -ne $null) {
        $MailBoxAvailability = "Yes"
    } else {
        $MailBoxAvailability = "No"
    }

    # Return multiple values as a hashtable
    return @{
        UPN    = $UPN
        User   = $User
        UserId = $UserId
        Mailbox = $MailBox
        MailboxAvailability = $MailBoxAvailability
    }
}

Function ResetPassword{
    # Call GetUPN and capture the returned hashtable
    $UserDetails = GetUPN
    if ($UserDetails -eq $null) {
        Write-Host "No UPN provided or user not found. Exiting." -ForegroundColor Red
        return
    }

    # Extract values from the hashtable
    $UPN = $UserDetails.UPN
    $User = $UserDetails.User
    $UserId = $UserDetails.UserId

    # Generate a random password
    $Password = -join ((48..57) + (65..90) + (97..122) | ForEach-Object { [char]$_ } | Get-Random -Count 8)
    Write-Host "Password produced: $Password"
    $log = "$UPN - $Password"
    $Pwd = $Password
    
    try {
        $Passwordprofile = @{
            forceChangePasswordNextSignIn = $true
            password = $Pwd
        }
        Update-MgBetaUser -UserId $UPN -PasswordProfile $Passwordprofile
        Write-Progress "Resetting password of $UPN"
        $log >> $PasswordLogFile
        $ResetPasswordAction = "Success"
    } catch {
        $ResetPasswordAction = "Failed"
        $ErrorLog = "$($UPN) - Reset Password Action - " + $_.Exception.Message
        $ErrorLog >> $ErrorsLogFile
    }

    if ($ResetPasswordAction -eq "Success") {
        Write-Host "`nPassword log file available in " -NoNewline -ForegroundColor Yellow
        Write-Host $PasswordLogFile
    } else {
        Write-Host "`nPassword reset failed, kindly check $ErrorsLogFile for more info"
    }

    #Signout to all devices
    Revoke-MgBetaUserSignInSession -UserId $UPN | Out-Null
}

#Called in EnableOnlineArchive function to choose retention policy
Function GetRetentionPolicy{
    # Fetch and display available retention policies
    Write-Host "`nAvailable Retention Policies:" -ForegroundColor Cyan
    $retentionPolicies = Get-RetentionPolicy | Select-Object -ExpandProperty Name

    # Display the policies in a numbered list
    for ($i=0; $i -lt $retentionPolicies.Count; $i++) {
        Write-Host "$($i+1). $($retentionPolicies[$i])"
    }

    # Ask user to select a retention policy
    $choice = Read-Host "`nEnter the number of the retention policy to apply"
    $selectedPolicy = $retentionPolicies[$choice - 1]

    return $selectedPolicy
}

Function EnableOnlineArchive{
    # Call GetUPN and capture the returned hashtable
    $UserDetails = GetUPN
    if ($UserDetails -eq $null) {
        Write-Host "No UPN provided or user not found. Exiting." -ForegroundColor Red
        return
    }

    # Extract values from the hashtable
    $UPN = $UserDetails.UPN
    $User = $UserDetails.User
    $UserId = $UserDetails.UserId
    $Mailbox = $UserDetails.Mailbox
    $MailboxAvailability = $UserDetails.MailboxAvailability


    if($MailboxAvailability -eq "Yes"){
        if($Mailbox.ArchiveStatus -ne "Active"){
            #Enable mailbox archive
            Write-Host "Enabling mailbox archive for $UPN..." -ForegroundColor Yellow
            Enable-Mailbox -Identity $UPN -Archive
            Write-Progress "Enabling Online Archive of $UPN"
            $RetentionPolicy = GetRetentionPolicy
            
            #Apply the selected retention policy
            Write-Progress "`nApplying retention policy '$RetentionPolicy' to $UPN..." 
            Set-Mailbox -Identity $UPN -RetentionPolicy $RetentionPolicy
            
            #Display updated mailbox information
            Write-Host "`nUpdated Mailbox Information:" -ForegroundColor Green
            Get-Mailbox -Identity $UPN | Select-Object DisplayName, ArchiveStatus, RetentionPolicy | Format-Table -AutoSize

            #Initiate the Mailbox Archive Push
            Start-ManagedFolderAssistant -Identity $UPN -FullCrawl
            
            Write-Host "Enabling mailbox archive for $UPN is successful"
        }else{
            Write-Host "Mailbox archive is already enabled for $UPN"
            $confirm = Read-Host Do you want to change the retention policy? [Y] Yes [N] No 
            if($confirm -match "[yY]"){
                $RetentionPolicy = GetRetentionPolicy
            
                #Apply the selected retention policy
                Write-Progress "`nApplying retention policy '$RetentionPolicy' to $UPN..." 
                Set-Mailbox -Identity $UPN -RetentionPolicy $RetentionPolicy

                #Display updated mailbox information
                Write-Host "`nUpdated Mailbox Information:" -ForegroundColor Green
                Get-Mailbox -Identity $UPN | Select-Object DisplayName, ArchiveStatus, RetentionPolicy | Format-Table -AutoSize

                #Initiate the Mailbox Archive Push
                Start-ManagedFolderAssistant -Identity $UPN -FullCrawl

                 Write-Host "Changing Retention policy for $UPN is successful"

            }else{
                
                #Display updated mailbox information
                Write-Host "`nCurrent Mailbox Information:" -ForegroundColor Green
                Get-Mailbox -Identity $UPN | Select-Object DisplayName, ArchiveStatus, RetentionPolicy | Format-Table -AutoSize
            }
        }
    }else{
        Write-Host "$UPN has no mailbox"
    }
}

Function AutoExpandOnlineArchive{
    # Call GetUPN and capture the returned hashtable
    $UserDetails = GetUPN
    if ($UserDetails -eq $null) {
        Write-Host "No UPN provided or user not found. Exiting." -ForegroundColor Red
        return
    }

    # Extract values from the hashtable
    $UPN = $UserDetails.UPN
    $User = $UserDetails.User
    $UserId = $UserDetails.UserId
    $Mailbox = $UserDetails.Mailbox
    $MailboxAvailability = $UserDetails.MailboxAvailability

    $AutoExpandEnabled = $Mailbox.AutoExpandingArchiveEnabled
    
    if($MailboxAvailability -eq "Yes"){
        if($Mailbox.ArchiveStatus -eq "Active"){
            Get-Mailbox -Identity $UPN | Select DisplayName, AutoExpandingArchiveEnabled
            if($Mailbox.AutoExpandingArchiveEnabled -eq $true){
                Write-Host "AutoExpandingArchive is already enabled"
            }else{
                Write-Progress "AutoExpandingArchive for $UPN"
                Enable-Mailbox -Identity $UPN -Archive

                Write-Host "Enabilng AutoExpandArchive for $UPN is successful!"
            }
        }
    }

}

Function ExportUsers{


    $LicenseMapSKU = ListOfSKU
    $ExportUsersCSV = "$Location\AllUsers_$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm-ss` tt).ToString()).csv"

    # Get all users
    $Users = Get-MgUser -All -Property DisplayName, Mail, CreatedDateTime, AssignedLicenses

    # Prepare the output array
    $UserData = @()

    # Loop through each user and extract the required details
    try{
        Write-Progress "Exporting users..."
        foreach ($User in $Users) {
            # Check if AssignedLicenses is null or empty
            if ($User.AssignedLicenses -ne $null -and $User.AssignedLicenses.Count -gt 0) {
                $LicenseNames = $User.AssignedLicenses.SkuId | ForEach-Object { $LicenseMapSKU[$_] }
            } else {
                $LicenseNames = @()  # If no licenses are assigned, return an empty array
            }
            $UserDetails = [PSCustomObject]@{
                DisplayName    = $User.DisplayName
                EmailAddress   = $User.Mail
                DateCreated    = $User.CreatedDateTime
                Licenses       = ($LicenseNames -join ", ")
            }
            $UserData += $UserDetails
        }
        $ExportingUsers = "Success"
    }catch{
        $ExportingUsers = "Fail"
        $ErrorLog = "Export Users Action - " + $_.Exception.Message
        $ErrorLog >> $ErrorsLogFile

    }

    

    if ($ExportingUsers -eq "Success") {
        Write-Host "`nExported list of users file will be available in " -NoNewline -ForegroundColor Yellow
        Write-Host $ExportUsersCSV
    } else {
        Write-Host "`nExporting users failed, kindly check $ErrorsLogFile for more info"
    }

    # Export the data to a CSV file
    $UserData | Export-Csv -Path $ExportUsersCSV -NoTypeInformation

}

Function ExportUsersWithLicense{
    $LicenseMapSKU = ListOfSKU
    $ExportUsersCSV = "$Location\AllUsersWithLicense_$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm-ss` tt).ToString()).csv"

    # Get all users
    $Users = Get-MgUser -All -Property DisplayName, Mail, CreatedDateTime, AssignedLicenses

    # Prepare the output array
    $UserData = @()

    # Loop through each user and extract the required details
    try{
        Write-Progress "Exporting users..."
        foreach ($User in $Users) {
            # Check if AssignedLicenses is null or empty
            if ($User.AssignedLicenses -ne $null -and $User.AssignedLicenses.Count -gt 0) {
                $LicenseNames = $User.AssignedLicenses.SkuId | ForEach-Object { $LicenseMapSKU[$_] }
            } else {
                $LicenseNames = @()  # If no licenses are assigned, return an empty array
            }
            $UserDetails = [PSCustomObject]@{
                DisplayName    = $User.DisplayName
                EmailAddress   = $User.Mail
                DateCreated    = $User.CreatedDateTime
                Licenses       = ($LicenseNames -join ", ")
            }
            if($LicenseNames -ne $null){
                $UserData += $UserDetails
            }
        }
        $ExportingUsers = "Success"
    }catch{
        $ExportingUsers = "Fail"
        $ErrorLog = "Export Users Action - " + $_.Exception.Message
        $ErrorLog >> $ErrorsLogFile
    }

    if ($ExportingUsers -eq "Success") {
        Write-Host "`nExported list of users with licences file will be available in " -NoNewline -ForegroundColor Yellow
        Write-Host $ExportUsersCSV
    } else {
        Write-Host "`nExporting users failed, kindly check $ErrorsLogFile for more info"
    }
    
  
    # Export the data to a CSV file
    $UserData | Export-Csv -Path $ExportUsersCSV -NoTypeInformation
}

#Called in CheckDistributionGroups
Function AddUsertoDistributionGroup{
    param (
        [Parameter(Mandatory = $true)]  # Make the parameter mandatory
        [string]$UPN
    )

    Write-Host ""
}

#Called in CheckDistributionGroups
Function RemoveUsertoDistributionGroup{
    param (
        [Parameter(Mandatory = $true)]  # Make the parameter mandatory
        [string]$UPN
    )

    Write-Host ""

}

Function CheckDistributionGroups{
    # Call GetUPN and capture the returned hashtable
    $UserDetails = GetUPN
    if ($UserDetails -eq $null) {
        Write-Host "No UPN provided or user not found. Exiting." -ForegroundColor Red
        return
    }

    # Extract values from the hashtable
    $UPN = $UserDetails.UPN
    $User = $UserDetails.User
    $UserId = $UserDetails.UserId
    $Mailbox = $UserDetails.Mailbox
    $MailboxAvailability = $UserDetails.MailboxAvailability

    if($MailBoxAvailability -eq "Yes"){
        $distributionGroups = Get-DistributionGroup | Where-Object { (Get-DistributionGroupMember -Identity $_.PrimarySmtpAddress | Select-Object -ExpandProperty PrimarySmtpAddress) -contains $UPN }
        $distributionGroups | Select-Object Name, PrimarySmtpAddress

        Write-Host "`nWe can perform below actions.`n"
        Write-Host "           1.  Join to other existing distribution group" -ForegroundColor Yellow
        Write-Host "           2.  Unjoin from distribution group" -ForegroundColor Yellow
        Write-Host "           3.  Exit" -ForegroundColor Yellow
        $Action = Read-Host "Please choose action to continue"
        if($Action -eq ""){
            Write-Host "`nPlease choose the action from the above." -ForegroundColor Red
            Exit
        }

        Switch($Action){
            1 { AddUsertoDistributionGroup -UPN $UPN }
            2 { RemoveUsertoDistributionGroup -UPN $UPN }
            3 { Exit }
            Default{
                Write-Host "No action found. Please provide valid input" -ForegroundColor Red
                DisconnectModules
            }
        }
    }else{
        Write-Host "$UPN has no mailbox"
    }

}



Function CheckEmailDelegation{}
Function DelegateUser{}
Function CheckInboxRules{}
Function DeleteInboxRules{}


Function main {

    ConnectModules
    
    $Location = Get-Location
    $ExportCSV =  "$Location\M365UserOffBoarding_StatusFile_$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm-ss` tt).ToString()).csv"
    $PasswordLogFile = "$Location\PasswordLogFile_$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm-ss` tt).ToString()).txt"
    $InvalidUserLogFile = "$Location\InvalidUsersLogFile$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm-ss` tt).ToString()).txt"
    $ErrorsLogFile = "$Location\ErrorsLogFile$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm-ss` tt).ToString()).txt"
    $AvailabiltyOfInvalidUser = $false
    

    Write-Host "`nWe can perform below operations.`n" -ForegroundColor Cyan
    Write-Host "           1.  Reset password" -ForegroundColor Yellow
    Write-Host "           2.  Enable Online Archive" -ForegroundColor Yellow
    Write-Host "           3.  Auto Expand Online Archive" -ForegroundColor Yellow
    Write-Host "           4.  Export Users" -ForegroundColor Yellow
    Write-Host "           5.  Export Users with License only" -ForegroundColor Yellow
    Write-Host "           6.  Check/Add/Remove User to Distribution Group" -ForegroundColor Yellow
    Write-Host "           7.  Check Email Delegation of User" -ForegroundColor Yellow
    Write-Host "           8.  Delegate User to Another" -ForegroundColor Yellow
    Write-Host "           9.  Check/Delete Inbox Rules" -ForegroundColor Yellow

    
    $Action=Read-Host "`nPlease choose the action to continue"
    Write-Host "Actions chosen:" $Action 
    if($Action -eq ""){
        Write-Host "`nPlease choose the action from the above." -ForegroundColor Red
        Exit
    }
    
    Switch($Action){
        1 { ResetPassword ; break }
        2 { EnableOnlineArchive break }
        3 { AutoExpandOnlineArchive ; break }
        4 { ExportUsers ; break }
        5 { ExportUsersWithLicense ; break }
        6 { CheckDistributionGroups ; break }
        7 { CheckEmailDelegation ; break }
        8 { DelegateUser ; break }
        9 { CheckInboxRules ; break }
        Default{
            Write-Host "No action found. Please provide valid input" -ForegroundColor Red
            DisconnectModules
        }
    }

   
    DisconnectModules
    
}
. main