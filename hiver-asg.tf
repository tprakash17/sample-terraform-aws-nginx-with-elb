## Launch config and auto scaling configuration 

locals {
  ec2-userdata = <<USERDATA
#!/bin/bash -xe

sudo apt-get update -y 

# install docker
sudo curl https://releases.rancher.com/install-docker/17.03.sh | sh
sudo usermod -a -G docker admin

# create custom index.html
sudo mkdir -p /opt/hiver
sudo chown -R admin.admin /opt/hiver

echo "Hello Hiver!" > /opt/hiver/index.html

# Run nginx container with custom html page.
sudo docker run --name hiver-nginx --restart=unless-stopped -v /opt/hiver:/usr/share/nginx/html:ro -d -p 8080:80 nginx
 
USERDATA
}

resource "aws_launch_configuration" "hiver-lc" {
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.ssh_key_pair}"
  name_prefix                 = "hiver-lc"
  security_groups      	      = ["${aws_security_group.hiver-instance-sg.id}"]
  user_data_base64            = "${base64encode(local.ec2-userdata)}"

  #user_data 		      = ${data.template_file.init.rendered} # this can be used to load dynamic values into userdata script

  associate_public_ip_address = true
  
  root_block_device {
    delete_on_termination = true
    volume_size = 10
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "hiver-asg" {
  #depends_on 	       = [aws_rds_cluster.aurora_cluster]
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.hiver-lc.id}"
  max_size             = 2
  min_size             = 2
  name                 = "hiver-asg"
  load_balancers       = ["${aws_elb.hiver-elb.name}"]
  vpc_zone_identifier  = ["${aws_subnet.hiver-demo.0.id}"]

  tag {
    key                 = "Name"
    value               = "TestInstance"
    propagate_at_launch = true
  }
  
}
