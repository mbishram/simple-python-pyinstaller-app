terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.17.0"
    }
  }
}

provider "google" {
  project = "dicoding-devops-449005"
  region  = "asia-southeast2"
  zone    = "asia-southeast2-a"
}

resource "google_compute_network" "this" {
  name                    = "dicoding-devops-network"
  description             = "Network for Dicoding's DevOps learning path course."
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "this" {
  name    = "dicoding-devops-firewall"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "this" {
  name         = "dicoding-devops-instance"
  description  = "Instance for Dicoding's DevOps learning path course."
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = google_compute_network.this.id
    access_config {}
  }

  # Config
  allow_stopping_for_update = true
}