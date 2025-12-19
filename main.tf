
# query the latest windows and linux ami
data "aws_ami" "os_latest" {
  most_recent = true
  owners      = var.ami_details.platform == "ubuntu" ? local.ubuntu_filter.owners : var.ami_details.platform == "debian" ? local.debian_filter.owners : var.ami_details.platform == "amazon" ? local.amazon_filter.owners : local.windows_filter.owners
  filter {
    name   = "name"
    values = var.ami_details.platform == "ubuntu" ? local.ubuntu_filter.name_values : var.ami_details.platform == "debian" ? local.debian_filter.name_values : var.ami_details.platform == "amazon" ? local.amazon_filter.name_values : local.windows_filter.name_values
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



#######################
# CREATE EC2 INSTANCE
#######################
resource "aws_instance" "ec2" {
count = var.spot_instance == false ? 1 : 0
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.os_latest.id
  instance_type               = var.instance_type
  tenancy                     = var.tenancy
  availability_zone           = var.az
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.public_subnet == true && var.elastic_ip == false ? true : false
  source_dest_check           = var.source_dest_check
  disable_api_termination     = var.termination_protection
  key_name                    = var.ec2_key_name
  vpc_security_group_ids      = var.public_subnet == true && var.allow_private_remote_access == true ? concat(var.security_group_ids, [aws_security_group.private-sg[0].id]) : var.security_group_ids
  user_data                   = var.user_data_path != null ? file("${path.cwd}${var.user_data_path}") : "<<EOF EOF"
  iam_instance_profile        = var.instance_profile_name
  root_block_device {
    volume_size           = var.root_vol.size != null ? var.root_vol.size : var.ami_details.platform == "windows" ? 100 : 30
    volume_type           = var.root_vol.type
    delete_on_termination = var.root_vol.delete_on_termination
    tags                  = merge(local.tags, tomap({ "Name" : "${var.ec2_name}_root-vol" }))
  }

  tags = merge(local.tags, tomap({ "Name" : "${var.ec2_name}" }))

  lifecycle {
    ignore_changes = [ami, associate_public_ip_address]
  }
  depends_on = [aws_eip.ec2]
}


resource "aws_instance" "ec2_spot" {
count = var.spot_instance == true ? 1 : 0
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.os_latest.id
  instance_type               = var.instance_type
  tenancy                     = var.tenancy
  availability_zone           = var.az
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.public_subnet == true && var.elastic_ip == false ? true : false
  source_dest_check           = var.source_dest_check
  disable_api_termination     = var.termination_protection
  key_name                    = var.ec2_key_name
  vpc_security_group_ids      = var.public_subnet == true && var.allow_private_remote_access == true ? concat(var.security_group_ids, [aws_security_group.private-sg[0].id]) : var.security_group_ids
  user_data                   = var.user_data_path != null ? file("${path.cwd}${var.user_data_path}") : "<<EOF EOF"
  iam_instance_profile        = var.instance_profile_name
  root_block_device {
    volume_size           = var.root_vol.size != null ? var.root_vol.size : var.ami_details.platform == "windows" ? 100 : 30
    volume_type           = var.root_vol.type
    delete_on_termination = var.root_vol.delete_on_termination
    tags                  = merge(local.tags, tomap({ "Name" : "${var.ec2_name}_root-vol" }))
  }

   instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = var.max_spot_price
      spot_instance_type = "persistent"
      instance_interruption_behavior = "stop"
    }
  }

  tags = merge(local.tags, tomap({ "Name" : "${var.ec2_name}-spot" }))

  lifecycle {
    ignore_changes = [ami, associate_public_ip_address]
  }
  depends_on = [aws_eip.ec2]
}



resource "aws_ec2_instance_state" "ec2_state" {
  instance_id = var.spot_instance == false ? aws_instance.ec2[0].id : aws_instance.ec2_spot[0].id
  state       = var.ec2_state
}


// ADD ADDITIONAL VOLUMES
resource "aws_ebs_volume" "additional_vols" {
  # checkov:skip=CKV_AWS_3: ADD REASON
  # checkov:skip=CKV_AWS_189: ADD REASON
  for_each          = var.additional_vols
  availability_zone = var.spot_instance == false ? aws_instance.ec2[0].availability_zone : aws_instance.ec2_spot[0].availability_zone
  size              = each.value["size"]
  final_snapshot    = each.value["final_snapshot"]
  type              = each.value["type"]
  snapshot_id       = each.value["snapshot_id"]
  encrypted         = each.value["encrypted"]

  depends_on = [aws_instance.ec2]

  tags = merge(local.tags, tomap({ "Name" : "${var.ec2_name}-${each.key}" }))

}


resource "aws_volume_attachment" "ec2" {
  for_each    = var.additional_vols
  volume_id   = aws_ebs_volume.additional_vols[each.key].id
  instance_id = var.spot_instance == false ? aws_instance.ec2[0].id : aws_instance.ec2_spot[0].id
  device_name = each.value["device_name"]

  depends_on = [aws_ebs_volume.additional_vols]
}




##########################
# ENABLE EIP 
##########################
resource "aws_eip" "ec2" {
  count  = var.public_subnet == true && var.elastic_ip == true ? 1 : 0
  domain = "vpc"

  tags = merge(local.tags, tomap({ "Name" : "${var.ec2_name}-pub_ip" }))

}

resource "aws_eip_association" "eip_ec2" {
  count         = var.public_subnet == true && var.elastic_ip == true ? 1 : 0
  instance_id   = var.spot_instance == false ? aws_instance.ec2[0].id : aws_instance.ec2_spot[0].id
  allocation_id = aws_eip.ec2[0].id
}


