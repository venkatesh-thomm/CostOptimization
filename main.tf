module "cost_optimization" {

  source = "./terraform-unused-resource/modules"

  providers = {
    aws = aws
  }

  notification_email = "tvenky359@gmail.com"

  cpu_idle_threshold = 5

  alarm_period_seconds = 60

  evaluation_periods = 1

  alarm_prefix = "test"
}
