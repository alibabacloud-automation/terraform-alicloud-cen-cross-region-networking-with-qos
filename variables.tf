
variable "cen_instance_config" {
  description = "The parameters of cen instance."
  type = object({
    cen_instance_name = optional(string, "cen-cross-region")
    description       = optional(string, "CEN instance for cross-region connectivity")
  })
  default = {}
}

# local
variable "local_tr_config" {
  description = "The parameters of transit router."
  type = object({
    transit_router_name        = optional(string, "tr-local")
    transit_router_description = optional(string, null)
  })
  default = {}
}


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
  default = []
}

# remote
variable "remote_tr_config" {
  description = "The parameters of transit router."
  type = object({
    transit_router_name        = optional(string, "tr-remote")
    transit_router_description = optional(string, null)
  })
  default = {}
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
  default = []
}

# DataTransfer
variable "tr_peer_attachment" {
  description = "The parameters of transit router peer attachment."
  type = object({
    transit_router_attachment_name  = optional(string, null)
    auto_publish_route_enabled      = optional(bool, true)
    route_table_propagation_enabled = optional(bool, true)
    route_table_association_enabled = optional(bool, true)
    bandwidth_type                  = optional(string, "DataTransfer")
    bandwidth                       = optional(number, 100)
  })
  default = {}
}


# QOS
variable "cen_traffic_marking_policys" {
  description = "The parameters of cen traffic marking policies."
  type = list(object({
    marking_dscp                = number
    priority                    = number
    traffic_marking_policy_name = optional(string, null)
  }))
  default = []
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
  default = {}
}
