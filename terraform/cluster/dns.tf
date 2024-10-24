resource "desec_domain" "this" {
  name = "sudbrock.eu"
}

resource "desec_rrset" "sudbrock-eu-A" {
  domain = "sudbrock.eu"
  subname = ""
  type = "A"
  records = [ hcloud_server.worker.ipv4_address ]
  ttl = desec_domain.this.minimum_ttl
}

resource "desec_rrset" "sudbrock-eu-star" {
  domain = "sudbrock.eu"
  subname = "*"
  type = "A"
  records = [ hcloud_server.worker.ipv4_address ]
  ttl = desec_domain.this.minimum_ttl
}