# Defines local variables for tags, OS image filters, 

# Tags
locals {
  default_tags = {
    IacTool = "terraform"
  }
  tags = merge(local.default_tags, var.custom_tags)
}


# Latest OS filter
locals {
  ubuntu_filter = {
    owners      = ["099720109477"]
    name_values = var.ami_details.platform == "ubuntu" ? ["ubuntu/images/hvm-ssd/ubuntu-${var.ami_details.os_version}-${var.ami_details.architecture}-server-*"] : [""]
  }
  debian_filter = {
    owners      = ["679593333241"]
    name_values = ["debian-10*"]
  }

  amazon_filter = {
    owners      = ["amazon"]
    name_values = ["amzn2-ami-hvm*"]
  }

  windows_filter = {
    owners      = ["amazon"]
    name_values = ["Windows_${var.ami_details.os_version}*"]
  }
}


// query my ip
data "http" "myip" {
  url = "https://icanhazip.com"
}

# locals {
#   myconnection = {
#     "ssh"   = [22, 22, "tcp", ["${chomp(data.http.myip.response_body)}/32"], [], false]
#     "https" = [443, 443, "tcp", ["${chomp(data.http.myip.response_body)}/32"], [], false]
#   }
# }
