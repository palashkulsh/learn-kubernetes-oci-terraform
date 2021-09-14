output "vcn_state" {
  description = "The state of the VCN."
  value       = oci_core_vcn.internal.state
}

output "vcn_cidr" {
  description = "CIDR block of the core VCN"
  value       = oci_core_vcn.internal.cidr_block
}

# output "public-ip-for-master" {
#   value = module.instance["master"].oci_core_instance.module_tf_instance.public_id
# }

# output "public-ip-for-node1" {
#   value = module.instance["node1"].oci_core_instance.module_tf_instance.public_id
# }

# output "public-ip-for-node2" {
#   value = module.instance["node2"].oci_core_instance.module_tf_instance.public_id
# }

# output "public-ip-for-node3" {
#   value = module.instance["node3"].oci_core_instance.module_tf_instance.public_id
# }
