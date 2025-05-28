<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CustomerMainForm
    Inherits System.Windows.Forms.Form

    'Form 重写 Dispose，以清理组件列表。
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Windows 窗体设计器所必需的
    Private components As System.ComponentModel.IContainer

    '注意: 以下过程是 Windows 窗体设计器所必需的
    '可以使用 Windows 窗体设计器修改它。  
    '不要使用代码编辑器修改它。
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.tabMain = New System.Windows.Forms.TabControl()
        Me.tabBrowse = New System.Windows.Forms.TabPage()
        Me.btnAddToCart = New System.Windows.Forms.Button()
        Me.txtQty = New System.Windows.Forms.TextBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.dgvProductList = New System.Windows.Forms.DataGridView()
        Me.btnSearch = New System.Windows.Forms.Button()
        Me.txtSearch = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.tabCart = New System.Windows.Forms.TabPage()
        Me.btnCheckout = New System.Windows.Forms.Button()
        Me.txtPhone = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.txtAddress = New System.Windows.Forms.TextBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.btnClearCart = New System.Windows.Forms.Button()
        Me.btnRemoveCartItem = New System.Windows.Forms.Button()
        Me.btnUpdateCart = New System.Windows.Forms.Button()
        Me.txtUpdateQty = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.dgvCart = New System.Windows.Forms.DataGridView()
        Me.btnViewCart = New System.Windows.Forms.Button()
        Me.tabOrder = New System.Windows.Forms.TabPage()
        Me.btnCancelOrder = New System.Windows.Forms.Button()
        Me.dgvOrders = New System.Windows.Forms.DataGridView()
        Me.btnQueryOrders = New System.Windows.Forms.Button()
        Me.tabReview = New System.Windows.Forms.TabPage()
        Me.btnReview = New System.Windows.Forms.Button()
        Me.txtReviewComment = New System.Windows.Forms.TextBox()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.txtReviewScore = New System.Windows.Forms.ComboBox()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.txtReviewProductID = New System.Windows.Forms.TextBox()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.txtReviewOrderID = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.tabMain.SuspendLayout()
        Me.tabBrowse.SuspendLayout()
        CType(Me.dgvProductList, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.tabCart.SuspendLayout()
        CType(Me.dgvCart, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.tabOrder.SuspendLayout()
        CType(Me.dgvOrders, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.tabReview.SuspendLayout()
        Me.SuspendLayout()
        '
        'tabMain
        '
        Me.tabMain.Controls.Add(Me.tabBrowse)
        Me.tabMain.Controls.Add(Me.tabCart)
        Me.tabMain.Controls.Add(Me.tabOrder)
        Me.tabMain.Controls.Add(Me.tabReview)
        Me.tabMain.Location = New System.Drawing.Point(12, 12)
        Me.tabMain.Name = "tabMain"
        Me.tabMain.SelectedIndex = 0
        Me.tabMain.Size = New System.Drawing.Size(784, 440)
        Me.tabMain.TabIndex = 0
        '
        'tabBrowse
        '
        Me.tabBrowse.Controls.Add(Me.btnAddToCart)
        Me.tabBrowse.Controls.Add(Me.txtQty)
        Me.tabBrowse.Controls.Add(Me.Label2)
        Me.tabBrowse.Controls.Add(Me.dgvProductList)
        Me.tabBrowse.Controls.Add(Me.btnSearch)
        Me.tabBrowse.Controls.Add(Me.txtSearch)
        Me.tabBrowse.Controls.Add(Me.Label1)
        Me.tabBrowse.Location = New System.Drawing.Point(4, 25)
        Me.tabBrowse.Name = "tabBrowse"
        Me.tabBrowse.Padding = New System.Windows.Forms.Padding(3)
        Me.tabBrowse.Size = New System.Drawing.Size(776, 411)
        Me.tabBrowse.TabIndex = 0
        Me.tabBrowse.Text = "商品浏览"
        Me.tabBrowse.UseVisualStyleBackColor = True
        '
        'btnAddToCart
        '
        Me.btnAddToCart.Location = New System.Drawing.Point(268, 63)
        Me.btnAddToCart.Name = "btnAddToCart"
        Me.btnAddToCart.Size = New System.Drawing.Size(92, 23)
        Me.btnAddToCart.TabIndex = 6
        Me.btnAddToCart.Text = "加入购物车"
        Me.btnAddToCart.UseVisualStyleBackColor = True
        '
        'txtQty
        '
        Me.txtQty.Location = New System.Drawing.Point(118, 62)
        Me.txtQty.Name = "txtQty"
        Me.txtQty.Size = New System.Drawing.Size(100, 25)
        Me.txtQty.TabIndex = 5
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(30, 62)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(52, 15)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "数量："
        '
        'dgvProductList
        '
        Me.dgvProductList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvProductList.Location = New System.Drawing.Point(-1, 45)
        Me.dgvProductList.Name = "dgvProductList"
        Me.dgvProductList.RowHeadersWidth = 51
        Me.dgvProductList.RowTemplate.Height = 27
        Me.dgvProductList.Size = New System.Drawing.Size(773, 363)
        Me.dgvProductList.TabIndex = 3
        '
        'btnSearch
        '
        Me.btnSearch.Location = New System.Drawing.Point(256, 17)
        Me.btnSearch.Name = "btnSearch"
        Me.btnSearch.Size = New System.Drawing.Size(75, 23)
        Me.btnSearch.TabIndex = 2
        Me.btnSearch.Text = "搜索"
        Me.btnSearch.UseVisualStyleBackColor = True
        '
        'txtSearch
        '
        Me.txtSearch.Location = New System.Drawing.Point(118, 14)
        Me.txtSearch.Name = "txtSearch"
        Me.txtSearch.Size = New System.Drawing.Size(100, 25)
        Me.txtSearch.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(15, 17)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(97, 15)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "搜索关键词："
        '
        'tabCart
        '
        Me.tabCart.Controls.Add(Me.btnCheckout)
        Me.tabCart.Controls.Add(Me.txtPhone)
        Me.tabCart.Controls.Add(Me.Label5)
        Me.tabCart.Controls.Add(Me.txtAddress)
        Me.tabCart.Controls.Add(Me.Label4)
        Me.tabCart.Controls.Add(Me.btnClearCart)
        Me.tabCart.Controls.Add(Me.btnRemoveCartItem)
        Me.tabCart.Controls.Add(Me.btnUpdateCart)
        Me.tabCart.Controls.Add(Me.txtUpdateQty)
        Me.tabCart.Controls.Add(Me.Label3)
        Me.tabCart.Controls.Add(Me.dgvCart)
        Me.tabCart.Controls.Add(Me.btnViewCart)
        Me.tabCart.Location = New System.Drawing.Point(4, 25)
        Me.tabCart.Name = "tabCart"
        Me.tabCart.Padding = New System.Windows.Forms.Padding(3)
        Me.tabCart.Size = New System.Drawing.Size(776, 411)
        Me.tabCart.TabIndex = 1
        Me.tabCart.Text = "购物车"
        Me.tabCart.UseVisualStyleBackColor = True
        '
        'btnCheckout
        '
        Me.btnCheckout.Location = New System.Drawing.Point(317, 297)
        Me.btnCheckout.Name = "btnCheckout"
        Me.btnCheckout.Size = New System.Drawing.Size(100, 32)
        Me.btnCheckout.TabIndex = 11
        Me.btnCheckout.Text = "结算/下单"
        Me.btnCheckout.UseVisualStyleBackColor = True
        '
        'txtPhone
        '
        Me.txtPhone.Location = New System.Drawing.Point(153, 315)
        Me.txtPhone.Name = "txtPhone"
        Me.txtPhone.Size = New System.Drawing.Size(100, 25)
        Me.txtPhone.TabIndex = 10
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(27, 326)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(82, 15)
        Me.Label5.TabIndex = 9
        Me.Label5.Text = "联系电话："
        '
        'txtAddress
        '
        Me.txtAddress.Location = New System.Drawing.Point(153, 266)
        Me.txtAddress.Name = "txtAddress"
        Me.txtAddress.Size = New System.Drawing.Size(100, 25)
        Me.txtAddress.TabIndex = 8
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(24, 266)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(82, 15)
        Me.Label4.TabIndex = 7
        Me.Label4.Text = "收货地址："
        '
        'btnClearCart
        '
        Me.btnClearCart.Location = New System.Drawing.Point(27, 184)
        Me.btnClearCart.Name = "btnClearCart"
        Me.btnClearCart.Size = New System.Drawing.Size(100, 23)
        Me.btnClearCart.TabIndex = 6
        Me.btnClearCart.Text = "清空购物车"
        Me.btnClearCart.UseVisualStyleBackColor = True
        '
        'btnRemoveCartItem
        '
        Me.btnRemoveCartItem.Location = New System.Drawing.Point(171, 125)
        Me.btnRemoveCartItem.Name = "btnRemoveCartItem"
        Me.btnRemoveCartItem.Size = New System.Drawing.Size(75, 23)
        Me.btnRemoveCartItem.TabIndex = 5
        Me.btnRemoveCartItem.Text = "删除商品"
        Me.btnRemoveCartItem.UseVisualStyleBackColor = True
        '
        'btnUpdateCart
        '
        Me.btnUpdateCart.Location = New System.Drawing.Point(27, 125)
        Me.btnUpdateCart.Name = "btnUpdateCart"
        Me.btnUpdateCart.Size = New System.Drawing.Size(75, 23)
        Me.btnUpdateCart.TabIndex = 4
        Me.btnUpdateCart.Text = "修改数量"
        Me.btnUpdateCart.UseVisualStyleBackColor = True
        '
        'txtUpdateQty
        '
        Me.txtUpdateQty.Location = New System.Drawing.Point(27, 80)
        Me.txtUpdateQty.Name = "txtUpdateQty"
        Me.txtUpdateQty.Size = New System.Drawing.Size(100, 25)
        Me.txtUpdateQty.TabIndex = 3
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(24, 49)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(82, 15)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "修改数量："
        '
        'dgvCart
        '
        Me.dgvCart.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvCart.Location = New System.Drawing.Point(3, 28)
        Me.dgvCart.Name = "dgvCart"
        Me.dgvCart.RowHeadersWidth = 51
        Me.dgvCart.RowTemplate.Height = 27
        Me.dgvCart.Size = New System.Drawing.Size(774, 380)
        Me.dgvCart.TabIndex = 1
        '
        'btnViewCart
        '
        Me.btnViewCart.Location = New System.Drawing.Point(6, 3)
        Me.btnViewCart.Name = "btnViewCart"
        Me.btnViewCart.Size = New System.Drawing.Size(92, 23)
        Me.btnViewCart.TabIndex = 0
        Me.btnViewCart.Text = "刷新购物车"
        Me.btnViewCart.UseVisualStyleBackColor = True
        '
        'tabOrder
        '
        Me.tabOrder.Controls.Add(Me.btnCancelOrder)
        Me.tabOrder.Controls.Add(Me.dgvOrders)
        Me.tabOrder.Controls.Add(Me.btnQueryOrders)
        Me.tabOrder.Location = New System.Drawing.Point(4, 25)
        Me.tabOrder.Name = "tabOrder"
        Me.tabOrder.Size = New System.Drawing.Size(776, 411)
        Me.tabOrder.TabIndex = 2
        Me.tabOrder.Text = "订单管理"
        Me.tabOrder.UseVisualStyleBackColor = True
        '
        'btnCancelOrder
        '
        Me.btnCancelOrder.Location = New System.Drawing.Point(128, 14)
        Me.btnCancelOrder.Name = "btnCancelOrder"
        Me.btnCancelOrder.Size = New System.Drawing.Size(75, 23)
        Me.btnCancelOrder.TabIndex = 2
        Me.btnCancelOrder.Text = "取消订单"
        Me.btnCancelOrder.UseVisualStyleBackColor = True
        '
        'dgvOrders
        '
        Me.dgvOrders.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvOrders.Location = New System.Drawing.Point(4, 43)
        Me.dgvOrders.Name = "dgvOrders"
        Me.dgvOrders.RowHeadersWidth = 51
        Me.dgvOrders.RowTemplate.Height = 27
        Me.dgvOrders.Size = New System.Drawing.Size(772, 365)
        Me.dgvOrders.TabIndex = 1
        '
        'btnQueryOrders
        '
        Me.btnQueryOrders.BackColor = System.Drawing.Color.Transparent
        Me.btnQueryOrders.Location = New System.Drawing.Point(4, 13)
        Me.btnQueryOrders.Name = "btnQueryOrders"
        Me.btnQueryOrders.Size = New System.Drawing.Size(75, 23)
        Me.btnQueryOrders.TabIndex = 0
        Me.btnQueryOrders.Text = "刷新订单"
        Me.btnQueryOrders.UseVisualStyleBackColor = False
        '
        'tabReview
        '
        Me.tabReview.Controls.Add(Me.btnReview)
        Me.tabReview.Controls.Add(Me.txtReviewComment)
        Me.tabReview.Controls.Add(Me.Label9)
        Me.tabReview.Controls.Add(Me.txtReviewScore)
        Me.tabReview.Controls.Add(Me.Label8)
        Me.tabReview.Controls.Add(Me.txtReviewProductID)
        Me.tabReview.Controls.Add(Me.Label7)
        Me.tabReview.Controls.Add(Me.txtReviewOrderID)
        Me.tabReview.Controls.Add(Me.Label6)
        Me.tabReview.Location = New System.Drawing.Point(4, 25)
        Me.tabReview.Name = "tabReview"
        Me.tabReview.Size = New System.Drawing.Size(776, 411)
        Me.tabReview.TabIndex = 3
        Me.tabReview.Text = "商品评价"
        Me.tabReview.UseVisualStyleBackColor = True
        '
        'btnReview
        '
        Me.btnReview.Location = New System.Drawing.Point(24, 201)
        Me.btnReview.Name = "btnReview"
        Me.btnReview.Size = New System.Drawing.Size(75, 23)
        Me.btnReview.TabIndex = 8
        Me.btnReview.Text = "提交评价"
        Me.btnReview.UseVisualStyleBackColor = True
        '
        'txtReviewComment
        '
        Me.txtReviewComment.Location = New System.Drawing.Point(134, 147)
        Me.txtReviewComment.Multiline = True
        Me.txtReviewComment.Name = "txtReviewComment"
        Me.txtReviewComment.Size = New System.Drawing.Size(100, 25)
        Me.txtReviewComment.TabIndex = 7
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(18, 147)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(82, 15)
        Me.Label9.TabIndex = 6
        Me.Label9.Text = "评价内容："
        '
        'txtReviewScore
        '
        Me.txtReviewScore.FormattingEnabled = True
        Me.txtReviewScore.Location = New System.Drawing.Point(134, 97)
        Me.txtReviewScore.Name = "txtReviewScore"
        Me.txtReviewScore.Size = New System.Drawing.Size(121, 23)
        Me.txtReviewScore.TabIndex = 5
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(3, 97)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(107, 15)
        Me.Label8.TabIndex = 4
        Me.Label8.Text = "评分 (1–5)："
        '
        'txtReviewProductID
        '
        Me.txtReviewProductID.Location = New System.Drawing.Point(134, 47)
        Me.txtReviewProductID.Name = "txtReviewProductID"
        Me.txtReviewProductID.Size = New System.Drawing.Size(100, 25)
        Me.txtReviewProductID.TabIndex = 3
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(18, 50)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(68, 15)
        Me.Label7.TabIndex = 2
        Me.Label7.Text = "商品ID："
        '
        'txtReviewOrderID
        '
        Me.txtReviewOrderID.Location = New System.Drawing.Point(134, 16)
        Me.txtReviewOrderID.Name = "txtReviewOrderID"
        Me.txtReviewOrderID.Size = New System.Drawing.Size(100, 25)
        Me.txtReviewOrderID.TabIndex = 1
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(15, 13)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(67, 15)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "订单号："
        '
        'CustomerMainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.tabMain)
        Me.Name = "CustomerMainForm"
        Me.Text = "Form1"
        Me.tabMain.ResumeLayout(False)
        Me.tabBrowse.ResumeLayout(False)
        Me.tabBrowse.PerformLayout()
        CType(Me.dgvProductList, System.ComponentModel.ISupportInitialize).EndInit()
        Me.tabCart.ResumeLayout(False)
        Me.tabCart.PerformLayout()
        CType(Me.dgvCart, System.ComponentModel.ISupportInitialize).EndInit()
        Me.tabOrder.ResumeLayout(False)
        CType(Me.dgvOrders, System.ComponentModel.ISupportInitialize).EndInit()
        Me.tabReview.ResumeLayout(False)
        Me.tabReview.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents tabMain As TabControl
    Friend WithEvents tabBrowse As TabPage
    Friend WithEvents tabCart As TabPage
    Friend WithEvents tabOrder As TabPage
    Friend WithEvents tabReview As TabPage
    Friend WithEvents dgvProductList As DataGridView
    Friend WithEvents btnSearch As Button
    Friend WithEvents txtSearch As TextBox
    Friend WithEvents Label1 As Label
    Friend WithEvents btnAddToCart As Button
    Friend WithEvents txtQty As TextBox
    Friend WithEvents Label2 As Label
    Friend WithEvents btnCheckout As Button
    Friend WithEvents txtPhone As TextBox
    Friend WithEvents Label5 As Label
    Friend WithEvents txtAddress As TextBox
    Friend WithEvents Label4 As Label
    Friend WithEvents btnClearCart As Button
    Friend WithEvents btnRemoveCartItem As Button
    Friend WithEvents btnUpdateCart As Button
    Friend WithEvents txtUpdateQty As TextBox
    Friend WithEvents Label3 As Label
    Friend WithEvents dgvCart As DataGridView
    Friend WithEvents btnViewCart As Button
    Friend WithEvents btnCancelOrder As Button
    Friend WithEvents dgvOrders As DataGridView
    Friend WithEvents btnQueryOrders As Button
    Friend WithEvents btnReview As Button
    Friend WithEvents txtReviewComment As TextBox
    Friend WithEvents Label9 As Label
    Friend WithEvents txtReviewScore As ComboBox
    Friend WithEvents Label8 As Label
    Friend WithEvents txtReviewProductID As TextBox
    Friend WithEvents Label7 As Label
    Friend WithEvents txtReviewOrderID As TextBox
    Friend WithEvents Label6 As Label
End Class
