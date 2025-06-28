##############################
# Upload Lambda ZIP to S3
##############################

resource "aws_s3_object" "lambda_code" {
  bucket = "shirishamendabucket123"
  key    = "lambdacode.zip"
  source = "lambdacode.zip"
  etag   = filemd5("lambdacode.zip")
}

##############################
# Bucket Policy to Allow Lambda Access
##############################

resource "aws_s3_bucket_policy" "lambda_bucket_policy" {
  bucket = "shirishamendabucket123"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::150292692856:root"
        },
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::shirishamendabucket123",
          "arn:aws:s3:::shirishamendabucket123/*"
        ]
      }
    ]
  })
}

##############################
# IAM Role for Lambda
##############################

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS Managed Policy for CloudWatch Logs
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom policy allowing Lambda to read from the bucket (optional but good)
resource "aws_iam_policy" "lambda_s3_read" {
  name = "lambda-s3-read"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::shirishamendabucket123",
          "arn:aws:s3:::shirishamendabucket123/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_s3_read.arn
}

##############################
# Lambda Function
##############################

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  s3_bucket     = "shirishamendabucket123"
  s3_key        = aws_s3_object.lambda_code.key
  timeout       = 100
  memory_size   = 128

  environment {
    variables = {
      ENV_VAR_KEY = "ENV_VAR_VALUE"
    }
  }

  tags = {
    Name = "MyLambdaFunction"
  }
}

