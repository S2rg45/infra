resource "aws_cloudwatch_log_group" "glue_log_group" {
  for_each = {for job in var.glue_glue : job.glue_job_name => job}
  name              = "/aws-glue/jobs/${each.value.glue_job_name}"
  retention_in_days = each.value.log_retention_in_days
}

resource "aws_glue_job" "glue_job" {
  for_each = {for job in var.glue_glue : job.glue_job_name => job}
  name     = each.value.glue_job_name
  role_arn = each.value.role_arn
  glue_version = each.value.glue_version
  worker_type = each.value.worker_type
  number_of_workers = each.value.number_of_workers
  timeout = each.value.timeout

  command {
    script_location = each.value.script_location
    name            = each.value.glue_job_type
  }

  default_arguments = {
    "--job-bookmark-option"              = each.value.job-bookmark
    "--job-language"                     = each.value.job-language 
    "--extra-py-files"                   = each.value.extra-py
    "--conf"                             = each.value.executor-spark 
    "--conf"                             = each.value.driver-spark
    "--enable-metrics"                   = each.value.enable-metrics  //"true"
    "--TempDir"                          = each.value.TempDir //"s3://your-temp-bucket/temp-dir/"
    "--enable-continuous-cloudwatch-log" = each.value.enable-cloud-watch-log  //"true"
    "--enable-spark-ui"                  = each.value.enable-spark-ui // "true"
    "--spark-event-logs-path"            = each.value.spark-event-logs-path // "s3://your-logs-bucket/spark-logs/"
    "--log-group-name"                   = each.value.glue_job_name
    "--log-stream-name-prefix"           = each.value.glue_job_name
  }

  
}