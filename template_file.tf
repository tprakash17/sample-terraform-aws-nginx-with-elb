data "template_file" "init" {
  template = "${file("user_data.tpl")}"

  vars {
    rds_endpoint = "${aws_rds_cluster.aurora_cluster.endpoint}"
    rds_user = "" 
  }
}
