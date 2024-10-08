resource "aws_glue_catalog_table" "data-catalog-claro-cenam-table" {
  for_each = {for job in var.glue_tables : job.catalog_table_name => job}
  database_name = each.value.catalog_database_name
  name          = each.value.catalog_table_name
}