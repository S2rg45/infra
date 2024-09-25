
variable "folder_name_raw" {
  description = "Name of the raw folder"
  type        = string
}

variable "bucket_name_gold" {
  description = "name of bucket layer gold"
  type = string
}

variable "folder_name_standard" {
  description = "Name of the standard folder"
  type        = string
}

variable "folder_name_analitycs" {
  description = "Name of the analytics folder"
  type        = string
}

variable "owner" {
  description = "owner"
  type = string
}

variable "project" {
  description = "project"
  type = string
}

variable "deadline" {
  description = "deadline"
  type = string
}

variable "source_bucket_folder" {
  description = "Source bucket folder"
  type        = string
}

variable "complement_name" {
  description = "Complement name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

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

variable "aplicacion_s3" {
  description = "nombre de la aplicacion en donde se despliega"
  type = string  
}

variable "ambiente" {
  description = "nombre del ambiente donde se despliega"
  type = string  
}

variable "bucket_name_analytics" {
  description = "nombre del bucket"
  type = string
}

variable "bucket_name_raw" {
  description = "nombre del bucket"
  type = string  
}

variable "domain" {
  description = "dominio"
  type = string
}


