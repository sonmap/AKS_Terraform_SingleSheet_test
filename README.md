# AKS Terraform Single Sheet Test

> Excel 1개 시트로 AKS, App, Namespace, PVC, CI/CD, Monitoring 설계를 관리하고, 이를 `tfvars`로 변환하여 Terraform으로 배포하는 테스트 저장소입니다.

## 1. 목표

이 프로젝트의 목표는 다음입니다.

```text
Excel Single Sheet
  ↓ CSV export
Python converter
  ↓ env/dev.generated.tfvars
Terraform stacks
  ↓ AKS / Kubernetes / Helm resources
```

즉, `main.tf`를 매번 수정하지 않고 **엑셀에 행을 추가하거나 enabled 값을 바꾸는 방식**으로 리소스를 제어하는 구조입니다.

## 2. 핵심 개념

| 구분 | 설명 |
|---|---|
| Excel | 전체 설계 원장 |
| enabled | true면 생성, false면 미생성 |
| domain/category/type | 리소스 분류 |
| param_01 이후 | 리소스별 상세 파라미터 |
| tools/excel_to_tfvars.py | CSV를 Terraform tfvars로 변환 |
| env/dev.generated.tfvars | 자동 생성된 Terraform 입력값 |
| modules | 반복 생성 로직 |
| stacks | 배포 순서 단위 |

## 3. 단일 시트 컬럼 설계

단일 시트 이름은 다음을 권장합니다.

```text
AKS_Terraform_Design
```

기본 컬럼:

| 컬럼 | 설명 |
|---|---|
| No | 순번 |
| enabled | 생성 여부: true/false |
| environment | dev/uat/prd |
| domain | LandingZone, AKS, K8S, CICD, Monitoring, Cost |
| category | Cluster, NodePool, Namespace, App, Storage, HPA 등 |
| type | 세부 유형: backend, frontend, pvc, argocd, jenkins 등 |
| purpose | 목적 |
| param_01 ~ param_20 | 상세 입력값 |
| terraform_stack | 대상 Stack |
| terraform_module | 대상 Module |
| depends_on | 선행 Stack |
| owner | 담당 |
| remarks | 비고 |

## 4. 샘플 설계 CSV

샘플 파일은 아래에 있습니다.

```text
design/AKS_Terraform_Design.csv
```

이 파일은 Excel에서 작성한 단일 시트를 CSV로 저장한 예시입니다.

## 5. 변환 방법

```bash
python3 tools/excel_to_tfvars.py \
  design/AKS_Terraform_Design.csv \
  env/dev.generated.tfvars
```

생성 결과:

```text
env/dev.generated.tfvars
```

## 6. Terraform 실행 예

Namespace 생성:

```bash
cd stacks/30-k8s-base
terraform init
terraform plan -var-file=../../env/dev.generated.tfvars
terraform apply -var-file=../../env/dev.generated.tfvars
```

App 생성:

```bash
cd ../50-apps
terraform init
terraform plan -var-file=../../env/dev.generated.tfvars
terraform apply -var-file=../../env/dev.generated.tfvars
```

CI/CD Helm 설치:

```bash
cd ../35-cicd
terraform init
terraform plan -var-file=../../env/dev.generated.tfvars
terraform apply -var-file=../../env/dev.generated.tfvars
```

## 7. 현재 포함 범위

| 영역 | 구현 상태 |
|---|---|
| Namespace | 구현 |
| Backend/Frontend App | 구현 |
| PVC | 구현 |
| ArgoCD/Jenkins Helm | 구현 |
| AKS Cluster | 예제 변수 구조만 포함 |
| Landing Zone | 기존 자원 참조 구조로 확장 예정 |
| Monitoring/Alert/Cost | 설계 행 포함, 모듈 확장 예정 |

## 8. 설계 예시

### Namespace 추가

CSV에 행 추가:

```text
true,dev,K8S,Namespace,namespace,Create namespace,pets,,,,,,,,30-k8s-base,k8s-namespace,20-aks,AKS팀,
```

### Backend API 추가

```text
true,dev,K8S,App,backend,Create backend API,coupon-api,pets,acr.azurecr.io/coupon-api:v1,8080,2,ClusterIP,8080,,,,50-apps,k8s-app,30-k8s-base,App팀,
```

### PVC 추가

```text
true,dev,K8S,Storage,pvc,Create PVC,upload-data,pets,azurefile-csi,50Gi,ReadWriteMany,/app/upload,,,,,31-storage,k8s-storage,30-k8s-base,AKS팀,
```

## 9. 권장 운영 방식

```text
1. Excel 수정
2. CSV로 저장
3. python 변환 실행
4. terraform plan 확인
5. terraform apply 수행
```

## 10. 보안 주의

GitHub에 올리면 안 되는 파일:

```text
.terraform/
*.tfstate
*.tfstate.*
terraform.tfplan
tfplan
terraform.tfvars
kubeconfig
*.key
*.pem
*.pfx
ArgoCD admin password
Jenkins admin password
```

## 11. 디렉터리 구조

```text
.
├── design/
│   └── AKS_Terraform_Design.csv
├── env/
│   └── dev.tfvars.example
├── tools/
│   └── excel_to_tfvars.py
├── modules/
│   ├── k8s-namespace/
│   ├── k8s-app/
│   ├── k8s-storage/
│   └── helm-release/
└── stacks/
    ├── 30-k8s-base/
    ├── 31-storage/
    ├── 35-cicd/
    └── 50-apps/
```

## 12. 확장 예정

향후 아래 항목을 추가할 수 있습니다.

```text
20-aks
22-nodepool
36-ingress
65-autoscaling
66-network-policy
91-alerts
92-dashboard
93-backup
94-cost
```

핵심은 `Excel 행 추가 → tfvars 자동 생성 → for_each 기반 Terraform 생성`입니다.
