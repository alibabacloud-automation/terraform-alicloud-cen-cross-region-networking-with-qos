Terraform module to build refined traffic scheduling for cloud-based VPC cross-region connections for Alibaba Cloud

terraform-alicloud-cen-cross-region-networking-with-qos
======================================

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-cen-cross-region-networking-with-qos/blob/main/README-CN.md)

This module focuses on scenarios involving refined traffic scheduling for cloud-based VPC cross-region connections. The total bandwidth for cross-region connections is fixed, and during the transmission of cross-region traffic, various business types often compete for bandwidth, leading to low network utilization and reduced quality of business communications. Different types of business traffic have varying network requirements, for example:
- Core System Services (e.g., Video Conferencing and Voice Calls): These services prioritize real-time network transmission. High packet loss rates and frequent jitter can degrade communication quality.
- Office SaaS and Other Services: These services emphasize timely responsiveness. Network congestion can diminish the user experience.
- Offline Big Data Traffic: This traffic type prioritizes high network throughput and requires sufficient bandwidth, with less concern for network latency and jitter.

The traffic scheduling feature supports adding tags to different types of cross-region traffic and can impose bandwidth limits on each type based on these tags. This effectively ensures that each category of business has the necessary cross-region bandwidth, thereby improving the overall efficiency of the network. The overall solution is as follows:
- Cloud Cross-Region: Utilize the Transit Router (TR) to establish a cross-region connection between Alibaba Cloud’s Beijing and Hangzhou regions. Concurrently, enable CDT (Cross-Region Traffic Billing) with bandwidth billed based on traffic, thereby linking the Beijing VPC with the Hangzhou VPC.
- Cloud Cross-Domain Traffic Scheduling: Through the TR's cross-region traffic scheduling functionality, add tags to different types of cross-region traffic. Based on these tag values, apply bandwidth limits to each traffic type accordingly. This ensures that each category of business maintains its required cross-region bandwidth, enhancing the overall operational efficiency of the network.

Architecture Diagram:

<img src="https://raw.githubusercontent.com/terraform-alicloud-cen-cross-region-networking-with-qos/main/scripts/diagram.png" alt="Architecture Diagram" width="600" height="300">


## Usage

create VPCs in cn-beijing and cn-hangzhou.

