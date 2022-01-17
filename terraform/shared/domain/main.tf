###
# Target space/org
###

data "cloudfoundry_space" "space" {
  org_name = var.cf_org_name
  name     = var.cf_space_name
}

###
# Route mapping and CDN instance
###

data "cloudfoundry_app" "tah" {
  name_or_id = "test_at_home-${var.env}-0"
  space      = data.cloudfoundry_space.space.id
}

###########################################################################
# Routes must be manually created by an OrgManager before terraform is run:
#
# cf create-domain gsa-tts-test-kits staging-covidtest.usa.gov
# cf create-domain gsa-tts-test-kits route.staging-covidtest.usa.gov
# cf create-domain gsa-tts-test-kits $region.staging-covidtest.usa.gov
# cf create-domain gsa-tts-test-kits $foundation_domain_name
#
#
# this makes sure the first app is routed properly.
# /foundry_<x>/<env>/map-routes.sh is used to connect the rest of the apps
###########################################################################

data "cloudfoundry_domain" "origin_url" {
  name = var.origin_domain_name
}

data "cloudfoundry_domain" "foundation_url" {
  name = var.foundation_domain_name
}

resource "cloudfoundry_route" "origin_route-n" {
  domain = data.cloudfoundry_domain.origin_url.id
  space  = data.cloudfoundry_space.space.id
  target {
    app = data.cloudfoundry_app.tah.id
  }
}

resource "cloudfoundry_route" "foundation_route-n" {
  domain = data.cloudfoundry_domain.foundation_url.id
  space  = data.cloudfoundry_space.space.id
  target {
    app = data.cloudfoundry_app.tah.id
  }
}

data "cloudfoundry_service" "external_domain" {
  name = "external-domain"
}

resource "cloudfoundry_service_instance" "external_domain_instance" {
  name             = "domain-${var.env}"
  space            = data.cloudfoundry_space.space.id
  service_plan     = data.cloudfoundry_service.external_domain.service_plans[var.cdn_plan_name]
  recursive_delete = var.recursive_delete
  json_params      = "{\"domains\": \"${var.global_domain_name},${var.origin_domain_name},${var.regional_domain_name},${var.foundation_domain_name}\"}"
}
