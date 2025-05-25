Imports System.Data.SqlClient

Module Module1
    Public myconn As New SqlConnection("Database = BrandManagement; Data Source = SHQ; Integrated Security = True")
    Public mycmd As New SqlCommand()
    Public username As String
    Public password As String
End Module
