resource "aws_ecr_repository" "default" {
  name                 = "terraform-test2"
  image_tag_mutability = "MUTABLE"
}