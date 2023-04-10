variable "region" {
  description = "The AWS region in which resources are set up."
  type        = string
  default     = "eu-west-1"
}


variable "replica_region" {
  description = "The AWS region to which the state bucket is replicated."
  type        = string
  default     = "eu-west-2"
}
