-- Init entity to origin table
--------------------------------------------

create table finance.entity_to_origin(
     id                         uuid default uuid_generate_v4() not null constraint entity_to_origin_pk primary key,
     entity_id                  uuid,
     origin_id                  uuid,

     constraint entity_to_origin_id_uindex unique (id)
);

-- Fill by the date from the document, email and enrichment_source
--------------------------------------------

insert into finance.entity_to_origin(entity_id, origin_id) (
    select id as entity_id, origin_id from finance.document
    union
    select id as entity_id, origin_id from finance.email
    union
    select id as entity_id, origin_id from finance.enrichment_source
);
