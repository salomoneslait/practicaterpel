variable "project_id" {
  description = "ID del proyecto de GCP"
  default     = "your-project-id"
}

variable "region" {
  description = "Región de GCP para crear los recursos"
  default     = "us-central1"
}

variable "network_name" {
  description = "Nombre de la red de GCP"
  default     = "my-network"
}

variable "subnetwork_name" {
  description = "Nombre de la subred de GCP"
  default     = "my-subnetwork"
}

variable "firewall_name" {
  description = "Nombre del firewall de GCP"
  default     = "allow-http-ssh"
}

variable "instance_name" {
  description = "Nombre de la instancia de GCP"
  default     = "my-instance"
}

variable "bucket_name" {
  description = "Nombre del bucket de GCS para el backend remoto"
  default     = "your-backend-bucket"
}
