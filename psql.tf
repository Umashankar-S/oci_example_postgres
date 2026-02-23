##  OCI Postgres DB 

resource oci_psql_db_system psql_instance {
  compartment_id = var.compartment_ocid
  #config_id      = 
  db_version = var.psql_version
  #admin_username = var.psql_admin
  #credentials =  random_string.psql_admin_password.result 
  credentials {
        #Required
        password_details {
            #Required
            password_type = local.psql_passwd_type           
            password = var.use_vault ?  null : local.psql_admin_password
            #Optional
             secret_id = var.use_vault ? oci_vault_secret.psql_secret[0].id : null
             secret_version = var.use_vault  ?  1 : null
        }
        username = var.psql_admin
    }

  description = "Postgres SQL Instance"
  display_name = var.psql_displayname
  freeform_tags = {
  }
  instance_count              = var.node_count
  #instances_details = <<Optional value>>

  management_policy {
    #backup_policy = <<Optional value >>
    maintenance_window_start = "FRI 04:00"
  }
  network_details {
    nsg_ids = [ var.create_vcn_subnet == true ? oci_core_network_security_group.vcn1-nsg[0].id : var.nsg_id
    ]
    #primary_db_endpoint_private_ip = 
    subnet_id      = var.create_vcn_subnet == true ?  oci_core_subnet.vcn1-psql-priv-subnet[0].id : var.psql_subnet_ocid
  }

  #shape = var.psql_shape_type == "Fixed" ?  local.all_psql_shapes_fixed["${var.psql_shape_family}_${var.ocpu}"] : local.all_psql_shapes_flex["${var.psql_shape_family}_${var.ocpu}"]
  shape = var.psql_shape_type == "Fixed" ?   ( lookup(local.all_psql_shapes_fixed, "${var.psql_shape_family}_${var.ocpu}",  local.all_psql_shapes_fixed["${var.psql_shape_family}_2"]) )  : ( lookup(local.all_psql_shapes_flex, "${var.psql_shape_family}_${var.ocpu}",local.all_psql_shapes_flex["${var.psql_shape_family}_2"]) )
  #Conatins key validation fixes : The given key does not identify an element in this collection value.  Also as a fail safe it uses 2 OCPUs shape
  instance_ocpu_count = local.ocpu
  instance_memory_size_in_gbs =  local.ocpu  * 16 
  storage_details {

    availability_domain   = data.oci_identity_availability_domains.ads.availability_domains[0].name
    iops                  = local.psql_iops[var.storage_iops]
    is_regionally_durable = "false"
    system_type           = "OCI_OPTIMIZED_STORAGE"
  }
  system_type = "OCI_OPTIMIZED_STORAGE"
}

