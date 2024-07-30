
### Virtual Cloud Network (VCN )
#################################

resource oci_core_vcn vcn1 {
   cidr_blocks = [
    var.vcn_cidr[0],
  ]
  compartment_id = var.compartment_ocid
 
  display_name = "vcn1"
  dns_label    = "vcn1"
  freeform_tags = {
  }
  ipv6private_cidr_blocks = [
  ]
  
  count = var.create_vcn_subnet == true ? 1 : 0
}

###  PSQL Private Subnet
#######################

resource oci_core_subnet vcn1-psql-priv-subnet {
  
  cidr_block     =  cidrsubnet(var.vcn_cidr[0],8,0)
  compartment_id = var.compartment_ocid
  dhcp_options_id = oci_core_vcn.vcn1[0].default_dhcp_options_id
  display_name    = "psql-priv-subnet"
  dns_label       = "psqlprivsubnet"
  freeform_tags = {
  }
  
  ipv6cidr_blocks = [
  ]
  prohibit_internet_ingress  = "true"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = oci_core_route_table.VCN1-RT[0].id
  security_list_ids = [
    #oci_core_security_list.Default-Security-List-VCN1.id,
    oci_core_default_security_list.Default-Security-List-VCN1[0].id,
  ]
  vcn_id = oci_core_vcn.vcn1[0].id
  count = var.create_vcn_subnet == true ? 1 : 0
}



# Service Gateway (SGW)
#######################
data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
  count = var.create_service_gateway == true ? 1 : 0
}

resource "oci_core_service_gateway" "vcn1_sgway" {
  compartment_id = var.compartment_ocid
  display_name   = "SRVC_GTWY"

  services {
    service_id = lookup(data.oci_core_services.all_oci_services[0].services[0], "id")
  }

  vcn_id = oci_core_vcn.vcn1[0].id

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }

  count = var.create_service_gateway == true ? 1 : 0
}




resource "oci_core_network_security_group" vcn1-nsg {
  compartment_id = var.compartment_ocid

  display_name = "PSQLNSG"
  freeform_tags = {
  }
  vcn_id = oci_core_vcn.vcn1[0].id
  count = var.create_vcn_subnet == true ? 1 : 0

}


resource "oci_core_network_security_group_security_rule" "vcn1-nsg_rule_0" {
    network_security_group_id = oci_core_network_security_group.vcn1-nsg[0].id
    direction = "INGRESS"
    protocol = "6" #TCP


    description = "Ingress on PSQL DB Connection from Within / Other VCNs."
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless = false
     tcp_options {
      destination_port_range {
        min = 5432
        max = 5432
      }
  }

}
resource "oci_core_network_security_group_security_rule" "vcn1-nsg_rule_1" {
    network_security_group_id = oci_core_network_security_group.vcn1-nsg[0].id
    direction = "EGRESS"
    protocol = "6" #TCP

    description = "Postgres Services to OSN for Backup ."
    destination_type  = "SERVICE_CIDR_BLOCK"
    destination       = lookup(data.oci_core_services.all_oci_services[0].services[0], "cidr_block")
    stateless = false

}

resource "oci_core_nat_gateway" vcn1-NGTWY {
  block_traffic  = "false"
  compartment_id = var.compartment_ocid

  display_name = "NGTWY"
  freeform_tags = {
  }
  vcn_id = oci_core_vcn.vcn1[0].id
  
  count = var.create_vcn_subnet == true ? 1 : 0
}


resource "oci_core_route_table" "VCN1-RT" {
  count = var.create_vcn_subnet == true ? 1 : 0
  compartment_id = var.compartment_ocid

  display_name = "VCN1-RT"
  freeform_tags = {
  }

  dynamic "route_rules" {
    # * If Service Gateway is created with the module, automatically creates a rule to handle traffic for "all services" through Service Gateway
    for_each = var.create_service_gateway == true ? [1] : []

    content {
      destination       = lookup(data.oci_core_services.all_oci_services[0].services[0], "cidr_block")
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.vcn1_sgway[0].id
      description       = "Terraformed - Auto-generated at Service Gateway creation: All Services in region to Service Gateway"
    }
  }

  
  vcn_id = oci_core_vcn.vcn1[0].id
  
}


resource "oci_core_default_security_list" "Default-Security-List-VCN1" {
  compartment_id = var.compartment_ocid
  count = var.create_vcn_subnet == true ? 1 : 0

  display_name = "Default Security List for VCN1"
  egress_security_rules {
    #description = <<Optional value >>
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    #icmp_options = <<Optional value >>
    protocol  = "all"
    stateless = "false"
    #tcp_options = <<Optional value >>
    #udp_options = <<Optional value >>
  }
  freeform_tags = {
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
      #source_port_range = <<Optional value >>
    }
    #udp_options = <<Optional value >>
  }
  ingress_security_rules {
    
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value >>
    #udp_options = <<Optional value >>
  }
  ingress_security_rules {
    #description = <<Optional value >>
    icmp_options {
      code = "-1"
      type = "3"
    }
    protocol    = "1"
    source      = cidrsubnet(var.vcn_cidr[0],8,0)
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value >>
    #udp_options = <<Optional value >>
  }
    manage_default_resource_id = oci_core_vcn.vcn1[0].default_security_list_id
   
}
