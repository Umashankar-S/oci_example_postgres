resource "oci_kms_vault" "psql_oci_kms_vault_1" {
	compartment_id = var.compartment_ocid
	defined_tags = {}
	display_name = "psql_oci_kms_vault"
	freeform_tags = {}
	vault_type = "DEFAULT"
    
}


resource oci_vault_secret psql_secret {
  compartment_id = var.compartment_ocid
  
  
  secret_content {
    #Required
    content_type = "BASE64"

    #Optional
    content = base64encode(random_string.psql_admin_password.result)
    name    = "psql_secret"
    stage   = "CURRENT"
  }
  secret_name    = "psql_secret"

  freeform_tags = {
  }
  key_id = oci_kms_key.psql_key.id
  metadata = {
  }
  vault_id  = oci_kms_vault.psql_oci_kms_vault_1.id

  lifecycle {
    ignore_changes = [secret_content]
  }
  
}


data "oci_kms_vault" "data_psql_oci_kms_vault_1" {
	#Required
	vault_id = oci_kms_vault.psql_oci_kms_vault_1.id
    
}


