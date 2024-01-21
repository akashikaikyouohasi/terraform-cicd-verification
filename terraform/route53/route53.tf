resource "aws_ecr_repository" "default" {
  name                 = "terraform-test3"
  image_tag_mutability = "MUTABLE"
}