// Crear las maquinas virtuales
variable "vm_names_create" {
  type    = list(string)
  default = ["CTXD38569INCT01"]  # Actualiza con los nombres de las máquinas virtuales deseadas
}

variable "subnet_names_create" {
  type    = list(string)
  default = ["SNETEU2DAASDSOAPROV001"]  # Actualiza con los nombres de las subredes deseadas
}

variable "existing_images" {
  type    = list(string)
  default = ["TPL001"]
}