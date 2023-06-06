data "aws_route53_zone" "main" {
  name = "fadiatestdevops.click"

}
#  module "zones" {

#    source  = "terraform-aws-modules/route53/aws//modules/zones"
#   version = "~> 2.0"
#   create=false
#   zones = "fadiatestdevops.click" 
# }
# resource "aws_route53_record" "rec" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   type    = "A"
#   name = var.env_code
#   alias {
    
#     name                   = module.lb.elb_dns_name
#     zone_id                = module.lb.elb_zone_id
#     evaluate_target_health = true
#   }
//}
module "dns" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = data.aws_route53_zone.main.zone_id


  records = [
    {
      name    = "www"
      type    = "CNAME"
      records = [module.lb.elb_dns_name]
      ttl     = 3600
    }

  ]


}
# module "dns" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "~> 2.0"

#   zone_id = data.aws_route53_zone.main.zone_id
#   type    = "A"
#   alias {
#     name                   = module.lb.elb_dns_name
#     zone_id                = module.elb.zone_id
#     evaluate_target_health = true
#   }

#   #   records = [
#   #     {
#   #       name    = "www"
#   #       type    = "CNAME"
#   #       records = [module.lb.elb_dns_name]
#   #       ttl     = 3600
#   #     }

#   //]


# }
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = "www.${data.aws_route53_zone.main.name}"
  zone_id     = data.aws_route53_zone.main.zone_id



  wait_for_validation = true

  tags = {
    Name = "my-domain.com"
  }
}