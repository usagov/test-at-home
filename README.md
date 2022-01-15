Test At Home
============

## Overview
A web-based, mobile-responsive solution for the public to submit a pre-order request for 1 set of four COVID-19 tests to be sent directly to their home through the USPS infrastructure. This solution is intended to be a back-up for the USPS web store, if it cannot stand peak traffic.

The launch date for this solution is January 17, 2022.

For more detail, see the [product scope doc](https://github.com/usagov/test-at-home/blob/main/doc/product/product-scope.md)

## Development

If you're new to Rails, see the [Getting Started with Rails](https://guides.rubyonrails.org/getting_started.html)
guide for an introduction to the framework.

### Local Setup

* Install Ruby 3.0.3
* Install NodeJS 16.13.1
* Install PostgreSQL: `brew install postgresql`
  * Add postgres to your PATH if it wasn't done automatically
  `echo 'export PATH="/usr/local/opt/postgresql/bin:$PATH"' >> ~/.zshrc`
  * Start the server
  `brew services start postgresql`
* Install Ruby dependencies: `bundle install`
* Install chromedriver for integration tests: `brew install --cask chromedriver`
  * Chromedriver must be allowed to run. You can either do that by:
    * The command line: `xattr -d com.apple.quarantine $(which chromedriver)` (this is the only option if you are on Big Sur)
    * Manually: clicking "allow" when you run the integration tests for the first time and a dialogue opens up
* Install JS dependencies: `yarn install`
* Build CSS and JS: `yarn build && yarn build:css`
* Create database: `bundle exec rake db:create`
* Run migrations: `bundle exec rake db:migrate`
* Run the server: `./bin/dev`
* Visit the site: http://localhost:3000

In staging and production environments, we cache pages. To mimic this in development, you can toggle caching by running `bin/rails dev:cache`. Page caching is off by default.

#### Local Configuration

Environment variables can be set in development using the [dotenv](https://github.com/bkeepers/dotenv) gem.

Consistent but sensitive credentials should be added to `config/credentials.yml.env` by using `$ rails credentials:edit`

Any changes to variables in `.env` that should not be checked into git should be set
in `.env.local`.

If you wish to override a config globally for the `test` Rails environment you can set it in `.env.test.local`.
However, any config that should be set on other machines should either go into `.env` or be explicitly set as part
of the test.

#### Authentication

This application does not contain an authentication component. All interaction is public/guest

### Inline `<script>` and `<style>` security

The system's Content-Security-Policy header prevents `<script>` and `<style>` tags from working without further
configuration. Use `<%= javascript_tag nonce: true %>` for inline javascript.

See the [CSP compliant script tag helpers](./doc/adr/0004-rails-csp-compliant-script-tag-helpers.md) ADR for
more information on setting these up successfully.

## Managing translation files

We use the gem `i18n-tasks` to manage translation files. Here are a few common tasks:

Add missing keys across locales:
```
$ i18n-tasks add-missing
```

Key sorting:
```
$ i18n-tasks normalize
```

Removing unused keys:
```
$ i18n-tasks unused
$ i18n-tasks remove-unused
```

For more information on usage and helpful rake tasks to manage translation files, see [the documentation](https://github.com/glebm/i18n-tasks#usage).


### Testing

#### Running tests

* Tests: `bundle exec rake spec`
* Ruby linter: `bundle exec rake standard`
* Accessibility scan: `./bin/pa11y-scan`
* Dynamic security scan: `./bin/owasp-scan`
* Ruby static security scan: `bundle exec rake brakeman`
* Ruby dependency checks: `bundle exec rake bundler:audit`
* JS dependency checks: `bundle exec rake yarn:audit`

Run everything: `bundle exec rake`

## CI/CD


CircleCI is in use as our CI/CD pipeline. All scans run on each PR, and security scans are also run
on a daily basis.


### Deployment

Each environment has dependencies on a PostgreSQL RDS instance managed by cloud.gov.
See [cloud.gov docs](https://cloud.gov/docs/services/relational-database/) for information on RDS.

#### Staging

First time only: create DB service with `cf create-service aws-rds micro-psql test_at_home-rds-stage`

`cf push --strategy rolling --vars-file config/deployment/stage.yml --var rails_master_key=$(cat config/master.key)`

#### Production

First time only: create DB service with `cf create-service aws-rds <<SERVICE_PLAN_NAME>> test_at_home-rds-prod`

`cf push --strategy rolling --vars-file config/deployment/prod.yml --var rails_master_key=$(cat config/master.key)`

### Configuring ENV variables in cloud.gov

All configuration that needs to be added to the deployed application's ENV should be added to
the `env:` block in `manifest.yml`

Items that are both **public** and **consistent** across staging and production can be set directly there.

Otherwise, they are set as a `((variable))` within `manifest.yml` and the variable is defined depending on sensitivity:

#### Credentials and other Secrets


1. Store variables that must be secret using [CircleCI Environment Variables](https://circleci.com/docs/2.0/env-vars/#setting-an-environment-variable-in-a-project)
1. TKTK, this step needs to be updated for CircleCI deployment pipeline. Add the secret to the `env:` block of the deploy action [as in this example](https://github.com/OHS-Hosting-Infrastructure/complaint-tracker/blob/a9e8d22aae2023a0afb631a6182251c04f597f7e/.github/workflows/deploy-stage.yml#L20)
1. TKTK, this step needs to be updated for CircleCI deployment pipeline. Add the appropriate `--var` addition to the `push_arguments` line on the deploy action [as in this example](https://github.com/OHS-Hosting-Infrastructure/complaint-tracker/blob/a9e8d22aae2023a0afb631a6182251c04f597f7e/.github/workflows/deploy-stage.yml#L27)


#### Non-secrets

Configuration that changes from staging to production, but is public, should be added to `config/deployment/stage.yml` and `config/deployment/prod.yml`



## Documentation

Architectural Decision Records (ADR) are stored in `doc/adr`
To create a new ADR, first install [ADR-tools](https://github.com/npryce/adr-tools) if you don't
already have it installed.
* `brew install adr-tools`

Then create the ADR:
*  `adr new Title Of Architectural Decision`

This will create a new, numbered ADR in the `doc/adr` directory.


## Contributing

*This will continue to evolve as the project moves forward.*

* Pull down the most recent main before checking out a branch
* Write your code
* If a big architectural decision was made, add an ADR
* Submit a PR
  * If you added functionality, please add tests.
  * All tests must pass!
* Ping the other engineers for a review.
* At least one approving review is required for merge.
* Rebase against main before merge to ensure your code is up-to-date!
* Merge after review.
  * Squash commits into meaningful chunks of work and ensure that your commit messages convey meaning.

## Story Acceptance

TBD
