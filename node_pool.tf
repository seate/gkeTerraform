resource "google_container_node_pool" "general" {
    name       = "my-node-pool" # Node Pool 이름
    cluster    = google_container_cluster.primary.id # 클러스터 이름
    location = google_container_cluster.primary.location

    autoscaling {
        min_node_count = 1
        max_node_count = 1
    }

    management {
        auto_repair  = true # 노드 자동 복구 기능 활성화
        auto_upgrade = true # 노드 자동 업그레이드 기능 활성화
    }

    node_config {
        disk_size_gb = 30
        preemptible  = false # 노드 중단 불가능 설정, spot instance 설정과 유사
        machine_type = "e2-standard-4" # Node의 크기

        metadata = {
            ssh-keys = "${var.ssh_user}:${tls_private_key.ssh_key.public_key_openssh}"
        }

        tags = ["gke-node"]

        labels = {
            role = "general"
        }

        service_account = google_service_account.kubernetes.email
        oauth_scopes = [
            "https://www.googleapis.com/auth/cloud-platform" # service account가 전체 클라우드 플랫폼에 액세스 허용
        ]
    }
  
}

resource "google_compute_firewall" "allow_tcp_to_nodes" {
  name    = "allow-tcp-to-nodes"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "3000", "8080", "8081", "8082", "8083", "8084"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags = ["gke-node"]
  target_tags   = ["gke-node"]
}
