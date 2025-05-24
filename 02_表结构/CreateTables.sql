USE BrandManagement;
GO

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

-- 创建订单明细表
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL  -- 下单时的价格（防止商品价格变动影响历史订单）
);

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

-- 创建购物车表
CREATE TABLE ShoppingCart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL DEFAULT 1,
    AddedDate DATETIME DEFAULT GETDATE()
);

-- 创建商品分类表
CREATE TABLE ProductCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    ParentCategoryID INT,
    Description NVARCHAR(200),
    CreateTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ParentCategoryID) REFERENCES ProductCategories(CategoryID)
);

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

-- 创建角色权限表
CREATE TABLE RolePermissions (
    PermissionID INT PRIMARY KEY IDENTITY(1,1),
    Role NVARCHAR(20) NOT NULL,
    PermissionName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    CreateTime DATETIME DEFAULT GETDATE()
); 