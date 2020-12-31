-- Add external_id to origin
--------------------------------------------

alter table finance.origin
add column external_id text;

-- Move external_id to origin from document, email and enrichment_source
--------------------------------------------

update finance.origin
set external_id = (
    select external_id from (
      select external_id, origin_id
      from finance.document
      union
      select cast(external_id as text), origin_id
      from finance.email
      union
      select external_id, origin_id
      from finance.enrichment_source
    ) as d where d.origin_id = finance.origin.id
 )
from finance.origin o;

-- Remove origin_id
--------------------------------------------

alter table finance.document
drop column origin_id;

alter table finance.email
drop column origin_id;

alter table finance.enrichment_source
drop column origin_id;

-- Remove external_id
--------------------------------------------

alter table finance.document
drop column external_id;

alter table finance.email
drop column external_id;

alter table finance.enrichment_source
drop column external_id;
