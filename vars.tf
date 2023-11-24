
variable region { default = "us-ashburn-1" }
#variable "tenancy_name" { }
variable  compartment_ocid {   }


## Network 

variable create_service_gateway { default = true }
variable create_vcn_subnet { default = false }
variable psql_subnet_ocid {  } ## Private Subnet OCID of existing Subnet 
variable "vcn_cidr" { 
    type = list
    default = ["10.10.0.0/16"] 
    }

## PSQL 
variable "psql_admin" {
    type = string
    description = "Name of PSQL Admin Usern"
}
variable inst_count  { default = 1 }

variable "num_ocpu" { default = 2 }
  
variable  psql_shape  {
    type = map(string) 
    default = { 
    2 =  "PostgreSQL.VM.Standard.E4.Flex.2.32GB"
    4 =  "PostgreSQL.VM.Standard.E4.Flex.4.64GB" 
    8 =  "PostgreSQL.VM.Standard.E4.Flex.8.128GB"
    16 =  "PostgreSQL.VM.Standard.E4.Flex.16.256GB"
    32 =  "PostgreSQL.VM.Standard.E4.Flex.32.512GB"
    64 =  "PostgreSQL.VM.Standard.E4.Flex.64.1024GB"
    }
}


#variable psql_passwd_type  {  default = "PLAIN_TEXT" }