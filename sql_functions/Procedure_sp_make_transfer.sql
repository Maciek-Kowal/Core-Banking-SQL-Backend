create procedure sp_make_transfer
    @sender_account_id int,
    @receiver_account_id int,
    @amount decimal(15,2)
as 
begin
    set nocount on;

    declare @sender_balance decimal(15,2);
    declare @receiver_balance decimal(15,2);
    declare @sender_iban varchar(34);
    declare @receiver_iban varchar(34);

    select @sender_balance = balance, @sender_iban = iban 
    from accounts 
    where account_id = @sender_account_id and is_active = 1;

    select @receiver_balance = balance, @receiver_iban = iban 
    from accounts 
    where account_id = @receiver_account_id and is_active = 1;

    if @sender_balance is null or @receiver_balance is null
    begin
        throw 50001, 'One or both accounts are inactive or do not exist.', 1;
        return;
    end

    if @sender_balance < @amount
    begin
        throw 50002, 'Insufficient funds in sender account.', 1;
        return;
    end

    begin try
        begin transaction;

        update accounts 
        set balance = balance - @amount, updated_at = getdate() 
        where account_id = @sender_account_id;

        update accounts 
        set balance = balance + @amount, updated_at = getdate() 
        where account_id = @receiver_account_id;

        insert into transactions (
            sender_account_id, sender_iban, 
            receiver_account_id, receiver_iban, 
            amount, transaction_date, status, transaction_type
        )
        values (
            @sender_account_id, @sender_iban, 
            @receiver_account_id, @receiver_iban, 
            @amount, getdate(), 'COMPLETED', 'INTERNAL'
        );

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        throw;
    end catch
end
