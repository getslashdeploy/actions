#!/bin/sh
#
# Deploys to AWS EB and report status to GitHub Deployment API
# Depends on https://github.com/unacast/actions/tree/master/github-deploy
#

# Respect AWS_DEFAULT_REGION if specified
[ -n "$AWS_DEFAULT_REGION" ] || export AWS_DEFAULT_REGION=us-east-1

# Pending
${HOME}/bin/deployment-create-status pending

# Execute
output=$( sh -c "eb $*" )

# Failure
RESULT=$?
if [ 0 != "${RESULT}" ]; then
  echo "Failed '$*'! Exit code '${RESULT}' is not equal to 0"
  ${HOME}/bin/deployment-create-status failure
  exit ${RESULT}
fi

# Preserve output for consumption by downstream actions
echo "$output" > "${HOME}/${GITHUB_ACTION}.${AWS_DEFAULT_OUTPUT}"

# Write output to STDOUT
echo "$output"

# Success
${HOME}/bin/deployment-create-status success

exit 0
