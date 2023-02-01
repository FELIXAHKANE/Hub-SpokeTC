variable "project-name" {
  type        = string
  default     = "HubSpoke"
  description = "The name of the Project"
}

variable "project-id" {
  type        = string
  default     = "1173088"
  description = "The ID of the Project"
}

#variable "my-secret-id" {
#  type        = string
#  default     = ""
#  description = "API keys Secret ID"
#}

#variable "my-secret-key" {
#  type        = string
#  default     = """
#  description = "API keys Secret key"
#}

variable "vpc_cidr_hub" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC's CIDR range"
}

variable "vpc_name_hub" {
  type        = string
  default     = "hub-vpc"
  description = "VPC's name"
}

variable "vpc_cidr_spoke1" {
  type        = string
  default     = "10.1.0.0/16"
  description = "VPC's CIDR range"
}

variable "vpc_name_spoke1" {
  type        = string
  default     = "spoke-vpc1"
  description = "VPC's name"
}

variable "vpc_cidr_spoke2" {
  type        = string
  default     = "10.2.0.0/16"
  description = "VPC's CIDR range"
}

variable "vpc_name_spoke2" {
  type        = string
  default     = "spoke-vpc2"
  description = "VPC's name"
}

variable "multicast" {
  type        = string
  default     = "false"
  description = "The value for the multicast enablement"
}

variable "region" {
  type        = string
  default     = "eu-frankfurt"
  description = "The name of the region"
}

variable "AZ-1" {
  type        = string
  default     = "1"
  description = "The value for the first availability zone"
}

variable "hub-region" {
  type        = string
  default     = "eu-frankfurt"
  description = "The name of the region"
}
variable "hub-az" {
  type        = string
  default     = "eu-frankfurt-1"
  description = "The name of the region"
}

variable "spoke1-region" {
  type        = string
  default     = "ap-guangzhou"
  description = "The name of the region"
}

variable "spoke1-az" {
  type        = string
  default     = "ap-guangzhou-1"
  description = "The name of the region"
}

variable "spoke2-region" {
  type        = string
  default     = "ap-singapore"
  description = "The name of the region"
}


variable "spoke2-az" {
  type        = string
  default     = "ap-singapore-1"
  description = "The name of the region"
}

variable "subnet_name_bastion" {
  type        = string
  default     = "bastion-hub-subnet"
  description = "Subnet name"
}

variable "subnet_name_firewall" {
  type        = string
  default     = "firewall-hub-subnet"
  description = "Subnet name"
}

variable "subnet_name_vpn" {
  type        = string
  default     = "vpngateway-hub-subnet"
  description = "Subnet name"
}

variable "subnet_name_spoke1" {
  type        = string
  default     = "spoke1-subnet"
  description = "Subnet name"
}

variable "subnet_name_spoke2" {
  type        = string
  default     = "spoke2-subnet"
  description = "Subnet name"
}

variable "rt-public-entry01-destination" {
  default = "0.0.0.0/0"
}

variable "rt-public-entry01-next_hop_type" {
  default = "NAT"
}

variable "rt-public-entry01-description" {
  default = "default route to NAT gateway"
}

variable "rt-public-entry02-destination" {
  default = "0.0.0.0/0"
}

variable "rt-public-entry02-next_hop_type" {
  default = "NAT"
}

variable "rt-public-entry02-description" {
  default = "default route to NAT gateway"
}
