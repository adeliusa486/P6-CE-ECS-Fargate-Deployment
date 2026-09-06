# ==============================================================================
# AWS ECR (Elastic Container Registry)
# This is our private vault for storing Docker images.
# Fargate will pull the image from here when it boots up.
# ==============================================================================

resource "aws_ecr_repository" "app_repo" {
  name                 = "${local.name_prefix}-app-repo"
  image_tag_mutability = "MUTABLE" # Allows us to overwrite the 'latest' tag
  force_delete         = true      # Allows terraform destroy to work even if images are inside!

  # Security best practice: Automatically scan images for vulnerabilities on push
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Output the URL of the repository so we can use it to push our image
output "ecr_repository_url" {
  value       = aws_ecr_repository.app_repo.repository_url
  description = "The URL of the ECR repository. You will use this in your docker push commands."
}