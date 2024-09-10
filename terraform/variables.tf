variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "Team4"
  }
}

variable "user_arns" {
  description = "List of IAM User ARNs who can assume the roles"
  type        = list(string)
  default     = []
}
variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}
