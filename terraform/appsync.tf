resource "aws_appsync_graphql_api" "messages" {
  authentication_type = "API_KEY"
  name                = "${local.project-name}-messages"
}

resource "aws_appsync_api_key" "example" {
  api_id  = "${aws_appsync_graphql_api.messages.id}"
  expires = "2019-10-01T04:00:00Z"
}

resource "aws_appsync_datasource" "messages" {
  api_id           = "${aws_appsync_graphql_api.messages.id}"
  name             = "${local.project-name}_messages"
  service_role_arn = "${aws_iam_role.appsync-messages.arn}"
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = "${aws_dynamodb_table.messages.name}"
    region = "${data.aws_region.current.name}"
  }
}

resource "aws_cloudformation_stack" "appsync-messages" {
  name = "${local.project-name}"

  parameters {
    ApiId = "${aws_appsync_graphql_api.messages.id}"
    MessageDataSourceName = "${aws_appsync_datasource.messages.name}"
  }

//  template_body = <<EOF
//{
//  "Parameters" : {
//    "ApiId" : {
//      "Type" : "String",
//      "Description" : "GraphQL API ID"
//    }
//  },
//  "Resources" : {
//    "AppSyncGraphQLSchemaMessages": {
//      "Type" : "AWS::AppSync::GraphQLSchema",
//      "Properties" : {
//        "Definition" : "${file("messages.graphql")}",
//        "ApiId" : { "Ref" : "ApiId" }
//      }
//    }
//  }
//}
//EOF
  template_body = <<EOF
Parameters:
  ApiId:
    Type: String
  MessageDataSourceName:
    Type: String

Resources:
  AppSyncGraphQLSchemaMessages:
    Type: AWS::AppSync::GraphQLSchema
    Properties:
      ApiId: !Ref ApiId
      Definition: |
        type Message {
            id: ID!
            text: String
            timestamp: String
        }

        type Query {
            singleMessage(id: ID!): Message
        }

        schema {
            query: Query
        }

  AppSyncResolverMessages:
    Type: AWS::AppSync::Resolver
    Properties:
      ApiId: !Ref ApiId
      TypeName: Query
      FieldName: singleMessage
      DataSourceName: !Ref MessageDataSourceName
      RequestMappingTemplate: |
        ## Below example shows how to look up an item with a Primary Key of "id" from GraphQL arguments
        ## The helper $util.dynamodb.toDynamoDBJson automatically converts to a DynamoDB formatted request
        ## There is a "context" object with arguments, identity, headers, and parent field information you can access.
        ## It also has a shorthand notation avaialable:
        ##  - $context or $ctx is the root object
        ##  - $ctx.arguments or $ctx.args contains arguments
        ##  - $ctx.identity has caller information, such as $ctx.identity.username
        ##  - $ctx.request.headers contains headers, such as $context.request.headers.xyz
        ##  - $ctx.source is a map of the parent field, for instance $ctx.source.xyz
        ## Read more: https://docs.aws.amazon.com/appsync/latest/devguide/resolver-mapping-template-reference.html

        {
            "version": "2017-02-28",
            "operation": "GetItem",
            "key": {
                "id": $util.dynamodb.toDynamoDBJson($ctx.args.id),
            }
        }
      ResponseMappingTemplate: |
        ## Pass back the result from DynamoDB. **
        $util.toJson($ctx.result)
EOF
}

resource "aws_iam_role" "appsync-messages" {
  name = "example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "appsync.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "appsync-messages-dynamodb" {
  name = "${local.project-name}-appsync-messages-dynamodb"
  role = "${aws_iam_role.appsync-messages.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_dynamodb_table.messages.arn}"
      ]
    }
  ]
}
EOF
}
