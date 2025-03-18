
variable "ami_details" {
  description = "latest OS filter, required if 'ami_id' variable is not defined"
  type = object({
    platform     = string
    os_version   = string
    architecture = string
  })
  default = {
    platform     = ""
    os_version   = ""
    architecture = ""
  }
}

variable "ami_id" {
  description = "ami_id, required if 'ami_details' variable is not defined "
  type        = string
  default     = ""
}


variable "ec2_key_name" {
  description = "name of keypair associated to ec2 intance"
  type        = string
}


variable "termination_protection" {
  description = "to prevent accidental termination"
  type = bool
  default = false
}


variable "ec2_name" {
  description = "ec2 instance name"
  type        = string
}

variable "tenancy" {
  type    = string
  default = "default"
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "instance_profile_name" {
  description = "ec2 attached role"
  type = string
  default = ""
}

variable "az" {
  description = "availability zone"
  type        = string
}

variable "subnet_id" {
  description = "subnet id"
  type        = string
}


variable "elastic_ip" {
  description = "assign eip to ec2"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "list of sg associated to instance"
  type        = list(string)
  default     = []
}

variable "source_dest_check" {
  description = "must be set to 'true' if ec2 is used for routing purpose"
  type    = bool
  default = true
}

variable "public_subnet" {
  description = "assign public ip to host in public subnet"
  type        = bool
  default     = false
}

variable "root_vol" {
  description = "root volume properties"
  type = object({
    size                  = number
    type                  = optional(string, "gp2")
    delete_on_termination = optional(bool, false)
  })

}


variable "additional_vols" {
  description = "add secondary volumes"
  type = map(object({
    # az             = string
    size           = number
    final_snapshot = optional(bool, true)
    type           = optional(string, "gp2")
    throughput     = optional(number, 100)
    snapshot_id    = optional(string, null)
    encrypted      = optional(bool, false)
    device_name    = string
  }))
  default = {}

}


variable "user_data_path" {
  description = "path of user data"
  type    = string
  default = null
}

variable "custom_tags" {
  description = "additional tags"
  type    = map(string)
  default = {}
}

variable "ec2_state" {
  description = "value of ec2 state"
  type = string
  default = "running"
}


variable "vpc_id" {
  description = "security group vpc id"
  type        = string
  default     = null
}

variable "allow_private_remote_access" {
  description = "allow private remote access to ec2"
  type    = bool
  default = false
}