#
# Provider Configuration
#

provider "aws" {
  region = "us-east-1"
  profile = "${var.aws_profile}"
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "all" {}

