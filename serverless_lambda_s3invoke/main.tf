################
# Creating resource variable
################

variable "function_name" {
    default = ""
}
variable "handler_name" {
    default = ""
}
variable "runtime" {
    default = ""
 }
variable "timeout" {
   default = ""
}


###############
# fetching current account id
###############

data "aws_caller_identity" "current" {}

###############
# Creating Lambda resource
################
resource "aws_lambda_function" "test_lambda" {
  function_name    = "${var.function_name}"
  role             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSRoleForLambda"
  handler          = "${var.handler_name}.lambda_handler"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
  filename         = "${var.handler_name}.zip"
  source_code_hash = "${base64sha256(file("${var.handler_name}.zip"))}"
  environment {
    variables = {
      CreatedBy = "Terraform"
    }
  } 
}

##################
# Creating s3 resource for invoking to lambda function
##################
resource "aws_s3_bucket" "bucket" {
  bucket = "my-test-bucket-eu-west-1"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
##################
# Adding S3 bucket as trigger to my lambda and giving the permissions
##################
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = "${aws_s3_bucket.bucket.id}"
  lambda_function {
    lambda_function_arn = "${aws_lambda_function.test_lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "file-prefix"
    filter_suffix       = "file-extension"                                   
}
}
resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.function_name}"
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::${aws_s3_bucket.bucket.id}"
}

###########
# output of lambda arn
###########
output "arn" {

value = "${aws_lambda_function.test_lambda.arn}"

}
