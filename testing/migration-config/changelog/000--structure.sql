create schema testing;
alter schema testing owner to postgres;

create extension if not exists "uuid-ossp";

create table testing.item
(
    id                         uuid default uuid_generate_v4() not null constraint email_pk primary key,
    external_id                int,
    "from"                     text,
    "to"                       text,
    subject                    text,
    body                       text,
    date                       text,
    valid                      bool,
    constraint order_date_unique unique (external_id)
);
alter table testing.item owner to postgres;

create unique index email_id_uindex
    on testing.item (id);