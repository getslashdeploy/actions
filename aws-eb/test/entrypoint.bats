#!/usr/bin/env bats

function setup() {
  # Override PATH to mock out the aws cli
  export PATH="$BATS_TEST_DIRNAME/bin:$PATH"
  # Ensure GITHUB_WORKSPACE is set
  export GITHUB_WORKSPACE='.'
}

@test "entrypoint runs successfully" {
  run $GITHUB_WORKSPACE/entrypoint.sh eb --help
  [ "$status" -eq 0 ]
}

@test "AWS_DEFAULT_REGION defaults to us-east-1" {
  run $GITHUB_WORKSPACE/entrypoint.sh eb --help
  [ "$status" -eq 0 ]
  [ "${lines[1]}" = "AWS_DEFAULT_REGION: us-east-1" ]
}

@test "AWS_DEFAULT_REGION may be overridden" {
  export AWS_DEFAULT_REGION=us-west-1
  run $GITHUB_WORKSPACE/entrypoint.sh eb --help
  [ "$status" -eq 0 ]
  [ "${lines[1]}" = "AWS_DEFAULT_REGION: us-west-1" ]
}

@test "AWS_DEFAULT_OUTPUT defaults to json" {
  run $GITHUB_WORKSPACE/entrypoint.sh eb --help
  [ "$status" -eq 0 ]
  [ "${lines[2]}" = "AWS_DEFAULT_OUTPUT: json" ]
}

@test "AWS_DEFAULT_OUTPUT may be overridden" {
  export AWS_DEFAULT_OUTPUT=text
  run $GITHUB_WORKSPACE/entrypoint.sh eb --help
  [ "$status" -eq 0 ]
  [ "${lines[2]}" = "AWS_DEFAULT_OUTPUT: text" ]
}

@test "output is preserved" {
  export HOME="$BATS_TMPDIR"
  export GITHUB_ACTION="github_action"
  run $GITHUB_WORKSPACE/entrypoint.sh help
  actual=$( cat "${HOME}/${GITHUB_ACTION}.json" )
  [ -f "${HOME}/${GITHUB_ACTION}.json" ]
  [ "$output" = "$actual" ]
}
