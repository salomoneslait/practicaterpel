terraform {
  backend "gcs" {
    bucket  = var.bucket_name
    prefix  = "terraform/state"
  }
}

provider "google" {
  credentials = file("./elegant-zodiac-391800-c056af2c4c71.json")
  project     = var.project_id
  region      = var.region
}

resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = var.subnetwork_name
  region        = var.region
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.network.self_link
}

resource "google_compute_firewall" "firewall" {
  name    = var.firewall_name
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "instance" {
  name         = var.instance_name
  machine_type = "n1-standard-1"
  zone         = "${var.region}-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network       = google_compute_network.network.id
    subnetwork    = google_compute_subnetwork.subnetwork.self_link
    access_config {
      // Ephemeral IP
    }
  }

  user-data = <<-EOF
      #cloud-config
      packages:
        - apache2

      write_files:
        - path: /var/www/html/index.html
          content: |
            <html>
            <head>
              <title>Práctica IAC en Terpel</title>
              <style>
                body {
                  background-color: #ffffff;
                  font-family: Arial, sans-serif;
                  text-align: center;
                  margin-top: 100px;
                }
                .logo {
                  width: 300px;
                  height: 92px;
                  background-image: url("https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png");
                  background-size: contain;
                  background-repeat: no-repeat;
                  margin: 0 auto;
                }
                .innovador {
                  font-size: 24px;
                  color: #555555;
                  margin-top: 20px;
                }
              </style>
            </head>
            <body>
              <div class="logo"></div>
              <h1>Práctica IAC en Terpel</h1>
              <p class="innovador">con un diseño innovador y original</p>
            </body>
            </html>
    EOF

}
