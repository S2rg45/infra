variable "glue_databases" {
  description = "Name of the catalog database"
  type        = list(map(string))
  default = []
}
