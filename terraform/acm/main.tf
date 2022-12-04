data "aws_route53_zone" "this" {
  name         = "${var.domain}"
  private_zone = false
}

# ACM
resource "aws_acm_certificate" "this" {
  domain_name = "${var.domain}"

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Route53 record
resource "aws_route53_record" "this" {
  depends_on = [aws_acm_certificate.this]

  # https://dev.classmethod.jp/articles/terraform-aws-certificate-validation/
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.this.id
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

# ACM Validate
resource "aws_acm_certificate_validation" "this" {
  certificate_arn = "${aws_acm_certificate.this.arn}"

  # https://dev.classmethod.jp/articles/terraform-aws-certificate-validation/
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}

######################################################################
output "acm_id" {
  value = "${aws_acm_certificate.this.id}"
}
