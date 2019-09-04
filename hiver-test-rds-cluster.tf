########################
## Cluster
########################

resource "aws_rds_cluster" "aurora_cluster" {

    cluster_identifier            = "${var.environment_name}-aurora-cluster"
    database_name                 = "${var.aurora_database_name}"
    master_username               = "${var.rds_master_username}"
    master_password               = "${var.rds_master_password}"
    backup_retention_period       = 7
    preferred_backup_window       = "02:00-03:00"
    preferred_maintenance_window  = "wed:03:00-wed:04:00"
    db_subnet_group_name          = "${aws_db_subnet_group.aurora_subnet_group.name}"
    final_snapshot_identifier     = "${var.environment_name}-aurora-cluster"
    vpc_security_group_ids        = ["${aws_security_group.hiver-instance-sg.id}"]

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Cluster"
        ManagedBy    = "Terraform"
        Environment  = "${var.environment_name}"
    }

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {

    #count                 = "${length(var.public_subnets)}"
    count 		  = 2
    identifier            = "${var.environment_name}-aurora-instance-${count.index}"
    cluster_identifier    = "${aws_rds_cluster.aurora_cluster.id}"
    instance_class        = "db.t2.small"
    db_subnet_group_name  = "${aws_db_subnet_group.aurora_subnet_group.name}"
    publicly_accessible   = true

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Instance-${count.index}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_db_subnet_group" "aurora_subnet_group" {

    name          = "${var.environment_name}-aurora-db-subnet-group"
    description   = "Allowed subnets for Aurora DB cluster instances"
    subnet_ids    = ["${aws_subnet.hiver-demo.*.id}"]

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Subnet-Group"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

}

########################
## Output
########################

output "cluster_address" {
    value = "${aws_rds_cluster.aurora_cluster.endpoint}"
}

