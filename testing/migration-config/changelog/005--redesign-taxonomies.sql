alter table taxonomies.cost_center add xero_name text;
alter table taxonomies.cost_center add constraint cost_center_xero_name_uindex unique (xero_name);

update taxonomies.cost_center cc
set xero_name = xp.name
from taxonomies.xero_project xp
where cc.xero_project_id = xp.id;

alter table taxonomies.space add xero_name text;
alter table taxonomies.space add constraint space_xero_name_uindex unique (xero_name);

alter table taxonomies.cost_center add constraint cost_center_name_uindex unique (name);
alter table taxonomies.space add constraint space_name_uindex unique (name);


