USE BrandManagement;
GO

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