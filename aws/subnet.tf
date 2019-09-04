data "aws_availability_zones" "available" {
  state = "available"
}

// 2 Public Subnets
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.${count.index * 2 + 1}.0/24"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  count = min(length(data.aws_availability_zones.available), var.max_availability_zones)

  tags = {
    Name   = "pub_10.0.${count.index * 2 + 1}.0_24_${element(data.aws_availability_zones.available.names, count.index)}"
    Author = var.author
    Tool   = local.build_tool
  }
}

// 2 Private Subnets
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.${count.index * 2}.0/24"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  count = min(length(data.aws_availability_zones.available), var.max_availability_zones)

  tags = {
    Name   = "pri_10.0.${count.index * 2}.0_${element(data.aws_availability_zones.available.names, count.index)}"
    Author = var.author
    Tool   = local.build_tool
  }
}

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name   = "igw_${var.vpc_name}"
    Author = var.author
    Tool   = local.build_tool
  }
}

// Static IP for Nat Gateway
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name   = "eip-nat_${var.vpc_name}"
    Author = var.author
    Tool   = local.build_tool
  }
}

// Nat Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets.*.id[0]

  tags = {
    Name   = "nat_${var.vpc_name}"
    Author = var.author
    Tool   = local.build_tool
  }
}

// Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = local.open_access
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name   = "pub_rt_${var.vpc_name}"
    Author = var.author
    Tool   = local.build_tool
  }
}

// Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = local.open_access
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name   = "pri_rt_${var.vpc_name}"
    Author = var.author
    Tool   = local.build_tool
  }
}

// Associate public subnets to public route table
resource "aws_route_table_association" "public" {
  count = min(length(data.aws_availability_zones.available), var.max_availability_zones)
  subnet_id      = aws_subnet.public_subnets.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}

// Associate private subnets to private route table
resource "aws_route_table_association" "private" {
  count = min(length(data.aws_availability_zones.available), var.max_availability_zones)
  subnet_id      = aws_subnet.private_subnets.*.id[count.index]
  route_table_id = aws_route_table.private_rt.id
}