```hcl
provider "alicloud" {
  alias  = "local_region"
  region = "cn-beijing"
}

provider "alicloud" {
  alias  = "remote_region"
  region = "cn-hangzhou"
}


module "complete" {
  source = alibabacloud-automation/cen-cross-region-networking-with-qos/alicloud
  providers = {
    alicloud.local_region  = alicloud.local_region
    alicloud.remote_region = alicloud.remote_region
  }

  local_vpc_config = [{
    vpc = {
      vpc_name   = "beijing_vpc"
      cidr_block = "172.16.0.0/16"
    }
    vswitches = [{
      vswitch_name = "core System"
      zone_id      = "cn-beijing-j"
      cidr_block   = "172.16.10.0/24"
      }, {
      vswitch_name = "Others"
      zone_id      = "cn-beijing-k"
      cidr_block   = "172.16.20.0/24"
      }, {
      vswitch_name = "BigData"
      zone_id      = "cn-beijing-l"
      cidr_block   = "172.16.30.0/24"
    }]
  }]

  remote_vpc_config = [{
    vpc = {
      vpc_name   = "hangzhou_vpc"
      cidr_block = "192.168.0.0/16"
    }
    vswitches = [{
      vswitch_name = "vsw_j"
      zone_id      = "cn-hangzhou-j"
      cidr_block   = "192.168.1.0/24"
      }, {
      vswitch_name = "vsw_k"
      zone_id      = "cn-hangzhou-k"
      cidr_block   = "192.168.2.0/24"
    }]
  }]

  cen_traffic_marking_policys = [{
    marking_dscp = 10
    priority     = 10
    }, {
    marking_dscp = 20
    priority     = 20
  }]

  traffic_qos_policy_and_queues = {
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
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-cen-cross-region-networking-with-qos/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |
| <a name="provider_alicloud.local_region"></a> [alicloud.local\_region](#provider\_alicloud.local\_region) | n/a |
| <a name="provider_alicloud.remote_region"></a> [alicloud.remote\_region](#provider\_alicloud.remote\_region) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_local_vpc"></a> [local\_vpc](#module\_local\_vpc) | ./modules/vpc | n/a |
| <a name="module_remote_vpc"></a> [remote\_vpc](#module\_remote\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_cen_instance.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_instance) | resource |
| [alicloud_cen_inter_region_traffic_qos_policy.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_inter_region_traffic_qos_policy) | resource |
| [alicloud_cen_inter_region_traffic_qos_queue.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_inter_region_traffic_qos_queue) | resource |
| [alicloud_cen_traffic_marking_policy.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_traffic_marking_policy) | resource |
| [alicloud_cen_transit_router.tr_local](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router) | resource |
| [alicloud_cen_transit_router.tr_remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router) | resource |
| [alicloud_cen_transit_router_peer_attachment.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_peer_attachment) | resource |
| [alicloud_cen_transit_router_route_table_association.tr_local](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_association.tr_remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_propagation.tr_local](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_route_table_propagation.tr_remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_route_tables.tr_local](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cen_transit_router_route_tables) | data source |
| [alicloud_cen_transit_router_route_tables.tr_remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cen_transit_router_route_tables) | data source |
| [alicloud_regions.remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cen_instance_config"></a> [cen\_instance\_config](#input\_cen\_instance\_config) | The parameters of cen instance. | <pre>object({<br>    cen_instance_name = optional(string, "cen-cross-region")<br>    description       = optional(string, "CEN instance for cross-region connectivity")<br>  })</pre> | `{}` | no |
| <a name="input_cen_traffic_marking_policys"></a> [cen\_traffic\_marking\_policys](#input\_cen\_traffic\_marking\_policys) | The parameters of cen traffic marking policies. | <pre>list(object({<br>    marking_dscp                = number<br>    priority                    = number<br>    traffic_marking_policy_name = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_local_tr_config"></a> [local\_tr\_config](#input\_local\_tr\_config) | The parameters of transit router. | <pre>object({<br>    transit_router_name        = optional(string, "tr-local")<br>    transit_router_description = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_local_vpc_config"></a> [local\_vpc\_config](#input\_local\_vpc\_config) | The parameters of local vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc = object({<br>      cidr_block = string<br>      vpc_name   = optional(string, null)<br>    })<br>    vswitches = list(object({<br>      zone_id      = string<br>      cidr_block   = string<br>      vswitch_name = optional(string, null)<br>    }))<br>    tr_vpc_attachment = optional(object({<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_remote_tr_config"></a> [remote\_tr\_config](#input\_remote\_tr\_config) | The parameters of transit router. | <pre>object({<br>    transit_router_name        = optional(string, "tr-remote")<br>    transit_router_description = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_remote_vpc_config"></a> [remote\_vpc\_config](#input\_remote\_vpc\_config) | The parameters of remote vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc = object({<br>      cidr_block = string<br>      vpc_name   = optional(string, null)<br>    })<br>    vswitches = list(object({<br>      zone_id      = string<br>      cidr_block   = string<br>      vswitch_name = optional(string, null)<br>    }))<br>    tr_vpc_attachment = optional(object({<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_tr_peer_attachment"></a> [tr\_peer\_attachment](#input\_tr\_peer\_attachment) | The parameters of transit router peer attachment. | <pre>object({<br>    transit_router_attachment_name  = optional(string, null)<br>    auto_publish_route_enabled      = optional(bool, true)<br>    route_table_propagation_enabled = optional(bool, true)<br>    route_table_association_enabled = optional(bool, true)<br>    bandwidth_type                  = optional(string, "DataTransfer")<br>    bandwidth                       = optional(number, 100)<br>  })</pre> | `{}` | no |
| <a name="input_traffic_qos_policy_and_queues"></a> [traffic\_qos\_policy\_and\_queues](#input\_traffic\_qos\_policy\_and\_queues) | The parameters of cen inter region traffic qos policy and queues. | <pre>object({<br>    policy_name        = optional(string, null)<br>    policy_description = optional(string, null)<br>    queues = optional(list(object({<br>      remain_bandwidth_percent = number<br>      dscps                    = list(string)<br>      queue_name               = optional(string, null)<br>      queue_description        = optional(string, null)<br>    })), [])<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cen_instance_id"></a> [cen\_instance\_id](#output\_cen\_instance\_id) | The id of CEN instance. |
| <a name="output_cen_inter_region_traffic_qos_policy_id"></a> [cen\_inter\_region\_traffic\_qos\_policy\_id](#output\_cen\_inter\_region\_traffic\_qos\_policy\_id) | The id of cen inter region traffic qos policy. |
| <a name="output_cen_inter_region_traffic_qos_queue_ids"></a> [cen\_inter\_region\_traffic\_qos\_queue\_ids](#output\_cen\_inter\_region\_traffic\_qos\_queue\_ids) | The ids of cen inter region traffic qos queues. |
| <a name="output_cen_traffic_marking_policy_ids"></a> [cen\_traffic\_marking\_policy\_ids](#output\_cen\_traffic\_marking\_policy\_ids) | The ids of cen traffic marking policy. |
| <a name="output_local_cen_transit_router_id"></a> [local\_cen\_transit\_router\_id](#output\_local\_cen\_transit\_router\_id) | The id of local CEN transit router. |
| <a name="output_local_tr_vpc_attachment_id"></a> [local\_tr\_vpc\_attachment\_id](#output\_local\_tr\_vpc\_attachment\_id) | The id of attachment between TR and local VPC. |
| <a name="output_local_vpc_id"></a> [local\_vpc\_id](#output\_local\_vpc\_id) | The local vpc id. |
| <a name="output_local_vpc_route_table_id"></a> [local\_vpc\_route\_table\_id](#output\_local\_vpc\_route\_table\_id) | The route table id of local vpc. |
| <a name="output_local_vswitch_ids"></a> [local\_vswitch\_ids](#output\_local\_vswitch\_ids) | The local ids of vswitches. |
| <a name="output_remote_cen_transit_router_id"></a> [remote\_cen\_transit\_router\_id](#output\_remote\_cen\_transit\_router\_id) | The id of remote CEN transit router. |
| <a name="output_remote_tr_vpc_attachment_id"></a> [remote\_tr\_vpc\_attachment\_id](#output\_remote\_tr\_vpc\_attachment\_id) | The id of attachment between TR and remote VPC. |
| <a name="output_remote_vpc_id"></a> [remote\_vpc\_id](#output\_remote\_vpc\_id) | The remote vpc id. |
| <a name="output_remote_vpc_route_table_id"></a> [remote\_vpc\_route\_table\_id](#output\_remote\_vpc\_route\_table\_id) | The route table id of remote vpc. |
| <a name="output_remote_vswitch_ids"></a> [remote\_vswitch\_ids](#output\_remote\_vswitch\_ids) | The remote ids of vswitches. |
| <a name="output_tr_peer_attachment_id"></a> [tr\_peer\_attachment\_id](#output\_tr\_peer\_attachment\_id) | The id of attachment between local TR and remote TR. |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
