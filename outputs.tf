output "cen_instance_id" {
  description = "The id of CEN instance."
  value       = alicloud_cen_instance.this.id
}

# local
output "local_cen_transit_router_id" {
  description = "The id of local CEN transit router."
  value       = alicloud_cen_transit_router.tr_local.transit_router_id
}

output "local_vpc_id" {
  value       = module.local_vpc[*].vpc_id
  description = "The local vpc id."
}

output "local_vpc_route_table_id" {
  value       = module.local_vpc[*].vpc_route_table_id
  description = "The route table id of local vpc."
}

output "local_vswitch_ids" {
  value       = module.local_vpc[*].vswitch_ids
  description = "The local ids of vswitches."
}

output "local_tr_vpc_attachment_id" {
  value       = module.local_vpc[*].tr_vpc_attachment_id
  description = "The id of attachment between TR and local VPC."
}


# remote 
output "remote_cen_transit_router_id" {
  description = "The id of remote CEN transit router."
  value       = alicloud_cen_transit_router.tr_remote.transit_router_id
}


output "remote_vpc_id" {
  value       = module.remote_vpc[*].vpc_id
  description = "The remote vpc id."
}

output "remote_vpc_route_table_id" {
  value       = module.remote_vpc[*].vpc_route_table_id
  description = "The route table id of remote vpc."
}

output "remote_vswitch_ids" {
  value       = module.remote_vpc[*].vswitch_ids
  description = "The remote ids of vswitches."
}

output "remote_tr_vpc_attachment_id" {
  value       = module.remote_vpc[*].tr_vpc_attachment_id
  description = "The id of attachment between TR and remote VPC."
}

# DataTransfer
output "tr_peer_attachment_id" {
  description = "The id of attachment between local TR and remote TR."
  value       = alicloud_cen_transit_router_peer_attachment.this.transit_router_attachment_id
}

# QOS
output "cen_traffic_marking_policy_ids" {
  description = "The ids of cen traffic marking policy."
  value       = alicloud_cen_traffic_marking_policy.this[*].traffic_marking_policy_id
}

output "cen_inter_region_traffic_qos_policy_id" {
  description = "The id of cen inter region traffic qos policy."
  value       = alicloud_cen_inter_region_traffic_qos_policy.this.id
}

output "cen_inter_region_traffic_qos_queue_ids" {
  description = "The ids of cen inter region traffic qos queues."
  value       = alicloud_cen_inter_region_traffic_qos_queue.this[*].id
}

