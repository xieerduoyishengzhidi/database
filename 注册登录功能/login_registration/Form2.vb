Imports System.Data.SqlClient

Public Class Form2
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        ' 检查用户名是否为空
        If String.IsNullOrEmpty(TextBox1.Text) Then
            MsgBox("用户名不能为空！")
            TextBox1.Focus() ' 聚焦到用户名输入框
            Return
        End If

        ' 检查手机号是否为空
        If String.IsNullOrEmpty(TextBox2.Text) Then
            MsgBox("手机号不能为空！")
            TextBox2.Focus()
            Return
        End If

        ' 检查密码是否为空
        If String.IsNullOrEmpty(TextBox3.Text) Then
            MsgBox("密码不能为空！")
            TextBox3.Focus()
            Return
        End If

        ' 检查是否选择用户类型
        If RadioButton1.Checked And RadioButton2.Checked And RadioButton3.Checked Then
            MsgBox("请选择用户类型！")
            Return
        End If

        mycmd.CommandType = CommandType.StoredProcedure
        mycmd.CommandText = "sp_registeruser"

        ' 清除旧参数
        mycmd.Parameters.Clear()

        ' 添加公共参数
        mycmd.Parameters.Add("@username", SqlDbType.NVarChar, 50).Value = TextBox1.Text.Trim()
        mycmd.Parameters.Add("@phone", SqlDbType.NVarChar, 20).Value = TextBox2.Text.Trim()
        mycmd.Parameters.Add("@password", SqlDbType.NVarChar, 100).Value = TextBox3.Text.Trim()

        If RadioButton1.Checked Then
            mycmd.Parameters.Add("@role", SqlDbType.NVarChar, 20).Value = "admin"
        ElseIf RadioButton2.Checked Then
            mycmd.Parameters.Add("@role", SqlDbType.NVarChar, 20).Value = "merchant"
        ElseIf RadioButton3.Checked Then
            mycmd.Parameters.Add("@role", SqlDbType.NVarChar, 20).Value = "customer"
        End If

        ' 添加输出参数捕获存储过程返回值
        Dim returnParam As New SqlParameter("@ReturnValue", SqlDbType.Int)
        returnParam.Direction = ParameterDirection.ReturnValue
        mycmd.Parameters.Add(returnParam)

        ' 打开连接并执行
        mycmd.ExecuteNonQuery()

        ' 获取存储过程返回值
        Dim result As Integer = CInt(returnParam.Value)

        Select Case result
            Case result > 0 ' 注册成功
                MsgBox("注册成功! 请使用新注册账户登录")
                Me.Close()
                Form1.Show()
            Case -1 ' 用户名已存在
                MsgBox("用户名已存在，请选择其他用户名")
                TextBox1.Text = ""
                TextBox1.Focus()
        End Select
    End Sub
End Class