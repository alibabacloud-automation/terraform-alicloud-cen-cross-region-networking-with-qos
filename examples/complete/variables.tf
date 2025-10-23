variable "local_vpc_config" {
  description = "The parameters of local vpc resources. The attributes 'vpc', 'vswitches' are required."
  type = list(object({
    vpc = object({
      cidr_block = string
      vpc_name   = optional(string, null)
    })
    vswitches = list(object({
      zone_id      = string
      cidr_block   = string
      vswitch_name = optional(string, null)
    }))
    tr_vpc_attachment = optional(object({
      transit_router_attachment_name  = optional(string, null)
      auto_publish_route_enabled      = optional(bool, true)
      route_table_propagation_enabled = optional(bool, true)
      route_table_association_enabled = optional(bool, true)
    }), {})
  }))
  default = [{
    vpc = {
      vpc_name   = "shanghai_vpc"
      cidr_block = "172.16.0.0/16"
    }
    vswitches = [{
      vswitch_name = "core System"
      zone_id      = "cn-shanghai-b"
      cidr_block   = "172.16.10.0/24"
      }, {
      vswitch_name = "Others"
      zone_id      = "cn-shanghai-e"
      cidr_block   = "172.16.20.0/24"
      }, {
      vswitch_name = "BigData"
      zone_id      = "cn-shanghai-f"
      cidr_block   = "172.16.30.0/24"
    }]
  }]
}

variable "remote_vpc_config" {
  description = "The parameters of remote vpc resources. The attributes 'vpc', 'vswitches' are required."
  type = list(object({
    vpc = object({
      cidr_block = string
      vpc_name   = optional(string, null)
    })
    vswitches = list(object({
      zone_id      = string
      cidr_block   = string
      vswitch_name = optional(string, null)
    }))
    tr_vpc_attachment = optional(object({
      transit_router_attachment_name  = optional(string, null)
      auto_publish_route_enabled      = optional(bool, true)
      route_table_propagation_enabled = optional(bool, true)
      route_table_association_enabled = optional(bool, true)
    }), {})
  }))
  default = [{
    vpc = {
      vpc_name   = "shenzhen_vpc"
      cidr_block = "192.168.0.0/16"
    }
    vswitches = [{
      vswitch_name = "vsw_j"
      zone_id      = "cn-shenzhen-e"
      cidr_block   = "192.168.1.0/24"
      }, {
      vswitch_name = "vsw_k"
      zone_id      = "cn-shenzhen-f"
      cidr_block   = "192.168.2.0/24"
    }]
  }]

}



# QOS
variable "cen_traffic_marking_policys" {
  description = "The parameters of cen traffic marking policies."
  type = list(object({
    marking_dscp                = number
    priority                    = number
    traffic_marking_policy_name = optional(string, null)
  }))
  default = [{
    marking_dscp = 10
    priority     = 10
    }, {
    marking_dscp = 20
    priority     = 20
  }]

}


variable "traffic_qos_policy_and_queues" {
  description = "The parameters of cen inter region traffic qos policy and queues."
  type = object({
    policy_name        = optional(string, null)
    policy_description = optional(string, null)
    queues = optional(list(object({
      remain_bandwidth_percent = number
      dscps                    = list(string)
      queue_name               = optional(string, null)
      queue_description        = optional(string, null)
    })), [])
  })
  default = {
    policy_name = "tf_example"
    queues = [{
      remain_bandwidth_percent = 40
      dscps                    = [10]
      queue_name               = "core"
      }, {
      remain_bandwidth_percent = 40
      dscps                    = [20]
      queue_name               = "bigdata"
    }]
  }
}
