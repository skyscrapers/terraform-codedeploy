resource "aws_codedeploy_app" "app" {
  name = "${var.project}-${var.name}"
}
