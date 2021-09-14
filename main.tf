######
# very good resource
# https://blog.gleb.ca/2021/08/03/terraform-modules-simplified/
#####

# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance#baseline_ocpu_utilization

# to get image ocid
# https://docs.oracle.com/en-us/iaas/images/image/4589c29c-1c8a-4207-9ff6-bc04854cc5c6/

# route table related
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_route_table

# tutorial
# https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-compute/01-summary.htm
terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
  }
}

provider "oci" {
  region              = var.region
  auth                = "SecurityToken"
  config_file_profile = "learn-terraform"
}

resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "172.16.0.0/20"
  compartment_id = var.compartment_id
  display_name   = "My internal VCN"  
}

resource oci_core_internet_gateway "my_ig_gateway" {
  compartment_id= var.compartment_id
  vcn_id = oci_core_vcn.internal.id
  enabled= true
}

# https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-vcn/01-summary.htm
resource oci_core_default_security_list "my_tf_created_sec_list" {
  compartment_id = var.compartment_id
  display_name = "terraform created security list"
  
  # https://blog.gleb.ca/2021/08/03/terraform-modules-simplified/
  # very good resource
  manage_default_resource_id = oci_core_vcn.internal.default_security_list_id
  
  ingress_security_rules {
    description = "allow tcp port 80"
    source = "0.0.0.0/0"
    protocol = "6"
    tcp_options  {
      min = 80
      max = 80
    }    
  }

  ingress_security_rules {
    description = "allow tcp port 22 for ssh"
    source = "0.0.0.0/0"
    protocol = "6"
    tcp_options  {
      min = 22
      max = 22
    }    
  }

  ingress_security_rules {
    description = "allow tcp port 22 for ssh"
    source = oci_core_vcn.internal.cidr_block
    protocol = "all"
  }

  ingress_security_rules {
    description = "allow private subnets"
    source = "10.0.0.0/8"
    protocol = "all"
  }
  
  egress_security_rules {
    description = "allow all outbound traffi"
    destination = "0.0.0.0/0"
    protocol = "all"
  }
}

resource "oci_core_route_table" "my_route_table" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.internal.id

    #Optional
    # defined_tags = {"Operations.CostCenter"= "42"}
    display_name = "terraform created route table"
    # freeform_tags = {"Department"= "Finance"}
    route_rules {
        #Required
        network_entity_id = oci_core_internet_gateway.my_ig_gateway.id

        #Optional
        destination = "0.0.0.0/0"
        description = "allow traffic from internet"
        # destination = var.route_table_route_rules_destination
        # destination_type = var.route_table_route_rules_destination_type
    }
}


resource "oci_core_subnet" "dev" {
  vcn_id                     = oci_core_vcn.internal.id
  cidr_block                 = "172.16.0.0/24"
  compartment_id             = var.compartment_id
  display_name               = "Dev subnet zzz"
  prohibit_public_ip_on_vnic = false
  dns_label                  = "dev"
}

resource "oci_core_route_table_attachment" "test_route_table_attachment" {
  #Required    
  subnet_id = oci_core_subnet.dev.id
  route_table_id =oci_core_route_table.my_route_table.id
}

module "instance" {
  source = "./modules/instance"
  for_each = var.instance_list
  
  subnet_id = oci_core_subnet.dev.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = var.compartment_id
  
  type = each.value.type
  #generic map
  config_map = var.instance_config_map
  shape_config = each.value.shape_config
}


