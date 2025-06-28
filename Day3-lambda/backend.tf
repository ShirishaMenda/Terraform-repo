terraform {
  backend "s3" {
    bucket = "shirishamendabucket123"
    key    = "Day3/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
