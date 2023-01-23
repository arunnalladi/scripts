resource "aws_s3_bucket" "s3bucket" {
  bucket = var.bucket
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.s3bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "s3bucket" {
  bucket = aws_s3_bucket.s3bucket.id

  acl = "public-read"
}

resource "aws_s3_bucket_policy" "s3bucket" {
  bucket = aws_s3_bucket.s3bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.s3bucket.arn,
          "${aws_s3_bucket.s3bucket.arn}/*",
        ]
      },
    ]
  })
}