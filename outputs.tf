output  "psql_admin_pwd" { 
  #value = random_password.psql_admin_password.result
  value = local.psql_admin_password
  sensitive   = true
 }