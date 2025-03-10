variable "project_id" {
    type        = string
}

variable "enable_apis" {
    type        = list(string)
    default     = [
        "compute.googleapis.com", # Google Compute Engine API 활성화
        "servicenetworking.googleapis.com", # Service Networking API 활성화
        "container.googleapis.com" # terraform.tfstate 활성화
    ]
}

variable "region" {
    type        = string
    default     = "asia-northeast3"
}

variable "zone" {
    type        = string
    default     = "asia-northeast3-a"
}

variable "cluster_name" {
    type = string
    default = "my-cluster"
    description = "kubernetes cluster name"
}

variable "ssh_user" {
    type            = string
    default         = "terraform_user"
    description     = "ssh user name of vm"
}

variable "ssh_key_dir" {
    type            = string
    default         = "./.ssh"
    description     = "ssh key directory"
}

variable "vm_spec" {
    type        = string
    default     = "e2-small" # 저렴한 옵션
}

variable "db_username" {
    type        = string
}

variable "db_password" {
    type        = string
}

variable "db_spec" {
    type        = string
    default     = "db-n1-standard-1" # 저렴한 옵션
}