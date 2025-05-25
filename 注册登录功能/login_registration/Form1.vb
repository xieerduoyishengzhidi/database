Imports System.Data.SqlClient
Imports System.Windows.Forms.VisualStyles.VisualStyleElement
Imports System.Windows.Forms.VisualStyles.VisualStyleElement.Button

Public Class Form1
    Dim form2 As New Form2
    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        myconn.Open()
        mycmd.Connection = myconn
    End Sub
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Me.Hide()
        form2.Show()
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        If String.IsNullOrEmpty(TextBox1.Text) Then
            MsgBox("用户名不能为空！")
            TextBox1.Focus() ' 聚焦到用户名输入框
            Return
        End If

        ' 检查密码是否为空
        If String.IsNullOrEmpty(TextBox2.Text) Then
            MsgBox("密码不能为空！")
            TextBox2.Focus()
            Return
        End If

        mycmd.CommandType = CommandType.StoredProcedure
        mycmd.CommandText = "sp_userlogin"
        mycmd.Parameters.Clear()
        mycmd.Parameters.Add("@username", SqlDbType.NVarChar, 50).Value = TextBox1.Text.Trim()
        mycmd.Parameters.Add("@password", SqlDbType.NVarChar, 100).Value = TextBox2.Text.Trim()

        ' 添加输出参数捕获存储过程返回值
        Dim returnParam As New SqlParameter("@ReturnValue", SqlDbType.Int)
        returnParam.Direction = ParameterDirection.ReturnValue
        mycmd.Parameters.Add(returnParam)

        ' 打开连接并执行
        mycmd.ExecuteNonQuery()

        ' 获取存储过程返回值
        Dim result As Integer = CInt(returnParam.Value)

        Select Case result
            Case result > 0 ' 登录成功
                Me.Close()

                '跳转到管理员/商家/用户界面

            Case -1 ' 用户名不存在
                MsgBox("用户名不存在，请先注册")
                TextBox1.Text = ""
                TextBox2.Text = ""
            Case -2 ' 密码输入错误
                MsgBox("密码错误，请重新输入")
                TextBox2.Text = ""
                TextBox2.Focus()
        End Select
    End Sub

    Private Sub Form1_FormClosed(sender As Object, e As FormClosedEventArgs) Handles MyBase.FormClosed
        myconn.Close()
    End Sub
End Class
