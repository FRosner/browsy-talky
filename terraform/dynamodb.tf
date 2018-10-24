resource "aws_dynamodb_table" "messages" {
  name           = "${local.project-name}-messages"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

/*
query GetMessage {
  singleMessage(id: 1) {
    id
  }
}
*/

/*
type Message {
	id: ID!
	text: String
}

type Query {
	singleMessage(id: ID!): Message
}

schema {
	query: Query
}
*/