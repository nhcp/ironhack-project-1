terraform {
  backend "s3" {
    bucket         = "ironhack-project1-tfstate-686699774218"
    key            = "main/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ironhack-project1-tf-locks"
    profile        = "nazmul"
    encrypt        = true
  }
}
