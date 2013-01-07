﻿'[[[NEW COPYRIGHT NOTICE]]]
Imports CkartrisFormatErrors
Imports KartSettingsManager
Imports CkartrisDataManipulation
Imports System.Web.HttpContext
Imports CkartrisDisplayFunctions

Partial Class Admin_Default

    Inherits System.Web.UI.Page
    'Dim LicenseStatus As LicenseChecker.EnumLicenseStatus

    Protected Sub Page_Error(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Error
        LogError()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Page.Title = GetGlobalResourceObject("Kartris", "PageTitle_LogInToSite") & " | " & GetGlobalResourceObject("_Kartris", "ContentText_KartrisName")

        If Not Page.IsPostBack Then

            Dim cokKartris As HttpCookie = Request.Cookies(GetKartConfig("general.webshopurl"))
            Dim arrAuth As String() = Nothing
            Session("Back_Auth") = ""
            If cokKartris IsNot Nothing Then
                arrAuth = HttpSecureCookie.Decrypt(cokKartris.Value)
                If arrAuth IsNot Nothing Then
                    If UBound(arrAuth) = 8 Then
                        Dim strClientIP As String = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
                        If String.IsNullOrEmpty(strClientIP) Then
                            strClientIP = Request.ServerVariables("REMOTE_ADDR")
                        End If
                        If Not String.IsNullOrEmpty(arrAuth(0)) And strClientIP = arrAuth(7) Then
                            Session("Back_Auth") = cokKartris.Value
                            Session("_LANG") = arrAuth(4)
                            Session("_User") = arrAuth(0)
                            Session("_UserID") = LoginsBLL._GetIDbyName(arrAuth(0))
                        End If
                    End If
                End If
            End If
            divError.Visible = False
        End If

    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        If Not String.IsNullOrEmpty(Session("Back_Auth")) Then
            RefreshSiteMap()
            Dim strRedirectTo As String = Request.QueryString("page")
            If Not String.IsNullOrEmpty(strRedirectTo) Then Response.Redirect("~/Admin/" & strRedirectTo) Else Response.Redirect("~/Admin/_Default.aspx")
        End If

    End Sub

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogin.Click
        Dim strUsername As String = txtUserName.Text
        Dim strPassword As String = txtPass.Text
        Dim blnResult As Boolean = LoginsBLL.Validate(strUsername, strPassword)
        If blnResult Then
            Dim strClientIP As String = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
            If String.IsNullOrEmpty(strClientIP) Then
                strClientIP = Request.ServerVariables("REMOTE_ADDR")
            End If

            Dim tblLogInDetails As DataTable = LoginsBLL.GetDetails(strUsername)

            Dim strHash As String = ""
            Dim numUserID As Integer = 0

            With tblLogInDetails
                numUserID = CInt(.Rows(0)("LOGIN_ID"))
                strHash = HttpSecureCookie.CreateHash(.Rows(0), strUsername, strPassword, strClientIP)
            End With

            Dim cokKartris As HttpCookie = New HttpCookie(GetKartConfig("general.webshopurl"), strHash)
            cokKartris.Expires = NowOffset.AddDays(1)
            If SSLHandler.IsSSLEnabled Then cokKartris.Secure = True
            Response.Cookies.Add(cokKartris)

            Session("_UserID") = numUserID
            Session("_USER") = strUsername
            Session("Back_Auth") = strHash
            Session("_LANG") = tblLogInDetails.Rows(0)("LOGIN_LanguageID")
            Session("LANG") = Session("_LANG")
            divError.Visible = False
        Else
            divError.Visible = True
        End If
    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        If Not Request.IsSecureConnection Then SSLHandler.RedirectToSecuredPage()
    End Sub

End Class

