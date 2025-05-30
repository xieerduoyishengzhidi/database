/****** Script for SelectTopNRows command from SSMS  ******/
-- 创建数据库
CREATE DATABASE BrandManagement;
GO

USE BrandManagement;
GO

-- 创建表（参考前面的表定义）
-- 创建索引和存储过程

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,  -- 存储加密后的密码
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Customer', 'Merchant', 'Admin')),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    RegisterDate DATETIME DEFAULT GETDATE(),
    LastLogin DATETIME,
    SecurityQuestion NVARCHAR(200),  -- 用于密码找回
    SecurityAnswer NVARCHAR(200)     -- 加密存储
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL DEFAULT 0,
    Category NVARCHAR(50),           -- 如"服装"、"食品"
    ImagePath NVARCHAR(255),         -- 商品图片本地路径
    IsActive BIT DEFAULT 1,          -- 1=上架, 0=下架
    CreatedBy INT FOREIGN KEY REFERENCES Users(UserID),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Completed', 'Cancelled')),
    ShippingAddress NVARCHAR(200),
    ContactPhone NVARCHAR(20)
);


CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL  -- 下单时的价格（防止商品价格变动影响历史订单）
);

CREATE TABLE InventoryLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    ChangeAmount INT NOT NULL,  -- 正数=入库，负数=出库
    CurrentStock INT NOT NULL,  -- 变更后的库存量
    OperationType NVARCHAR(50), -- 'Purchase', 'Sale', 'Adjustment'等
    OperatorID INT FOREIGN KEY REFERENCES Users(UserID),
    OperationTime DATETIME DEFAULT GETDATE(),
    Notes NVARCHAR(200)        -- 备注（如"手动调整"或"订单号123"）
);

CREATE TABLE ShoppingCart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL DEFAULT 1,
    AddedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE ProductCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    ParentCategoryID INT,
    Description NVARCHAR(200),
    CreateTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ParentCategoryID) REFERENCES ProductCategories(CategoryID)
);

