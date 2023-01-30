# Pineapp infra

This project manages lambdas and deployment in an Amazon API Gateway

In order to add a new lambda please take a look at `api--config.tf` it has an array containing the lambda configuration
for your API, just add a new item

Has  an array like this :

```hcl
 lambdas = [

  {
    name          = "awesome-lambda"
    roleName      = "role-basic-lambda-${var.environment}",
    resource_path = "awesome",
    method        = "POST",
    parent_resource = (aws_api_gateway_resource.awesome)
    authorizer    = false,
    
  },
  {
    name          = "cool-lambda"
    roleName      = "role-basic-lambda-${var.environment}",
    resource_path = "cool",
    method        = "GET",
    parent_resource = (aws_api_gateway_resource.cool)
    authorizer    = false,
    
  }
]
```

## Inputs

| Name | Description                                                                          | Type |  Required |
|------|--------------------------------------------------------------------------------------|:----:|:-----:|
| name | lambda name                                                                          | string  | yes |
| roleName | existing role name                                                                   | string | yes |
| resource_path | name path in your api                                                                | string  | yes |
| method | http method (POST,GET,PUT,etc)                                                       | string  | yes |
| authorizer | whether to configure with an authorizer or not (ignore it or delete it if you want ) | bool  | yes |
| parent_resource | API parent resource, should be an aws_api_gateway_resource                           | string  | yes |


