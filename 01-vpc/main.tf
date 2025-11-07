
# Create VPC
resource "aws_vpc" "this" {
    cidr_block = "10.10.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.project}-${var.env}-vpc"
    }
}

# Create Private subnets in 2 AZs (for Lambda ENIs)
resource "aws_subnet" "private" {
    for_each = toset(var.azs)

    vpc_id = aws_vpc.this.id
    cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, index(var.azs, each.key))
    availability_zone = each.key
    map_public_ip_on_launch = false

    tags = {
        Name = "${var.project}-${var.env}-private-${each.key}"
    }
}

# Create Private route table 
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "${var.project}-${var.env}-private-rt"
    }
}

# Associate Pricate Subnets with Route Table
resource "aws_route_table_association" "private_assoc" {
    for_each = aws_subnet.private
    subnet_id = each.value.id
    route_table_id = aws_route_table.private.id
}
