resource "aws_glue_catalog_table" "data-catalog-claro-cenam-table" {
  database_name = var.catalog_database_name
  name          = var.catalog_table_name
}