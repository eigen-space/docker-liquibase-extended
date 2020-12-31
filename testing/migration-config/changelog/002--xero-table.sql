create extension if not exists "uuid-ossp";

create table access_data.xero
(
    id                         uuid default uuid_generate_v4() not null constraint xero_token_pk primary key,
    environment                text,
    content                    jsonb,

    constraint xero_token_id_uindex unique (id)
);
