Imports System.Data.SqlClient
Imports System.Data
Public Class frmInventory
    Private Sub frmInventory_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        CheckPermission("ManageInventory") ' 权限校验
        LoadProducts() ' 加载商品到ComboBox
    End Sub

    Private Sub LoadProducts()
        Using conn As New SqlConnection(My.Settings.DBConnectionString)
            conn.Open()
            Dim cmd As New SqlCommand("SELECT ProductID, Name FROM Products WHERE CreatedBy = @UserID", conn)
            cmd.Parameters.AddWithValue("@UserID", GlobalVariables.CurrentUserID)
            Dim adapter As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            adapter.Fill(dt)
            cmbProduct.DataSource = dt
            cmbProduct.DisplayMember = "Name"
            cmbProduct.ValueMember = "ProductID"
        End Using
    End Sub

    Private Sub btnUpdate_Click(sender As Object, e As EventArgs) Handles btnUpdate.Click
        If cmbProduct.SelectedValue Is Nothing OrElse String.IsNullOrEmpty(txtAdjustment.Text) Then
            MessageBox.Show("请选择商品并输入调整数量！", "错误", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return
        End If

        Using conn As New SqlConnection(My.Settings.DBConnectionString)
            conn.Open()
            Dim cmd As New SqlCommand("sp_UpdateInventory", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ProductID", CInt(cmbProduct.SelectedValue))
            cmd.Parameters.AddWithValue("@Adjustment", CInt(txtAdjustment.Text))
            cmd.Parameters.AddWithValue("@OperatorID", GlobalVariables.CurrentUserID)
            cmd.Parameters.AddWithValue("@Notes", "手动调整")

            Try
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    MessageBox.Show($"库存更新成功！当前库存：{reader("CurrentStock")}", "提示", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            Catch ex As SqlException
                MessageBox.Show("错误：" & ex.Message, "错误", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
    End Sub

    Private Sub CheckPermission(permissionName As String)
        ' 同商品管理界面的权限校验逻辑
    End Sub
End Class