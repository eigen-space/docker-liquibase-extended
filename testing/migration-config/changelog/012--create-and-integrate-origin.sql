-- Init origin table
--------------------------------------------

create table finance.origin
(
    id                         uuid default uuid_generate_v4() not null constraint origin_pk primary key,
    type                       text,
    content                    jsonb,

    constraint origin_id_uindex unique (id)
);

insert into finance.origin(id, content, type) select id, content, 'RossumAnnotation' from finance.raw_document;

-- Drop old alternatives
--------------------------------------------

alter table finance.raw_document drop constraint raw_document_document_fk;
drop table finance.raw_document;

-- Add references to related entities
--------------------------------------------

alter table finance.email
    add column origin_id uuid unique;

alter table finance.email
    add constraint origin_id foreign key (origin_id)
    references finance.origin (id);

alter table finance.document
    add column origin_id uuid unique;

alter table finance.document
    add constraint origin_id foreign key (origin_id)
    references finance.origin (id);

alter table finance.enrichment_source
    add column origin_id uuid unique;

alter table finance.enrichment_source
    add constraint origin_id foreign key (origin_id)
    references finance.origin (id);
