
resource "aws_iam_role" "replication" {
  name = "s3-vr-role"

  assume_role_policy = var.assume_role_policy
}
resource "aws_iam_policy" "replication" {
  name = "s3-vr-policy"

  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket" "destination" {
  bucket = "s3-version-bucc"
}

resource "aws_s3_bucket_versioning" "destination" {
  bucket = aws_s3_bucket.destination.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "source" {
  provider = aws.replica

  bucket   = "s3replication-buc"
}

resource "aws_s3_bucket_acl" "source_bucket_acl" {
  provider = aws.replica

  bucket = aws_s3_bucket.source.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.replica

  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.replica
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source.id

  rule {
    id = "foobar"

    filter {
      prefix = "foo"
    }

    status = "Enabled"

    delete_marker_replication {
  status = "Enabled"
}

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}
