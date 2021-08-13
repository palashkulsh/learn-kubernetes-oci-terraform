output "vcn_state" {
  description = "The state of the VCN."
  value       = oci_core_vcn.internal.state
}

output "vcn_cidr" {
  description = "CIDR block of the core VCN"
  value       = oci_core_vcn.internal.cidr_block
}

output "public-ip-for-compute-instance" {
  value = oci_core_instance.ubuntu_instance.public_ip
}
