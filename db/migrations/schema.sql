--db:fhir_value_sets
--{{{
    -- drop table fhir_value_sets_schema_migrations;
    drop schema IF EXISTS fhir_value_sets cascade;
    create schema fhir_value_sets;
    create extension IF NOT EXISTS "uuid-ossp";
    drop type if exists value_set_status;
    create type value_set_status as enum ('draft', 'active', 'retired');

    create table fhir_value_sets.value_sets (
      value_set_id   uuid primary key default uuid_generate_v4(),
      identifier     varchar,
      version        varchar,
      name           varchar            not null,
      publisher      varchar,
      description    varchar            not null,
      copyright      varchar,
      status         value_set_status   not null,
      experimental   boolean,
      extensible     boolean,
      date           timestamp
    );

    create table fhir_value_sets.defines (
      define_id      uuid primary key default uuid_generate_v4(),
      value_set_id   uuid not null,
      system         varchar not null,
      version        varchar,
      case_sensitive boolean
    );

    create table fhir_value_sets.concepts (
      concept_id     uuid primary key default uuid_generate_v4(),
      define_id      uuid not null,
      code           varchar not null,
      abstract       boolean,
      display        varchar,
      definition     varchar,
      parent_id      uuid,
      path           varchar
    );
--}}}
