resource "aws_ecr_repository" "default" {
  name                 = "terraform-test2d"
  image_tag_mutability =     "MUTABLE"
}