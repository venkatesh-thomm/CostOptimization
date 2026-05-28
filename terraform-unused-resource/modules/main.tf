

########################################
# Fetch Running EC2 Instances
########################################

data "aws_instances" "running_ec2" {
  instance_state_names = ["running"]
}

########################################
# Fetch Unattached EBS Volumes
########################################

data "aws_ebs_volumes" "unattached_ebs" {

  filter {
    name   = "status"
    values = ["available"]
  }
}

########################################
# SNS Topic
########################################

resource "aws_sns_topic" "cost_alerts" {
  name = "cost-optimization-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {

  topic_arn = aws_sns_topic.cost_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

########################################
# Local Filtering
########################################

locals {

  filtered_ec2_instances = [
    for id in data.aws_instances.running_ec2.ids :
    id
    if !contains(var.excluded_instance_ids, id)
  ]

  filtered_ebs_volumes = [
    for id in data.aws_ebs_volumes.unattached_ebs.ids :
    id
    if !contains(var.excluded_volume_ids, id)
  ]
}

########################################
# EC2 Idle CPU Alarms
########################################

resource "aws_cloudwatch_metric_alarm" "ec2_idle" {

  for_each = toset(local.filtered_ec2_instances)

  alarm_name = "${var.alarm_prefix}-ec2-idle-${each.value}"

  comparison_operator = "LessThanOrEqualToThreshold"

  evaluation_periods  = var.evaluation_periods
  datapoints_to_alarm = var.evaluation_periods

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"

  period    = var.alarm_period_seconds
  statistic = "Average"

  threshold = var.cpu_idle_threshold

  treat_missing_data = "notBreaching"

  alarm_description = "EC2 idle detection alarm"

  dimensions = {
    InstanceId = each.value
  }

  alarm_actions = [
    aws_sns_topic.cost_alerts.arn
  ]

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "CostOptimization"
  }
}

########################################
# Unattached EBS Alert
########################################

resource "aws_cloudwatch_metric_alarm" "unused_ebs" {

  for_each = toset(local.filtered_ebs_volumes)

  alarm_name = "${var.alarm_prefix}-unused-ebs-${each.value}"

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods  = 1
  datapoints_to_alarm = 1

  metric_name = "BurstBalance"
  namespace   = "AWS/EBS"

  statistic = "Average"
  period    = 86400

  threshold = 0

  treat_missing_data = "notBreaching"

  alarm_description = "Unattached EBS volume detected"

  dimensions = {
    VolumeId = each.value
  }

  alarm_actions = [
    aws_sns_topic.cost_alerts.arn
  ]

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "CostOptimization"
  }
}
