
####################### Tenancy  #######################
variable region { 
  type    = string
  default = "us-ashburn-1"
  }

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID (used for AD discovery). If empty, compartment_ocid is used."
  default     = ""
}

variable "compartment_ocid" {
  type = string
}

####################### Network   #######################

variable "create_service_gateway" {
  type    = bool
  default = true
}
variable "create_vcn_subnet" {
  type    = bool
  default = true
}

variable "psql_subnet_ocid" {
  type        = string
  description = "Private Subnet OCID of existing subnet (used when create_vcn_subnet = false)"
  default     = ""
}

variable "vcn_id" {
  type        = string
  description = "VCN OCID of existing VCN (used when create_vcn_subnet = false)"
  default     = ""
}

variable "nsg_id" {
  type        = string
  description = "Existing NSG ocid  (used when create_vcn_subnet = false)"
  default     = ""
}
variable "vcn_cidr" { 
    type = list
    default = ["10.10.0.0/16"] 
    }

####################### PSQL  #######################

variable psql_displayname {  
    type = string
    description = "PostgreSQL DB system Name"
    } 

variable "psql_admin" {
    type = string
    description = "Name of PSQL Admin User i.e admin "
}

variable psql_version {  
    type = number
    description = "PostgreSQL DB version i.e 16 or 15 "
    #default = 16 
    } 
variable node_count  { 
    type = number
    description = "PostgreSQL Node Count , 1st is primary and rest is replica"
    default = 1 
    }

variable "ocpu" { 
    type = number
    description = "PostgreSQL instance's OCPU count "
    default = 2 
    }

variable psql_shape_type { 
    type = string
    description = "PSQL Compute Shapes Fixed or Flex"
    default = "Fixed"  # Fixed or Flex
}  

variable psql_shape_family { 
    type = string
    description = "PSQL Compute Shapes Family E5 , E6 (AMD) or Standard3 (Intel) "
    default = "e5"  
} 
# variable  psql_shape  {
#     type = map(string) 
#     description = "PSQL Compute Shapes : PostgreSQL.VM.Standard.E4.Flex.*"
#     default = { 
#     2 =  "PostgreSQL.VM.Standard.E4.Flex.2.32GB"
#     4 =  "PostgreSQL.VM.Standard.E4.Flex.4.64GB" 
#     8 =  "PostgreSQL.VM.Standard.E4.Flex.8.128GB"
#     16 =  "PostgreSQL.VM.Standard.E4.Flex.16.256GB"
#     32 =  "PostgreSQL.VM.Standard.E4.Flex.32.512GB"
#     64 =  "PostgreSQL.VM.Standard.E4.Flex.64.1024GB"
#     }
# }


variable storage_iops {
   type = number
   description = "PSQL DB System IOPS i.e  75 => 75,000 IOPS, 75 K (Min) to 300K (Max) "
    default = 75
}
# variable psql_passwd_type  { 
# type = string
# description = "PSQL Password Type PLAIN_TEXT or VAULT_SECRET"
# default = "PLAIN_TEXT" 
# }

variable psql_admin_password { 
type = string
description = "PSQL ADMIN Password , if not provided will be auto generated "
default = ""
sensitive = true
}

    
variable "use_vault" {
  type = bool
  default = false
}
variable "create_vault" { 
    type    = bool
    default = true
 }

variable "vault_id" { 
  type = string
  description = "OCI Vault OCID of existing Vault"
  default = ""
}


####################### OCI PostgreSQL Configuration (optional) #######################

variable "create_psql_configuration" {
  type        = bool
  description = "Whether to create an OCI PostgreSQL configuration in this stack"
  default     = false
}

variable "psql_configuration_ocid" {
  type        = string
  description = "Existing OCI PostgreSQL configuration OCID to use (if provided, skips creation)"
  default     = ""
}

variable "psql_config_display_name" {
  type        = string
  description = "Display name for the OCI PostgreSQL configuration (when created)"
  default     = "Flexible_configuration"
}

variable "psql_config_is_flexible" {
  type        = bool
  description = "Whether the configuration is flexible"
  default     = true
}

variable "psql_config_compatible_shapes" {
  type        = list(string)
  description = "List of compatible shapes for the configuration"
  default     = [
    "VM.Standard.E5.Flex",
    "VM.Standard.E6.Flex",
    "VM.Standard3.Flex"
  ]
}

variable "psql_config_description" {
  type        = string
  description = "Description for the PostgreSQL configuration"
  default     = "Test configuration created by terraform"
}

variable "psql_config_overrides" {
  type        = map(string)
  description = "Configuration overrides as key/value pairs"
  default     = {
    "oci.admin_enabled_extensions" = "pg_stat_statements,pglogical,vector"
    "pglogical.conflict_log_level" = "debug1"
    "pg_stat_statements.max"       = "5000"
  }
}
