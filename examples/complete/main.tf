provider "alicloud" {
  alias  = "local_region"
  region = "cn-shanghai"
}

provider "alicloud" {
  alias  = "remote_region"
  region = "cn-shenzhen"
}

resource "alicloud_cen_bandwidth_package" "example" {
  provider                   = alicloud.local_region
  bandwidth                  = 5
  cen_bandwidth_package_name = "tf-cen-cross-region-with-qos"
  geographic_region_a_id     = "China"
  geographic_region_b_id     = "China"
  payment_type               = "PostPaid"
}

resource "alicloud_cen_bandwidth_package_attachment" "example" {
  provider             = alicloud.local_region
  instance_id          = module.complete.cen_instance_id
  bandwidth_package_id = alicloud_cen_bandwidth_package.example.id
}

module "complete" {
  source = "../.."
  providers = {
    alicloud.local_region  = alicloud.local_region
    alicloud.remote_region = alicloud.remote_region
  }

  local_vpc_config = var.local_vpc_config

  remote_vpc_config = var.remote_vpc_config

  cen_traffic_marking_policys = var.cen_traffic_marking_policys

  traffic_qos_policy_and_queues = var.traffic_qos_policy_and_queues

  tr_peer_attachment = {
    bandwidth_type           = "BandwidthPackage"
    bandwidth                = 5
    cen_bandwidth_package_id = alicloud_cen_bandwidth_package_attachment.example.bandwidth_package_id
  }
}
