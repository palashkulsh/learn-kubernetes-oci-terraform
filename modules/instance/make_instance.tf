variable availability_domain {}
variable subnet_id {}
variable compartment_id {}
variable config_map {}
variable type {}
variable shape_config {}

resource "oci_core_instance" "module_tf_instance" {
  # Required
  availability_domain = var.availability_domain
  compartment_id = var.compartment_id
  # shape = "VM.Standard.E2.1.Micro"
  # source_details {
  #   source_id = var.e2_image_id
  #   source_type = "image"
  # }

  shape = lookup(var.config_map, var.type)["shape"]
  source_details {
    source_id = lookup(var.config_map, var.type, "arm")["source_id"]
    source_type = "image"
  }

  dynamic shape_config {
    for_each = try(var.shape_config , lookup(var.shape_config, var.type)["shape_config"]) 
    content {
      ocpus = shape_config.value["ocpus"]
      memory_in_gbs = shape_config.value["memory_in_gbs"]
    }
  }
  
  # Optional
  display_name = "launched_from_terraform"
  create_vnic_details {
    assign_public_ip = true
    subnet_id = var.subnet_id
  }
  metadata = {
    ssh_authorized_keys = file("/home/palashkulshreshtha/.ssh/id_rsa.pub")
  } 
  preserve_boot_volume = false

  # provisioner "local-exec" {
  #   command = "sleep 200;ansible-playbook -i oci_core_instance.ubuntu_instance.public_ip playbook.yml"
  # }

}



