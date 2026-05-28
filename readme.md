# AWS Cost Optimization using Terraform

## Overview

This project implements an AWS cost optimization framework using Terraform.

The solution automatically detects:

* Idle EC2 Instances
* Unattached / Unused EBS Volumes

and sends notifications using:

* Amazon CloudWatch
* Amazon SNS

This helps organizations reduce unnecessary AWS infrastructure costs.

---

# Architecture Diagram

```text
                   +----------------------+
                   |      Terraform       |
                   +----------+-----------+
                              |
                              |
             -----------------------------------
             |                                 |
             v                                 v

+------------------------+       +--------------------------+
| Running EC2 Instances  |       | Unattached EBS Volumes  |
+-----------+------------+       +------------+-------------+
            |                                     |
            |                                     |
            v                                     v

+-------------------------+      +----------------------------+
| CloudWatch CPU Alarm    |      | CloudWatch Metric Math     |
| CPUUtilization <= 5%    |      | ReadOps + WriteOps         |
+------------+------------+      +-------------+--------------+
             |                                     |
             |                                     |
             v                                     v

      +-----------------------------------------------+
      |           Amazon SNS Notifications            |
      +----------------------+------------------------+
                             |
                             |
                             v

                   +-------------------+
                   | Email Alerts      |
                   +-------------------+
```

---

# Features

* Detect idle EC2 instances automatically
* Detect unattached EBS volumes
* CloudWatch metric-based monitoring
* SNS email notifications
* Reusable Terraform module
* Dynamic infrastructure discovery using Terraform data sources
* Environment-independent architecture

---

# Technologies Used

* Terraform
* AWS EC2
* AWS EBS
* Amazon CloudWatch
* Amazon SNS

---

# Project Structure

```text
terraform-unused-resource/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
│
└── modules/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

# How It Works

## EC2 Idle Detection

Terraform dynamically discovers all running EC2 instances.

For every instance:

* CloudWatch alarm monitors CPUUtilization
* If CPU remains below threshold for configured duration:

  * Alarm enters ALARM state
  * SNS sends email notification

### Example

```text
CPUUtilization <= 5%
for 7 days
```

---

## EBS Unused Detection

Terraform identifies unattached EBS volumes.

CloudWatch Metric Math combines:

* VolumeReadOps
* VolumeWriteOps

If:

* No read/write operations exist
* Or metrics are missing

then:

* Alarm enters ALARM state
* SNS sends notification

---

# Deployment Steps

## 1. Clone Repository

```bash
git clone <repository-url>
cd terraform-unused-resource
```

---

## 2. Initialize Terraform

```bash
terraform init
```

---

## 3. Validate Configuration

```bash
terraform validate
```

---

## 4. Review Execution Plan

```bash
terraform plan
```

---

## 5. Deploy Infrastructure

```bash
terraform apply
```

Type:

```text
yes
```

---

# SNS Email Confirmation

After deployment:

1. AWS sends SNS subscription confirmation email
2. Open mailbox
3. Click:

```text
Confirm subscription
```

Without confirmation:

* Email notifications will not work

---

# Example Root Module Configuration

```hcl
module "cost_optimization" {

  source = "./terraform-unused-resource/modules"

  providers = {
    aws = aws
  }

  notification_email = "your-email@gmail.com"

  cpu_idle_threshold = 5

  alarm_period_seconds = 86400

  evaluation_periods = 7

  alarm_prefix = "production"
}
```

---

# Testing

For faster testing:

```hcl
alarm_period_seconds = 60
evaluation_periods   = 1
```

This triggers alarms within 1 minute.

---

# Example Alerts

## EC2 Idle Alert

```text
ALARM: test-ec2-idle-i-xxxxxxxx
```

## Unused EBS Alert

```text
ALARM: test-unused-ebs-vol-xxxxxxxx
```

---

# Cleanup

To destroy resources:

```bash
terraform destroy
```

---

# Future Improvements

* Lambda-based auto-remediation
* Automatic EC2 stop/start
* Slack integration
* Weekly cost optimization reports
* Tag-based exclusions
* EventBridge scheduling

---
