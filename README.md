# Pericles

Welcome to Pericles !

Pericles was designed to make **API specification** easier.

## Installation

Pericles is a Ruby on Rails project, and currently runs on Ruby v2.3.1. Make sure you are using the right version before
 continuing.

To get the project up and running, proceed as follows (within the app's directory):

1. Install the required gems and dependencies:
   ```sh
   bundle install
   ```

2. This project uses PostgreSQL. Create the local databases for the different environments (development and test):
   ```sh
   createdb Pericles_GW_dev
   createdb Pericles_GW_test
   ```

3. Run the migrations:
   ```sh
   bundle exec rake db:migrate
   ```

4. Pericles uses Node.js (v7.10.1, currently), and Yarn to manage packages. We use
 [json-schema-faker](https://github.com/json-schema-faker/json-schema-faker) to generate JSON instances based on JSON Schemas,
 because we could not find a Ruby equivalent. To install the required packages, run:
   ```sh
   yarn install
   ```

* **Note**: Pericles uses [dotenv](https://github.com/bkeepers/dotenv) to manage environment variables in the test and development
 environments.
   * You should create a .env file in the project's directory,
   * Every environment variable you need (in the test and development environments) should be declared in this file. For instance:
      ```
      YOUR_ENVIRONMENT_VARIABLE=your_value
      ```

5. Pericles uses [Devise](https://github.com/plataformatec/devise) to manage authentication. More specifically, it lets users log
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
   * You should then create two environment variables in the .env file: `GOOGLE_APP_ID` and `GOOGLE_APP_SECRET`. The value for
    `GOOGLE_APP_ID` should be your OAuth client ID's "Client ID", and the value for `GOOGLE_APP_SECRET` should be your OAuth
    client ID's "Client secret".
   * Copy the following in the .env file (where `your_email_domain` could be, for instance, `@fabernovel.com`):
      ```
      INTERNAL_EMAIL_DOMAIN=your_email_domain
      ```
      Pericles will use this environment variable for authentication purposes. The only users that will be able to log in through
       OAuth2 are the users with an email address from the email domain you provided.

6. Below, we list the different environment variables that you should set up in your .env file:
   Name | Description | Example
   --- | --- | ---
   `ANDROID_COMPANY_DOMAIN_NAME` | Pericles allows to generate code in Java and Kotlin. The environment variable corresponds to what you would enter under 'Company Domain' when creating a project in Android Studio. It is then used to generate package names. Defaults to `com.example`. | `com.applidium`
   `GOOGLE_APP_ID` | Client ID of your OAuth client ID in the Google Developers Console. See part 5 of this section. | n/a
   `GOOGLE_APP_SECRET` | Client secret of your OAuth client ID in the Google Developers Console. See part 5 of this section. | n/a
   `INTERNAL_EMAIL_DOMAIN` | Email domain used for authentication purposes. See part 5 of this section. | `@fabernovel.com`
   `MAIL_DEFAULT_URL` | URL used to generate absolute links in emails | `pericles.fabernovel.com`
   `MAIL_SMTP_DOMAIN` | Domain of the from field in your email | `pericles.fabernovel.com`
   `MAIL_SMTP_PASSWORD` | Password to connect to your SMTP server | n/a
   `MAIL_SMTP_USERNAME` | Username to connect to your SMTP server | n/a
   `SECRET_KEY_BASE` | You can use `bundle exec rake secret` in the app's directory to generate this key. | n/a

7. You should now be able to run the project smoothly on your machine:
   ```sh
   bundle exec rails s
   ```

## Deployment on Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

To make sure that your newly deployed instance of Pericles works correctly, you should set up the environment variables mentioned
 in part 6 of the **Installation** section *on Heroku*.

The other installation steps (than step 6, which requires step 5) presented in the aforementioned section are not necessary when
 deploying on Heroku. The app will be deployed in the **production** environment, which means that in this context, anything
 related to the development and test environments should be ignored.

Finally, do not forget to replace `http://localhost:3000` by the URI (using https) of your newly deployed application when reading
 the instructions.

## Tests

To run tests, simply run (in the project's directory):
```sh
bundle exec rails test
```
