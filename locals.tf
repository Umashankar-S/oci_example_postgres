

locals {


  psql_admin_password = var.psql_admin_password != "" ? var.psql_admin_password : random_password.psql_admin_password.result
  psql_passwd_type = var.use_vault ? "VAULT_SECRET" : "PLAIN_TEXT"
  psql_iops = {
    75  = 75000
    150 = 150000
    225 = 225000
    300 = 300000
    }
  # Base shape prefixes
  shape_prefixes_fixed = {
    e5        = "PostgreSQL.VM.Standard.E5.Flex"
    standard3 = "PostgreSQL.VM.Standard3.Flex"
  }

  
  # OCPU to memory ratio (OCPU: GB)
  # E5 = 1:16, E6 = 1:16, Standard3 = 1:16
  memory_ratios_fixed = {
    e5        = 16
    standard3 = 16
  }

  # OCPU options
  ocpu_counts_fixed = {
    e5 = [2, 4, 8, 16, 32, 64]
    standard3 = [2, 4, 8, 16, 32 ]
  }

  # Generate shapes dynamically for all shape types

  psql_shapes_fixed_e5 = {
    for ocpu in local.ocpu_counts_fixed.e5 :
    ocpu => "${local.shape_prefixes_fixed.e5}.${ocpu}.${ocpu * local.memory_ratios_fixed.e5}GB"
  }

  psql_shapes_fixed_standard3 = {
    for ocpu in local.ocpu_counts_fixed.standard3 :
    ocpu => "${local.shape_prefixes_fixed.standard3}.${ocpu}.${ocpu * local.memory_ratios_fixed.standard3}GB"
  }

  # Combined map with all shapes
  all_psql_shapes_fixed = merge(
    { for k, v in local.psql_shapes_fixed_e5 : "e5_${k}" => v },
    { for k, v in local.psql_shapes_fixed_standard3 : "standard3_${k}" => v }
  )

  ## Flex 
  shape_prefixes_flex = {
    e5        = "PostgreSQL.VM.Standard.E5.Flex"
    e6        = "PostgreSQL.VM.Standard.E6.Flex"
    standard3 = "PostgreSQL.VM.Standard3.Flex"
   }
  ocpus_counts_flex =  { 
    e5  = range ( 1, 64 )
    e6  = range ( 1, 126 )
    standard3 = range ( 1, 32 )
   }
  psql_shapes_flex_e5 = {
    for ocpu in local.ocpus_counts_flex.e5 :
    ocpu => "${local.shape_prefixes_flex.e5}"
     }
  psql_shapes_flex_e6 = {
    for ocpu in local.ocpus_counts_flex.e6 :
    ocpu => "${local.shape_prefixes_flex.e6}"
     }   
  psql_shapes_flex_standard3 = {
    for ocpu in local.ocpus_counts_flex.standard3 :
    ocpu => "${local.shape_prefixes_flex.standard3}"
    }

  all_psql_shapes_flex = merge(
    { for k, v in local.psql_shapes_flex_e5 : "e5_${k}" => v },
    { for k, v in local.psql_shapes_flex_e6 : "e6_${k}" => v },
    { for k, v in local.psql_shapes_flex_standard3 : "standard3_${k}" => v }
  )  

## ocpu If wrong ocpu count is sepcfied for the instance shape / type then defaults to 2 opcus
ocpu = var.psql_shape_type == "Fixed" ? (
  contains(keys(local.all_psql_shapes_fixed), "${var.psql_shape_family}_${var.ocpu}") 
  ? var.ocpu 
  : 2
) : (
  contains(keys(local.all_psql_shapes_flex), "${var.psql_shape_family}_${var.ocpu}") 
  ? var.ocpu 
  : 2
)  

}

# Usage examples:
# local.psql_shapes_fixed_e5[8]          => "PostgreSQL.VM.Standard.E5.Flex.8.128GB"
# local.psql_shapes_fixed_standard3[32]  => "PostgreSQL.VM.Standard3.Flex.32.512GB"
# local.all_psql_shapes_fixed["e5_4"]    => "PostgreSQL.VM.Standard.E5.Flex.4.64GB"

###
# local.all_psql_shapes_flex["e5_1"]     => "PostgreSQL.VM.Standard.E5.Flex"
# local.psql_shapes_flex_e6[126]          => "PostgreSQL.VM.Standard.E6.Flex"
# local.psql_shapes_flex_standard[16]    => "PostgreSQL.VM.Standard3.Flex"

