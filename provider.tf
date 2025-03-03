terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id # 프로젝트 ID 입력
  region  = var.region # 배포할 region
}