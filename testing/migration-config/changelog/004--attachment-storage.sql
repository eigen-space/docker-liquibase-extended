alter table finance.attachment drop url;
alter table finance.attachment add data bytea;
alter table finance.attachment add constraint attachment_email_id_name_uindex unique (email_id, name);

alter table finance.email add constraint email_external_id_uindex unique (external_id);
