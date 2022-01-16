# Terraform

## Set up a new environment

Prerequisite: install the `jq` JSON processor: `brew install jq`

The below steps rely on you first configuring access to the Terraform state in s3 as described in [Terraform State Credentials](#terraform-state-credentials).

1. Set up a service key
    ```bash
    # login to the appropriate foundry
    ./switch_foundation.sh <FOUNDRY_NUMBER>
    # follow temporary authorization code prompts
    # select the desired cloud.gov org and environment space

    # create a space deployer service instance that can log in with just a username and password
    # the value of < SPACE-NAME > should be `staging` or `prod` depending on where you are working
    # the value for < SERVICE-NAME > can be anything, although we recommend
    # something that communicates the purpose of the deployer
    # for example: circleci-deployer for the credentials CircleCI uses to
    # deploy the application
    ./create_space_deployer.sh <SPACE-NAME> <SERVICE-NAME> > foundry_<X>/<env>/secrets.auto.tfvars
    ```

    The script will output the `username` (as `cf_user`) and `password` (as `cf_password`) for your `<SERVICE-NAME>`. Read more in the [cloud.gov service account documentation](https://cloud.gov/docs/services/cloud-gov-service-account/).

    The easiest way to use this script is to redirect the output directly to the `secrets.auto.tfvars` file it needs to be used in

1. `cd` to the foundry/env you are working in

1. Run terraform from your new environment directory with
    ```bash
    terraform init
    terraform plan
    ```

1. Apply changes with `terraform apply`.

  *TKTK, information about how the terraform gets applied by CI/CD, when we do that.*

1. Remove the space deployer service instance if it doesn't need to be used again, such as when manually running terraform once.
    ```bash
    # <SPACE-NAME> and <SERVICE-NAME> have the same values as used above.
    ./destroy_space_deployer.sh <SPACE-NAME> <SERVICE-NAME>
    ```

## Structure

Each foundry has it's own folder with bootstrap s3 module for storing state, and staging and prod environments.

Each environment has its own module, which relies on a shared module for everything except the providers code and environment specific variables and settings.

```
- foundry_x/
  |- bootstrap/
     |- main.tf
     |- providers.tf
     |- variables.tf
     |- run.sh
     |- teardown_creds.sh
     |- import.sh
  |- <env>/
     |- main.tf
     |- providers.tf
     |- secrets.auto.tfvars
     |- secrets.auto.tfvars.example
     |- variables.tf
- shared/
  |- s3/
     |- main.tf
     |- providers.tf
     |- variables.tf
  |- database/
     |- main.tf
     |- providers.tf
     |- variables.tf
```

In the shared modules:
- `providers.tf` contains set up instructions for Terraform about Cloud Foundry and AWS
- `main.tf` sets up the data and resources the application relies on
- `variables.tf` lists the required variables and applicable default values

In the environment-specific modules:
- `providers.tf` lists the required providers
- `main.tf` calls the shared Terraform code, but this is also a place where you can add any other services, resources, etc, which you would like to set up for that environment
- `variables.tf` lists the variables that will be needed, either to pass through to the child module or for use in this module
- `secrets.auto.tfvars` is a file which contains the information about the service-key and other secrets that should not be shared

In the bootstrap module:
- `providers.tf` lists the required providers
- `main.tf` sets up s3 bucket to be shared across all environments. It lives in `prod` to communicate that it should not be deleted
- `variables.tf` lists the variables that will be needed. Most values are hard-coded in this module
- `run.sh` Helper script to set up a space deployer and run terraform. The terraform action (`show`/`plan`/`apply`/`destroy`) is passed as an argument
- `teardown_creds.sh` Helper script to remove the space deployer setup as part of `run.sh`
- `import.sh` Helper script to create a new local state file in case terraform changes are needed

## Terraform State Credentials

The bootstrap module is used to create an s3 bucket for later terraform runs to store their state in.

### Retrieving existing bucket credentials

1. login to the appropriate foundry with `./switch_foundation.sh <FOUNDRY_NUMBER>`
1. Run `./run.sh show`
1. Follow instructions under `Use bootstrap credentials`

### Bootstrapping the state storage s3 buckets

1. login to the appropriate foundry with `./switch_foundation.sh <FOUNDRY_NUMBER>`
1. Run `terraform init`
1. Run `./run.sh plan` to verify that the changes are what you expect
1. Run `./run.sh apply` to set up the bucket and retrieve credentials
1. Follow instructions under `Use bootstrap credentials`
1. Ensure that `import.sh` includes a line and correct IDs for any resources created
1. Run `./teardown_creds.sh` to remove the space deployer account used to create the s3 bucket

### To make changes to the bootstrap module

1. login to the appropriate foundry with `./switch_foundation.sh <FOUNDRY_NUMBER>`
1. Run `terraform init`
1. If you don't have terraform state locally:
  1. run `./import.sh`
  1. optionally run `./run.sh apply` to include the existing outputs in the state file
1. Make your changes
1. Continue from step 2 of the boostrapping instructions

#### Use bootstrap credentials

1. Add the following to `~/.aws/credentials` (where X is the foundry number)
    ```
    [tah-foundry-X-backend]
    aws_access_key_id = <access_key_id from bucket_credentials>
    aws_secret_access_key = <secret_access_key from bucket_credentials>
    ```

1. Copy `bucket` from `bucket_credentials` output to the backend block of `foundry_X/<env>/providers.tf`
