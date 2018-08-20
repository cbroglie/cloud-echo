terraform {
  backend "gcs" {
    bucket = "cf-sec-eng-tf"
    prefix = "terraform/state"
    credentials = "./account.json"
  }
}

provider "google" {
  credentials = "${file("account.json")}"
  project = "cf-sec-eng"
  region = "us-west1"
}

resource "google_container_cluster" "primary" {
  name = "evida-cloud"

  zone = "us-west1-a"
  additional_zones = [
    "us-west1-b",
    "us-west1-c",
  ]

  network = "projects/cf-sec-eng/global/networks/default"

  node_version = "1.10.6-gke.1"
  min_master_version = "1.10.6-gke.1"

  remove_default_node_pool = true
  node_pool {
    name = "default-pool"
  }

  lifecycle {
    ignore_changes = ["node_pool"]
  }
}

resource "google_container_node_pool" "primary_pool" {
  name = "primary-pool"
  cluster = "${google_container_cluster.primary.name}"
  zone = "us-west1-a"
  node_count = "1"

  node_config {
    machine_type = "n1-standard-1"
    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]
  }

  version = "${google_container_cluster.primary.node_version}"

  management {
    auto_repair = true
    auto_upgrade = false
  }
}

resource "google_compute_global_address" "default" {
  name = "evida-cloud-ingress-ip"
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}