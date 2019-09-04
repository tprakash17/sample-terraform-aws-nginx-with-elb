# Values from user at runtime.

variable "ami"{
	description = "choose ubuntu AMI available in us-east-1 region"
}

variable "instance_type"{
	description = "Enter - instance type. You can choose t2.micro for this test setup"
}

variable "aws_profile" {
	description = "Enter - AWS CLI profile name configured for this setup"
}

# take this from user in run time
variable "ssh_key_pair" {

}

variable "public_subnets" {
    type    = "list"
    default = ["10.12.0.0/22", "10.12.4.0/22", "10.12.8.0/22"]
}

########################
## RDS aurora DB Variables
########################

variable "environment_name" {
    default = "testing"
    description = "The name of the environment"
}

variable "rds_master_username" {
  default = "rdsuser"
  description = "Enter RDS master username"
}

variable "rds_master_password" {
  description = "Enter DB master password"
}

variable "aurora_database_name" {
  default = "testrds"
  description = "Enter DB name"
}
