USE BrandManagement;
GO

-- 添加商品到购物车
CREATE PROCEDURE sp_AddToCart
    @UserID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 参数验证
        IF @UserID IS NULL OR @ProductID IS NULL OR @Quantity IS NULL
        BEGIN
            RAISERROR('用户ID、商品ID和数量不能为空', 16, 1);
            RETURN;
        END;

        -- 检查用户是否存在
        IF NOT EXISTS (SELECT 1 FROM Users WHERE UserID = @UserID)
        BEGIN
            RAISERROR('用户不存在', 16, 1);
            RETURN;
        END;

        -- 检查商品是否存在且库存充足
        IF NOT EXISTS (
            SELECT 1 
            FROM Products 
            WHERE ProductID = @ProductID 
            AND IsActive = 1 
            AND Stock >= @Quantity
        )
        BEGIN
            RAISERROR('商品不存在或库存不足', 16, 1);
            RETURN;
        END;

        -- 检查购物车中是否已存在该商品
        IF EXISTS (
            SELECT 1 
            FROM ShoppingCart 
            WHERE UserID = @UserID 
            AND ProductID = @ProductID
        )
        BEGIN
            -- 更新数量
            UPDATE ShoppingCart
            SET Quantity = Quantity + @Quantity,
                UpdatedAt = GETDATE()
            WHERE UserID = @UserID 
            AND ProductID = @ProductID;
        END
        ELSE
        BEGIN
            -- 添加新商品
            INSERT INTO ShoppingCart (
                UserID,
                ProductID,
                Quantity
            )
            VALUES (
                @UserID,
                @ProductID,
                @Quantity
            );
        END;

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

-- 更新购物车商品数量
CREATE PROCEDURE sp_UpdateCartItemQuantity
    @UserID INT,
    @ProductID INT,
    @NewQuantity INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 参数验证
        IF @UserID IS NULL OR @ProductID IS NULL OR @NewQuantity IS NULL
        BEGIN
            RAISERROR('用户ID、商品ID和新数量不能为空', 16, 1);
            RETURN;
        END;

        -- 检查购物车中是否存在该商品
        IF NOT EXISTS (
            SELECT 1 
            FROM ShoppingCart 
            WHERE UserID = @UserID 
            AND ProductID = @ProductID
        )
        BEGIN
            RAISERROR('购物车中不存在该商品', 16, 1);
            RETURN;
        END;

        -- 检查库存是否充足
        IF NOT EXISTS (
            SELECT 1 
            FROM Products 
            WHERE ProductID = @ProductID 
            AND Stock >= @NewQuantity
        )
        BEGIN
            RAISERROR('商品库存不足', 16, 1);
            RETURN;
        END;

        -- 更新数量
        UPDATE ShoppingCart
        SET Quantity = @NewQuantity,
            UpdatedAt = GETDATE()
        WHERE UserID = @UserID 
        AND ProductID = @ProductID;

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

-- 从购物车中删除商品
CREATE PROCEDURE sp_RemoveFromCart
    @UserID INT,
    @ProductID INT
AS
BEGIN
    BEGIN TRY
        -- 参数验证
        IF @UserID IS NULL OR @ProductID IS NULL
        BEGIN
            RAISERROR('用户ID和商品ID不能为空', 16, 1);
            RETURN;
        END;

        -- 删除商品
        DELETE FROM ShoppingCart
        WHERE UserID = @UserID 
        AND ProductID = @ProductID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 获取购物车内容
CREATE PROCEDURE sp_GetCartItems
    @UserID INT
AS
BEGIN
    BEGIN TRY
        SELECT 
            sc.ProductID,
            p.Name AS ProductName,
            p.Price,
            sc.Quantity,
            (p.Price * sc.Quantity) AS ItemTotal,
            p.Stock AS AvailableStock,
            p.ImagePath
        FROM ShoppingCart sc
        JOIN Products p ON sc.ProductID = p.ProductID
        WHERE sc.UserID = @UserID
        AND p.IsActive = 1;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 清空购物车
CREATE PROCEDURE sp_ClearCart
    @UserID INT
AS
BEGIN
    BEGIN TRY
        -- 参数验证
        IF @UserID IS NULL
        BEGIN
            RAISERROR('用户ID不能为空', 16, 1);
            RETURN;
        END;

        -- 清空购物车
        DELETE FROM ShoppingCart
        WHERE UserID = @UserID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 