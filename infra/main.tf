

module "glue-job" {
    source = "./modules/glue_jobs"
    glue_job_name = var.glue_job_name
}

module "database-catalog" {
  source = "./modules/glue_catalog_database"
  database_name = var.database_name
}

module "table-catalog" {
  source = "./modules/glue_catalog_table" 
  table_catalog = var.table_catalog
}