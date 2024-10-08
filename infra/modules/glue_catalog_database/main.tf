resource "aws_glue_catalog_database" "data-catalog-claro-cenam-db" {
  for_each = {for job in var.glue_databases : job.catalog_database_name => job}
  name = each.value.catalog_database_name
}

