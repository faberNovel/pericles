var jsf = require('json-schema-faker');
// jsf.option({ optionalsProbability: 1.0 }); TODO Uncomment when https://github.com/json-schema-faker/json-schema-faker/issues/477#issuecomment-510525609 fixed

var schema = JSON.parse(process.argv[2]);
var json = jsf.generate(schema);

console.log(JSON.stringify(json));
