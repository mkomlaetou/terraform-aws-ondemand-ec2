## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.additional_vols](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_ec2_instance_state.ec2_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_state) | resource |
| [aws_eip.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.eip_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_instance.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.private-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_volume_attachment.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_ami.os_latest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_vols"></a> [additional\_vols](#input\_additional\_vols) | add secondary volumes | <pre>map(object({<br>    # az             = string<br>    size           = number<br>    final_snapshot = optional(bool, true)<br>    type           = optional(string, "gp2")<br>    throughput     = optional(number, 100)<br>    snapshot_id    = optional(string, null)<br>    encrypted      = optional(bool, false)<br>    device_name    = string<br>  }))</pre> | `{}` | no |
| <a name="input_allow_private_remote_access"></a> [allow\_private\_remote\_access](#input\_allow\_private\_remote\_access) | allow private remote access to ec2 | `bool` | `false` | no |
| <a name="input_ami_details"></a> [ami\_details](#input\_ami\_details) | latest OS filter, required if 'ami\_id' variable is not defined | <pre>object({<br>    platform     = string<br>    os_version   = string<br>    architecture = string<br>  })</pre> | <pre>{<br>  "architecture": "",<br>  "os_version": "",<br>  "platform": ""<br>}</pre> | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | ami\_id, required if 'ami\_details' variable is not defined | `string` | `""` | no |
| <a name="input_az"></a> [az](#input\_az) | availability zone | `string` | n/a | yes |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | additional tags | `map(string)` | `{}` | no |
| <a name="input_ec2_key_name"></a> [ec2\_key\_name](#input\_ec2\_key\_name) | name of keypair associated to ec2 intance | `string` | n/a | yes |
| <a name="input_ec2_name"></a> [ec2\_name](#input\_ec2\_name) | ec2 instance name | `string` | n/a | yes |
| <a name="input_ec2_state"></a> [ec2\_state](#input\_ec2\_state) | value of ec2 state | `string` | `"running"` | no |
| <a name="input_elastic_ip"></a> [elastic\_ip](#input\_elastic\_ip) | assign eip to ec2 | `bool` | `false` | no |
| <a name="input_instance_profile_name"></a> [instance\_profile\_name](#input\_instance\_profile\_name) | ec2 attached role | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | ec2 instance type | `string` | n/a | yes |
| <a name="input_private_additional_ports"></a> [private\_additional\_ports](#input\_private\_additional\_ports) | n/a | `list(number)` | `[]` | no |
| <a name="input_public_subnet"></a> [public\_subnet](#input\_public\_subnet) | assign public ip to host in public subnet | `bool` | `false` | no |
| <a name="input_root_vol"></a> [root\_vol](#input\_root\_vol) | root volume properties | <pre>object({<br>    size                  = number<br>    type                  = optional(string, "gp2")<br>    delete_on_termination = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | list of sg associated to instance | `list(string)` | `[]` | no |
| <a name="input_source_dest_check"></a> [source\_dest\_check](#input\_source\_dest\_check) | must be set to 'true' if ec2 is used for routing purpose | `bool` | `true` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | subnet id | `string` | n/a | yes |
| <a name="input_tenancy"></a> [tenancy](#input\_tenancy) | n/a | `string` | `"default"` | no |
| <a name="input_termination_protection"></a> [termination\_protection](#input\_termination\_protection) | to prevent accidental termination | `bool` | `false` | no |
| <a name="input_user_data_path"></a> [user\_data\_path](#input\_user\_data\_path) | path of user data | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | security group vpc id | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_details"></a> [ec2\_details](#output\_ec2\_details) | output ec2 details |
