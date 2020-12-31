alter table taxonomies.space rename column employee_id to admin_contact_id;

alter table taxonomies.employee add first_name text;
alter table taxonomies.employee add last_name text;
alter table taxonomies.employee add photo_url text;
alter table taxonomies.employee add telegram_username text;


