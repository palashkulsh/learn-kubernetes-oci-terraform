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
  default = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaynmm2ujtdafpwtruxxqo4zz6so3fy7jjfyunwlidmgngeha3kclq"
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
      source_id = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaynmm2ujtdafpwtruxxqo4zz6so3fy7jjfyunwlidmgngeha3kclq"
      shape = "VM.Standard.E2.1.Micro"
      shape_config = []
    }
  }
}

variable "instance_map" {
  description = "all things about what type of instance you want to launch"
  default = [
    {
      type = "arm"
      shape_config = [
        {
          ocpus = "1"
          memory_in_gbs = "6"
        }
      ]
    },
    {
      type = "amd"
      shape_config = [
      ]
    }        
  ]
}
