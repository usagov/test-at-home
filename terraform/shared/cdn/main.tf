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

resource "cloudfoundry_domain" "url" {
  name = var.public_domain_name
  org  = var.cf_org_name
}

data "cloudfoundry_app" "tah" {
  name_or_id = "test_at_home-${var.env}"
  space      = data.cloudfoundry_space.space.id
}

resource "cloudfoundry_route" "external_route" {
  domain = resource.cloudfoundry_domain.url.id
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
  json_params      = "{\"domains\": \"${var.public_domain_name}\"}"
}
