# us-elderly-care-prod-aws-terraform
IaC(Terraform) code of the US Elderly care PROD AWS account

## 📁 Folder Structure

```plaintext
mothership-prod-terraform/
│
├── provider.tf           # Terraform backend & provider configuration
├── variables.tf          # Global input variables shared across modules
├── main.tf               # Root module wiring — calls each service module
│
├── networking/           # VPC, private subnets, and route tables
│   └── main.tf
│
├── endpoints/            # Private VPC endpoints for S3, DDB
│   └── main.tf
│
├── storage/              # S3 buckets, DynamoDB tables, and IAM policies
│   └── main.tf
│
├── lambda/               # Lambda function, IAM role.
│   ├── main.tf
│   └── lambda_function.py
│
├── apigateway/           # API Gateway integration with Lambda
│   └── main.tf
│
├── stepfunctions/        # State machine workflows for orchestration
    └── main.tf
```

