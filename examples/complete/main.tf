provider "alicloud" {
  alias  = "local_region"
  region = "cn-shanghai"
}

provider "alicloud" {
  alias  = "remote_region"
  region = "cn-shenzhen"
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

}
