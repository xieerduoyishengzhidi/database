Imports System.Data.SqlClient
Imports System.Data
Public Class frmAddProduct
    Private Sub frmAddProduct_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        LoadCategories() ' 加载分类
    End Sub

    Private Sub LoadCategories()
        Using conn As New SqlConnection(My.Settings.DBConnectionString)
            conn.Open()
            Dim cmd As New SqlCommand("SELECT DISTINCT Category FROM Products WHERE CreatedBy = @UserID", conn)
            cmd.Parameters.AddWithValue("@UserID", GlobalVariables.CurrentUserID)
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            cmbCategory.Items.Clear()
            While reader.Read()
                cmbCategory.Items.Add(reader("Category"))
            End While
        End Using
    End Sub

    Private Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        If String.IsNullOrEmpty(txtName.Text) OrElse
           String.IsNullOrEmpty(txtPrice.Text) OrElse
           String.IsNullOrEmpty(txtStock.Text) Then
            MessageBox.Show("名称、价格和库存为必填项！", "错误", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return
        End If

        Using conn As New SqlConnection(My.Settings.DBConnectionString)
            conn.Open()
            Dim cmd As New SqlCommand("sp_AddProduct", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@Name", txtName.Text)
            cmd.Parameters.AddWithValue("@Description", rtbDescription.Text)
            cmd.Parameters.AddWithValue("@Price", CDec(txtPrice.Text))
            cmd.Parameters.AddWithValue("@Stock", CInt(txtStock.Text))
            cmd.Parameters.AddWithValue("@Category", If(cmbCategory.SelectedItem Is Nothing, DBNull.Value, cmbCategory.SelectedItem))
            cmd.Parameters.AddWithValue("@ImagePath", If(String.IsNullOrEmpty(txtimagePath.Text), DBNull.Value, txtimagePath.Text))
            cmd.Parameters.AddWithValue("@CreatedBy", GlobalVariables.CurrentUserID)

            Try
                cmd.ExecuteNonQuery()
                MessageBox.Show("商品添加成功！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.DialogResult = DialogResult.OK
                Me.Close()
            Catch ex As SqlException
                MessageBox.Show("数据库错误：" & ex.Message, "错误", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
    End Sub
End Class
