resource "google_compute_network" "custom_vpc" {
  name                            = "${var.custom_prefix}-vpc"
  project                         = var.project_id
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
  mtu                             = 1460
  routing_mode                    = "REGIONAL"
}

resource "google_compute_subnetwork" "subnets" {
  count = length(var.subnets)

  name                     = "${var.custom_prefix}-${var.subnets[count.index].name}"
  network                  = google_compute_network.custom_vpc.self_link
  ip_cidr_range            = var.subnets[count.index].cidr_range
  region                   = var.subnets[count.index].region
  private_ip_google_access = var.subnets[count.index].private_ip_google_access

  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = var.subnets[count.index].purpose
  stack_type                 = "IPV4_ONLY"

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    filter_expr          = null
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    metadata_fields      = []
  }
  
  depends_on = [
    google_compute_network.custom_vpc
  ]
}

resource "google_compute_firewall" "firewalls" {
  count = length(var.firewalls)

  name      = "${var.custom_prefix}-${var.firewalls[count.index].name}-fw"
  network   = google_compute_network.custom_vpc.self_link
  direction = var.firewalls[count.index].direction
  priority  = var.firewalls[count.index].priority

  source_ranges = var.firewalls[count.index].source_ranges
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  dynamic "allow" {
    for_each = var.firewalls[count.index].allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = var.firewalls[count.index].deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  depends_on = [
    google_compute_network.custom_vpc
  ]
}

resource "google_compute_router" "route_table" {
  name    = "${var.custom_prefix}-rtr"
  region  = var.subnets[0].region
  project = var.project_id
  network = google_compute_network.custom_vpc.self_link

  depends_on = [
    google_compute_network.custom_vpc, google_compute_subnetwork.subnets
  ]
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${var.custom_prefix}-nat"
  router                             = google_compute_router.route_table.name
  region                             = google_compute_router.route_table.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  depends_on = [
    google_compute_network.custom_vpc, google_compute_router.route_table
  ]
}

