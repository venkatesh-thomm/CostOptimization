output "unattached_ebs_volumes" {
  value = module.cost_optimization.unattached_ebs_volumes
}

output "monitored_ec2_instances" {
  value = module.cost_optimization.monitored_ec2_instances
}
output "sns_topic_arn" {
  value = module.cost_optimization.sns_topic_arn
}
output "monitored_ec2_count" {
  value = module.cost_optimization.monitored_ec2_count
}
output "unattached_ebs_count" {
  value = module.cost_optimization.unattached_ebs_count
}
