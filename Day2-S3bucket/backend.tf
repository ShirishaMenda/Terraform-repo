terraform {
  backend "s3" {
    bucket = "shirishamendabucket123"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}
