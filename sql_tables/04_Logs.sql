create table audit_logs (
    log_id int identity(1,1) primary key,
    table_name varchar(50) not null,
    record_id int not null,
    old_value nvarchar(max) not null,
    new_value nvarchar(max) not null,
    changed_at datetime not null default getdate()
)