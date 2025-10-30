locals {
  letters = ["a", "b"]
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    {
      Name = "${var.name}-${var.env}"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "${var.name}-${var.env}-igw"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      Name = "${var.name}-${var.env}-public"
    }
  )
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    {
      Name = "${var.name}-${var.env}-public-${local.letters[count.index]}"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    {
      Name = "${var.name}-${var.env}-private-${local.letters[count.index]}"
    }
  )
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  tags = merge(
    {
      Name = "${var.name}-${var.env}-private-${local.letters[count.index]}"
    }
  )
}

resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"
  tags = merge(
    {
      Name = "${var.name}-${var.env}-eip-${local.letters[count.index]}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = merge(
    {
      Name = "${var.name}-${var.env}-nat-${local.letters[count.index]}"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_security_group" "vpc" {
  vpc_id = aws_vpc.main.id
  name   = "${var.name}-${var.env}"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.vpc_cidr
  }

  tags = merge(
    {
      Name = "${var.name}-${var.env}"
    }
  )
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id
  tags = merge(
    {
      Name = "${var.name}-${var.env}"
    }
  )
}

resource "aws_vpc_endpoint" "ssm" {
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = "false"
  }

  ip_address_type     = "ipv4"
  private_dns_enabled = "true"
  security_group_ids  = [aws_security_group.vpc.id]
  service_name        = "com.amazonaws.${var.region}.ssm"

  subnet_ids = aws_subnet.private[*].id

  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.name}-${var.env}"
    }
  )
}