CREATE TABLE UserAddresses (
    AddressID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    IsDefault BIT DEFAULT 0,
    ContactName NVARCHAR(50) NOT NULL,
    ContactPhone NVARCHAR(20) NOT NULL,
    CreateTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE ProductReviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    UserID INT NOT NULL,
    OrderID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(500),
    CreateTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE PaymentRecords (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod NVARCHAR(50) NOT NULL,
    PaymentStatus NVARCHAR(20) NOT NULL CHECK (PaymentStatus IN ('Pending', 'Success', 'Failed')),
    PaymentTime DATETIME DEFAULT GETDATE(),
    TransactionID NVARCHAR(100),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE SystemLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    OperationType NVARCHAR(50) NOT NULL,
    OperationContent NVARCHAR(MAX),
    IPAddress NVARCHAR(50),
    OperationTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE RolePermissions (
    PermissionID INT PRIMARY KEY IDENTITY(1,1),
    Role NVARCHAR(20) NOT NULL,
    PermissionName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    CreateTime DATETIME DEFAULT GETDATE()
);

-- 插入基础权限数据
INSERT INTO RolePermissions (Role, PermissionName, Description) VALUES
-- 顾客权限
('Customer', 'ViewProducts', '浏览商品'),
('Customer', 'ManageCart', '管理购物车'),
('Customer', 'PlaceOrder', '下单'),
('Customer', 'ViewOrders', '查看订单'),
('Customer', 'WriteReview', '评价商品'),

-- 商家权限
('Merchant', 'ManageProducts', '管理商品'),
('Merchant', 'ManageInventory', '管理库存'),
('Merchant', 'ProcessOrders', '处理订单'),
('Merchant', 'ViewReports', '查看报表'),

-- 管理员权限
('Admin', 'ManageUsers', '管理用户'),
('Admin', 'ManageMerchants', '管理商家'),
('Admin', 'ViewAllOrders', '查看所有订单'),
('Admin', 'ViewAllReports', '查看所有报表'),
('Admin', 'SystemSettings', '系统设置'),
('Admin', 'ViewLogs', '查看系统日志');

-- 用户登录优化
CREATE INDEX IX_Users_Username ON Users(Username);

-- 商品搜索优化
CREATE INDEX IX_Products_Name ON Products(Name);
CREATE INDEX IX_Products_Category ON Products(Category);

-- 订单查询优化
CREATE INDEX IX_Orders_UserID ON Orders(UserID);
CREATE INDEX IX_Orders_Status ON Orders(Status);

-- 库存管理优化
CREATE INDEX IX_InventoryLog_ProductID ON InventoryLog(ProductID);

-- 商品分类索引
CREATE INDEX IX_ProductCategories_ParentID ON ProductCategories(ParentCategoryID);

-- 用户地址索引
CREATE INDEX IX_UserAddresses_UserID ON UserAddresses(UserID);

-- 商品评价索引
CREATE INDEX IX_ProductReviews_ProductID ON ProductReviews(ProductID);
CREATE INDEX IX_ProductReviews_UserID ON ProductReviews(UserID);

-- 支付记录索引
CREATE INDEX IX_PaymentRecords_OrderID ON PaymentRecords(OrderID);
CREATE INDEX IX_PaymentRecords_Status ON PaymentRecords(PaymentStatus);

-- 系统日志索引
CREATE INDEX IX_SystemLogs_UserID ON SystemLogs(UserID);
CREATE INDEX IX_SystemLogs_OperationTime ON SystemLogs(OperationTime);

--顾客下单
CREATE PROCEDURE sp_PlaceOrder
    @UserID INT,
    @ShippingAddress NVARCHAR(200),
    @ContactPhone NVARCHAR(20)
AS
BEGIN
    BEGIN TRY
        -- 参数验证
        IF @UserID IS NULL OR @ShippingAddress IS NULL OR @ContactPhone IS NULL
        BEGIN
            RAISERROR('用户名称，地址，联系方式不能为空', 16, 1);
            RETURN;
        END;

        -- 用户存在性检查
        IF NOT EXISTS (SELECT 1 FROM Users WHERE UserID = @UserID)
        BEGIN
            RAISERROR('用户不存在', 16, 1);
            RETURN;
        END;

        -- 购物车检查
        IF NOT EXISTS (SELECT 1 FROM ShoppingCart WHERE UserID = @UserID)
        BEGIN
            RAISERROR('购物车为空', 16, 1);
            RETURN;
        END;

        -- 库存检查
        IF EXISTS (
            SELECT 1
            FROM ShoppingCart sc
            JOIN Products p ON sc.ProductID = p.ProductID
            WHERE sc.UserID = @UserID
            AND p.Stock < sc.Quantity
        )
        BEGIN
            RAISERROR('部分商品库存不足', 16, 1);
            RETURN;
        END;

        BEGIN TRANSACTION;
        
        DECLARE @OrderID INT;
        DECLARE @Total DECIMAL(10, 2);
        
        -- 计算购物车总金额
        SELECT @Total = SUM(p.Price * sc.Quantity)
        FROM ShoppingCart sc
        JOIN Products p ON sc.ProductID = p.ProductID
        WHERE sc.UserID = @UserID;
        
        -- 创建订单
        INSERT INTO Orders (UserID, TotalAmount, ShippingAddress, ContactPhone)
        VALUES (@UserID, @Total, @ShippingAddress, @ContactPhone);
        
        SET @OrderID = SCOPE_IDENTITY();
        
        -- 写入订单明细
        INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
        SELECT @OrderID, sc.ProductID, sc.Quantity, p.Price
        FROM ShoppingCart sc
        JOIN Products p ON sc.ProductID = p.ProductID
        WHERE sc.UserID = @UserID;
        
        -- 更新库存
        UPDATE p
        SET p.Stock = p.Stock - sc.Quantity
        FROM Products p
        JOIN ShoppingCart sc ON p.ProductID = sc.ProductID
        WHERE sc.UserID = @UserID;
        
        -- 记录库存变更
        INSERT INTO InventoryLog (ProductID, ChangeAmount, CurrentStock, OperationType, OperatorID)
        SELECT sc.ProductID, -sc.Quantity, p.Stock - sc.Quantity, 'Sale', @UserID
        FROM ShoppingCart sc
        JOIN Products p ON sc.ProductID = p.ProductID
        WHERE sc.UserID = @UserID;
        
        -- 创建支付记录
        INSERT INTO PaymentRecords (OrderID, Amount, PaymentMethod, PaymentStatus)
        VALUES (@OrderID, @Total, 'Online', 'Pending');
        
        -- 记录系统日志
        INSERT INTO SystemLogs (UserID, OperationType, OperationContent)
        VALUES (@UserID, 'PlaceOrder', '创建订单：' + CAST(@OrderID AS NVARCHAR(20)));
        
        -- 清空购物车
        DELETE FROM ShoppingCart WHERE UserID = @UserID;
        
        COMMIT TRANSACTION;
        
        SELECT @OrderID AS NewOrderID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

-- 商家或管理员更新库存
CREATE PROCEDURE sp_UpdateInventory
    @ProductID INT,
    @Adjustment INT,
    @OperatorID INT,
    @Notes NVARCHAR(200) = NULL
AS
BEGIN
    BEGIN TRY
        -- 检查权限
        IF NOT EXISTS (
            SELECT 1 
            FROM Users u
            WHERE u.UserID = @OperatorID 
            AND (u.Role = 'Merchant' OR u.Role = 'Admin')
        )
        BEGIN
            RAISERROR('只有商家或管理员可以更新库存', 16, 1);
            RETURN;
        END;

        -- 参数验证
        IF @ProductID IS NULL OR @Adjustment IS NULL OR @OperatorID IS NULL
        BEGIN
            RAISERROR('商品ID、调整数量和操作员ID不能为空', 16, 1);
            RETURN;
        END;

        -- 检查商品是否存在
        IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID)
        BEGIN
            RAISERROR('商品不存在', 16, 1);
            RETURN;
        END;

        -- 检查库存是否足够（如果是减少库存）
        IF @Adjustment < 0
        BEGIN
            DECLARE @CurrentStock INT;
            SELECT @CurrentStock = Stock FROM Products WHERE ProductID = @ProductID;
            
            IF @CurrentStock + @Adjustment < 0
            BEGIN
                RAISERROR('库存不足，无法减少指定数量', 16, 1);
                RETURN;
            END;
        END;

        BEGIN TRANSACTION;

        -- 更新库存
        UPDATE Products
        SET Stock = Stock + @Adjustment,
            ModifiedDate = GETDATE()
        WHERE ProductID = @ProductID;
        
        -- 记录变更
        INSERT INTO InventoryLog (
            ProductID, 
            ChangeAmount, 
            CurrentStock, 
            OperationType, 
            OperatorID, 
            Notes
        )
        SELECT 
            @ProductID, 
            @Adjustment, 
            Stock, 
            'Adjustment', 
            @OperatorID, 
            @Notes
        FROM Products
        WHERE ProductID = @ProductID;

        -- 记录系统日志
        INSERT INTO SystemLogs (
            UserID, 
            OperationType, 
            OperationContent
        )
        VALUES (
            @OperatorID, 
            'UpdateInventory', 
            '更新商品' + CAST(@ProductID AS NVARCHAR(20)) + 
            '库存，调整数量：' + CAST(@Adjustment AS NVARCHAR(20))
        );

        COMMIT TRANSACTION;

        -- 返回更新后的库存信息
        SELECT 
            p.ProductID,
            p.Name,
            p.Stock AS CurrentStock,
            il.ChangeAmount,
            il.OperationTime
        FROM Products p
        LEFT JOIN InventoryLog il ON p.ProductID = il.ProductID
        WHERE p.ProductID = @ProductID
        AND il.LogID = SCOPE_IDENTITY();

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- 获取错误信息
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- 记录错误日志
        INSERT INTO SystemLogs (
            UserID, 
            OperationType, 
            OperationContent
        )
        VALUES (
            @OperatorID, 
            'Error', 
            '更新库存失败：' + @ErrorMessage
        );
        
        -- 重新抛出错误
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

-- 创建检查权限的存储过程
CREATE PROCEDURE sp_CheckPermission
    @UserID INT,
    @RequiredPermission NVARCHAR(50)
AS
BEGIN
    DECLARE @UserRole NVARCHAR(20);
    
    -- 获取用户角色
    SELECT @UserRole = Role 
    FROM Users 
    WHERE UserID = @UserID;
    
    -- 检查权限
    IF NOT EXISTS (
        SELECT 1 
        FROM RolePermissions 
        WHERE Role = @UserRole 
        AND PermissionName = @RequiredPermission
    )
    BEGIN
        RAISERROR('当前用户没有执行此操作的权限', 16, 1);
        RETURN 0;
    END
    
    RETURN 1;
END;

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
    -- 实现用户注册逻辑
END;

-- 用户登录
CREATE PROCEDURE sp_UserLogin
    @Username NVARCHAR(50),
    @Password NVARCHAR(100)
AS
BEGIN
    -- 实现用户登录逻辑
END;

-- 密码找回
CREATE PROCEDURE sp_ResetPassword
    @Username NVARCHAR(50),
    @SecurityAnswer NVARCHAR(200),
    @NewPassword NVARCHAR(100)
AS
BEGIN
    -- 实现密码重置逻辑
END;

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
    -- 实现添加商品逻辑
END;

-- 批量导入商品
CREATE PROCEDURE sp_BulkImportProducts
    @ProductData NVARCHAR(MAX)  -- JSON格式的商品数据
AS
BEGIN
    -- 实现批量导入逻辑
END;

-- 商品搜索
CREATE PROCEDURE sp_SearchProducts
    @Keyword NVARCHAR(100),
    @Category NVARCHAR(50) = NULL,
    @MinPrice DECIMAL(10,2) = NULL,
    @MaxPrice DECIMAL(10,2) = NULL
AS
BEGIN
    -- 实现商品搜索逻辑
END;

-- 查看订单列表
CREATE PROCEDURE sp_GetOrders
    @UserID INT,
    @Status NVARCHAR(20) = NULL,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    -- 实现订单查询逻辑
END;

-- 更新订单状态
CREATE PROCEDURE sp_UpdateOrderStatus
    @OrderID INT,
    @NewStatus NVARCHAR(20),
    @OperatorID INT
AS
BEGIN
    -- 实现订单状态更新逻辑
END;

-- 导出订单报表
CREATE PROCEDURE sp_ExportOrderReport
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    -- 实现订单报表导出逻辑
END;

-- 添加商品到购物车
CREATE PROCEDURE sp_AddToCart
    @UserID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    -- 实现添加购物车逻辑
END;

-- 更新购物车商品数量
CREATE PROCEDURE sp_UpdateCartItem
    @CartID INT,
    @Quantity INT
AS
BEGIN
    -- 实现更新购物车逻辑
END;

-- 获取购物车内容
CREATE PROCEDURE sp_GetCartItems
    @UserID INT
AS
BEGIN
    -- 实现获取购物车内容逻辑
END;

-- 销售报表
CREATE PROCEDURE sp_GetSalesReport
    @StartDate DATETIME,
    @EndDate DATETIME,
    @GroupBy NVARCHAR(20)  -- 'Day'/'Month'
AS
BEGIN
    -- 实现销售报表统计逻辑
END;

-- 热销商品排名
CREATE PROCEDURE sp_GetTopProducts
    @StartDate DATETIME,
    @EndDate DATETIME,
    @TopN INT = 10
AS
BEGIN
    -- 实现热销商品统计逻辑
END;

-- 库存预警
CREATE PROCEDURE sp_GetLowStockProducts
    @Threshold INT
AS
BEGIN
    -- 实现库存预警逻辑
END;

-- 添加商品评价
CREATE PROCEDURE sp_AddProductReview
    @ProductID INT,
    @UserID INT,
    @OrderID INT,
    @Rating INT,
    @Comment NVARCHAR(500)
AS
BEGIN
    -- 实现添加评价逻辑
END;

-- 获取商品评价
CREATE PROCEDURE sp_GetProductReviews
    @ProductID INT,
    @Page INT = 1,
    @PageSize INT = 10
AS
BEGIN
    -- 实现获取评价逻辑
END;