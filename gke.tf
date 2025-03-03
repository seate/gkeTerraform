resource "google_container_cluster" "primary" {
    name                     = var.cluster_name # 클러스터 이름
    location                 = var.region #Region 설정


    # multi location, 가용영역을 지정
    #node_locations = var.zones 

    deletion_protection = false # 삭제 방지 해제
    
    
    remove_default_node_pool = true # node pool 별도 지정을 위해 기본 node pool 삭제
    initial_node_count = 1 # 별도 node pool 사용 시 1 이상을 지정해야 함
    lifecycle {
        ignore_changes = [
            initial_node_count # node 개수를 쿠버네티스 라이프 사이클에서 제외
        ]
    }
    

    network                  = google_compute_network.main.self_link
    subnetwork               = google_compute_subnetwork.private_subnet.name

        
    #addons_config {
        #http_load_balancing {
        #    disabled = false
        #}
        #horizontal_pod_autoscaling {
        #    disabled = false
        #}
    #}

    release_channel {
        channel = "REGULAR"
    }

    workload_identity_config { # 쿠버네티스 인스턴스가 GCP 리소스에 접근할 수 있도록 설정
        workload_pool = "${var.project_id}.svc.id.goog" # 워크로드 이름 설정. 보통 <이름>.svc.id.goog 사용
    }

    ip_allocation_policy { # 클러스터와 서비스에 사용할 ip 지정
        cluster_secondary_range_name  = "k8s-pod-range"
        services_secondary_range_name = "k8s-service-range"
    }

    private_cluster_config {
        enable_private_nodes    = true
        enable_private_endpoint = false
        master_ipv4_cidr_block  = "172.16.0.0/28"
    }

    depends_on = [
        google_service_account.kubernetes
    ]
}