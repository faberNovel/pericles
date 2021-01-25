# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## 0.11.6 - 2021-01-25

* Fix news order
* Fix crash in reports analysis

## 0.11.5 - 2021-01-20

* Bump Ruby, Rails, Kaminari and rails/webpacker
* Use cache in Actions (thanks @Mrchoclate)
* Update changelog (thanks @cchantep)
* Add root key missing in swagger request bodies
* Hide passwords in reports
* Add validation on request body in report
* Fix error section in a report not displayed if the only error was a status_error
* Fix error not displayed if a body error description did not match
* Delete past errors before saving new errors when validating a report
* Add button to get a representation's JSON schema
* Stay on the instance tab when a mock instance has been created
* Add all attributes to representation by default
* Fix order in daily slack posts
* Fix wording in news
* Add query parameters to every HTTP verbs

## 0.11.4 - 2020-05-27

* Add API to create Routes, Ressources and Representations (thanks @Mrchoclate)
* Switch Kotlin code generation to snake case (thanks @flolom)

## 0.11.3 - 2020-04-17

* Confirm email at signup (thanks @ThibaultTourailles)
* Display attr enum as comma separated code tags
* Add requests in exported json schema (thanks @MrChoclate)
* Handle headers that have list values (like Strict-Transport-Security)
* Add graphql format for resource and resource representation (thanks @MrChoclate)

## 0.11.2 - 2019-12-06

* Fix the datetime format for json schema (thanks @grizio)
* Bump rubyzip to fix security issue

## 0.11.1 - 2019-11-19

* Add API Gateway integration (thanks @grizio)
* Improve security schemes (thanks @grizio)
* Add operation id to route (thanks @grizio)
* Add test action on Github PR
* Bump loofah to fix security issues
* Bump to latest Ruby version

## 0.11.0 - 2019-09-26

* Add security schemes (thanks @grizio)
* Fix a bug in typescript export when resource has a string attribute
* Bump devise, mixin-deep and set-value to fix security issues

## 0.10.2 - 2019-08-20

* Escape description in vue-markdown
* Fix broken svg images in vue components
* Do not load validation errors into memory when cleaning old reports
* Add default internal email domain in test env

## 0.10.1 - 2019-08-14

* Fix typescript generation (thanks @grizio)
* Support Markdown in description (thanks @grizio)
* Add title on representation color dot (thanks @grizio)
* Upgrade to webpacker 4
* Bump fstream to fix security issues

## 0.10.0 - 2019-08-05

* Add users management page
* Fix issue with mocks when query string contains id parameter
* Bump lodash and js-yaml to fix security issues

## 0.9.0 - 2019-07-12

* Add Slack integration
* Disable resource/representation deletion when used by other resources/representatins
* Cap the proxy:clean_reports memory footprint

## 0.8.11 - 2019-05-29

* Add priority on mock pickers

## 0.8.10 - 2019-05-23

* Use API error name as UID in Swagger

## 0.8.9 - 2019-05-23

* Bump rubyzip version to fix security issues
* Handle invalid JSON in report validation

## 0.8.8 - 2019-05-22

* Bump bootstrap-sass version to fix security issues
* Use resource representation name as UID in Swagger for request too

## 0.8.7 - 2019-05-22

* Use resource representation name as UID in Swagger

## 0.8.6 - 2019-05-07

* Bump Rails and Ruby version to fix security issues

## 0.8.5 - 2019-04-12

* Fix Elixir proxy HTTP client to handle 304

## 0.8.4 - 2019-04-11

* Replace Elixir proxy HTTP client to fix crash with redirection when using HTTP proxy

## 0.8.3 - 2019-04-4

* Fix call to removed Rails proxy route helper

## 0.8.2 - 2019-04-4

* Remove Rails proxy source code
* Add created attributes from json in default resource representation
* Add button to revalidate report
* Limit resources tree to not seen nested resources
* Add NewRelic to proxy
* Fix date parsing on Safari and Firefox
* Add missing nodejs buildpack to Heroku config file

## 0.8.1 - 2019-03-7
* Add news page
* Remove java code generation
* Migrate from Google+ Sign-In to Google Sign-in

## 0.8.0 - 2019-02-26
* Report page is now filterable
* Add nullable to metadata

## 0.7.4 - 2019-02-08
* Fix swagger export
* Fix issue in route description where {{}} was used
* Can now add key to metadata_responses

## 0.7.3 - 2019-01-14
* Reports are destroyed when project is destroyed
* Add a 30 seconds cache on json schema

## 0.7.2 - 2018-11-02
* Fix Elixir proxy error

## 0.7.1 - 2018-10-31

* Fix swagger export
* Fix issue with file in proxy
* Fix unwanted proxy config deletion
* Fix issue with boolean in ts generation of resource representation

## 0.7.0 - 2018-10-02

* Add has_many and belongs_to to ruby serializer code generation
* Reports no longer need 10 minutes to be analyzed
* Fix bug with mock generation
* Add form to create REST (CRUD) routes from resource
* Use same order in edit_attributes page
* Fix issue with scheme container width
* Fix issues with proxy
* Remove default Authorization header
* Better typescript generator 
* Allow to copy json schema via text mode
* Display query parameters first instead of headers

