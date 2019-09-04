#### Terraform Automation - HA contanerized nginx webserver setup and RDS Aurora cluster.

## Prerequisites 
* AWS CLI configured with proofile right IAM access
* Terraform Installed

## Clone Repo
```
$ git clone https://github.com/tprakash17/sample-terraform-aws-nginx-with-elb.git
cd sample-terraform-aws-nginx-with-elb
```

## Run the setup - create AWS resources
```
$ terraform init
```

## Dry run - terrafrom plan
```
$ terraform plan

tarunprakash$ terraform plan
var.ami
  choose ubuntu AMI available in us-east-1 region

  Enter a value: ami-0dc82b70

var.aws_profile
  Enter - AWS CLI profile name configured for this setup

  Enter a value: hiver-test

var.instance_type
  Enter - instance type. You can choose t2.micro for this test setup

  Enter a value: t2.micro

var.rds_master_password
  Enter DB master password

  Enter a value: ******       

var.ssh_key_pair
  Enter a value: hiver-test

data.aws_region.current: Refreshing state...
data.aws_availability_zones.all: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:
...
...
...
```

Note - Above will create following resources.
* This created `VPC` with 3 `public subnets`
* AWS autoscaling group with min-max 2 instances.
* This also creates the ELB and register it with ASG instances.
* nginx docker container is created - part of `user_data` script supplied to each instance.
* We are also creating RDS MYSQL Aurora cluster.

## Access
Once setup is done, you can hit the ELB endpoint and you should see the sample response in your browser or from CLI.

`while true; do curl hiver-test-elb-********.us-east-1.elb.amazonaws.com; done`


