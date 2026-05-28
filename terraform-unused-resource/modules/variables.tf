variable "notification_email" {
  type        = string
  description = "Email address for cost optimization alerts"
}

variable "cpu_idle_threshold" {
  type        = number
  default     = 5
  description = "CPU threshold percentage"
}

variable "alarm_period_seconds" {
  type        = number
  default     = 86400
  description = "CloudWatch alarm period"
}

variable "evaluation_periods" {
  type        = number
  default     = 7
  description = "Number of evaluation periods"
}

variable "alarm_prefix" {
  type        = string
  default     = "costopt"
  description = "Alarm name prefix"
}

variable "excluded_instance_ids" {
  type        = list(string)
  default     = []
  description = "Instances excluded from monitoring"
}

variable "excluded_volume_ids" {
  type        = list(string)
  default     = []
  description = "Volumes excluded from monitoring"
}
