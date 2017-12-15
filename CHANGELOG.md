# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

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
