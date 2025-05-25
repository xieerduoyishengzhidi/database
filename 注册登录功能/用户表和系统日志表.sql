use brandmanagement
go

-- 创建用户表
create table users (
    userid int primary key identity(1,1),
    username nvarchar(50) not null unique,
    password nvarchar(100) not null,  
    role nvarchar(20) not null check (role in ('customer', 'merchant', 'admin')),
    phone nvarchar(20) not null,
    registerdate datetime default getdate(),
    lastlogin datetime
)

-- 创建系统日志表
create table systemlogs (
    logid int primary key identity(1,1),
    userid int,
    operationtype nvarchar(50) not null,
    operationcontent nvarchar(max),
    operationtime datetime default getdate(),
    foreign key (userid) references users(userid)
)