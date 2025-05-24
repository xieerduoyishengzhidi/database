USE BrandManagement;
GO

-- 获取销售报表
CREATE PROCEDURE sp_GetSalesReport
    @StartDate DATETIME,
    @EndDate DATETIME,
    @Category NVARCHAR(50) = NULL
AS
BEGIN
    BEGIN TRY
        -- 参数验证
        IF @StartDate IS NULL OR @EndDate IS NULL
        BEGIN
            RAISERROR('开始日期和结束日期不能为空', 16, 1);
            RETURN;
        END;

        -- 按日期统计销售数据
        SELECT 
            CAST(o.CreatedAt AS DATE) AS SaleDate,
            COUNT(DISTINCT o.OrderID) AS OrderCount,
            COUNT(oi.OrderItemID) AS ItemCount,
            SUM(oi.Quantity) AS TotalQuantity,
            SUM(oi.Quantity * oi.Price) AS TotalAmount
        FROM Orders o
        JOIN OrderItems oi ON o.OrderID = oi.OrderID
        JOIN Products p ON oi.ProductID = p.ProductID
        WHERE o.Status = 'Completed'
        AND o.CreatedAt BETWEEN @StartDate AND @EndDate
        AND (@Category IS NULL OR p.Category = @Category)
        GROUP BY CAST(o.CreatedAt AS DATE)
        ORDER BY SaleDate;

        -- 按商品类别统计
        SELECT 
            p.Category,
            COUNT(DISTINCT o.OrderID) AS OrderCount,
            COUNT(oi.OrderItemID) AS ItemCount,
            SUM(oi.Quantity) AS TotalQuantity,
            SUM(oi.Quantity * oi.Price) AS TotalAmount
        FROM Orders o
        JOIN OrderItems oi ON o.OrderID = oi.OrderID
        JOIN Products p ON oi.ProductID = p.ProductID
        WHERE o.Status = 'Completed'
        AND o.CreatedAt BETWEEN @StartDate AND @EndDate
        AND (@Category IS NULL OR p.Category = @Category)
        GROUP BY p.Category
        ORDER BY TotalAmount DESC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 获取热销商品报表
CREATE PROCEDURE sp_GetTopProducts
    @StartDate DATETIME,
    @EndDate DATETIME,
    @TopN INT = 10
AS
BEGIN
    BEGIN TRY
        -- 检查缓存
        IF EXISTS (
            SELECT 1 
            FROM ReportCache 
            WHERE ReportType = 'TopProducts'
            AND StartDate = @StartDate
            AND EndDate = @EndDate
            AND TopN = @TopN
            AND CacheTime > DATEADD(MINUTE, -30, GETDATE())
        )
        BEGIN
            -- 返回缓存数据
            SELECT * FROM ReportCache
            WHERE ReportType = 'TopProducts'
            AND StartDate = @StartDate
            AND EndDate = @EndDate
            AND TopN = @TopN;
            RETURN;
        END;
        
        -- 参数验证
        IF @StartDate IS NULL OR @EndDate IS NULL
        BEGIN
            RAISERROR('开始日期和结束日期不能为空', 16, 1);
            RETURN;
        END;

        -- 按销量统计
        SELECT TOP (@TopN)
            p.ProductID,
            p.Name,
            p.Category,
            p.Price,
            SUM(oi.Quantity) AS TotalQuantity,
            SUM(oi.Quantity * oi.Price) AS TotalAmount,
            COUNT(DISTINCT o.OrderID) AS OrderCount
        FROM Products p
        JOIN OrderItems oi ON p.ProductID = oi.ProductID
        JOIN Orders o ON oi.OrderID = o.OrderID
        WHERE o.Status = 'Completed'
        AND o.CreatedAt BETWEEN @StartDate AND @EndDate
        GROUP BY p.ProductID, p.Name, p.Category, p.Price
        ORDER BY TotalQuantity DESC;

        -- 按销售额统计
        SELECT TOP (@TopN)
            p.ProductID,
            p.Name,
            p.Category,
            p.Price,
            SUM(oi.Quantity) AS TotalQuantity,
            SUM(oi.Quantity * oi.Price) AS TotalAmount,
            COUNT(DISTINCT o.OrderID) AS OrderCount
        FROM Products p
        JOIN OrderItems oi ON p.ProductID = oi.ProductID
        JOIN Orders o ON oi.OrderID = o.OrderID
        WHERE o.Status = 'Completed'
        AND o.CreatedAt BETWEEN @StartDate AND @EndDate
        GROUP BY p.ProductID, p.Name, p.Category, p.Price
        ORDER BY TotalAmount DESC;
        
        -- 更新缓存
        INSERT INTO ReportCache (ReportType, StartDate, EndDate, TopN, CacheData, CacheTime)
        VALUES ('TopProducts', @StartDate, @EndDate, @TopN, @ReportData, GETDATE());
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 获取用户消费报表
CREATE PROCEDURE sp_GetUserConsumptionReport
    @StartDate DATETIME,
    @EndDate DATETIME,
    @TopN INT = 10
