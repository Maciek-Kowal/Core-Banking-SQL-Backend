create view v_corporate_holding_balances as
select c.customer_id, c.company_name, c.parent_company_id, a.balance, sum(a.balance) over(partition by c.parent_company_id) as holding_total_balance from customers c
join accounts a on c.customer_id = a.customer_id
where c.customer_type = 'corporate' and c.parent_company_id is not null and c.is_active = 1 and a.is_active = 1