module "vpc" {
  source = "./vpc"

  vpc_cidr          = var.vpc_cidr
  public_subnets    = var.public_subnets
  private_subnets   = var.private_subnets
  availability_zones = var.availability_zones
  cluster_name      = var.cluster_name
}


module "eks" {
  source = "./eks"

  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnets
}



module "node_groups" {
  source = "./node-groups"

  cluster_name        = module.eks.cluster_name
  private_subnet_ids  = module.vpc.private_subnets

  desired_size = 2
  min_size     = 1
  max_size     = 4
}

module "alb_controller" {
  source = "./alb-controller"

  cluster_name       = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.cluster_oidc_issuer_url
  aws_region        = var.aws_region
}
