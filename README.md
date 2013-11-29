Terrminology
===============

[![Build Status](https://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png)](https://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME])

FHIR Terminology for ruby

## Usage

```
  term = Terminology::Facade.new(sequel_db)
  term.create_valueset(fhir_json)
  #TODO: more documentation

  term.concenpts('identifier_of_valuest', code: 'active') #=> concept
```


