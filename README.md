Pericles
&middot;
![Language](https://img.shields.io/badge/language-Ruby-red.svg)
![Framework](https://img.shields.io/badge/framework-Rails-red.svg)
![License](https://img.shields.io/github/license/applidium/Pericles.svg)
[![Twitter](https://img.shields.io/badge/twitter-@applidium-blue.svg)](https://twitter.com/applidium)
======

<p align="center" >
  <img src="banner.jpg" alt="Pericles">
</p>

Pericles was designed to make **API specification** easier.

## Installation

To run the project locally, you have the choice between using containers or setup your own machine.

### Use docker-compose

Create your own `docker-compose.yml` based on the [sample](docker-compose.yml.sample), then run:

```sh
docker build -t pericles:ruby-2.7 .
docker-compose up
```

### Setup your machine

Pericles is a Ruby on Rails project. To get the project up and running, proceed as follows (within the app's directory):

1. Install the version of Ruby specified at the top of the [Gemfile](Gemfile#L2) along with the bundler gem.

2. Install the required gems and dependencies:
   ```sh
   bundle install
   ```

3. This project uses PostgreSQL. Create the local databases for the different environments (development and test):
   ```sh
   createdb Pericles_GW_dev
   createdb Pericles_GW_test
   ```

4. Run the migrations:
   ```sh
   bundle exec rake db:migrate
   ```

5. Pericles uses [Node.js](https://nodejs.org), and [Yarn](https://yarnpkg.com) to manage packages. We use
 [json-schema-faker](https://github.com/json-schema-faker/json-schema-faker) to generate JSON instances based on JSON Schemas,
 because we could not find a Ruby equivalent. To install the required packages, run:
   ```sh
   yarn install
   ```

6. Pericles uses [dotenv](https://github.com/bkeepers/dotenv) to manage [environment variables](#environment-variables) in the test and development
 environments.
   * You should create a .env file in the project's directory,
   * Every environment variable you need (in the test and development environments) should be declared in this file. For instance:
      ```
      YOUR_ENVIRONMENT_VARIABLE=your_value
      ```

7. You should now be able to run the project smoothly on your machine:
   ```sh
   bundle exec rails s
   ```

## Environment variables

Name | Description | Example
--- |--- | ---
`SECRET_KEY_BASE` | You can use `bundle exec rake secret` in the app's directory to generate this key. | n/a
`GOOGLE_APP_ID` | Client ID of your OAuth client ID in the Google Developers Console. Check [Google OAuth2](#google-oauth2). | n/a
`GOOGLE_APP_SECRET` | Client secret of your OAuth client ID in the Google Developers Console. [Google OAuth2](#google-oauth2). | n/a
`INTERNAL_EMAIL_DOMAIN` | Email domain used for authentication purposes. [Google OAuth2](#google-oauth2). | `@fabernovel.com`
`MAIL_DEFAULT_URL` | Public URL to Pericles instance used to generate absolute links in emails | `pericles.fabernovel.com`
`MAIL_SMTP_DOMAIN` | Domain of the from field in your email | `pericles.fabernovel.com`
`MAIL_SMTP_PASSWORD` | Password to connect to your SMTP server | n/a
`MAIL_SMTP_USERNAME` | Username to connect to your SMTP server | n/a
`ANDROID_COMPANY_DOMAIN_NAME` | Pericles allows to generate code in Kotlin. The environment variable corresponds to what you would enter under 'Company Domain' when creating a project in Android Studio. It is then used to generate package names. Defaults to `com.example`. | `com.applidium`
`RAILS_ENV` | Rails environment. Defauls to `development`.  | `production`
`PORT` | Port on which the web server will listen. Defaults to `3000`. | `8080`
`DATABASE_URL` | The URL of your PostgreSQL database. Defaults to [database.yml](config/database.yml). | `postgres://username:password@host/database`
`RAILS_SERVE_STATIC_FILES` | In case your reverse proxy do not serve static files. Defaults to `false`. | `enabled`
`RAILS_DISABLE_FORCE_SSL` | In case your reverse proxy do not handle SSL. Defaults to `false`. | `enabled`
`PROXY_HOST` | The host of your [Elixir proxy](proxy)
`SLACK_CLIENT_ID` | Client ID of your Slack app. Check [Slack integration](#slack-integration). | `1234567890.1234567890`
`SLACK_CLIENT_SECRET` | Client secret of your Slack app. Check [Slack integration](#slack-integration). | `abcdef123456789`

### Google OAuth2

Pericles uses [Devise](https://github.com/plataformatec/devise) to manage authentication. More specifically, it lets users log
 in using their Google account via OAuth2. To make this work, you need to:
* Create a project on [Google Developers Console](https://console.developers.google.com),
* Follow the instructions [here](https://github.com/zquestz/omniauth-google-oauth2#google-api-setup) (in the Google API
 Setup section),
* On the Google Developers Console (in your project) go to Credentials, and click on the Credentials tab on top. Click on
 "Create Credentials", and choose "OAuth client ID". Choose "Web application" for "Application type". Choose a name for your
 OAuth client ID. In "Authorized JavaScript origins", add `http://localhost:3000` (the URI of the application when run
 locally). In "Authorized redirect URIs", add `http://localhost:3000/users/auth/google_oauth2/callback` (the URI, when the
 application is run locally, which users are redirected to after being authenticated with Google). You can then click on
 "Save".
* Once your OAuth client ID was created, it should appear (in Credentials, in the Credentials tab) under
 "OAuth 2.0 client IDs". You can click on it to view its details.
* The value for `GOOGLE_APP_ID` should be your OAuth client ID's "Client ID", and the value for `GOOGLE_APP_SECRET` should be your OAuth
 client ID's "Client secret".
* Pericles will use INTERNAL_EMAIL_DOMAIN environment variable for authentication purposes. The only users that will be able to log in through OAuth2 are the users from the email domain you provided.

### Slack integration

If you want to post recent news on Slack, you can [create a Slack app](https://api.slack.com/apps). Then:

1. Enable the *Incoming webhooks* feature.
2. Enable OAuth and whitelist the redirect URL which should looks like `https://YOUR_HOST/projects`.
3. Set the `SLACK_CLIENT_ID` and `SLACK_CLIENT_SECRET` env variables.

To automate this posting, use the `audits:slack_post` rake task in a cron/scheduler.

## Deployment

To make sure that your newly deployed instance of Pericles works correctly, you should set up the [environment variables](#environment-variables). Do not forget to replace `http://localhost:3000` by the URI (using https) of your newly deployed application when reading the instructions.

### Heroku

Heroku automatically set `RAILS_ENV`, `PORT`, `DATABASE_URL` (see [Heroku Postgres](https://elements.heroku.com/addons/heroku-postgresql)) and `RAILS_SERVE_STATIC_FILES` for you.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

### Container

The [Dockerfile](Dockerfile) defines a container with a web server listening on the PORT environment variable.

## Tests

To run tests, simply run (in the project's directory):

```sh
bundle exec rails test
```
