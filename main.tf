terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}

provider "tencentcloud" {
  region     = var.region
}

provider "tencentcloud" {
  alias = "gz"
  region = "ap-guangzhou"
}

provider "tencentcloud" {
  alias = "sg"
  region = "ap-singapore"
}

resource "tencentcloud_vpc" "HubVPC" {
  name         = var.vpc_name_hub
  cidr_block   = var.vpc_cidr_hub
  is_multicast = var.multicast
  
}

resource "tencentcloud_vpc" "SpokeVPC1" {
  name         = var.vpc_name_spoke1
  cidr_block   = var.vpc_cidr_spoke1
  is_multicast = var.multicast

  provider = tencentcloud.gz
}

resource "tencentcloud_vpc" "SpokeVPC2" {
  name         = var.vpc_name_spoke2
  cidr_block   = var.vpc_cidr_spoke2
  is_multicast = var.multicast
  
  provider = tencentcloud.sg
}

resource "tencentcloud_subnet" "bastion-subnet" {
  name              = var.subnet_name_bastion
  availability_zone = var.hub-az
  vpc_id            = tencentcloud_vpc.HubVPC.id
  cidr_block        = cidrsubnet("${var.vpc_cidr_hub}", 8, 0) #10.0.0.0/24

  # Optional but highly recommended parameters
  #route_table_id      = tencentcloud_route_table.rt-public01.id
  is_multicast = var.multicast
}

resource "tencentcloud_subnet" "firewall-subnet" {
  name              = var.subnet_name_firewall
  availability_zone = var.hub-az
  vpc_id            = tencentcloud_vpc.HubVPC.id
  cidr_block        = cidrsubnet("${var.vpc_cidr_hub}", 8, 1) #10.0.1.0/24

  # Optional but highly recommended parameters
  is_multicast = var.multicast
}

resource "tencentcloud_subnet" "vpngateway-subnet" {
  name              = var.subnet_name_vpn
  availability_zone = var.hub-az
  vpc_id            = tencentcloud_vpc.HubVPC.id
  cidr_block        = cidrsubnet("${var.vpc_cidr_hub}", 8, 2) #10.0.2.0/24

  # Optional but highly recommended parameters
  is_multicast = var.multicast
}

resource "tencentcloud_subnet" "spoke1-subnet" {
  name              = var.subnet_name_spoke1
  availability_zone = var.spoke1-az
  vpc_id            = tencentcloud_vpc.SpokeVPC1.id
  cidr_block        = cidrsubnet("${var.vpc_cidr_spoke1}", 8, 0) #10.1.0.0/24

  # Optional but highly recommended parameters
  is_multicast = var.multicast
  provider = tencentcloud.gz
}

resource "tencentcloud_subnet" "spoke2-subnet" {
  name              = var.subnet_name_spoke2
  availability_zone = var.spoke2-az
  vpc_id            = tencentcloud_vpc.SpokeVPC2.id
  cidr_block        = cidrsubnet("${var.vpc_cidr_spoke2}", 8, 0) #10.1.1.0/24

  # Optional but highly recommended parameters
  #route_table_id      = tencentcloud_route_table.rt-public01.id
  is_multicast = var.multicast
  provider = tencentcloud.sg
}

data "tencentcloud_instance_types" "bastion_instance_types" {
  filter {
    name   = "instance-family"
    values = ["S3"]
  }

  cpu_core_count = 1
  memory_size    = 1
}

#Deploy two Bastion CVM instances
/*resource "tencentcloud_instance" "bastion-host" { 
  instance_name              = "bastion-host"
  #availability_zone          = data.tencentcloud_availability_zones.bastion_zone.zones.0.name
  availability_zone          = var.hub-az
  image_id                   = "img-eb30mz89"
  instance_type              = "S3.MEDIUM2"
  system_disk_type           = "CLOUD_PREMIUM"
  system_disk_size           = 50
  hostname                   = "user"
  project_id                 = 0
  vpc_id                     = tencentcloud_vpc.HubVPC.id
  subnet_id                  = tencentcloud_subnet.bastion-subnet.id
  allocate_public_ip         = true
  internet_max_bandwidth_out = 5
  count                      = 2

  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  tags = {
    tagKey = "tagValue"
  }
}*/

#Security group for the subnet
resource "tencentcloud_security_group" "bastion-sg" {
  name = "bastion-sg"
}

resource "tencentcloud_security_group_lite_rule" "bastion-sg-rules" {
  security_group_id = tencentcloud_security_group.bastion-sg.id

  ingress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]

  egress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]
}

resource "tencentcloud_security_group" "firewall-sg" {
  name = "firewall-sg"
}

resource "tencentcloud_security_group_lite_rule" "firewall-sg-rules" {
  security_group_id = tencentcloud_security_group.firewall-sg.id

  ingress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]

  egress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]
}

resource "tencentcloud_security_group" "vpn-sg" {
  name = "vpn-sg"
}

resource "tencentcloud_security_group_lite_rule" "vpn-sg-rules" {
  security_group_id = tencentcloud_security_group.vpn-sg.id

  ingress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]

  egress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]
}

resource "tencentcloud_security_group" "spoke1-sg" {
  name = "spoke1-sg"
  provider = tencentcloud.gz
}

resource "tencentcloud_security_group_lite_rule" "spoke1-sg-rules" {
  security_group_id = tencentcloud_security_group.spoke1-sg.id

  ingress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]

  egress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]
  provider = tencentcloud.gz
}

resource "tencentcloud_security_group" "spoke2-sg" {
  name = "spoke2-sg"
  provider = tencentcloud.sg
}

resource "tencentcloud_security_group_lite_rule" "spoke2-sg-rules" {
  security_group_id = tencentcloud_security_group.spoke2-sg.id

  ingress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]

  egress = [
    "DROP#0.0.0.0/0#ALL#ALL",
    #"DROP#0.0.0.0/0#80,22,3389#TCP"
  ]
  provider = tencentcloud.sg
}

#CCN association
resource "tencentcloud_ccn" "main" {
  name                 = "main-ccn"
  description          = "CCN description"
  qos                  = "AG" # AG for CCN Silver Support
  charge_type          = "POSTPAID"
  bandwidth_limit_type = "INTER_REGION_LIMIT"
}

resource "tencentcloud_ccn_attachment" "hub-ccn" {
  ccn_id          = tencentcloud_ccn.main.id
  instance_type   = "VPC" # VPC, DIRECTCONNECT, BMVPC and VPNGW
  instance_id     = tencentcloud_vpc.HubVPC.id
  instance_region = var.hub-region
}

resource "tencentcloud_ccn_attachment" "spoke1-ccn" {
  ccn_id          = tencentcloud_ccn.main.id
  instance_type   = "VPC"
  instance_id     = tencentcloud_vpc.SpokeVPC1.id
  instance_region = var.spoke1-region
}

resource "tencentcloud_ccn_attachment" "spoke2-ccn" {
  ccn_id          = tencentcloud_ccn.main.id
  instance_type   = "VPC"
  instance_id     = tencentcloud_vpc.SpokeVPC2.id
  instance_region = var.spoke2-region
}

