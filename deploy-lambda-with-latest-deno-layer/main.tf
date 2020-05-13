data "external" "deno_layer" {
  program = ["node", "${path.module}/get-release.js"]
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = data.external.deno_layer.result.file
  layer_name = "deno_lambda_layer"
  source_code_hash = filebase64sha256(data.external.deno_layer.result.file)
}

output "external_source" {
  value = data.external.deno_layer.result
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "index.ts"
  output_path = "lambda.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_deno_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "deno_lambda" {
  filename      = "lambda.zip"
  function_name = "deno_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  runtime = "provided"

  layers = [aws_lambda_layer_version.lambda_layer.arn]

}