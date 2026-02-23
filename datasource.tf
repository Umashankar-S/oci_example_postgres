data "oci_identity_availability_domains" "ads" {
  compartment_id = coalesce(var.tenancy_ocid, var.compartment_ocid)
}

data "oci_kms_vault" "data_psql_oci_kms_vault_1" {
	#Required
  count = var.use_vault ? 1 : 0
	vault_id = var.create_vault == true ? oci_kms_vault.psql_oci_kms_vault_1[0].id : var.vault_id
    
}

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
  count = var.create_service_gateway == true ? 1 : 0
}


resource "random_password" "psql_admin_password" {
  length    = 16
  upper     = true
  lower     = true
  numeric   = true
  special   = true
  min_lower = 2
  min_upper = 2
  min_numeric = 2
  min_special = 1
  override_special = "!@#$%^&*()-_=+[]{}<>?"
  }