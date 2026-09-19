# Terraform AWS Multi-Environment Infrastructure

![Architecture](https://raw.githubusercontent.com/abhishekmishra9768/terraform-aws-multi-env/main/Screenshot%202026-09-19%20123250_edited.png)

## Overview

This project provisions AWS infrastructure across multiple environments (`dev`, `stg`, `prd`) using Terraform workspaces and reusable modules.

Each environment gets:
- EC2 instances (count varies per env)
- S3 buckets (count varies per env)
- Security groups, Key pair, VPC

Remote state is stored in S3 with file-based locking (`use_lockfile`).

---

## Project Structure

```
terraform-aws-multi-env/
├── main.tf                  → module calls + env_config locals
├── variable.tf              → root variables
├── terraform.tf             → backend + required_providers
├── providers.tf             → AWS provider
├── remote-backend/          → bootstrap: creates S3 bucket for remote state
│   ├── terraform.tf
│   ├── providers.tf
│   └── s3.tf
└── modules/
    ├── ec2/                 → EC2, Key pair, Security group, VPC
    │   ├── main.tf
    │   ├── variable.tf
    │   └── output.tf
    └── s3/                  → S3 buckets
        ├── main.tf
        ├── variable.tf
        └── output.tf
```

---

## Environment Configuration

| Environment | EC2 Count | S3 Count |
|-------------|-----------|----------|
| dev         | 1         | 1        |
| stg         | 2         | 2        |
| prd         | 4         | 3        |

---

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured (`aws configure`)
- SSH key pair generated:
```
ssh-keygen -t ed25519 -f terra-auto-server-key
```

---

## Steps to Run

### Step 1 — Remote Backend S3 Bucket banao (ek baar)
```bash
cd remote-backend
terraform init
terraform apply
cd ..
```

### Step 2 — Root folder initialize karo
```bash
terraform init
```

### Step 3 — Workspaces banao
```bash
terraform workspace new dev
terraform workspace new stg
terraform workspace new prd
```

### Step 4 — Har environment deploy karo
```bash
# Dev
terraform workspace select dev
terraform apply

# Stg
terraform workspace select stg
terraform apply

# Prd
terraform workspace select prd
terraform apply
```

### Step 5 — Destroy karna ho toh
```bash
terraform workspace select dev
terraform destroy
```

---

## Remote State Structure in S3

```
terraform-aws-multi-env-remote-backend-2026/
└── terraform-aws-multi-env/
    ├── env:/dev/terraform.tfstate
    ├── env:/stg/terraform.tfstate
    └── env:/prd/terraform.tfstate
```

---

## Resources Created Per Environment

| Resource | Dev | Stg | Prd |
|----------|-----|-----|-----|
| EC2 instances | 1 | 2 | 4 |
| S3 buckets | 1 | 2 | 3 |
| Security group | 1 | 1 | 1 |
| Key pair | 1 | 1 | 1 |

<img width="1385" height="637" alt="AdobeExpressPhotos_2b67cd5db931413784972e5dff93af5b_CopyEdited" src="https://github.com/user-attachments/assets/3b8d9b38-fe14-4608-9869-5a6ca05e66c3" />


---

## Notes

- Private key (`terra-auto-server-key`) is in `.gitignore` — never commit it
- `remote-backend/` has its own local state — it is a one-time bootstrap step
- Workspace `default` is not used — always select `dev`, `stg`, or `prd`
