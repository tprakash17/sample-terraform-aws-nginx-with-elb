## Security Group for ELB
resource "aws_security_group" "hiver-elb-sg" {
  name 	      = "hiver-elb-security-group"
  vpc_id      = "${aws_vpc.hiver-demo.id}"
  description = "ELB security group"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a new load balancer

### Creating ELB
resource "aws_elb" "hiver-elb" {
  name = "hiver-test-elb"
  security_groups = ["${aws_security_group.hiver-elb-sg.id}"]
  subnets = ["${aws_subnet.hiver-demo.*.id}"]
  #availability_zones = ["${data.aws_availability_zones.all.names}"]

  listener {
    lb_port = 80
    lb_protocol = "tcp"
    instance_port = 8080
    instance_protocol = "tcp"
  }

# This can be used if we are planning to have https on domain.
#  listener {
#    instance_port      = 8080
#    instance_protocol  = "http"
#    lb_port            = 443
#    lb_protocol        = "https"
#    ssl_certificate_id = "arn:aws:iam::<ACCT-ID>:server-certificate/crtName"
#  }

  idle_timeout	      = 400
  connection_draining = true
  connection_draining_timeout = 400
}
