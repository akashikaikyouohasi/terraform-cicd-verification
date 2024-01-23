# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_route53_record" "_0099fd8d79038ec1b124d51ce652af04_testwww_build_automation_de_CNAME" {
  health_check_id                  = null
  name                             = "_0099fd8d79038ec1b124d51ce652af04.testwww.build-automation.de"
  records                          = ["_8afb7aab5a5048e6d466b391ad3bb994.jhztdrwbnw.acm-validations.aws."]
  ttl                              = 300
  type                             = "CNAME"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
}

# __generated__ by Terraform
resource "aws_route53_record" "www_build_automation_de_A" {
  health_check_id                  = null
  name                             = "www.build-automation.de"
  type                             = "A"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
  alias {
    evaluate_target_health = true
    name                   = "d3dyegta20nddk.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
  }
}

# __generated__ by Terraform
resource "aws_route53_record" "testapi_build_automation_de_A" {
  health_check_id                  = null
  name                             = "testapi.build-automation.de"
  type                             = "A"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
  alias {
    evaluate_target_health = true
    name                   = "d17n7mlgrgbg64.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
  }
}

# __generated__ by Terraform
resource "aws_route53_record" "_84f0eabfcdf6b625c0f614e21e751274_www_build_automation_de_CNAME" {
  health_check_id                  = null
  name                             = "_84f0eabfcdf6b625c0f614e21e751274.www.build-automation.de"
  records                          = ["_55eae4caeaed6c4d99f1a44ee5389737.tgztlnjmjp.acm-validations.aws."]
  ttl                              = 300
  type                             = "CNAME"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
}

# __generated__ by Terraform
resource "aws_route53_record" "build_automation_de_NS" {
  health_check_id                  = null
  name                             = "build-automation.de"
  records                          = ["ns-1488.awsdns-58.org.", "ns-1937.awsdns-50.co.uk.", "ns-257.awsdns-32.com.", "ns-745.awsdns-29.net."]
  ttl                              = 172800
  type                             = "NS"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
}

# __generated__ by Terraform
resource "aws_route53_record" "api_build_automation_de_A" {
  health_check_id                  = null
  name                             = "api.build-automation.de"
  type                             = "A"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
  alias {
    evaluate_target_health = true
    name                   = "d23kanuy7x5r0y.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
  }
}

# __generated__ by Terraform
resource "aws_route53_record" "_62eeb7b08d5177f78245c93043cb681b_testapi_build_automation_de_CNAME" {
  health_check_id                  = null
  name                             = "_62eeb7b08d5177f78245c93043cb681b.testapi.build-automation.de"
  records                          = ["_73bb59b2954a33ab4b9b4234627870b2.jhztdrwbnw.acm-validations.aws."]
  ttl                              = 300
  type                             = "CNAME"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
}

# __generated__ by Terraform
resource "aws_route53_record" "testwww_build_automation_de_A" {
  health_check_id                  = null
  name                             = "testwww.build-automation.de"
  type                             = "A"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
  alias {
    evaluate_target_health = true
    name                   = "d17fhm8lk6ie0x.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
  }
}

# __generated__ by Terraform
resource "aws_route53_record" "build_automation_de_SOA" {
  health_check_id                  = null
  name                             = "build-automation.de"
  records                          = ["ns-1937.awsdns-50.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  ttl                              = 900
  type                             = "SOA"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
}

# __generated__ by Terraform
resource "aws_route53_record" "_d92b16251a393151e13b8ff3545666b0_api_build_automation_de_CNAME" {
  health_check_id                  = null
  name                             = "_d92b16251a393151e13b8ff3545666b0.api.build-automation.de"
  records                          = ["_9a4b2985b84928d198a19ab3fa61c50b.kzhndfqvzk.acm-validations.aws."]
  ttl                              = 300
  type                             = "CNAME"
  zone_id                          = "Z0383667MSTTMDLTD5CH"
}
