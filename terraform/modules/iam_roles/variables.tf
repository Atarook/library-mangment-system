variable "user_arns" {
  description = "List of IAM user ARNs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
