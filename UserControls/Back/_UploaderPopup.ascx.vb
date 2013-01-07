﻿'[[[NEW COPYRIGHT NOTICE]]]
Partial Class UserControls_Back_UploaderPopup
    Inherits System.Web.UI.UserControl
    Dim blnFileSaved As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        '' The following line is important for the confirmation msg box
        ''  => it will allow the event of the server side button to be fired
        If Page.IsPostBack Then
            Page.ClientScript.GetPostBackEventReference(Me, String.Empty)
        Else
            Page.Form.Enctype = "multipart/form-data"
        End If
    End Sub

    Public Event NeedCategoryRefresh()

    Public Function HasFile() As Boolean
        Return filUploader.HasFile
    End Function
    Public Function FileName() As String
        Return filUploader.FileName
    End Function
    Protected Sub lnkUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) 'Handles lnkUpload.Click
        RaiseEvent UploadClicked()
    End Sub

    Public Sub OpenFileUpload()
        popExtender.Show()
    End Sub

    Public Function GetFileName() As String
        Return filUploader.FileName
    End Function

    Public Sub SaveFile(ByVal strPath As String)

        Dim arrTemp = Split(strPath, ".")
        Dim numSegments = UBound(arrTemp)
        Dim strFileExt As String = arrTemp(numSegments)

        'Dim strFileExt2 As String = strPath.GetType.ToString

        'Need to check the file being uploaded is not
        'of a type listed in the excludedUploadFiles
        'setting in the web.config. For security, we
        'block the uploader from uploading files of
        'such types. This prevents an attacker who has
        'gained back end access to Kartris from being
        'able to upload files that could be used to
        'modify or write new files, or read sensitive
        'info such as from the web.config. Basically,
        'damage limitation.

        '(Similar code in _FileUploader.ascx.vb)
        Dim arrExcludedFileTypes() As String = ConfigurationManager.AppSettings("ExcludedUploadFiles").ToString().Split(",")
        For i As Integer = 0 To arrExcludedFileTypes.GetUpperBound(0)
            If Replace(strFileExt.ToLower, ".", "") = arrExcludedFileTypes(i).ToLower Then
                'Banned file type, don't upload
                'Log error so attempts can be seen in logs
                CkartrisFormatErrors.LogError("Attempt to upload a file of type: " & arrExcludedFileTypes(i).ToLower)
                litStatus2.Text = "It is not permitted to upload files of this type. Change 'ExcludedUploadFiles' in the web.config if you need to upload this file."
                popExtender2.Show()
                Exit Sub
            End If
        Next

        '' To avoid saving the file twice
        If Not blnFileSaved Then
            filUploader.SaveAs(strPath)
            blnFileSaved = True
            RaiseEvent NeedCategoryRefresh()
        Else
            blnFileSaved = False
        End If
    End Sub

    Public Event UploadClicked()

End Class
