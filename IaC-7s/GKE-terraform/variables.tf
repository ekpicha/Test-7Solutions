variable "project" {
  description = "gcp projecct id"
  type        = string
  default     = "solutions-test-475602"
}

variable "region" {
  description = "gcp region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "gcp zone"
  type        = string
  default     = "us-central1-a"
}

# variable "k8s-version" {
#   description = "gke version"
#   type        = string
#   default     = "1.33.5-gke.1080000"
# }

# variable "node-count" {
#   description = "gke node count"
#   type        = number
#   default     = 1
# }