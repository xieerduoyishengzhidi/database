USE BrandManagement;
GO

-- 添加商品
CREATE PROCEDURE sp_AddProduct
    @Name NVARCHAR(100),
    @Description NVARCHAR(500),
    @Price DECIMAL(10,2),
    @Stock INT,
    @Category NVARCHAR(50),
    @ImagePath NVARCHAR(255),
    @CreatedBy INT
AS
BEGIN
    BEGIN TRY
        -- 参数验证
        IF @Name IS NULL OR @Price IS NULL OR @CreatedBy IS NULL
        BEGIN
            RAISERROR('商品名称、价格和创建者不能为空', 16, 1);
            RETURN;
        END;

        -- 检查创建者是否存在且是商家或管理员
        IF NOT EXISTS (
            SELECT 1 
            FROM Users 
            WHERE UserID = @CreatedBy 
            AND Role IN ('Merchant', 'Admin')
        )
        BEGIN
            RAISERROR('只有商家或管理员可以添加商品', 16, 1);
            RETURN;
        END;

        -- 插入商品
        INSERT INTO Products (
            Name,
            Description,
            Price,
            Stock,
            Category,
            ImagePath,
            CreatedBy
        )
        VALUES (
            @Name,
            @Description,
            @Price,
            @Stock,
            @Category,
            @ImagePath,
            @CreatedBy
        );

        -- 记录系统日志
        INSERT INTO SystemLogs (
            UserID,
            OperationType,
            OperationContent
        )
        VALUES (
            @CreatedBy,
            'AddProduct',
            '添加新商品：' + @Name
        );

        SELECT SCOPE_IDENTITY() AS NewProductID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 商品搜索
CREATE PROCEDURE sp_SearchProducts
    @Keyword NVARCHAR(100),
    @Category NVARCHAR(50) = NULL,
    @MinPrice DECIMAL(10,2) = NULL,
    @MaxPrice DECIMAL(10,2) = NULL
AS
BEGIN
    BEGIN TRY
        SELECT 
            p.ProductID,
            p.Name,
            p.Description,
            p.Price,
            p.Stock,
            p.Category,
            p.ImagePath,
            p.IsActive,
            u.Username AS CreatedBy
        FROM Products p
        LEFT JOIN Users u ON p.CreatedBy = u.UserID
        WHERE p.IsActive = 1
        AND (
            @Keyword IS NULL 
            OR p.Name LIKE '%' + @Keyword + '%'
            OR p.Description LIKE '%' + @Keyword + '%'
        )
        AND (@Category IS NULL OR p.Category = @Category)
        AND (@MinPrice IS NULL OR p.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR p.Price <= @MaxPrice)
        ORDER BY p.Name;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 批量导入商品
CREATE PROCEDURE sp_BulkImportProducts
    @ProductData NVARCHAR(MAX)  -- JSON格式的商品数据
AS
BEGIN
    BEGIN TRY
        -- 这里需要实现JSON解析和批量插入逻辑
        -- 由于SQL Server版本差异，具体实现可能不同
        -- 建议在应用程序层面实现批量导入功能
        RAISERROR('此功能需要在应用程序层面实现', 16, 1);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 