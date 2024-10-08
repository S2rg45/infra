provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Ambiente    = var.ambiente
      aplicacion  = var.aplicacion
      cuenta      = "${var.cuenta}-${var.environment}"
      gerencia    = var.gerencia
      direccion   = var.direccion
      pais        = var.pais
    }
  }
}

terraform {
   backend "s3" {}
}



