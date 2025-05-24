USE BrandManagement;
GO

-- 创建订单
CREATE PROCEDURE sp_CreateOrder
    @UserID INT,
    @AddressID INT,
    @PaymentMethod NVARCHAR(50),
    @OrderItems OrderItemTableType READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 参数验证
        IF @UserID IS NULL OR @AddressID IS NULL OR @PaymentMethod IS NULL
        BEGIN
            RAISERROR('用户ID、地址ID和支付方式不能为空', 16, 1);
            RETURN;
        END;

        -- 检查用户是否存在
        IF NOT EXISTS (SELECT 1 FROM Users WHERE UserID = @UserID)
        BEGIN
            RAISERROR('用户不存在', 16, 1);
            RETURN;
        END;

        -- 检查地址是否存在且属于该用户
        IF NOT EXISTS (
            SELECT 1 
            FROM UserAddresses 
            WHERE AddressID = @AddressID AND UserID = @UserID
        )
        BEGIN
            RAISERROR('地址不存在或不属于该用户', 16, 1);
            RETURN;
        END;

        -- 检查购物车是否为空
        IF NOT EXISTS (SELECT 1 FROM @OrderItems)
        BEGIN
            RAISERROR('订单项不能为空', 16, 1);
            RETURN;
        END;

        -- 计算订单总金额
        DECLARE @TotalAmount DECIMAL(10,2) = 0;
        SELECT @TotalAmount = SUM(oi.Quantity * p.Price)
        FROM @OrderItems oi
        JOIN Products p ON oi.ProductID = p.ProductID;

        -- 创建订单
        INSERT INTO Orders (
            UserID,
            AddressID,
            TotalAmount,
            Status,
            PaymentMethod
        )
        VALUES (
            @UserID,
            @AddressID,
            @TotalAmount,
            'Pending',
            @PaymentMethod
        );

        DECLARE @OrderID INT = SCOPE_IDENTITY();

        -- 插入订单项
        INSERT INTO OrderItems (
            OrderID,
            ProductID,
            Quantity,
            Price
        )
        SELECT 
            @OrderID,
            oi.ProductID,
            oi.Quantity,
            p.Price
        FROM @OrderItems oi
        JOIN Products p ON oi.ProductID = p.ProductID;

        -- 更新库存
        UPDATE p
        SET p.Stock = p.Stock - oi.Quantity
        FROM Products p
        JOIN @OrderItems oi ON p.ProductID = oi.ProductID;

        -- 创建支付记录
        INSERT INTO PaymentRecords (
            OrderID,
            Amount,
            PaymentMethod,
            Status
        )
        VALUES (
            @OrderID,
            @TotalAmount,
            @PaymentMethod,
            'Pending'
        );

        -- 记录系统日志
        INSERT INTO SystemLogs (
            UserID,
            OperationType,
            OperationContent
        )
        VALUES (
            @UserID,
            'CreateOrder',
            '创建新订单：' + CAST(@OrderID AS NVARCHAR(10))
        );

        COMMIT TRANSACTION;

        SELECT @OrderID AS NewOrderID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 更新订单状态
CREATE PROCEDURE sp_UpdateOrderStatus
    @OrderID INT,
    @NewStatus NVARCHAR(50),
    @UpdatedBy INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 参数验证
        IF @OrderID IS NULL OR @NewStatus IS NULL OR @UpdatedBy IS NULL
        BEGIN
            RAISERROR('订单ID、新状态和更新者不能为空', 16, 1);
            RETURN;
        END;

        -- 检查订单是否存在
        IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
        BEGIN
            RAISERROR('订单不存在', 16, 1);
            RETURN;
        END;

        -- 检查更新者权限
        IF NOT EXISTS (
            SELECT 1 
            FROM Users 
            WHERE UserID = @UpdatedBy 
            AND Role IN ('Merchant', 'Admin')
        )
        BEGIN
            RAISERROR('只有商家或管理员可以更新订单状态', 16, 1);
            RETURN;
        END;

        -- 更新订单状态
        UPDATE Orders
        SET Status = @NewStatus,
            UpdatedAt = GETDATE()
        WHERE OrderID = @OrderID;

        -- 如果订单取消，恢复库存
        IF @NewStatus = 'Cancelled'
        BEGIN
            UPDATE p
            SET p.Stock = p.Stock + oi.Quantity
            FROM Products p
            JOIN OrderItems oi ON p.ProductID = oi.ProductID
            WHERE oi.OrderID = @OrderID;
        END;

        -- 记录系统日志
        INSERT INTO SystemLogs (
            UserID,
            OperationType,
            OperationContent
        )
        VALUES (
            @UpdatedBy,
            'UpdateOrderStatus',
            '更新订单状态：' + CAST(@OrderID AS NVARCHAR(10)) + ' -> ' + @NewStatus
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 获取订单详情
CREATE PROCEDURE sp_GetOrderDetails
    @OrderID INT
AS
BEGIN
    BEGIN TRY
        SELECT 
            o.OrderID,
            o.UserID,
            u.Username,
            o.AddressID,
            a.Address,
            o.TotalAmount,
            o.Status,
            o.PaymentMethod,
            o.CreatedAt,
            o.UpdatedAt,
            oi.ProductID,
            p.Name AS ProductName,
            oi.Quantity,
            oi.Price,
            (oi.Quantity * oi.Price) AS ItemTotal
        FROM Orders o
        JOIN Users u ON o.UserID = u.UserID
        JOIN UserAddresses a ON o.AddressID = a.AddressID
        JOIN OrderItems oi ON o.OrderID = oi.OrderID
        JOIN Products p ON oi.ProductID = p.ProductID
        WHERE o.OrderID = @OrderID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 