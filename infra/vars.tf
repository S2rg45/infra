variable "glue_job_name" {
  description = "glue_job_name"
  type = list(map(string))
  default = []
}

variable "table_catalog" {
  type = list(map(string))
  default = []
}

variable "database_name" {
  description = "Name of the catalog database"
  type        = list(map(string))
  default = []
}

variable "aws_region" {
  description = "aws region"
  type        = string   
}


#################################
## Tags variables
#################################
variable "cuenta" {
  description = "nombre de la cuenta de claro"
  type = string
}

variable "gerencia" {
  description = "nombre de la gerencia de claro"
  type = string
}

variable "direccion" {
  description = "nombre de la direcion de claro"
  type = string  
}

variable "pais" {
  description = "nombre del pais donde se despliega"
  type = string
}

variable "aplicacion" {
  description = "nombre de la aplicacion en donde se descpliega"
  type = string  
}

variable "ambiente" {
  description = "nombre del ambiente donde se despliega"
  type = string
}

variable "environment" {
  description = "Environment for deployment (like dev or staging)"
  type        = string
}
