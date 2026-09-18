create trigger trg_customers_audit_json
on customers
after update
as
begin
    if trigger_nestlevel() > 1 
        return
    insert into audit_logs (table_name, record_id, old_value, new_value)
    select 
        'customers',
        i.customer_id,
        (select * from deleted where customer_id = d.customer_id for json path, without_array_wrapper),
        (select * from inserted where customer_id = i.customer_id for json path, without_array_wrapper)
    from inserted i
    join deleted d on i.customer_id = d.customer_id
end
go

create trigger trg_accounts_audit_json
on accounts
after update
as
begin
     if trigger_nestlevel() > 1 
        return
    insert into audit_logs (table_name, record_id, old_value, new_value)
    select 
        'accounts',
        i.account_id,
        (select * from deleted where account_id = d.account_id for json path, without_array_wrapper),
        (select * from inserted where account_id = i.account_id for json path, without_array_wrapper)
    from inserted i
    join deleted d on i.account_id = d.account_id
end