
resource oci_kms_key psql_key {
  compartment_id = var.compartment_ocid
  defined_tags = {
  }
  desired_state = "ENABLED"
  display_name  = "psql_key"
  #external_key_reference = <<Optional value>>
  freeform_tags = {
  }
  key_shape {
    algorithm = "AES"
    curve_id  = ""
    length    = "32"
  }
  #management_endpoint = "https://ejsv6rxhaagwg-management.kms.us-ashburn-1.oraclecloud.com"
  management_endpoint  =  data.oci_kms_vault.data_psql_oci_kms_vault_1.management_endpoint 
  protection_mode     = "SOFTWARE"
  #restore_from_file = <<Optional value>>
  #restore_from_object_store = <<Optional value>>
  #restore_trigger = <<Optional value>>
  #time_of_deletion = <<Optional value>>

  
}

resource oci_kms_key_version psql_key_version {
  #external_key_version_id = <<Optional value>>
  key_id              = oci_kms_key.psql_key.id
  #management_endpoint = "https://ejsv6rxhaagwg-management.kms.us-ashburn-1.oraclecloud.com"
  management_endpoint  =  data.oci_kms_vault.data_psql_oci_kms_vault_1.management_endpoint 

  #time_of_deletion = <<Optional value>>
  
}

