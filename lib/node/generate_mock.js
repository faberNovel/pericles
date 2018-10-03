var jsf = require('json-schema-faker');
var schema = JSON.parse(process.argv[2]);
var json = jsf.generate(schema);

console.log(JSON.stringify(json));
