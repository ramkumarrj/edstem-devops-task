terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.7.0"
    }
  }
}

provider "google" {
  credentials = file("../../../../edstem-task.json")
  project     = "edstem-task"
}

module "custom_networking" {
  source         = "../../../gcp-resources-code/gcp-modules/custom_networking/"
  project_id     = var.project_id
  custom_prefix  = var.custom_prefix
  subnets        = var.subnets
  firewalls      = var.firewalls
}

module "service_accounts_tfvars" {
  source               = "../../../gcp-resources-code/gcp-modules/iam_and_security/service_account_tfvars/service_accounts_tfvars"    
  project_id           = var.project_id
  service_accounts_list_tfvars  = var.service_accounts_list_tfvars 
}

module "gke_roles_sa_bindings_tfvars" {
  source                 = "../../../gcp-resources-code/gcp-modules/iam_and_security/service_account_tfvars/role_bindings_tfvars"    
  project_id             = var.project_id
  service_account_email  = var.gke_service_account 
  roles_list             = var.gke_service_account_roles

  depends_on = [ 
    module.service_accounts_tfvars 
  ]
}

module "kubernetes_cluster" {
  source           = "../../../gcp-resources-code/gcp-modules/kubernetes_cluster"
  project_id       = var.project_id
  custom_prefix    = var.custom_prefix
  kubernetes_clusters  = var.kubernetes_clusters  

  depends_on = [ 
    module.custom_networking, module.service_accounts_tfvars, module.gke_roles_sa_bindings_tfvars
  ]
}