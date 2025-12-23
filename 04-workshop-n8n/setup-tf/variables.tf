############################################
# Compartments and Region
############################################

variable "tenancy_ocid" {
  description = "🔐 OCID del tenancy."
  type        = string
  
  validation {
    condition     = length(var.tenancy_ocid) > 0
    error_message = "El nombre del [Tenancy OCID] no puede estar vacío."
  }
}

variable "compartment_ocid" {
  description = "🔐 OCID del compartment donde se desplegarán los recursos."
  type        = string
  
  validation {
    condition     = length(var.compartment_ocid) > 0
    error_message = "El nombre del [Compartment OCID] no puede estar vacío."
  }
}

variable "region" {
  description = "🌍 OCID de la Región donde se desplegarán los recursos (por ejemplo, us-chicago-1)"
  type        = string
  
  validation {
    condition     = length(var.region) > 0
    error_message = "El nombre de la [region OCID] no puede estar vacío."
  }
}

variable "database_password" {
  description = <<EOT
🔑 Contraseña del usuario ADMIN para la base de datos autónoma. 
Debe tener entre 12 y 30 caracteres, incluir al menos una mayúscula, una minúscula y un número. 
No puede contener comillas dobles (") ni la palabra "admin" (sin importar mayúsculas/minúsculas).
EOT

  type      = string
  sensitive = true

  validation {
    condition = (
      length(var.database_password) >= 12 &&
      length(var.database_password) <= 30 &&
      can(regex("[A-Z]", var.database_password)) &&
      can(regex("[a-z]", var.database_password)) &&
      can(regex("[0-9]", var.database_password)) &&
      !can(regex("\"", var.database_password)) &&
      !can(regex("(?i)admin", var.database_password))
    )
    error_message = <<EOT
La contraseña debe tener entre 12 y 30 caracteres, contener al menos una letra mayúscula, una minúscula y un número. 
No puede contener comillas dobles (") ni la palabra "admin" (sin importar mayúsculas/minúsculas).
EOT
  }
}