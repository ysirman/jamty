# VPC
resource "aws_vpc" "this" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "${var.name}"
  }
}

######################################################################
# Public Subnet
######################################################################
resource "aws_subnet" "publics" {
  count = "${length(var.public_subnet_cidrs)}"

  vpc_id = "${aws_vpc.this.id}"

  availability_zone = "${var.azs[count.index]}"
  cidr_block        = "${var.public_subnet_cidrs[count.index]}"

  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

######################################################################
# Internet Gateway：VPCからインターネットへの出入り口となる
resource "aws_internet_gateway" "this" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "${var.name}"
  }
}

# Elastic IP
resource "aws_eip" "nat" {
  count = "${length(var.public_subnet_cidrs)}"

  vpc = true

  tags = {
    Name = "${var.name}-natgw-${count.index}"
  }
}

# NAT Gateway：プライベートサブネットからインターネットへ通信するために必要
resource "aws_nat_gateway" "this" {
  count = "${length(var.public_subnet_cidrs)}"

  subnet_id     = "${element(aws_subnet.publics.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"

  tags = {
    Name = "${var.name}-${count.index}"
  }
}

######################################################################
# Route Table (public)
######################################################################
# Route Table：経路情報の格納場所
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "${var.name}-public"
  }
}

# Route：Route Tableへ経路情報を追加する
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.public.id}"
  gateway_id             = "${aws_internet_gateway.this.id}"
}

# Association：Route TableとSubnetの紐づけ
resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnet_cidrs)}"

  subnet_id      = "${element(aws_subnet.publics.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

######################################################################
# Private Subnet
######################################################################
resource "aws_subnet" "privates" {
  count = "${length(var.private_subnet_cidrs)}"

  vpc_id = "${aws_vpc.this.id}"

  availability_zone = "${var.azs[count.index]}"
  cidr_block        = "${var.private_subnet_cidrs[count.index]}"

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

######################################################################
# Route Table (private)
######################################################################
resource "aws_route_table" "privates" {
  count = "${length(var.private_subnet_cidrs)}"

  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

resource "aws_route" "privates" {
  count = "${length(var.private_subnet_cidrs)}"

  destination_cidr_block = "0.0.0.0/0"

  route_table_id = "${element(aws_route_table.privates.*.id, count.index)}"
  nat_gateway_id = "${element(aws_nat_gateway.this.*.id, count.index)}"
}

resource "aws_route_table_association" "privates" {
  count = "${length(var.private_subnet_cidrs)}"

  subnet_id      = "${element(aws_subnet.privates.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.privates.*.id, count.index)}"
}

######################################################################
output "vpc_id" {
  value = "${aws_vpc.this.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.publics.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.privates.*.id}"]
}
