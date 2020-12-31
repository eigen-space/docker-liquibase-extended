create schema finance;
alter schema finance owner to postgres;

create schema taxonomies;
alter schema taxonomies owner to postgres;

create extension if not exists "uuid-ossp";

create table finance.email
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
alter table finance.email owner to postgres;

create unique index email_id_uindex
    on finance.email (id);

create table finance.attachment
(
    id                       uuid default uuid_generate_v4() not null constraint attachment_pk primary key,
    email_id                 uuid,
    type                     text,
    name                     text,
    url                      text,

    constraint attachment_email_fk
      foreign key (email_id) references finance.email (id)
);

alter table finance.attachment
    owner to postgres;

create unique index attachment_id_uindex
    on finance.attachment (id);

create table finance.sync_state
(
    id        uuid default uuid_generate_v4() not null
        constraint sync_state_pkey
            primary key,
    name      text                            not null,
    meta     jsonb not null
);
alter table finance.sync_state owner to postgres;

create unique index sync_state_id_uindex
    on finance.sync_state (id);

create unique index sync_state_name_uindex
    on finance.sync_state (name);

create table finance.document
(
    id                         uuid default uuid_generate_v4() not null constraint document_pk primary key,
    attachment_id              uuid,
    external_id                text,
    status                     text,

    deduplication_key          text,

    type                       text,
    number                     text,
    po_number                  text,
    issue_date                 text,
    due_date                   text,
    currency                   text,

    tax_amount                  float4,
    net_amount                  float4,
    total_amount                float4,

    space                      text,
    cost_center                text,

    vendor_id                  uuid,
    customer_id                uuid,

    constraint document_id_uindex unique (id),
    constraint document_deduplication_key_uindex unique (deduplication_key)
);

create table finance.reflexia_document
(
    id                         uuid default uuid_generate_v4() not null constraint reflexia_document_pk primary key,
    reflexia_document_id       bigint,
    failed                     bool,

    constraint reflexia_document_id_uindex unique (id)
);
alter table finance.reflexia_document alter column reflexia_document_id set not null;

create unique index reflexia_document_reflexia_document_id_uindex
    on finance.reflexia_document (reflexia_document_id);


create table finance.document_line
(
    id                         uuid default uuid_generate_v4() not null constraint document_line_pk primary key,
    document_id                uuid,
    item_code                  text,
    description                text,
    quantity                   int,

    vat_rate                   float4,
    net_price                  float4,

    space                      text,
    cost_center                text,

    constraint document_line_id_uindex unique (id)
);

create table finance.raw_document
(
    id                       uuid default uuid_generate_v4() not null constraint raw_document_pk primary key,
    content                  jsonb,
    parent_id                uuid not null unique,

    constraint raw_document_document_fk
      foreign key (parent_id) references finance.document (id)
);

alter table finance.raw_document
    owner to postgres;

create unique index raw_document_id_uindex
    on finance.raw_document (id);

create table taxonomies.space
(
    id                 bigserial not null ,
    name               text   not null,
    city               text,
    country            text,
    bamboo_location_id bigint,
    active             boolean default true,
    address            text,
    employee_id        integer,
    notes              text,
    constraint space_name_non_empty check ((name <> ''::text))
);

alter table taxonomies.space
    owner to postgres;

create unique index space_id_uindex
    on taxonomies.space (id);

create table taxonomies.cost_center
(
    id                   bigserial not null,
    name                 text   not null,
    bamboo_department_id bigint,
    active               boolean default true,
    xero_project_id      uuid,
    constraint cost_center_name_non_empty check ((name <> ''::text))
);

alter table taxonomies.cost_center
    owner to postgres;

create table taxonomies.bamboo_department
(
    id       bigserial constraint bamboo_department_id_pk unique,
    name     text,
    active   bool
);

alter table taxonomies.bamboo_department
    owner to postgres;

create table taxonomies.xero_project
(
    id       uuid default uuid_generate_v4() not null constraint xero_project_pk primary key,
    name     text,
    active   bool
);

alter table taxonomies.xero_project
    owner to postgres;

create table taxonomies.bamboo_location
(
    id       bigserial constraint bamboo_location_id_pk unique,
    name     text,
    active   bool
);

alter table taxonomies.bamboo_location
    owner to postgres;

create table taxonomies.employee
(
    id       bigserial constraint employee_id_pk unique,
    name     text,
    active   bool
);

alter table taxonomies.employee
    owner to postgres;
