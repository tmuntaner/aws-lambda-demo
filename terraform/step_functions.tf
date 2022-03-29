########################################################################################################################
## Event Runner IAM Role
########################################################################################################################

data "aws_iam_policy_document" "sm_event_runner" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "states.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "sm_event_runner" {
  name = "${terraform.workspace}-aws-lanbda-demo-event-runner"

  assume_role_policy = data.aws_iam_policy_document.sm_event_runner.json
}

data "aws_iam_policy_document" "sm_invoker" {
  statement {
    sid = "lambda"
    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      module.hello_world.qualified_arn,
      module.greeter.qualified_arn,
    ]
  }

  statement {
    actions = [
      "states:StartExecution"
    ]

    # tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      "arn:aws:states:${data.aws_region.current.name}:*:stateMachine:*"
    ]
  }
}

resource "aws_iam_policy" "sm_invoker" {
  name   = "${terraform.workspace}-aws-lambda-demo-invoker"
  path   = "/"
  policy = data.aws_iam_policy_document.sm_invoker.json
}

resource "aws_iam_role_policy_attachment" "sm_invoker_1" {
  policy_arn = aws_iam_policy.sm_invoker.arn
  role       = aws_iam_role.event_runner.id
}

resource "aws_sfn_state_machine" "main" {
  name       = "${terraform.workspace}-aws-demo-greeter"
  role_arn   = aws_iam_role.event_runner.arn
  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Greeter",
  "States": {
    "Greeter": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "FunctionName": "${module.greeter.qualified_arn}"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "Next": "Map"
    },
    "Map": {
      "Type": "Map",
      "End": true,
      "Iterator": {
        "StartAt": "Hello World",
        "States": {
          "Hello World": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "${module.hello_world.qualified_arn}"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "End": true
          }
        }
      },
      "ItemsPath": "$.who_to_greet"
    }
  }
}
EOF
}
