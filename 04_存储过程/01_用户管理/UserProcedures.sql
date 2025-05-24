USE BrandManagement;
GO

-- 用户注册
CREATE PROCEDURE sp_RegisterUser
    @Username NVARCHAR(50),
    @Password NVARCHAR(100),
    @Role NVARCHAR(20),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @SecurityQuestion NVARCHAR(200),
    @SecurityAnswer NVARCHAR(200)
AS
BEGIN
    BEGIN TRY
        -- 参数验证
        IF @Username IS NULL OR @Password IS NULL OR @Role IS NULL
        BEGIN
            RAISERROR('用户名、密码和角色不能为空', 16, 1);
            RETURN;
        END;

        -- 检查用户名是否已存在
        IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
        BEGIN
            RAISERROR('用户名已存在', 16, 1);
            RETURN;
        END;

        -- 检查角色是否有效
        IF @Role NOT IN ('Customer', 'Merchant', 'Admin')
        BEGIN
            RAISERROR('无效的角色类型', 16, 1);
            RETURN;
        END;

        -- 插入新用户
        INSERT INTO Users (
            Username, 
            Password, 
            Role, 
            Email, 
            Phone, 
            SecurityQuestion, 
            SecurityAnswer
        )
        VALUES (
            @Username,
            @Password,  -- 注意：实际应用中应该加密存储
            @Role,
            @Email,
            @Phone,
            @SecurityQuestion,
            @SecurityAnswer  -- 注意：实际应用中应该加密存储
        );

        -- 记录系统日志
        INSERT INTO SystemLogs (
            UserID,
            OperationType,
            OperationContent
        )
        VALUES (
            SCOPE_IDENTITY(),
            'Register',
            '新用户注册：' + @Username
        );

        SELECT SCOPE_IDENTITY() AS NewUserID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 用户登录
CREATE PROCEDURE sp_UserLogin
    @Username NVARCHAR(50),
    @Password NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @UserID INT;
        DECLARE @StoredPassword NVARCHAR(100);
        DECLARE @Role NVARCHAR(20);

        -- 验证用户
        SELECT 
            @UserID = UserID,
            @StoredPassword = Password,
            @Role = Role
        FROM Users 
        WHERE Username = @Username;

        -- 检查用户是否存在
        IF @UserID IS NULL
        BEGIN
            RAISERROR('用户名不存在', 16, 1);
            RETURN;
        END;

        -- 验证密码
        IF @StoredPassword <> @Password  -- 注意：实际应用中应该使用加密比较
        BEGIN
            RAISERROR('密码错误', 16, 1);
            RETURN;
        END;

        -- 更新最后登录时间
        UPDATE Users 
        SET LastLogin = GETDATE()
        WHERE UserID = @UserID;

        -- 记录登录日志
        INSERT INTO SystemLogs (
            UserID,
            OperationType,
            OperationContent
        )
        VALUES (
            @UserID,
            'Login',
            '用户登录成功'
        );

        -- 返回用户信息
        SELECT 
            UserID,
            Username,
            Role,
            Email,
            Phone
        FROM Users
        WHERE UserID = @UserID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 密码找回
CREATE PROCEDURE sp_ResetPassword
    @Username NVARCHAR(50),
    @SecurityAnswer NVARCHAR(200),
    @NewPassword NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @UserID INT;
        DECLARE @StoredAnswer NVARCHAR(200);

        -- 获取用户信息
        SELECT 
            @UserID = UserID,
            @StoredAnswer = SecurityAnswer
        FROM Users 
        WHERE Username = @Username;

        -- 检查用户是否存在
        IF @UserID IS NULL
        BEGIN
            RAISERROR('用户名不存在', 16, 1);
            RETURN;
        END;

        -- 验证密保答案
        IF @StoredAnswer <> @SecurityAnswer  -- 注意：实际应用中应该使用加密比较
        BEGIN
            RAISERROR('密保答案错误', 16, 1);
            RETURN;
        END;

        -- 更新密码
        UPDATE Users 
        SET Password = @NewPassword  -- 注意：实际应用中应该加密存储
        WHERE UserID = @UserID;

        -- 记录密码重置日志
        INSERT INTO SystemLogs (
            UserID,
            OperationType,
            OperationContent
        )
        VALUES (
            @UserID,
            'ResetPassword',
            '密码重置成功'
        );

        SELECT '密码重置成功' AS Message;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 