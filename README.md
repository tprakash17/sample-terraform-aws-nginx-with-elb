### Terraform Automation - HA contanerized nginx webserver setup and RDS Aurora cluster.

### Resources created by this template.
* This creates a new `VPC` in us-east-1 (default region) with 3 `public subnets`
* AWS autoscaling group with min-max 2 instances for testing HA across availability zones.
* This also creates separate security_groups for `instances` and `ELB`. 
* This also creates the ELB and register it with ASG instances.
* nginx docker container is created - part of `user_data` script supplied to each instance.
* We are also creating RDS MYSQL Aurora cluster.

### Prerequisites 
* AWS CLI configured with proofile right IAM access
* Terraform Installed

### Clone repository
```
$ git clone https://github.com/tprakash17/sample-terraform-aws-nginx-with-elb.git
cd sample-terraform-aws-nginx-with-elb
```

## Setup 

### Initialize terraform
```
$ terraform init
```

### dry-run
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
Outputs:

elb_dns_name = hiver-test-elb-*******.us-east-1.elb.amazonaws.com
rds_cluster_address = testing-aurora-cluster.cluster-*********.us-east-1.rds.amazonaws.com
```

If everything looks ok during `terraform plan` then apply real changes using `terraform apply`

### Apply terraform 
```
$ terraform apply
```

## Access
Once `terraform apply` is `successful`, you will see the `elb_dns_name` configured as a part of output. you can hit `elb_dns_name` in your browser and should see the sample response from nginx container deployed or you can access `elb_dns_name` from CLI as well as given below.

`while true; do curl hiver-test-elb-********.us-east-1.elb.amazonaws.com; done`


