
#######################
# CREATE SECURITY GROUP
#######################
resource "aws_security_group" "private-sg" {
  count       = var.public_subnet == true && var.allow_private_remote_access == true ? 1 : 0
  name        = "${var.ec2_name}-priv-sg"
  description = "Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "ALL"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    self        = true
    description = "private_ingress_ports"
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "all_outbound"
  }

  tags = merge(local.tags, tomap({ "Name" : "${var.ec2_name}-priv-sg" }))

  timeouts {
    delete = "2m"
  }

  lifecycle {
    create_before_destroy = true
  }
}





variable "private_additional_ports" {
  type    = list(number)
  default = []
}

