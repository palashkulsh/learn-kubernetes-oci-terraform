variable "compartment_id" {
  description = "OCID from your tenancy page"
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaa722upqzuunb47ow4mb77fi4u557mga2qmjz3by4quyhuiiw6aowa"
}

variable "region" {
  description = "region where you have OCI tenancy"
  type        = string
  default     = "ap-mumbai-1"
}

variable "e2_image_id" {
  description = "image to use for amd"
  type = string
  default = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaarah75lphjlnpdwvmumdxdryfcsdeyqbc6s6i3ircakzrwhgmfk7a"
}

variable "a1_image_id" {
  description = "image to use for amd arch"
  type = string
  default = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaynmm2ujtdafpwtruxxqo4zz6so3fy7jjfyunwlidmgngeha3kclq"
}

variable "instance_config_map" {
  description = "all config for instance type at single place"
  default = {
    "arm" = {
      source_id = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaynmm2ujtdafpwtruxxqo4zz6so3fy7jjfyunwlidmgngeha3kclq"
      shape = "VM.Standard.A1.Flex"
      shape_config = [{
        memory_in_gbs = "6"
        ocpus = "1"
      }]
    }

    "amd" = {
      source_id = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaarah75lphjlnpdwvmumdxdryfcsdeyqbc6s6i3ircakzrwhgmfk7a"
      shape = "VM.Standard.E2.1.Micro"
      shape_config = []
    }
  }
}

variable "instance_list" {
  description = "all things about what type of instance you want to launch"
  default = {
    node3 = {
      type = "arm"
      shape_config = [
        {
          ocpus = "1"
          memory_in_gbs = "6"
        }
      ]
    }
    
    node2 = {
      type = "amd"
      shape_config = [
      ]
    }

    node1 = {
      type = "arm"
      shape_config = [
        {
          ocpus = "1"
          memory_in_gbs = "6"
        }
      ]
    }

    master = {
      type = "arm"
      shape_config = [
        {
          ocpus = "2"
          memory_in_gbs = "12"
        }
      ]
    }

    # ar4 = {
    #   type = "arm"
    #   shape_config = [
    #     {
    #       ocpus = "1"
    #       memory_in_gbs = "6"
    #     }
    #   ]
    # }
    
  }
}
