Terrminology
===============

[![Build Status](https://travis-ci.org/hospital-systems/terrminology.png)](https://travis-ci.org/hospital-systems/terminology)
[![Code Climate](https://codeclimate.com/repos/529897abf3ea0036eb14a375/badges/f3fbcdadcc946573bc33/gpa.png)](https://codeclimate.com/repos/529897abf3ea0036eb14a375/feed)

CTS2-like module for FHIR in ruby

## Installation

```sh
 psql -c 'create database terrminology;' -U travis
 sequel -m db/migrations postgres:///terrminology
 rspec spec/
```

## Usage

```ruby
  term = Terminology::Facade.new(sequel_db)
  term.create_valueset(fhir_json)
  #TODO: more documentation

  term.concenpts('identifier_of_valuest', code: 'active') #=> concept
```


