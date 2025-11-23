# 🔐 Salesforce Sandbox Data Masking Automation

## 📌 Overview
This project provides an automated and configurable Apex-based framework to mask sensitive Production data after Salesforce Sandbox refreshes. It prevents exposure of personal information (PII) while keeping the data usable for development, QA, and UAT testing.

---

## ⚙️ How It Works
- Uses **Custom Metadata** to define which Object + Field combinations require masking.
- Supports **multiple masking types** (Name, Email, Phone, Text, Number).
- Executes using **Apex Batch Processing** with **batch size configurable per object** via metadata.
- Automatically **skips execution in Production orgs** for safety.
- Can be triggered **manually after sandbox refresh.

---

## 🧠 Key Features
- No code changes required when new fields need masking → just update metadata.
- Processes large datasets safely using Batch Apex and dynamic chunking.
- Handles multiple fields per object in a **single DML update** to avoid unnecessary batches.
- Prevents re-masking of already masked records (e.g., avoids double-appending `.invalid` on email).
- Phone masking respects numeric-only storage requirements.

---

## 🧼 Masking Rules (Summary)
| Masking Type | Sample Output |
|--------------|----------------|
| Email | `original+sandbox@masked.invalid` (skips if already masked) |
| Phone | `999-999-9956` (last 2 digits retained for reference) |
| Name | FirstName = `Test`, LastName = `User` |
| Text / Long Text | `Masked` or scrambled placeholder |
| Number | `0` (numeric mask to avoid type errors) |

---

## 🏗️ Technical Components
| Component | Purpose |
|----------|---------|
| `Data_Masking_Config__mdt` | Defines Object, Field, Masking Type, Batch Size, Active flag |
| `DataMaskingBatch.cls` | Applies masking to records in scalable chunks; single-DML-per-record |
| `DataMaskingController.cls` | Reads metadata, groups configurations, starts batches; blocks execution in PROD |
| `MaskingUtil.cls` | Centralized masking logic for each supported data type |
| `TestDataMaskingSetup.cls` | Unit tests exercising mocking test data |
| `Test_DataMaskingBatch.cls` | Unit tests exercising masking logic and DataMaskingBatch.cls |
| `Test_DataMaskingController.cls` | Unit tests exercising masking logic and DataMaskingController.cls |

---

## 🧪 Running in Sandbox
From **Developer Console → Execute Anonymous**:

```apex
DataMaskingController.maskData();
```

## 🚀 How to Deploy
- Clone or download this repository.
- Update the `PROD_ORG_ID` value inside **`DataMaskingController.cls`** with your actual Production Org Id.
- Deploy the entire project to **any Sandbox** using **VS Code + Salesforce Extensions**, **SFDX CLI**, or **Metadata API / Change Set**.
- Once deployed and validated in Sandbox, the same package can be deployed to **Production** — it includes **test classes**, so deployment will not block.
- No additional configuration or external libraries required.

---

## ⚙️ How to Configure Metadata After Deployment
- Go to **Setup → Custom Metadata Types → Data Masking Config**.
- Click **Manage Records**.
- For every field you want to mask:
  - Select **Object API Name**
  - Select **Field API Name**
  - Choose **Masking Type** (Name, Email, Phone, Name, Text, Number)
  - (Optional) Set the **Batch Size** for large datasets
  - Set **Active = TRUE**
- No code modifications are needed to add/remove masking on new fields — simply adjust metadata and re-run the masking job.

---

## 📁 Demo & Reference
- A **sample demonstration video** is available inside the **`demo/` folder**.
- The project is built to work **immediately after Sandbox refresh** when scheduled as an Apex job.
- Production masking is prevented by **Org Id validation**, ensuring the feature is **safe and compliant**.
- Supports:
  - Multiple objects
  - Multiple fields per object
  - Different masking types in the same run

---

## 💡 Note
There can be many different ways to approach data masking — this repository reflects the approach I chose based on scalability, reusability, and simplicity.
If you have suggestions, improvements, or questions, I’d be happy to connect.

📫 **Feel free to reach out anytime!**

---
