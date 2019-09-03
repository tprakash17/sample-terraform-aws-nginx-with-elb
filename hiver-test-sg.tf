resource "aws_security_group" "hiver-instance-sg" {
  name        = "hiver-instance-sg"
  description = "security group for instances"
  vpc_id      = "${aws_vpc.hiver-demo.id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = "true"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self	= "true"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "hiver-instance-sg",
    )
  }"
}
