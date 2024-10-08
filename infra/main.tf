

module "glue-job" {
    source = "./modules/glue_jobs"
    glue_job_name = var.glue_glue
}

module "database-catalog" {
  source = "./modules/glue_catalog_database"
  database_name = var.glue_databases
}

module "table-catalog" {
  source = "./modules/glue_catalog_table" 
  table_catalog = var.glue_tables
}