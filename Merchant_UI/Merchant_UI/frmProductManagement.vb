Imports System.Data.SqlClient
Imports System.Data
Public Class frmProductManagement
    Private currentPage As Integer = 1
    Private pageSize As Integer = 10

    ' 窗体加载时加载商品列表
    Private Sub frmProductManagement_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        CheckPermission("ManageProducts") ' 权限校验
        LoadCategories() ' 加载分类到ComboBox
        LoadProducts()   ' 初始化商品列表
    End Sub

    ' 加载商品分类到ComboBox
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

    ' 加载商品列表
    Private Sub LoadProducts()
        Using conn As New SqlConnection(My.Settings.DBConnectionString)
            conn.Open()
            Dim cmd As New SqlCommand("sp_SearchProducts", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@Keyword", If(String.IsNullOrEmpty(txtKeyword.Text), DBNull.Value, txtKeyword.Text))
            cmd.Parameters.AddWithValue("@Category", If(cmbCategory.SelectedItem Is Nothing, DBNull.Value, cmbCategory.SelectedItem))
            cmd.Parameters.AddWithValue("@MinPrice", DBNull.Value) ' 可根据需求扩展
            cmd.Parameters.AddWithValue("@MaxPrice", DBNull.Value)
            cmd.Parameters.AddWithValue("@PageNumber", currentPage)
            cmd.Parameters.AddWithValue("@PageSize", pageSize)

            Dim adapter As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            adapter.Fill(dt)
            dgvProducts.DataSource = dt
            dgvProducts.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill ' 自适应列宽
        End Using
    End Sub

    ' 搜索按钮点击事件
    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnsearch.Click
        currentPage = 1 ' 重置页码
        LoadProducts()
    End Sub

    ' 添加商品按钮点击事件
    Private Sub btnAddProduct_Click(sender As Object, e As EventArgs) Handles btnAddProduct.Click
        Using frmAdd As New frmAddProduct()
            If frmAdd.ShowDialog() = DialogResult.OK Then
                LoadProducts() ' 刷新列表
            End If
        End Using
    End Sub

    ' 权限校验
    Private Sub CheckPermission(permissionName As String)
        Using conn As New SqlConnection(My.Settings.DBConnectionString)
            conn.Open()
            Dim cmd As New SqlCommand("sp_CheckPermission", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UserID", GlobalVariables.CurrentUserID)
            cmd.Parameters.AddWithValue("@RequiredPermission", permissionName)
            Dim result As Integer = CInt(cmd.ExecuteScalar())
            If result = 0 Then
                MessageBox.Show("权限不足，无法访问此功能！", "警告", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Me.Close()
            End If
        End Using
    End Sub
End Class
