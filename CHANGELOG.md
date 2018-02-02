# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

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
