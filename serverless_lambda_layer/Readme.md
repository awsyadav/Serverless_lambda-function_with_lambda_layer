## AWS Lambda Layers

A Layer is a ZIP archive that contains libraries and other dependencies that you can import at runtime for your lambda functions to use. 
It is especially useful if you have several AWS Lambda functions that use the same set of functions or libraries — you know, code reuse

Layers let you keep your deployment package small, which makes development easier. 
You can avoid errors that can occur when you install and package dependencies with your function code.
For Node.js, Python, and Ruby functions, you can develop your function code in the Lambda console as long as you keep your deployment package under 3 MB.
