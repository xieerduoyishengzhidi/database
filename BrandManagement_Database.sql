-- 品牌管理系统数据库创建脚本
-- 创建时间：2024年

-- 1. 创建数据库
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'BrandManagement')
BEGIN
    ALTER DATABASE BrandManagement SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BrandManagement;
END
GO

CREATE DATABASE BrandManagement;
GO

USE BrandManagement;
GO

-- 2. 创建表结构
-- 创建用户表
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
GO

-- 创建商品表
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
GO

-- 创建订单表
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Completed', 'Cancelled')),
    ShippingAddress NVARCHAR(200),
    ContactPhone NVARCHAR(20)
);
GO

-- 创建订单明细表
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL  -- 下单时的价格（防止商品价格变动影响历史订单）
);
GO

-- 创建库存日志表
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
GO

-- 创建购物车表
CREATE TABLE ShoppingCart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL DEFAULT 1,
    AddedDate DATETIME DEFAULT GETDATE()
);
GO

-- 创建商品分类表
CREATE TABLE ProductCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    ParentCategoryID INT,
    Description NVARCHAR(200),
    CreateTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ParentCategoryID) REFERENCES ProductCategories(CategoryID)
);
GO

-- 创建用户地址表
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
GO

-- 创建商品评价表
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
GO

-- 创建支付记录表
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
GO

-- 创建系统日志表
CREATE TABLE SystemLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    OperationType NVARCHAR(50) NOT NULL,
    OperationContent NVARCHAR(MAX),
    IPAddress NVARCHAR(50),
    OperationTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- 创建角色权限表
CREATE TABLE RolePermissions (
    PermissionID INT PRIMARY KEY IDENTITY(1,1),
    Role NVARCHAR(20) NOT NULL,
    PermissionName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    CreateTime DATETIME DEFAULT GETDATE()
);
GO

-- 3. 创建索引
-- 用户登录优化
CREATE INDEX IX_Users_Username ON Users(Username);
GO

-- 商品搜索优化
CREATE INDEX IX_Products_Name ON Products(Name);
CREATE INDEX IX_Products_Category ON Products(Category);
GO

-- 订单查询优化
CREATE INDEX IX_Orders_UserID ON Orders(UserID);
CREATE INDEX IX_Orders_Status ON Orders(Status);
GO

-- 库存管理优化
CREATE INDEX IX_InventoryLog_ProductID ON InventoryLog(ProductID);
GO

-- 商品分类索引
CREATE INDEX IX_ProductCategories_ParentID ON ProductCategories(ParentCategoryID);
GO

-- 用户地址索引
CREATE INDEX IX_UserAddresses_UserID ON UserAddresses(UserID);
GO

-- 商品评价索引
CREATE INDEX IX_ProductReviews_ProductID ON ProductReviews(ProductID);
CREATE INDEX IX_ProductReviews_UserID ON ProductReviews(UserID);
GO

-- 支付记录索引
CREATE INDEX IX_PaymentRecords_OrderID ON PaymentRecords(OrderID);
CREATE INDEX IX_PaymentRecords_Status ON PaymentRecords(PaymentStatus);
GO

-- 系统日志索引
CREATE INDEX IX_SystemLogs_UserID ON SystemLogs(UserID);
CREATE INDEX IX_SystemLogs_OperationTime ON SystemLogs(OperationTime);
GO

-- 4. 创建存储过程
-- 用户管理存储过程
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
    IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
    BEGIN
        RAISERROR('用户名已存在', 16, 1)
        RETURN
    END

    INSERT INTO Users (Username, Password, Role, Email, Phone, SecurityQuestion, SecurityAnswer)
    VALUES (@Username, @Password, @Role, @Email, @Phone, @SecurityQuestion, @SecurityAnswer)
END
GO

CREATE PROCEDURE sp_LoginUser
    @Username NVARCHAR(50),
    @Password NVARCHAR(100)
AS
BEGIN
    SELECT UserID, Username, Role, Email, Phone
    FROM Users
    WHERE Username = @Username AND Password = @Password
END
GO

-- 商品管理存储过程
CREATE PROCEDURE sp_AddProduct
    @Name NVARCHAR(100),
    @Description NVARCHAR(500),
    @Price DECIMAL(10, 2),
    @Stock INT,
    @Category NVARCHAR(50),
    @ImagePath NVARCHAR(255),
    @CreatedBy INT
AS
BEGIN
    INSERT INTO Products (Name, Description, Price, Stock, Category, ImagePath, CreatedBy)
    VALUES (@Name, @Description, @Price, @Stock, @Category, @ImagePath, @CreatedBy)
END
GO

CREATE PROCEDURE sp_UpdateProduct
    @ProductID INT,
    @Name NVARCHAR(100),
    @Description NVARCHAR(500),
    @Price DECIMAL(10, 2),
    @Category NVARCHAR(50),
    @ImagePath NVARCHAR(255)
AS
BEGIN
    UPDATE Products
    SET Name = @Name,
        Description = @Description,
        Price = @Price,
        Category = @Category,
        ImagePath = @ImagePath,
        ModifiedDate = GETDATE()
    WHERE ProductID = @ProductID
END
GO

-- 订单管理存储过程
CREATE PROCEDURE sp_CreateOrder
    @UserID INT,
    @TotalAmount DECIMAL(10, 2),
    @ShippingAddress NVARCHAR(200),
    @ContactPhone NVARCHAR(20)
AS
BEGIN
    DECLARE @OrderID INT
    
    INSERT INTO Orders (UserID, TotalAmount, ShippingAddress, ContactPhone)
    VALUES (@UserID, @TotalAmount, @ShippingAddress, @ContactPhone)
    
    SET @OrderID = SCOPE_IDENTITY()
    
    -- 清空购物车
    DELETE FROM ShoppingCart WHERE UserID = @UserID
    
    RETURN @OrderID
END
GO

-- 库存管理存储过程
CREATE PROCEDURE sp_UpdateInventory
    @ProductID INT,
    @ChangeAmount INT,
    @OperationType NVARCHAR(50),
    @OperatorID INT,
    @Notes NVARCHAR(200)
AS
BEGIN
    DECLARE @CurrentStock INT
    
    -- 获取当前库存
    SELECT @CurrentStock = Stock
    FROM Products
    WHERE ProductID = @ProductID
    
    -- 更新库存
    UPDATE Products
    SET Stock = Stock + @ChangeAmount
    WHERE ProductID = @ProductID
    
    -- 记录库存变更
    INSERT INTO InventoryLog (ProductID, ChangeAmount, CurrentStock, OperationType, OperatorID, Notes)
    VALUES (@ProductID, @ChangeAmount, @CurrentStock + @ChangeAmount, @OperationType, @OperatorID, @Notes)
END
GO

-- 5. 创建初始数据
-- 创建管理员账户
INSERT INTO Users (Username, Password, Role, Email, Phone)
VALUES ('admin', 'admin123', 'Admin', 'admin@example.com', '13800138000');
GO

-- 创建默认商品分类
INSERT INTO ProductCategories (CategoryName, Description)
VALUES 
('服装', '各类服装商品'),
('食品', '各类食品商品'),
('电子产品', '各类电子产品');
GO

-- 创建默认角色权限
INSERT INTO RolePermissions (Role, PermissionName, Description)
VALUES 
('Admin', 'All', '所有权限'),
('Merchant', 'ProductManagement', '商品管理权限'),
('Customer', 'Shopping', '购物权限');
GO