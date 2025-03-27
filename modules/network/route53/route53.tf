data "aws_route53_zone" "this" {
  name         = var.zone_name
  private_zone = false
}

resource "aws_route53_record" "records" {
  for_each = { for idx, record in var.records : idx => record }

  zone_id = data.aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type

  ttl     = lookup(each.value, "ttl", null)
  records = lookup(each.value, "records", null)

  dynamic "alias" {
    for_each = lookup(each.value, "alias_name", null) != null ? [1] : []
    content {
      name                   = each.value.alias_name
      zone_id                = each.value.alias_zone_id
      evaluate_target_health = lookup(each.value, "evaluate_target_health", false)
    }
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = { for idx, record in var.acm_records : idx => record }

  zone_id = data.aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = lookup(each.value, "ttl", 300)
  records = each.value.records
}