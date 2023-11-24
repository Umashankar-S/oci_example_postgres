/*data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
  count = var.create_service_gateway == true ? 1 : 0
}
*/

resource "random_string" "psql_admin_password" {
  length    = 12
  upper     = true
  lower     = true
  numeric   = true
  special   = true
  min_lower = 2
  min_upper = 2
  min_numeric = 2
  }

