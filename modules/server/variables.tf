variable "subnet_id_target" {
  description = "ID Subnet tempat server ditaruh"
  type = string
}

variable "nama_server" {    
  description = "Nama server yang akan dibuat"
  type = string
  default = "server-module"  
}

variable "jumlah_instance" {
  description = "Mau Bikin berapa server ?"
  type = number
  default = 1
}