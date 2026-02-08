# Production-Grade EKS Platform with ALB, HTTPS & IRSA

This project demonstrates how to design, deploy, and secure a **production-ready Kubernetes platform on AWS EKS** using Terraform, AWS Load Balancer Controller, IAM Roles for Service Accounts (IRSA), and HTTPS via ACM.

A containerized **Next.js frontend application** is deployed behind an **internet-facing Application Load Balancer (ALB)** with full TLS termination and health checks.

---

## 🔗 Live Endpoint (During Deployment)

👉 https://media.pruddieverse.com  
*(Endpoint was live during deployment and validated via HTTPS. Infrastructure has since been torn down to avoid cloud costs.)*

---

## 🏗️ Architecture Overview

- **Infrastructure as Code**: Terraform  
- **Kubernetes**: Amazon EKS  
- **Networking**:
  - VPC with public & private subnets
  - Application Load Balancer (ALB)
- **Ingress**:
  - AWS Load Balancer Controller
  - ALB Ingress (IP mode)
- **Security**:
  - IAM Roles for Service Accounts (IRSA)
  - Least-privilege IAM policy for ALB controller
  - HTTPS via AWS Certificate Manager (ACM)
- **Application**:
  - Next.js frontend
  - Containerized with Docker
  - Image stored in Amazon ECR

---

## 🧱 Project Structure

The repository is organized to clearly separate infrastructure, Kubernetes manifests, and application code:

```
eks-alb-https-platform/
├── terraform/
│   ├── vpc/
│   ├── eks/
│   ├── node-groups/
│   ├── alb-controller/
│   └── main.tf
│
├── k8s/
│   └── media-prod/
│       ├── namespace.yaml
│       ├── ingress.yaml
│       └── frontend/
│           ├── media-frontend-deployment.yaml
│           ├── service.yaml
│           └── configmap.yaml
│
├── frontend/
│   └── media-frontend/
│       ├── Dockerfile
│       ├── package.json
│       ├── next.config.js
│       └── app/
│
└── README.md
```

---


## 🚀 Deployment Flow

1. **Provision Infrastructure**
   - VPC, EKS cluster, node groups created via Terraform
   - Remote backend enabled for Terraform state

2. **Install AWS Load Balancer Controller**
   - IAM policy created with least privilege
   - IRSA configured using OIDC provider
   - Controller installed via Helm

3. **Deploy Application**
   - Next.js app containerized with Docker
   - Image pushed to Amazon ECR
   - Kubernetes Deployment & Service applied

4. **Expose via ALB Ingress**
   - HTTPS listener (443) configured
   - ACM certificate attached
   - Health checks and SSL redirect enabled

---

## 🔐 Security Highlights

- No static AWS credentials inside pods
- IRSA used for ALB controller permissions
- TLS termination at ALB using ACM
- Internet-facing traffic restricted to ALB only

---

## 🧠 What Went Wrong & How I Fixed It

- **ALB not provisioning** → IAM policy too restrictive  
  → Fixed by identifying missing EC2 & ELB permissions and applying the official ALB controller policy.

- **Terraform state lock issues** → Interrupted apply  
  → Resolved by inspecting DynamoDB lock and reinitializing state safely.

- **HTTPS certificate validation failed initially**  
  → Fixed by creating a dedicated subdomain and validating DNS via CNAME without affecting the main domain.

- **502 Bad Gateway errors**  
  → Root cause traced to container port mismatch and health check configuration.

Each issue reinforced real-world troubleshooting skills across IAM, Kubernetes, networking, and Terraform.

---

## 🧪 Validation Evidence

- HTTPS verified with `curl -I https://media.pruddieverse.com`
- ALB health checks passing
- Kubernetes pods running and serving traffic
- Screenshots captured for portfolio documentation

---

## 📌 Key Takeaways

- Infrastructure-first thinking matters
- Security must be designed, not patched
- Kubernetes issues are often IAM or networking-related
- Production readiness goes beyond “it works”

---

## 🧹 Teardown

All resources were intentionally destroyed after validation to prevent unnecessary cloud costs.

---

## 📣 Author

**Prudence Anumudu**  
Cloud / DevOps Engineer  
