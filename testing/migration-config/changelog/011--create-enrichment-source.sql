create table finance.enrichment_source
(
    id                         uuid default uuid_generate_v4() not null constraint enrichment_source_pk primary key,
    external_id                text,
    type                       text,
    url                        text,

    constraint enrichment_source_id_uindex unique (id)
);
