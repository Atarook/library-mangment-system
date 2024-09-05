# Variable for User ARNs
variable "user_arns" {
  description = "List of IAM User ARNs allowed to assume the role"
  type        = list(string)
  default     = [
    "arn:aws:iam::637423483309:user/Tarek",
    "arn:aws:iam::637423483309:user/fawzy",
    "arn:aws:iam::637423483309:user/ahmed",
    "arn:aws:iam::637423483309:user/ahmedkamal",
  ]
}

# Tags Variable
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "Production"
    Team        = "Team4"
  }
}