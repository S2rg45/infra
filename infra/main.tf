

module "glue-job" {
    source = "./modules/glue_jobs"
    glue_glue = var.glue_glue
}

module "database-catalog" {
  source = "./modules/glue_catalog_database"
  glue_databases = var.glue_databases
}

module "table-catalog" {
  source = "./modules/glue_catalog_table" 
  glue_tables = var.glue_tables
}