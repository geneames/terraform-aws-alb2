variable "namespace" {
  type        = "string"
  description = "Namespace, which could be your organization name, e.g. `cp` or `cloudposse`"
}

variable "stage" {
  type        = "string"
  description = "Stage, e.g. `prod`, `staging`, `dev`, or `test`"
}

variable "name" {
  type        = "string"
  description = "Solution name, e.g. `app`"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `name`, `stage` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes, e.g. `1`"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map(`BusinessUnit`,`XYZ`)"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID to associate with ALB"
}

variable "subnet_ids" {
  type        = "list"
  description = "A list of subnet IDs to associate with ALB"
}

variable "security_group_ids" {
  type        = "list"
  default     = []
  description = "A list of additional security group IDs to allow access to ALB"
}

variable "internal" {
  type        = "string"
  default     = "false"
  description = "A boolean flag to determine whether the ALB should be internal"
}

variable "certificate_arn" {
  type        = "string"
  default     = ""
  description = "The ARN of the default SSL certificate for HTTPS listener"
}

variable "access_logs_prefix" {
  type        = "string"
  default     = ""
  description = "The S3 bucket prefix"
}

variable "access_logs_enabled" {
  type        = "string"
  default     = "true"
  description = "A boolean flag to enable/disable access_logs"
}

variable "access_logs_region" {
  type        = "string"
  default     = "us-east-1"
  description = "The region for the access_logs S3 bucket"
}

variable "cross_zone_load_balancing_enabled" {
  type        = "string"
  default     = "true"
  description = "A boolean flag to enable/disable cross zone load balancing"
}

variable "http2_enabled" {
  type        = "string"
  default     = "true"
  description = "A boolean flag to enable/disable HTTP/2"
}

variable "idle_timeout" {
  type        = "string"
  default     = "60"
  description = "The time in seconds that the connection is allowed to be idle"
}

variable "ip_address_type" {
  type        = "string"
  default     = "ipv4"
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`."
}

variable "deletion_protection_enabled" {
  type        = "string"
  default     = "false"
  description = "A boolean flag to enable/disable deletion protection for ALB"
}

variable "alb_access_logs_s3_bucket_force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the ALB access logs S3 bucket so that the bucket can be destroyed without error"
  default     = false
}
