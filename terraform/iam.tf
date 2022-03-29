########################################################################################################################
## IAM Roles
########################################################################################################################

#-----------------------------------------------------------------------------------------------------------------------
#- Event Runner
#-
#- Used for CloudWatch events and State Machines
#-----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "event_runner_assume" {
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

resource "aws_iam_role" "event_runner" {
  name = "${terraform.workspace}-event-runner"

  assume_role_policy = data.aws_iam_policy_document.event_runner_assume.json
}
