create view v_active_customer_accounts as
select c.customer_id, c.first_name, c.last_name, a.account_id, a.balance from customers c
join accounts a on c.customer_id = a.customer_id
where a.is_active = 1 and c.is_active = 1

