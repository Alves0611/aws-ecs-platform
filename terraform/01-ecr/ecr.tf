resource "aws_ecr_repository" "this" {
  for_each = var.repositories

  name                 = each.key
  image_tag_mutability = each.value.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }

  encryption_configuration {
    encryption_type = each.value.encryption_type
  }

  tags = merge(
    var.common_tags,
    {
      Name = each.key
    }
  )
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = {
    for k, v in var.repositories : k => v
    if v.lifecycle_policy != ""
  }

  repository = aws_ecr_repository.this[each.key].name

  policy = each.value.lifecycle_policy
}

