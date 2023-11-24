output  "psql_admin_pwd" { 
  #value = oci_psql_db_system.psql_inst_1.credentials
  value = random_string.psql_admin_password.result
  sensitive   = true
 }