# GCP & N8N Application Infrastructure

```
┌─────────────────────────────────────────────────────────────────┐
│                    GOOGLE CLOUD PROJECT                         │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
        ┌─────────────────────────────────────────────────────┐
        │                 🐳 CLOUD RUN                        │
        │                (n8n Application)                    │
        │                                                     │
        │           Auto-scales: 0 ──▶ 10 instances           │
        └─────────────────────────────────────────────────────┘
                    │                        │
                    │                        │
                    ▼                        ▼
        ┌─────────────────────┐    ┌─────────────────────┐
        │   💾 CLOUD SQL      │    │    CLOUD STORAGE    │
        │     (PostgreSQL)    │    │   (File Storage)    │
        │                     │    │                     │
        │  • Workflows        │    │  • Uploads          │
        │  • User Data        │    │  • Documents        │
        │  • History          │    │  • Backups          │
        └─────────────────────┘    └─────────────────────┘


                        🔄 DATA FLOW

    ┌─────────┐          ┌─────────┐          ┌─────────┐
    │ User    │─────────▶│Cloud Run│─────────▶│Database │
    │Request  │          │Container│          │& Files  │
    └─────────┘          └─────────┘          └─────────┘


                       🔧 DEPLOYMENT

    ┌─────────────┐    Terraform    ┌──────────────────┐
    │  Developer  │────────────────▶│ GCP Resources    │
    │             │     Commands    │ Created Auto     │
    └─────────────┘                 └──────────────────┘


                        ⚙️ KEY PARTS

    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
    │    APP      │  │   DATABASE  │  │   STORAGE   │
    │             │  │             │  │             │
    │ Cloud Run   │  │ Cloud SQL   │  │ Cloud       │
    │ Containers  │  │ PostgreSQL  │  │ Storage     │
    │             │  │             │  │ Bucket      │
    │ Serverless  │  │ Managed     │  │ Files       │
    │ Auto-scale  │  │ Backups     │  │ Auto-clean  │
    └─────────────┘  └─────────────┘  └─────────────┘
```

## Summary

**3 Main Parts:**

1. **🐳 Cloud Run** - Runs n8n app, scales automatically
2. **💾 Cloud SQL** - Stores workflows and data
3. **📁 Cloud Storage** - Holds files and uploads

**How it works:**

- User → Cloud Run → Database/Storage
- Terraform creates everything automatically
- Scales from 0 to 10 based on traffic

**Location:** Europe (frankfurt region)
**Cost:** Pay only when used (scales to zero)
