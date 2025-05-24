USE BrandManagement;
GO

-- 更新商品库存
CREATE PROCEDURE sp_UpdateInventory
    @ProductID INT,
    @Quantity INT,
    @OperationType NVARCHAR(50),
    @OperatorID INT,
    @Remark NVARCHAR(500) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 参数验证
        IF @ProductID IS NULL OR @Quantity IS NULL OR @OperationType IS NULL OR @OperatorID IS NULL
        BEGIN
            RAISERROR('商品ID、数量、操作类型和操作者ID不能为空', 16, 1);
            RETURN;
        END;

        -- 检查商品是否存在
        IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID)
        BEGIN
            RAISERROR('商品不存在', 16, 1);
            RETURN;
        END;

        -- 检查操作者权限
        IF NOT EXISTS (
            SELECT 1 
            FROM Users 
            WHERE UserID = @OperatorID 
            AND Role IN ('Merchant', 'Admin')
        )
        BEGIN
            RAISERROR('只有商家或管理员可以更新库存', 16, 1);
            RETURN;
        END;

        -- 获取当前库存
        DECLARE @CurrentStock INT;
        SELECT @CurrentStock = Stock FROM Products WHERE ProductID = @ProductID;

        -- 计算新库存
        DECLARE @NewStock INT;
        IF @OperationType = 'In'
            SET @NewStock = @CurrentStock + @Quantity;
        ELSE IF @OperationType = 'Out'
        BEGIN
            IF @CurrentStock < @Quantity
            BEGIN
                RAISERROR('库存不足', 16, 1);
                RETURN;
            END;
            SET @NewStock = @CurrentStock - @Quantity;
        END
        ELSE
        BEGIN
            RAISERROR('无效的操作类型', 16, 1);
            RETURN;
        END;

        -- 更新库存
        UPDATE Products
        SET Stock = @NewStock,
            UpdatedAt = GETDATE()
        WHERE ProductID = @ProductID;

        -- 记录库存变动
        INSERT INTO InventoryLog (
            ProductID,
            Quantity,
            OperationType,
            OperatorID,
            Remark
        )
        VALUES (
            @ProductID,
            @Quantity,
            @OperationType,
            @OperatorID,
            @Remark
        );

        -- 记录系统日志
        INSERT INTO SystemLogs (
            UserID,
            OperationType,
            OperationContent
        )
        VALUES (
            @OperatorID,
            'UpdateInventory',
            '更新商品库存：' + CAST(@ProductID AS NVARCHAR(10)) + 
            '，操作：' + @OperationType + 
            '，数量：' + CAST(@Quantity AS NVARCHAR(10))
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

-- 获取库存变动记录
CREATE PROCEDURE sp_GetInventoryLogs
    @ProductID INT = NULL,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @OperationType NVARCHAR(50) = NULL
AS
BEGIN
    BEGIN TRY
        SELECT 
            il.LogID,
            il.ProductID,
            p.Name AS ProductName,
            il.Quantity,
            il.OperationType,
            il.OperatorID,
            u.Username AS OperatorName,
            il.Remark,
            il.CreatedAt
        FROM InventoryLog il
        JOIN Products p ON il.ProductID = p.ProductID
        JOIN Users u ON il.OperatorID = u.UserID
        WHERE (@ProductID IS NULL OR il.ProductID = @ProductID)
        AND (@StartDate IS NULL OR il.CreatedAt >= @StartDate)
        AND (@EndDate IS NULL OR il.CreatedAt <= @EndDate)
        AND (@OperationType IS NULL OR il.OperationType = @OperationType)
        ORDER BY il.CreatedAt DESC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 获取库存预警商品
CREATE PROCEDURE sp_GetLowStockProducts
    @Threshold INT = 10
AS
BEGIN
    BEGIN TRY
        SELECT 
            p.ProductID,
            p.Name,
            p.Stock,
            p.Category,
            p.Price,
            p.CreatedAt,
            p.UpdatedAt
        FROM Products p
        WHERE p.Stock <= @Threshold
        AND p.IsActive = 1
        ORDER BY p.Stock ASC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 