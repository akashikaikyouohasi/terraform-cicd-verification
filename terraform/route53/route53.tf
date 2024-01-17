resource "aws_ecr_repository" "default" {
  name                 = "terraform-test"
  image_tag_mutability = "MUTABLE"
}