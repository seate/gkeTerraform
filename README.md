# GKE 기본 By Terraform

### kubectl을 사용하기 위한 bastion 수동 실행

1. 명령 실행 후 브라우저에서 로그인
```shell
gcloud auth login
```

2. 실행
```shell
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```

3. 실행
```shell
gcloud container clusters get-credentials {var.cluster_name} --region {var.region} --project {var.project_id}
```