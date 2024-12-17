locals {
  tr_local_route_table_id  = data.alicloud_cen_transit_router_route_tables.tr_local.tables[0].transit_router_route_table_id
  tr_remote_route_table_id = data.alicloud_cen_transit_router_route_tables.tr_remote.tables[0].transit_router_route_table_id
}

resource "alicloud_cen_instance" "this" {
  cen_instance_name = var.cen_instance_config.cen_instance_name
  description       = var.cen_instance_config.description
}

# localRegion
resource "alicloud_cen_transit_router" "tr_local" {
  provider = alicloud.local_region

  cen_id                     = alicloud_cen_instance.this.id
  transit_router_name        = var.local_tr_config.transit_router_name
  transit_router_description = var.local_tr_config.transit_router_description
}

data "alicloud_cen_transit_router_route_tables" "tr_local" {
  provider = alicloud.local_region

  transit_router_id               = alicloud_cen_transit_router.tr_local.transit_router_id
  transit_router_route_table_type = "System"
}

module "local_vpc" {
  providers = {
    alicloud = alicloud.local_region
  }

  source = "./modules/vpc"
  count  = length(var.local_vpc_config)

  cen_instance_id                   = alicloud_cen_instance.this.id
  cen_transit_router_id             = alicloud_cen_transit_router.tr_local.transit_router_id
  cen_transit_router_route_table_id = local.tr_local_route_table_id

  vpc               = var.local_vpc_config[count.index].vpc
  vswitches         = var.local_vpc_config[count.index].vswitches
  tr_vpc_attachment = var.local_vpc_config[count.index].tr_vpc_attachment
}

# remoteRegion
resource "alicloud_cen_transit_router" "tr_remote" {
  provider = alicloud.remote_region

  cen_id                     = alicloud_cen_instance.this.id
  transit_router_name        = var.remote_tr_config.transit_router_name
  transit_router_description = var.remote_tr_config.transit_router_description
}

data "alicloud_cen_transit_router_route_tables" "tr_remote" {
  provider = alicloud.remote_region

  transit_router_id               = alicloud_cen_transit_router.tr_remote.transit_router_id
  transit_router_route_table_type = "System"
}

module "remote_vpc" {
  providers = {
    alicloud = alicloud.remote_region
  }

  source = "./modules/vpc"
  count  = length(var.remote_vpc_config)

  cen_instance_id                   = alicloud_cen_instance.this.id
  cen_transit_router_id             = alicloud_cen_transit_router.tr_remote.transit_router_id
  cen_transit_router_route_table_id = local.tr_remote_route_table_id

  vpc               = var.remote_vpc_config[count.index].vpc
  vswitches         = var.remote_vpc_config[count.index].vswitches
  tr_vpc_attachment = var.remote_vpc_config[count.index].tr_vpc_attachment
}


# DataTransfer
data "alicloud_regions" "remote" {
  provider = alicloud.remote_region
  current  = true
}

resource "alicloud_cen_transit_router_peer_attachment" "this" {
  provider = alicloud.local_region

  cen_id                         = alicloud_cen_instance.this.id
  transit_router_id              = alicloud_cen_transit_router.tr_local.transit_router_id
  peer_transit_router_region_id  = data.alicloud_regions.remote.regions[0].id
  peer_transit_router_id         = alicloud_cen_transit_router.tr_remote.transit_router_id
  auto_publish_route_enabled     = var.tr_peer_attachment.auto_publish_route_enabled
  bandwidth_type                 = var.tr_peer_attachment.bandwidth_type
  bandwidth                      = var.tr_peer_attachment.bandwidth
  transit_router_attachment_name = var.tr_peer_attachment.transit_router_attachment_name
}

resource "alicloud_cen_transit_router_route_table_propagation" "tr_local" {
  provider = alicloud.local_region
  count    = var.tr_peer_attachment.route_table_propagation_enabled ? 1 : 0

  transit_router_route_table_id = local.tr_local_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.this.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_association" "tr_local" {
  provider = alicloud.local_region
  count    = var.tr_peer_attachment.route_table_association_enabled ? 1 : 0

  transit_router_route_table_id = local.tr_local_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.this.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "tr_remote" {
  provider = alicloud.remote_region
  count    = var.tr_peer_attachment.route_table_propagation_enabled ? 1 : 0

  transit_router_route_table_id = local.tr_remote_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.this.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_association" "tr_remote" {
  provider = alicloud.remote_region
  count    = var.tr_peer_attachment.route_table_association_enabled ? 1 : 0

  transit_router_route_table_id = local.tr_remote_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.this.transit_router_attachment_id
}

# QOS
resource "alicloud_cen_traffic_marking_policy" "this" {
  provider = alicloud.local_region
  count    = length(var.cen_traffic_marking_policys)

  transit_router_id           = alicloud_cen_transit_router.tr_local.transit_router_id
  marking_dscp                = var.cen_traffic_marking_policys[count.index].marking_dscp
  priority                    = var.cen_traffic_marking_policys[count.index].priority
  traffic_marking_policy_name = var.cen_traffic_marking_policys[count.index].traffic_marking_policy_name
}

resource "alicloud_cen_inter_region_traffic_qos_policy" "this" {
  provider = alicloud.local_region

  transit_router_id                           = alicloud_cen_transit_router.tr_remote.transit_router_id
  transit_router_attachment_id                = alicloud_cen_transit_router_peer_attachment.this.transit_router_attachment_id
  inter_region_traffic_qos_policy_name        = var.traffic_qos_policy_and_queues.policy_name
  inter_region_traffic_qos_policy_description = var.traffic_qos_policy_and_queues.policy_description
}

resource "alicloud_cen_inter_region_traffic_qos_queue" "this" {
  provider = alicloud.local_region
  count    = length(var.traffic_qos_policy_and_queues.queues)

  traffic_qos_policy_id                      = alicloud_cen_inter_region_traffic_qos_policy.this.id
  remain_bandwidth_percent                   = var.traffic_qos_policy_and_queues.queues[count.index].remain_bandwidth_percent
  dscps                                      = var.traffic_qos_policy_and_queues.queues[count.index].dscps
  inter_region_traffic_qos_queue_name        = var.traffic_qos_policy_and_queues.queues[count.index].queue_name
  inter_region_traffic_qos_queue_description = var.traffic_qos_policy_and_queues.queues[count.index].queue_description
}
