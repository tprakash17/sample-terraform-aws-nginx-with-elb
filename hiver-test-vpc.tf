#
# New VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "hiver-demo" {
  cidr_block = "10.12.0.0/19"
  enable_dns_hostnames = true

  tags = "${
    map(
     "Name", "hiver-test-vpc",
    )
  }"
}

## hiver public subnets
resource "aws_subnet" "hiver-demo" {
  count = "${length(var.public_subnets)}"

  availability_zone = "${data.aws_availability_zones.all.names[count.index]}"
  cidr_block        = "${var.public_subnets[count.index]}"
  vpc_id            = "${aws_vpc.hiver-demo.id}"

  tags = "${
    map(
     "Name", "hiver-public-subnet"
    )
  }"
}


## internet gateway
resource "aws_internet_gateway" "hiver-gtw" {
  vpc_id = "${aws_vpc.hiver-demo.id}"

  tags {
    Name = "terraform-hiver-demo"
  }
}

## create routing table
resource "aws_route_table" "hiver-rt" {
  vpc_id = "${aws_vpc.hiver-demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.hiver-gtw.id}"
  }

}
resource "aws_route_table_association" "hiver-demo" {
  count = "${length(var.public_subnets)}"

  subnet_id      = "${aws_subnet.hiver-demo.*.id[count.index]}"
  route_table_id = "${aws_route_table.hiver-rt.id}"
}	
