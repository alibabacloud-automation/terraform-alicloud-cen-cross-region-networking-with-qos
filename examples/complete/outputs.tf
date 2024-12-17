output "cen_instance_id" {
  description = "The id of CEN instance."
  value       = module.complete.cen_instance_id
}

# local
output "local_cen_transit_router_id" {
  description = "The id of local CEN transit router."
  value       = module.complete.local_cen_transit_router_id
}

output "local_vpc_id" {
  value       = module.complete.local_vpc_id
  description = "The local vpc id."
}

output "local_vpc_route_table_id" {
  value       = module.complete.local_vpc_route_table_id
  description = "The route table id of local vpc."
}

output "local_vswitch_ids" {
  value       = module.complete.local_vswitch_ids
  description = "The local ids of vswitches."
}

output "local_tr_vpc_attachment_id" {
  value       = module.complete.local_tr_vpc_attachment_id
  description = "The id of attachment between TR and local VPC."
}


# remote 
output "remote_cen_transit_router_id" {
  description = "The id of remote CEN transit router."
  value       = module.complete.remote_cen_transit_router_id
}


output "remote_vpc_id" {
  value       = module.complete.remote_vpc_id
  description = "The remote vpc id."
}

output "remote_vpc_route_table_id" {
  value       = module.complete.remote_vpc_route_table_id
  description = "The route table id of remote vpc."
}

output "remote_vswitch_ids" {
  value       = module.complete.remote_vswitch_ids
  description = "The remote ids of vswitches."
}

output "remote_tr_vpc_attachment_id" {
  value       = module.complete.remote_tr_vpc_attachment_id
  description = "The id of attachment between TR and remote VPC."
}

# DataTransfer
output "tr_peer_attachment_id" {
  description = "The id of attachment between local TR and remote TR."
  value       = module.complete.tr_peer_attachment_id
}

# QOS
output "cen_traffic_marking_policy_ids" {
  description = "The ids of cen traffic marking policy."
  value       = module.complete.cen_traffic_marking_policy_ids
}

output "cen_inter_region_traffic_qos_policy_id" {
  description = "The id of cen inter region traffic qos policy."
  value       = module.complete.cen_inter_region_traffic_qos_policy_id
}

output "cen_inter_region_traffic_qos_queue_ids" {
  description = "The ids of cen inter region traffic qos queues."
  value       = module.complete.cen_inter_region_traffic_qos_queue_ids
}

