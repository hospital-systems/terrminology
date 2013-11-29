Terrminology
===============


![alt travis](https://travis-ci.org/hospital-systems/terrminology.png "travis")


FHIR Terminology for ruby


# Usage

```
  term = Terminology::Facade.new(sequel_db)
  term.create_valueset(fhir_json)
  #TODO: more documentation

  term.concenpts('identifier_of_valuest', code: 'active') #=> concept
```


