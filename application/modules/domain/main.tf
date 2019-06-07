data "aws_route53_zone" "root_domain" {
  name         = "${var.route53_root_domain_name}"
  private_zone = false
}

module "certificate" {
  source = "../certificates"

  route53_root_domain_name = "${var.route53_root_domain_name}"
  route53_sub_domain_name  = "${var.route53_sub_domain_name}"
  route53_zone_id          = "${data.aws_route53_zone.root_domain.zone_id}"

  environment = "${var.environment}"
  project     = "${var.project}"
  owner       = "${var.owner}"

}

resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name              = "${var.route53_sub_domain_name}"
  regional_certificate_arn = "${module.certificate.arn}"

  depends_on = ["module.certificate"]

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "api_domain" {
  name    = "${aws_api_gateway_domain_name.api_domain.domain_name}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.root_domain.zone_id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.api_domain.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.api_domain.regional_zone_id}"
  }
}
