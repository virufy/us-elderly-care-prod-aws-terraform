module "vpc" {
  source  = "./01-vpc"
  project = var.project
  env     = var.env
  azs     = var.azs
}

module "endpoints" {
  source             = "./02-endpoints"
  project            = var.project
  env                = var.env
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  route_table_ids    = module.vpc.private_route_table_ids
}

module "lambda" {
  source             = "./03-lambda"
  project            = var.project
  env                = var.env
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  s3_bucket_arn      = module.s3_ddb.raw_audio_bucket_arn
  s3_bucket_name     = module.s3_ddb.raw_audio_bucket_name
  dynamodb_table_arn = module.s3_ddb.patient_data_table_arn
}

module "s3_ddb" {
  source  = "./04-s3-ddb"
  project = var.project
  env     = var.env
}

module "apigateway" {
  source     = "./05-apigateway"
  project    = var.project
  env        = var.env
  lambda_arn = module.lambda.lambda_arn
}

module "stepfunctions" {
  source     = "./06-stepfunctions"
  project    = var.project
  env        = var.env
  lambda_arn = module.lambda.lambda_arn
}