## 0.6.7 - 2018-09-11

* Fix infinite loop
* Better json display for route show

## 0.6.6 - 2018-09-05

* Add type Object and any for attributes
* Add ruby serializers generation from resource/resource representation
* Add typescript interface and mapper generation from resource/resource representation
* Sort routes index by url and method
* Automatically clean reports older than 1 month

## 0.6.5 - 2018-09-04

* Handle null value in JSON importer
* A route resource is now updatable
* Validate report even if route is missing

## 0.6.4 - 2018-08-16

* Proxy handles connection error
* Add instances number to mock response
* Better README style
* Fix sensitive value hide in proxy

## 0.6.3 - 2018-06-06

* Add buttons to select representation in new mock page
* Display (required) for representation attributes
* Hide sensitive values in proxy report
* Minor fixes and improvements

## 0.6.2 - 2018-05-04

* Welcome Docker 👋🐳 (thanks @julienmession)
* Fix proxy report crash when oneOf was used
* Grouped report type errors
* Polished resource page layout

## 0.6.1 - 2018-03-20

* Generate json schema of api error from example
* Better error messages
* Add a button to delete mock profile
* Submit button are at the top
* Full screen manage representations
* Minor fixes

## 0.6.0 - 2018-03-20

* Add a global search
* Sidebar new design

## 0.5.3 - 2018-03-05

* Add a swagger format for projects
* Show isRequired and isNull in non managed mode
* Allow to search different words without spaces
* Fix login issue
* Fix proxy issue

## 0.5.2 - 2018-02-21

* Add an option for the proxy to use an http proxy (like Squid)
* Use cache first strategy for resources page
* Add search by name in resources page
* Add an unused section in resources page

## 0.5.1 - 2018-02-14

* Fix mock profile page

## 0.5.0 - 2018-02-13

* Add metadata and metadatum instances
* Metadata can be added to responses (keys are not required)
* No longer automaticaly add attribute to default representation
* Add buttons to download Kotlin and Swift code
* Add a 'tree' visualization for resources
* Minor fixes

## 0.4.1 - 2018-02-06

* Group representation by resources for route request and response form
* Add clone button for resource representation
* Allow empty body for response
* Add a resource link in route summary
* Add a button to get an archive of all mock instances of a profile
* Search attributes by name in resource page
* Sort attributes by name or type in resource page
* List where the resource is used in resource page
* Minor fixes

## 0.4.0 - 2018-02-02

* Overhaul of resource page
* Fix issue with proxy not creating a report for a json response
* Fix swift code having lint warning and wrong boolean types
* Fix issue with valid resource instance marked as invalid


## 0.3.1 - 2018-01-22

* Added deploy to Heroku button
* Added sign in link on projects index if user not logged
* Fix api errors controller issues
* Fix json schema generation

## 0.3.0 - 2018-01-17

* Add date and datetime types
* User can now register via web interface
* Project can now be public and visible by everyone
* Create 'external' member who can be added to a project
* Generate Decodable swift code
* Add buttons to download all the Rest class of a project (swift, kotlin and java)
* Oauth domain is now configurable through env variables
* Fix proxy issue with empty body
* Added AGPL licence

## 0.2.2 - 2017-12-28

* Select a String by default for new attribute
* Proxy now works for gzip encoding
* Add Schemes to navbar
* Request body is not bounded to the route's resource
* Add custom key name to representation
* Add 3 buttons to generate code (java, swift and kotlin) from resource

## 0.2.1 - 2017-12-20

* Rewriting of attributes form
* Add inheritance to mock profiles

## 0.2.0 - 2017-12-15

* JSON schema is now automaticaly generated
* Add minItems and maxItems constraints for array
* Create Mock Profiles
* Create API errors
* Create Resources and API Instances
* Remove unused description fields
* Create matchers to bind Mock profile with instances. Matching is done on url and body using regexp
* Add download button to download all JSON Schemas of a project
* Resource can be created from JSON. Nested resource must be created first and are found using JSON key name
* Route can be created from a global new Route button. A select is used to find the related Resource
* Minors UX/UI improvements


## 0.1.4 - 2017-10-23

## Changed

* Fix attributes form horizontal scroll
* Tab selection when resource representation contains a space
* Hide generate doc button
* Routes grouped by resources
* Fix active menu selection
* Move resource representation info in routes
* Auto-generate a JSON instance on route show
* New resource form contains only name and description
* Delete project button moved in left column
* Remove non pertinent fields from resource form
* Response pill color according to its status
* Body is now the first tab of response and request
* Meta schema now embedded in codebase

## Added
* Clean old reports
* New project default description
* New route default description
* Link to resource in routes index
* Create route button from routes index

## 0.1.4 - 2017-10-23

## Changed

* Fix route resolution if url is escaped (proxy)

## 0.1.3 - 2017-10-23

## Changed

* Proxy uses encoded URL

## 0.1.2 - 2017-10-23

## Changed

* JSON Schema are now generated with additionalProperties = false

## 0.1.1 - 2017-10-19

## Changed

* Proxy follows redirection

## 0.1.0 - 2017-10-17

## Added

* A changelog 🎉
* Rollbar monitoring

## Changed

* Route first response and resource first response are now automatically unfolded
