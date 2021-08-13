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



resource "oci_core_instance" "ubuntu_instance" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = var.compartment_id
  shape = "VM.Standard.E2.1.Micro"
  # shape_config {
  #   baseline_ocpu_utilization = "BASELINE_1_8"
  #   memory_in_gbs = "6"
  #   ocpus = "1"
  # }
  source_details {
    source_id = var.image_id
    source_type = "image"
  }

  # Optional
  display_name = "launched_from_terraform"
  create_vnic_details {
    assign_public_ip = true
    subnet_id = oci_core_subnet.dev.id
  }
  metadata = {
    ssh_authorized_keys = file("/home/palashkulshreshtha/.ssh/id_rsa.pub")
  } 
  preserve_boot_volume = false
}