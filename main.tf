resource "aws_api_gateway_rest_api" "rest-api" {
  name                     = "Rest API for testing gzip"
  minimum_compression_size = var.minimum_compression_length
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "Rest API"
      version = "1.0"
    }
    paths = {
      "/foo" = {
        get = {
          responses = {
            "200" = {
              "description" = "200 response"
              "schema" = {
                "$ref" = "#/definitions/Empty"
              }
            }
          }
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP"
            uri                  = "https://reqres.in/api/users"
            responses = {
              default = {
                statusCode = 200
              }
            }
            "passthroughBehavior" = "when_no_match"
          }
        }
        definitions = {
          Empty = {
            type  = "object"
            title = "Empty Schema"
          }
        }
      }
    }
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest-api.id
  description = "Terraform robot deployment beep boop beep!"

  triggers = {
    redeployment = sha1(join(",", tolist(
      [
        jsonencode(module.lambda_with_api.source_code_hash),
        sha1(jsonencode(aws_api_gateway_rest_api.rest-api.body))
      ]
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest-api.id
  stage_name    = "dev"
}

module "lambda_with_api" {
  source         = "./modules/lambda"
  api_gateway_id = aws_api_gateway_rest_api.rest-api.id
  src_path       = "./src"
  description    = "Test Lambda for gzip"
  name           = "tf-test-lambda-gzip"
}