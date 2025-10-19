# VPC
resource "google_compute_network" "custom-network" {
  name                    = "custom-vpc-7s"
  auto_create_subnetworks = false
}

# SUBNET
resource "google_compute_subnetwork" "custom-subnet" {
  name          = "custom-subnet-7s"
  region        = var.region
  network       = google_compute_network.custom-network.id
  ip_cidr_range = "10.10.0.0/16"
}

# FW 1
resource "google_compute_firewall" "allow-internal" {
  name    = "internal-firewall"
  network = google_compute_network.custom-network.id

  allow {
    protocol = "all"
  }

  source_ranges = ["10.10.0.0/16"]
}

# FW 2
resource "google_compute_firewall" "allow-gke" {
  name    = "gke-firewall"
  network = google_compute_network.custom-network.id

  allow {
    protocol = "tcp"
    ports    = ["443", "8443", "10250", "15017", "80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# GKE CLUSTER
resource "google_container_cluster" "primary" {
  project  = var.project
  name     = "terraform-gke-cluster-7s"
  location = var.zone

  network                  = google_compute_network.custom-network.id
  subnetwork               = google_compute_subnetwork.custom-subnet.id
  min_master_version       = "1.33.5-gke.1080000"
  deletion_protection      = false
  remove_default_node_pool = true
  initial_node_count       = 1
}

# GKE NODE
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name           = "my-node-pool"
  project        = google_container_cluster.primary.project
  cluster        = google_container_cluster.primary.name
  location       = google_container_cluster.primary.location
  version        = "1.33.5-gke.1080000"
  node_locations = ["us-central1-a"]
  node_count     = 1

  node_config {
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = "10"
    disk_type    = "pd-standard"
    machine_type = "e2-medium"
  }
  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
