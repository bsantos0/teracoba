terraform {
  required_providers {
    aws = {}
  }

  backend "s3" {
    bucket = "terraform-state-terra-lab"
    key    = "project-terra/terraform.tfstate" 
    region = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }

}

provider "aws" {
    region = "ap-southeast-1"  
}

locals {
  jumlah_server     = terraform.workspace == "prod" ? 2 : 1
  nama_dynamic      = "kantor-${terraform.workspace}"
}

module "kantor-pusat" {
    source       = "./modules/network"
    cidr_vpc     = "10.0.0.0/16"
    project_name = local.nama_dynamic  
}

###
#module "kantor_cabang1" {
#    source       = "./modules/network"
#    cidr_vpc     = "192.168.0.0/16"
#    project_name = "kantor-cabang1"  
#}

module "server-kantor-pusat" {
    source              = "./modules/server"
    subnet_id_target    = module.kantor-pusat.subnet_id
    nama_server         = "${local.nama_dynamic}-server"  
    jumlah_instance     = local.jumlah_server
}

#module "server-kantor-cabang1" {
#    source       = "./modules/server"
#    subnet_id_target = module.kantor_cabang1.subnet_id
#    nama_server = "server-kantor-cabang1"  
#}



#module database
module "database-kantor-pusat" {
    source          = "./modules/database"
    project_name    = local.nama_dynamic
    vpc_id          = module.kantor-pusat.vpc_id
    private_subnets = module.kantor-pusat.private_subnet_ids
    db_name         = "kantordb"
    db_username     = "adminuser"
}

output "alamat_database" {
    value = module.database-kantor-pusat.db_endpoint
}

output "password_database" {
    value     = module.database-kantor-pusat.db_password
    sensitive = true
}