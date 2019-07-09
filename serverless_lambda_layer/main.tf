############################################
# Variables zone
############################################

variable "layerfilename" {
  default = ""
}
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

# current account_id
data "aws_caller_identity" "current" {}

###############################################
# Resource lambda_function creation
###############################################

resource "aws_lambda_function" "test_lambda" {
  function_name    = "${var.function_name}"                                  #Lambda Function name 
  role             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSRoleForLambda"
  handler          = "${var.handler_name}.lambda_handler"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
  filename         = "${var.handler_name}.zip"                                 # pass lambda_function code
  source_code_hash = "${base64sha256(file("${var.handler_name}.zip"))}"
  layers              = ["${aws_lambda_layer_version.lambda_layer.arn}"]        #attach lambda_layer arn
  environment {
    variables = {
      CreatedBy = "Terraform"
    }
  } 
}

#################################################
# Resource Lambda layer creation
#################################################

resource "aws_lambda_layer_version" "lambda_layer" {
  filename = "lambda_function.zip"                                        #Pass the lambda layer version code
  layer_name = "lambda_layer_name"

  compatible_runtimes = ["python3.6"]
}