AS
BEGIN
    BEGIN TRY
        -- 参数验证
        IF @StartDate IS NULL OR @EndDate IS NULL
        BEGIN
            RAISERROR('开始日期和结束日期不能为空', 16, 1);
            RETURN;
        END;

        -- 按消费金额统计
        SELECT TOP (@TopN)
            u.UserID,
            u.Username,
            COUNT(DISTINCT o.OrderID) AS OrderCount,
            SUM(o.TotalAmount) AS TotalAmount,
            AVG(o.TotalAmount) AS AverageAmount,
            MAX(o.TotalAmount) AS MaxAmount,
            MIN(o.TotalAmount) AS MinAmount
        FROM Users u
        JOIN Orders o ON u.UserID = o.UserID
        WHERE o.Status = 'Completed'
        AND o.CreatedAt BETWEEN @StartDate AND @EndDate
        GROUP BY u.UserID, u.Username
        ORDER BY TotalAmount DESC;

        -- 按订单数量统计
        SELECT TOP (@TopN)
            u.UserID,
            u.Username,
            COUNT(DISTINCT o.OrderID) AS OrderCount,
            SUM(o.TotalAmount) AS TotalAmount,
            AVG(o.TotalAmount) AS AverageAmount,
            MAX(o.TotalAmount) AS MaxAmount,
            MIN(o.TotalAmount) AS MinAmount
        FROM Users u
        JOIN Orders o ON u.UserID = o.UserID
        WHERE o.Status = 'Completed'
        AND o.CreatedAt BETWEEN @StartDate AND @EndDate
        GROUP BY u.UserID, u.Username
        ORDER BY OrderCount DESC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 获取库存周转报表
CREATE PROCEDURE sp_GetInventoryTurnoverReport
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    BEGIN TRY
        -- 参数验证
        IF @StartDate IS NULL OR @EndDate IS NULL
        BEGIN
            RAISERROR('开始日期和结束日期不能为空', 16, 1);
            RETURN;
        END;

        -- 计算库存周转率
        SELECT 
            p.ProductID,
            p.Name,
            p.Category,
            p.Stock AS CurrentStock,
            SUM(oi.Quantity) AS TotalSales,
            CASE 
                WHEN p.Stock = 0 THEN 0
                ELSE CAST(SUM(oi.Quantity) AS FLOAT) / p.Stock
            END AS TurnoverRate
        FROM Products p
        LEFT JOIN OrderItems oi ON p.ProductID = oi.ProductID
        LEFT JOIN Orders o ON oi.OrderID = o.OrderID
            AND o.Status = 'Completed'
            AND o.CreatedAt BETWEEN @StartDate AND @EndDate
        WHERE p.IsActive = 1
        GROUP BY p.ProductID, p.Name, p.Category, p.Stock
        ORDER BY TurnoverRate DESC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 添加分页功能
CREATE PROCEDURE sp_SearchProducts
    @Keyword NVARCHAR(100),
    @Category NVARCHAR(50) = NULL,
    @MinPrice DECIMAL(10,2) = NULL,
    @MaxPrice DECIMAL(10,2) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    BEGIN TRY
        -- 计算总记录数
        DECLARE @TotalCount INT;
        SELECT @TotalCount = COUNT(*)
        FROM Products p
        WHERE p.IsActive = 1
        AND (@Keyword IS NULL 
            OR p.Name LIKE '%' + @Keyword + '%'
            OR p.Description LIKE '%' + @Keyword + '%')
        AND (@Category IS NULL OR p.Category = @Category)
        AND (@MinPrice IS NULL OR p.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR p.Price <= @MaxPrice);

        -- 分页查询
        SELECT 
            p.*,
            @TotalCount AS TotalCount
        FROM Products p
        WHERE p.IsActive = 1
        AND (@Keyword IS NULL 
            OR p.Name LIKE '%' + @Keyword + '%'
            OR p.Description LIKE '%' + @Keyword + '%')
        AND (@Category IS NULL OR p.Category = @Category)
        AND (@MinPrice IS NULL OR p.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR p.Price <= @MaxPrice)
        ORDER BY p.Name
        OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;

-- 添加并发控制
CREATE PROCEDURE sp_CreateOrder
    @UserID INT,
    @AddressID INT,
    @PaymentMethod NVARCHAR(50),
    @OrderItems OrderItemTableType READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- 添加行级锁
        SELECT @UserID, @AddressID
        FROM Users WITH (UPDLOCK, ROWLOCK)
        WHERE UserID = @UserID;
        
        -- 其他逻辑保持不变
        ...
    END TRY
    BEGIN CATCH
        ...
    END CATCH
END;

-- 添加并发控制
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
        
        -- 添加行级锁
        SELECT @ProductID
        FROM Products WITH (UPDLOCK, ROWLOCK)
        WHERE ProductID = @ProductID;
        
        -- 其他逻辑保持不变
        ...
    END TRY
    BEGIN CATCH
        ...
    END CATCH
END; 