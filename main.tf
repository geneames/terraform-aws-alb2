module "default_label" {
  source     = "git::https://github.com/geneames/terraform-null-label.git?ref=tags/0.11.1"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_security_group" "default" {
  description = "Controls access to the ALB (HTTP/HTTPS)"
  vpc_id      = "${var.vpc_id}"
  name        = "${module.default_label.id}"
  tags        = "${module.default_label.tags}"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "http_ingress" {
  count             = "${var.http_enabled == "true" ? 1 : 0}"
  type              = "ingress"
  from_port         = "${var.http_port}"
  to_port           = "${var.http_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.http_ingress_cidr_blocks}"]
  prefix_list_ids   = ["${var.http_ingress_prefix_list_ids}"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "https_ingress" {
  count             = "${var.https_enabled == "true" ? 1 : 0}"
  type              = "ingress"
  from_port         = "${var.https_port}"
  to_port           = "${var.https_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.https_ingress_cidr_blocks}"]
  prefix_list_ids   = ["${var.https_ingress_prefix_list_ids}"]
  security_group_id = "${aws_security_group.default.id}"
}

module "access_logs" {
  source        = "git::https://github.com/geneames/terraform-aws-lb-s3-bucket.git?ref=tags/0.11.14"
  attributes    = "${compact(concat(var.attributes, list("alb", "access", "logs")))}"
  delimiter     = "${var.delimiter}"
  name          = "${var.name}"
  namespace     = "${var.namespace}"
  stage         = "${var.stage}"
  tags          = "${var.tags}"
  region        = "${var.access_logs_region}"
  force_destroy = "${var.alb_access_logs_s3_bucket_force_destroy}"
}

resource "aws_lb" "default" {
  name                             = "${module.default_label.id}"
  tags                             = "${module.default_label.tags}"
  internal                         = "${var.internal}"
  load_balancer_type               = "application"
  security_groups                  = ["${compact(concat(var.security_group_ids, list(aws_security_group.default.id)))}"]
  subnets                          = ["${var.subnet_ids}"]
  enable_cross_zone_load_balancing = "${var.cross_zone_load_balancing_enabled}"
  enable_http2                     = "${var.http2_enabled}"
  idle_timeout                     = "${var.idle_timeout}"
  ip_address_type                  = "${var.ip_address_type}"
  enable_deletion_protection       = "${var.deletion_protection_enabled}"

  access_logs {
    bucket  = "${module.access_logs.bucket_id}"
    prefix  = "${var.access_logs_prefix}"
    enabled = "${var.access_logs_enabled}"
  }
}
