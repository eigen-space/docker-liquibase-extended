alter table finance.attachment add valid bool
    constraint valid_constraint default (false);
