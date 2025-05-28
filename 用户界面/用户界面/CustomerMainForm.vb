Imports System.Data.SqlClient

Public Class CustomerMainForm
    Public UserID As Integer '登录后赋值

    ' 1. 查询商品
    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Dim dt As New DataTable()
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_SearchProducts", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@Keyword", txtSearch.Text.Trim())
            cmd.Parameters.AddWithValue("@Category", DBNull.Value)
            cmd.Parameters.AddWithValue("@MinPrice", DBNull.Value)
            cmd.Parameters.AddWithValue("@MaxPrice", DBNull.Value)
            conn.Open()
            dt.Load(cmd.ExecuteReader())
        End Using
        dgvProductList.DataSource = dt
    End Sub

    ' 2. 加入购物车
    Private Sub btnAddToCart_Click(sender As Object, e As EventArgs) Handles btnAddToCart.Click
        If dgvProductList.SelectedRows.Count = 0 Then Return
        Dim productID = Convert.ToInt32(dgvProductList.SelectedRows(0).Cells("ProductID").Value)
        Dim quantity = Convert.ToInt32(txtQty.Text)
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_AddToCart", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UserID", UserID)
            cmd.Parameters.AddWithValue("@ProductID", productID)
            cmd.Parameters.AddWithValue("@Quantity", quantity)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        MessageBox.Show("已加入购物车")
    End Sub

    ' 3. 查看购物车
    Private Sub btnViewCart_Click(sender As Object, e As EventArgs) Handles btnViewCart.Click
        Dim dt As New DataTable()
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_GetCartItems", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UserID", UserID)
            conn.Open()
            dt.Load(cmd.ExecuteReader())
        End Using
        dgvCart.DataSource = dt
    End Sub

    ' 4. 修改购物车数量
    Private Sub btnUpdateCart_Click(sender As Object, e As EventArgs) Handles btnUpdateCart.Click
        If dgvCart.SelectedRows.Count = 0 Then Return
        Dim productID = Convert.ToInt32(dgvCart.SelectedRows(0).Cells("ProductID").Value)
        Dim quantity = Convert.ToInt32(txtUpdateQty.Text)
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_UpdateCartItemQuantity", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UserID", UserID)
            cmd.Parameters.AddWithValue("@ProductID", productID)
            cmd.Parameters.AddWithValue("@NewQuantity", quantity)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        MessageBox.Show("数量已修改")
    End Sub

    ' 5. 删除购物车商品
    Private Sub btnRemoveCartItem_Click(sender As Object, e As EventArgs) Handles btnRemoveCartItem.Click
        If dgvCart.SelectedRows.Count = 0 Then Return
        Dim productID = Convert.ToInt32(dgvCart.SelectedRows(0).Cells("ProductID").Value)
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_RemoveFromCart", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UserID", UserID)
            cmd.Parameters.AddWithValue("@ProductID", productID)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        MessageBox.Show("已删除")
    End Sub

    ' 6. 清空购物车
    Private Sub btnClearCart_Click(sender As Object, e As EventArgs) Handles btnClearCart.Click
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_ClearCart", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UserID", UserID)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        MessageBox.Show("已清空购物车")
    End Sub

    ' 7. 购物车结算（生成订单）
    Private Sub btnCheckout_Click(sender As Object, e As EventArgs) Handles btnCheckout.Click
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_PlaceOrder", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UserID", UserID)
            cmd.Parameters.AddWithValue("@ShippingAddress", txtAddress.Text.Trim())
            cmd.Parameters.AddWithValue("@ContactPhone", txtPhone.Text.Trim())
            conn.Open()
            Dim orderID = cmd.ExecuteScalar()
            MessageBox.Show("下单成功，订单号：" & orderID.ToString())
        End Using
    End Sub

    ' 8. 查询订单
    Private Sub btnQueryOrders_Click(sender As Object, e As EventArgs) Handles btnQueryOrders.Click
        Dim dt As New DataTable()
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_GetOrders", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UserID", UserID)
            conn.Open()
            dt.Load(cmd.ExecuteReader())
        End Using
        dgvOrders.DataSource = dt
    End Sub

    ' 9. 取消订单
    Private Sub btnCancelOrder_Click(sender As Object, e As EventArgs) Handles btnCancelOrder.Click
        If dgvOrders.SelectedRows.Count = 0 Then Return
        Dim orderID = Convert.ToInt32(dgvOrders.SelectedRows(0).Cells("OrderID").Value)
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_UpdateOrderStatus", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@OrderID", orderID)
            cmd.Parameters.AddWithValue("@NewStatus", "Cancelled")
            cmd.Parameters.AddWithValue("@UpdatedBy", UserID)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        MessageBox.Show("订单已取消")
    End Sub

    ' 10. 商品评价
    Private Sub btnReview_Click(sender As Object, e As EventArgs) Handles btnReview.Click
        Dim productID = Convert.ToInt32(txtReviewProductID.Text)
        Dim orderID = Convert.ToInt32(txtReviewOrderID.Text)
        Dim rating = Convert.ToInt32(txtReviewScore.Text)
        Dim comment = txtReviewComment.Text.Trim()
        Using conn As New SqlConnection("Data Source=.;Initial Catalog=BrandManagement;Integrated Security=True")
            Dim cmd As New SqlCommand("sp_AddProductReview", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ProductID", productID)
            cmd.Parameters.AddWithValue("@UserID", UserID)
            cmd.Parameters.AddWithValue("@OrderID", orderID)
            cmd.Parameters.AddWithValue("@Rating", rating)
            cmd.Parameters.AddWithValue("@Comment", comment)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        MessageBox.Show("评价成功")
    End Sub

End Class
