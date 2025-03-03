resource "google_compute_network" "main" {
  name                            = "gke-vpc" # VPC 이름
  routing_mode                    = "GLOBAL" # REGIONAL일 경우 같은 리전의 서브넷들에만 경로를 광고, GLOBAL일 경우 다른 리전의 서브넷들에게도 경로를 광고
  auto_create_subnetworks         = false # false로 설정할 경우 custom subnet mode
}

# public 서브넷 생성
resource "google_compute_subnetwork" "public_subnet" {
  	name          = "public-subnet"
  	ip_cidr_range = "10.0.0.0/24"
  	region        = var.region
  	network       = google_compute_network.main.name
}

# private 서브넷 생성
resource "google_compute_subnetwork" "private_subnet" {
    name                     = "private-subnet"
    ip_cidr_range            = "10.0.2.0/24"
    region                   = var.region
    network                  = google_compute_network.main.id
    private_ip_google_access = true

    secondary_ip_range { # 서브넷에 '추가로' 이 범위를 할당함, 기존 범위와 겹치지 않아야 함
        range_name    = "k8s-pod-range"
        ip_cidr_range = "10.1.0.0/16"
    }
    secondary_ip_range {
        range_name    = "k8s-service-range"
        ip_cidr_range = "10.2.0.0/16"
    }
}


resource "google_compute_global_address" "service_networking" {
  name          = "vpc-peer"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

# 서비스 네트워킹과 VPC 연결
resource "google_service_networking_connection" "private_vpc_connection" {
  network                   = google_compute_network.main.id
  service                   = "servicenetworking.googleapis.com"
  reserved_peering_ranges   = [google_compute_global_address.service_networking.name]

  deletion_policy	        = "ABANDON" // 이 설정을 추가해야 destory 시에 error가 발생하지 않음, vpc peering이 남을 수? 있다고 하는데 정확한 정보 필요
}