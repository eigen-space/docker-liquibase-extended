update finance.sync_state
set meta = meta - 'uid' || jsonb_build_object('externalEmailId', meta->'uid')
where name = 'email_adapter';
