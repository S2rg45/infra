resource "aws_s3_bucket" "datalake_bucket_raw" {
  bucket  = var.bucket_name_raw
  force_destroy = true
  tags = {
    Aplicacion = var.aplicacion_s3
    Ambiente = var.ambiente
    Pais = var.pais
    Direccion = var.direccion
    Gerencia = var.gerencia
    Cuenta = "${var.cuenta}-${var.environment}"
    Dominio = var.domain
    owner = var.owner
    project = var.project
    deadline = var.deadline
  }
}

resource "aws_s3_bucket" "datalake_bucket_gold" {
  bucket  = var.bucket_name_gold
  force_destroy = true
  tags = {
    Aplicacion = var.aplicacion_s3
    Ambiente = var.ambiente
    Pais = var.pais
    Direccion = var.direccion
    Gerencia = var.gerencia
    Cuenta = "${var.cuenta}-${var.environment}"
    Dominio = var.domain
    owner = var.owner
    project = var.project
    deadline = var.deadline
  }
}

resource "aws_s3_bucket" "datalake_bucket_analytics" {
  bucket  = var.bucket_name_analytics
  force_destroy = true
  tags = {
    Aplicacion = var.aplicacion_s3
    Ambiente = var.ambiente
    Pais = var.pais
    Direccion = var.direccion
    Gerencia = var.gerencia
    Cuenta = "${var.cuenta}-${var.environment}"
    Dominio = var.domain
    owner = var.owner
    project = var.project
    deadline = var.deadline
  }
}

locals {
  s3-subfolders-raw = [
    "Cdrs/Movil/Voz",
    "Cdrs/Movil/Gprs"
  ]
}

locals {
  s3-subfolders-analytics = [
    "Ciencia/HuellaDeTrafico/GT",
    "Ciencia/HuellaDeTrafico/SV",
    "Ciencia/HuellaDeTrafico/HN",
    "Ciencia/HuellaDeTrafico/NI",
    "Ciencia/HuellaDeTrafico/CR",
    "Ciencia/Kido/Cdrs",
    "Ciencia/Kido/Xdrs",
    "Ciencia/Kido/Crm",
    "Ciencia/Kido/Antenas",
    "Ciencia/Movilidad/Rank/GT",
    "Ciencia/Movilidad/Rank/SV",
    "Ciencia/Movilidad/Rank/HN",
    "Ciencia/Movilidad/Rank/NI",
    "Ciencia/Movilidad/Rank/CR",
    "Ciencia/Movilidad/Cierre/GT",
    "Ciencia/Movilidad/Cierre/SV",
    "Ciencia/Movilidad/Cierre/HN",
    "Ciencia/Movilidad/Cierre/NI",
    "Ciencia/Movilidad/Cierre/CR",
    "Ciencia/SNA",
  ]
}

resource "aws_s3_object" "datalake_folder_analytics" {
  bucket = aws_s3_bucket.datalake_bucket_analytics.id
  force_destroy = true
  key    = format("%s/",var.folder_name_analitycs)
  source = var.source_bucket_folder
}

resource "aws_s3_object" "datalake_folder_raw" {
  bucket = aws_s3_bucket.datalake_bucket_raw.id
  force_destroy = true
  key    = format("%s/",var.folder_name_raw)
  source = var.source_bucket_folder
}



resource "aws_s3_object" "object_folder_s3_raw" {
  bucket = aws_s3_bucket.datalake_bucket_raw.id
  for_each = toset(local.s3-subfolders-raw)
  key = format("%s","${var.folder_name_raw}/${each.value}/")
  content_type = "application/x-directory"

  depends_on = [  aws_s3_bucket.datalake_bucket_raw,  
                  aws_s3_object.datalake_folder_raw ]
}


resource "aws_s3_object" "object_folder_s3_analytics" {
  bucket = aws_s3_bucket.datalake_bucket_analytics.id
  for_each = toset(local.s3-subfolders-analytics)
  key = format("%s","${var.folder_name_analitycs}/${each.value}/")
  content_type = "application/x-directory"

  depends_on = [  aws_s3_bucket.datalake_bucket_analytics,  
                  aws_s3_object.datalake_folder_analytics ]
}




