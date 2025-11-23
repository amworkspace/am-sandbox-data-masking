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

There are multiple ways to implement data masking in Salesforce, and this repository reflects one approach that I personally designed and found scalable for sandbox environments. If you have suggestions, improvements, or questions, feel free to reach out — I’d be happy to collaborate.
---
