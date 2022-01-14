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
  name_or_id = "test_at_home-${var.env}"
  space      = data.cloudfoundry_space.space.id
}

resource "cloudfoundry_domain" "global_url" {
  name = var.global_domain_name
  org  = var.cf_org_name
}

resource "cloudfoundry_route" "global_route" {
  domain = resource.cloudfoundry_domain.global_url.id
  space  = data.cloudfoundry_space.space.id
  target {
    app = data.cloudfoundry_app.tah.id
  }
}

resource "cloudfoundry_domain" "foundation_url" {
  name = var.foundation_domain_name
  org  = var.cf_org_name
}

resource "cloudfoundry_route" "foundation_route" {
  domain = resource.cloudfoundry_domain.foundation_url.id
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
  json_params      = "{\"domains\": \"${var.global_domain_name},${var.regional_route_name},${var.foundation_domain_name}\"}"
}
