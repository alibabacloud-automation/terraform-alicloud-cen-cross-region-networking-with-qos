Terraform module to build refined traffic scheduling for cloud-based VPC cross-region connections for Alibaba Cloud

terraform-alicloud-cen-cross-region-networking-with-qos
======================================

[English](https://github.com/alibabacloud-automation/terraform-alicloud-cen-cross-region-networking-with-qos/blob/main/README.md) | 简体中文

本模块重点介绍云上VPC跨地域连接精细化流量调度功能场景，跨地域的总带宽是固定的，在跨地域连接传输流量的过程中，各种业务流量通常会相互挤占带宽，造成网络利用率不高、业务通信质量下降等问题。不同业务的流量对网络的要求不同，例如：
- 视频会议和语音通话类等核心系统业务注重网络传输的实时性，高丢包率和频繁抖动会降低通信质量。
- 办公SaaS类其他业务注重响应的及时性，网络堵塞会降低用户的使用体验。
- 离线大数据流量注重网络大吞吐量，需要网络提供足够的大带宽，对网络时延、网络抖动等网络性能指标要求不高。

流量调度功能支持为不同类型的跨地域流量添加标记，并且能够依据标记值对不同类型的跨地域流量分别进行带宽限制，有效保证各类业务的跨地域带宽，提高网络整体的运行效率。整体方案如下：
- 云上跨地域：通过TR构建阿里云北京-杭州跨地域连接，同时开通CDT跨域带宽按流量计费，打通北京VPC与杭州VPC。
- 云上跨域流量调度：通过TR跨域流量调度功能，对不同类型的跨地域流量添加标记，依据标记值对不同类型的跨地域流量分别进行带宽限制，有效保证各类业务的跨地域带宽，提高网络整体的运行效率。

架构图:

<img src="https://raw.githubusercontent.com/terraform-alicloud-cen-cross-region-networking-with-qos/main/scripts/diagram-CN.png" alt="Architecture Diagram" width="600" height="300">

## 用法

在北京和杭州区域分别创建 VPC

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

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-cen-cross-region-networking-with-qos/tree/main/examples/complete)


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

## 提交问题

如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

## 作者

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## 许可

MIT Licensed. See LICENSE for full details.

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
