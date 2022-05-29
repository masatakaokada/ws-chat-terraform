resource "aws_s3_bucket" "alb_log" {
  bucket        = "alb-log-ws-chat-app"
  force_destroy = true # TODO あとで削除する
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_log_config" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    id = "expiration-rule"

    expiration {
      days = 180
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["582318560864"]
    }
  }
}
