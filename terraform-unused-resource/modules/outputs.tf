output "sns_topic_arn" {
  value = aws_sns_topic.cost_alerts.arn
}

output "monitored_ec2_instances" {
  value = local.filtered_ec2_instances
}

output "unattached_ebs_volumes" {
  value = local.filtered_ebs_volumes
}

output "monitored_ec2_count" {
  value = length(local.filtered_ec2_instances)
}

output "unattached_ebs_count" {
  value = length(local.filtered_ebs_volumes)
}
