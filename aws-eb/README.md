# GitHub Actions for AWS Elastic Beanstalk

This Action for [AWS](https://aws.amazon.com/) enables arbitrary actions for interacting with AWS Elastic Beanstalk service via [the `eb` command-line client](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html). It's based on the [GitHub Actions for AWS](https://github.com/actions/aws).

## Usage

The example below illustrates how to deploy to AWS Elastic Beanstalk and report status back to [GitHub Deployment API](https://developer.github.com/v3/repos/deployments/), so that [SlashDeploy](https://getslashdeploy.com/) could process the deployment and notify Slack.

```
workflow "Deploy to AWS EB" {
  on = "deployment"
  resolves = ["deploy"]
}

action "deploy.scripts" {
  uses = "unacast/actions/github-deploy@master"
}

action "deploy" {
  uses = "getslashdeploy/actions/aws-eb@master"
  secrets = ["GITHUB_TOKEN"]
  args = "deploy <ENTER NAME OF EB ENVIRONMENT>"
  needs = ["deploy.scripts"]
}
```

### Secrets

- `AWS_ACCESS_KEY_ID` – **Required** The AWS access key part of your credentials ([more info](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys))
- `AWS_SECRET_ACCESS_KEY` – **Required** The AWS secret access key part of your credentials ([more info](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys))

### Environment variables

All environment variables listed in [the official documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html) are supported.

We provide defaults for the following, these may also be overridden:

- `AWS_DEFAULT_REGION`- **Optional** The AWS region name, defaults to `us-east-1` ([more info](https://docs.aws.amazon.com/general/latest/gr/rande.html))
- `AWS_DEFAULT_OUTPUT`- **Optional** The CLI's output output format, defaults to `json` ([more info](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html))
- `AWS_PROFILE` - **Optional** The AWS profile with the credentials and options to use, defaults to `eb-cli`. ([more info](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html))

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

Container images built with this project include third party materials. See [THIRD_PARTY_NOTICE.md](THIRD_PARTY_NOTICE.md) for details.
