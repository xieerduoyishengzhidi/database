use brandmanagement;
go

-- 用户注册
create proc sp_registeruser
    @username nvarchar(50),
    @password nvarchar(100),
    @role nvarchar(20),
    @phone nvarchar(20)
as
begin
    -- 检查用户名是否已存在
    if exists (select 1 from users where username = @username)
    begin
        return -1
    end;

    -- 插入新用户
    insert into users (username, password, role, phone)
    values (@username,@password,@role,@phone)

    -- 记录系统日志
    insert into systemlogs (userid,operationtype,operationcontent)
    values (
        scope_identity(), -- 用于获取当前作用域内最后插入的标识值
        'register',
        '新用户注册：' + @username
    )
end
go

-- 用户登录
create proc sp_userlogin
    @username nvarchar(50),
    @password nvarchar(100)
as
begin
    declare @userid int
    declare @storedpassword nvarchar(100)
    declare @role nvarchar(20)

    -- 验证用户
    select 
        @userid = userid,
        @storedpassword = password,
        @role = role
    from users 
    where username = @username

    -- 检查用户是否存在
    if @userid is null
    begin
        return -1
    end

    -- 验证密码
    if @storedpassword <> @password 
    begin
        return -2
    end

    -- 更新最后登录时间
    update users 
    set lastlogin = getdate()
    where userid = @userid;

    -- 记录登录日志
    insert into systemlogs (userid,operationtype,operationcontent)
    values (@userid,'login','用户登录成功')
end
go
