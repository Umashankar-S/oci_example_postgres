




resource oci_psql_db_system psql_inst_1 {
  compartment_id = var.compartment_ocid
  #config_id      = 
  db_version = "14"
  #admin_username = var.psql_admin
  #credentials =  random_string.psql_admin_password.result 
  credentials {
        #Required
        password_details {
            #Required
            
            #password_type = var.psql_passwd_type == "PLAIN_TEXT"  ?   "PLAIN_TEXT" : "VAULT_SECRET"
            password_type = "VAULT_SECRET"
            #password =  random_string.psql_admin_password.result
            
            #Optional
           # password = var.db_system_credentials_password_details_password
             secret_id = oci_vault_secret.psql_secret.id
            secret_version = 1
        }
        username = var.psql_admin
    }

  description = "Postgres SQL Instance"
  display_name = "psql_inst_1"
  freeform_tags = {
  }
  instance_count              = var.inst_count
  instance_memory_size_in_gbs =  var.num_ocpu  * 16 
  instance_ocpu_count         = var.num_ocpu
  #instances_details = <<Optional value>>
  management_policy {
    #backup_policy = <<Optional value >>
    maintenance_window_start = "FRI 04:00"
  }
  network_details {
    nsg_ids = [
    ]
    #primary_db_endpoint_private_ip = 
    subnet_id      = var.create_vcn_subnet == true ?  oci_core_subnet.vcn1-psql-priv-subnet[0].id : var.psql_subnet_ocid
  }
  #shape = "PostgreSQL.VM.Standard.E4.Flex.2.32GB"
   shape = lookup(var.psql_shape,var.num_ocpu, "PostgreSQL.VM.Standard.E4.Flex.2.32GB")
  
  storage_details {
    availability_domain   = data.oci_identity_availability_domain.US-ASHBURN-AD-1.name
    iops                  = "300000"
    is_regionally_durable = "false"
    system_type           = "OCI_OPTIMIZED_STORAGE"
  }
  system_type = "OCI_OPTIMIZED_STORAGE"
}

