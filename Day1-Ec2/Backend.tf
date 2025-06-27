terraform {
  backend "s3" {
    bucket = "siribucketttt"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}
