--db:terrminology
--{{{
    -- drop table terrminology_schema_migrations;
    drop schema IF EXISTS terrminology cascade;
    create schema terrminology;
    create extension IF NOT EXISTS "uuid-ossp";
    drop type if exists value_set_status;
    create type value_set_status as enum ('draft', 'active', 'retired');
    drop type if exists concept_map_equivalence;
    create type concept_map_equivalence as enum ('equal', 'equivalent', 'wider', 'narrower', 'inexact', 'unmatched', 'disjoint');

    create table terrminology.value_sets (
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

    create table terrminology.defines (
      define_id      uuid primary key default uuid_generate_v4(),
      value_set_id   uuid not null,
      system         varchar not null,
      version        varchar,
      case_sensitive boolean
    );

    create table terrminology.concepts (
      concept_id     uuid primary key default uuid_generate_v4(),
      define_id      uuid not null,
      code           varchar not null,
      abstract       boolean,
      display        varchar,
      definition     varchar,
      parent_id      uuid,
      path           varchar
    );

    create table terrminology.concept_maps (
      concept_map_id    uuid primary key default uuid_generate_v4(),
      identifier        varchar,
      version           varchar,
      name              varchar            not null,
      publisher         varchar,
      description       varchar            not null,
      copyright         varchar,
      status            value_set_status   not null,
      experimental      boolean,
      date              timestamp,
      source            uuid               not null,
      target            uuid               not null
    );

    create table terrminology.source_concepts (
      source_concept_id uuid primary key default uuid_generate_v4(),
      concept_map_id    uuid            not null,
      name              varchar,
      system            varchar,
      code              varchar,
      parent_id         uuid,
      path              varchar
    );

    create table terrminology.maps (
      map_id            uuid primary key default uuid_generate_v4(),
      system            varchar,
      code              varchar,
      equivalence       concept_map_equivalence not null,
      comments          varchar
    )
--}}}
