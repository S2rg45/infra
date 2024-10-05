output "glue_job_name" {
  value = aws_glue_job.glue_job.name
}

output "cloudwatch_job_glue_name" {
  value = aws_cloudwatch_log_group.glue_log_group.name
}