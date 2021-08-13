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

variable "image_id" {
  description = "image to use"
  type = string
  default = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaynmm2ujtdafpwtruxxqo4zz6so3fy7jjfyunwlidmgngeha3kclq"
}
