
# Complete

Configuration in this directory create xxx

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete"></a> [complete](#module\_complete) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cen_traffic_marking_policys"></a> [cen\_traffic\_marking\_policys](#input\_cen\_traffic\_marking\_policys) | The parameters of cen traffic marking policies. | <pre>list(object({<br>    marking_dscp                = number<br>    priority                    = number<br>    traffic_marking_policy_name = optional(string, null)<br>  }))</pre> | <pre>[<br>  {<br>    "marking_dscp": 10,<br>    "priority": 10<br>  },<br>  {<br>    "marking_dscp": 20,<br>    "priority": 20<br>  }<br>]</pre> | no |
| <a name="input_local_vpc_config"></a> [local\_vpc\_config](#input\_local\_vpc\_config) | The parameters of local vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc = object({<br>      cidr_block = string<br>      vpc_name   = optional(string, null)<br>    })<br>    vswitches = list(object({<br>      zone_id      = string<br>      cidr_block   = string<br>      vswitch_name = optional(string, null)<br>    }))<br>    tr_vpc_attachment = optional(object({<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    }), {})<br>  }))</pre> | <pre>[<br>  {<br>    "vpc": {<br>      "cidr_block": "172.16.0.0/16",<br>      "vpc_name": "beijing_vpc"<br>    },<br>    "vswitches": [<br>      {<br>        "cidr_block": "172.16.10.0/24",<br>        "vswitch_name": "core System",<br>        "zone_id": "cn-beijing-j"<br>      },<br>      {<br>        "cidr_block": "172.16.20.0/24",<br>        "vswitch_name": "Others",<br>        "zone_id": "cn-beijing-k"<br>      },<br>      {<br>        "cidr_block": "172.16.30.0/24",<br>        "vswitch_name": "BigData",<br>        "zone_id": "cn-beijing-l"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_remote_vpc_config"></a> [remote\_vpc\_config](#input\_remote\_vpc\_config) | The parameters of remote vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc = object({<br>      cidr_block = string<br>      vpc_name   = optional(string, null)<br>    })<br>    vswitches = list(object({<br>      zone_id      = string<br>      cidr_block   = string<br>      vswitch_name = optional(string, null)<br>    }))<br>    tr_vpc_attachment = optional(object({<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    }), {})<br>  }))</pre> | <pre>[<br>  {<br>    "vpc": {<br>      "cidr_block": "192.168.0.0/16",<br>      "vpc_name": "hangzhou_vpc"<br>    },<br>    "vswitches": [<br>      {<br>        "cidr_block": "192.168.1.0/24",<br>        "vswitch_name": "vsw_j",<br>        "zone_id": "cn-hangzhou-j"<br>      },<br>      {<br>        "cidr_block": "192.168.2.0/24",<br>        "vswitch_name": "vsw_k",<br>        "zone_id": "cn-hangzhou-k"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_traffic_qos_policy_and_queues"></a> [traffic\_qos\_policy\_and\_queues](#input\_traffic\_qos\_policy\_and\_queues) | The parameters of cen inter region traffic qos policy and queues. | <pre>object({<br>    policy_name        = optional(string, null)<br>    policy_description = optional(string, null)<br>    queues = optional(list(object({<br>      remain_bandwidth_percent = number<br>      dscps                    = list(string)<br>      queue_name               = optional(string, null)<br>      queue_description        = optional(string, null)<br>    })), [])<br>  })</pre> | <pre>{<br>  "policy_name": "tf_example",<br>  "queues": [<br>    {<br>      "dscps": [<br>        10<br>      ],<br>      "queue_name": "core",<br>      "remain_bandwidth_percent": 40<br>    },<br>    {<br>      "dscps": [<br>        20<br>      ],<br>      "queue_name": "bigdata",<br>      "remain_bandwidth_percent": 40<br>    }<br>  ]<br>}</pre> | no |

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