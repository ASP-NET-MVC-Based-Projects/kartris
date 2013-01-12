﻿<%@ Page Language="VB" Trace="false" AutoEventWireup="true" MasterPageFile="~/Skins/Kartris/Template.master"
    CodeFile="checkout.aspx.vb" Inherits="_Checkout" Title="Checkout" MaintainScrollPositionOnPostback="True" %>

<%@ Register TagPrefix="user" TagName="CheckoutAddress" Src="~/UserControls/Front/CheckoutAddressPopup.ascx" %>
<%@ Register TagPrefix="user" TagName="AddressDetails" Src="~/UserControls/General/AddressDetails.ascx" %>
<%@ Register TagPrefix="user" TagName="KartrisLogin" Src="~/UserControls/Front/KartrisLogin.ascx" %>
<%@ Register TagPrefix="user" TagName="CreditCardInput" Src="~/UserControls/Front/CreditCardInput.ascx" %>
<%@ Register TagPrefix="user" Namespace="Kartris" Assembly="KartrisCheckboxValidator" %>
<asp:Content ID="cntMain" ContentPlaceHolderID="cntMain" runat="Server">
    <div id="checkout">
        <user:BreadCrumbTrail ID="UC_BreadCrumbTrail" runat="server" EnableViewState="False" />
        <h1>
            <asp:Literal ID="litCheckoutTitle" runat="server" Text="<%$ Resources: PageTitle_CheckOut%>"
                EnableViewState="false" /></h1>
        <!--
        ===============================
        CUSTOMER LOGIN / CREATE USER
        ===============================
        -->
        <asp:MultiView ID="mvwCheckout" runat="server" ActiveViewIndex="0">
            <asp:View ID="viwEmailInput" runat="server">
                <div>
                    <user:KartrisLogin runat="server" ID="UC_KartrisLogin" ForSection="checkout" />
                </div>
            </asp:View>
            <asp:View ID="viwCheckoutInput" runat="server">
                <div>
                    <asp:LinkButton ID="lnkbtnDummy" runat="server" Text="" />
                    <!--
                    ===============================
                    POPUP FOR ERRORS
                    Ones with no client-side
                    validation...
                    ===============================
                    -->
                    <ajaxToolkit:ModalPopupExtender ID="popExtender" runat="server" TargetControlID="lnkbtnDummy"
                        CancelControlID="btnCancel" PopupControlID="pnlErrorPopup" BackgroundCssClass="popup_background" />
                    <asp:Panel ID="pnlErrorPopup" runat="server" CssClass="popup" Style="display: none">
                        <h2>
                            <asp:Literal ID="litTitle" runat="server" Text="<%$ Resources: Kartris, ContentText_CorrectErrors %>"
                                EnableViewState="false" /></h2>
                        <asp:Literal runat="server" ID="litOtherErrors" Text="" EnableViewState="false"></asp:Literal>
                        <div>
                            <br />
                            <asp:Button CausesValidation="false" ID="btnOk" CssClass="button" runat="server"
                                Text="<%$ Resources: Kartris, ContentText_OK %>" /></div>
                        <asp:LinkButton ID="btnCancel" CssClass="closebutton linkbutton" runat="server" Text="X"
                            CausesValidation="false" />
                    </asp:Panel>
                    <!--
                    -------------------------------
                    MODAL POPUP 'UPDATING' DISPLAY
                    -------------------------------
                    -->
                    <asp:UpdateProgress ID="prgAddresses" runat="server" AssociatedUpdatePanelID="updAddresses">
                        <ProgressTemplate>
                            <div class="loadingimage">
                            </div>
                            <div class="updateprogress">
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                    <!--
                    ===============================
                    STREET ADDRESSES
                    Billing / Shipping
                    ===============================
                    -->
                    <asp:UpdatePanel runat="server" ID="updAddresses" UpdateMode="Conditional">
                        <ContentTemplate>
                            <!--
                            -------------------------------
                            BILLING ADDRESS
                            -------------------------------
                            -->
                            <div class="checkoutaddress">
                                <user:CheckoutAddress runat="server" ID="UC_BillingAddress" Title="<%$ Resources: Address, FormLabel_BillingAddress %>"
                                    ErrorMessagePrefix="Billing " ValidationGroup="Billing" EnableValidation="true" />
                            </div>
                            <!--
                            -------------------------------
                            SHIPPING ADDRESS
                            -------------------------------
                            -->
                            <div class="checkoutaddress">
                                <!-- Shipping Address Selection/Input Control-->
                                <asp:Panel ID="pnlShippingAddress" runat="server" Visible="false">
                                    <user:CheckoutAddress ID="UC_ShippingAddress" runat="server" ErrorMessagePrefix="Shipping "
                                        ValidationGroup="Shipping" Title="<%$ Resources: Address, FormLabel_ShippingAddress %>" />
                                </asp:Panel>
                            </div>
                            <div class="spacer">
                            </div>
                            <!--
                            -------------------------------
                            SAME SHIPPING/BILLING CHECKBOX
                            -------------------------------
                            -->
                            <p>
                                <span class="checkbox">
                                    <asp:CheckBox ID="chkSameShippingAsBilling" runat="server" Checked="true" AutoPostBack="true" />
                                    <asp:Label ID="lblchkSameShipping" Text="<%$ Resources: Checkout, ContentText_SameShippingAsBilling %>"
                                        runat="server" AssociatedControlID="chkSameShippingAsBilling" EnableViewState="false" /></span></p>
                    <!--
                    ===============================
                    EU VAT NUMBER
                    This section only displays if
                    required (i.e. the setting:
                    general.tax.euvatcountry is
                    not blank, and the user who is
                    checking out is in another EU
                    country).
                    ===============================
                    -->
                            <asp:PlaceHolder ID="phdEUVAT" runat="server" Visible="false">
                                <div class="section">
                                    <h2>
                                        <asp:Literal ID="litEnterEUVAT" runat="server" Text="<%$ Resources: ContentText_EnterEUVat %>"
                                            EnableViewState="false" /></h2>
                                    <strong>
                                        <asp:Literal ID="litMSCode" runat="server" EnableViewState="true" /></strong>&nbsp;
                                    <asp:TextBox ID="txtEUVAT" runat="server" EnableViewState="true" AutoPostBack="true"></asp:TextBox>
                                </div>
                            </asp:PlaceHolder>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <div class="spacer">
                    </div>
                </div>
                <!--
                ===============================
                PAYMENT METHODS
                Dropdown if multiple choices
                available, hidden if only one
                choice.
                ===============================
                -->
                <asp:PlaceHolder ID="phdPaymentMethods" runat="server">
                    <div class="section">
                        <h2>
                            <asp:Literal ID="litCheckoutPaymentMethod" runat="server" Text="<%$ Resources: FormLabel_SelectPayment %>"
                                EnableViewState="false" /></h2>
                        <p>
                            <asp:DropDownList ID="ddlPaymentGateways" runat="server" />
                            <asp:RequiredFieldValidator EnableClientScript="True" ID="valPaymentGateways" runat="server"
                                ControlToValidate="ddlPaymentGateways" CssClass="error" ForeColor="" ValidationGroup="Checkout"
                                Display="Dynamic" Text="<%$ Resources: Kartris, ContentText_RequiredField %>"></asp:RequiredFieldValidator>
                        </p>
                    </div>
                </asp:PlaceHolder>
                <!--
                -------------------------------
                PURCHASE ORDER NUMBER
                This field appears dynamically
                if 'PO' (offline payment) is
                selected.
                -------------------------------
                -->
                <div class="section" id="phdPONumber" runat="server" style="display: none; margin-top: 10px;">
                    <h2>
                        <asp:Literal ID="litPONumber" runat="server" Text="<%$ Resources: Invoice, ContentText_PONumber %>"
                            EnableViewState="false" /></h2>
                    <p>
                         <asp:TextBox ID="txtPurchaseOrderNo" style="display: none" runat="server" />
                    </p>
                </div>
                
                <!--
                ===============================
                BASKET
                ===============================
                -->
                <div id="checkoutbasket">
                    <asp:UpdatePanel ID="updBasket" runat="server" UpdateMode="Conditional">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="chkSameShippingAsBilling" />
                        </Triggers>
                        <ContentTemplate>
                            <div>
                                <user:BasketView ID="UC_BasketView" runat="server" ViewType="CHECKOUT_BASKET" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                
                <!--
                ===============================
                SHOW/HIDE JAVASCRIPT
                Used for Ts and Cs and comments
                box.
                ===============================
                -->
                <%  'keep this JS here rather than inside comments
                    'placeholder, as it is used for Ts and Cs too %>
                <script type="text/javascript">
                <!--
                                       function toggle_visibility(id) {
                                           var e = document.getElementById(id);
                                           if (e.style.display == 'block')
                                               e.style.display = 'none';
                                           else
                                               e.style.display = 'block';
                                       }
                //-->
                </script>
                <!--
                ===============================
                CUSTOMER COMMENTS BOX
                frontend.checkout.comments.enabled
                ===============================
                -->
                <asp:PlaceHolder ID="phdCustomerComments" runat="server">
                <a href="javascript:toggle_visibility('comments');" class="link2 icon_new">
                    <asp:Literal ID="litComments" runat="server" Text="<%$ Resources: Checkout, SubTitle_Comments %>"
                        EnableViewState="false" /></a>
                <div id="comments" style="display: none; margin-top: 10px;">
                    <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine"></asp:TextBox>
                </div>
                </asp:PlaceHolder>
                <!--
                ===============================
                ORDER EMAILS OPT-IN
                backend.orders.emailupdates
                ===============================
                -->
                <asp:PlaceHolder ID="phdOrderEmails" runat="server">
                    <div class="section">
                        <h2>
                            <asp:Literal ID="litOrderEmails" runat="server" Text="<%$ Resources:Checkout,ContentText_OrderEmails%>"
                                EnableViewState="false" /></h2>
                        <p>
                            <asp:Literal ID="litOrderEmailsText" runat="server" Text="<%$ Resources:Checkout,ContentText_OrderEmailsText%>"
                                EnableViewState="false" /></p>
                        <div class="inputform">
                            <span class="checkbox">
                                <asp:CheckBox ID="chkOrderEmails" runat="server" Checked="true" />
                                <asp:Label ID="litOrderEmailsYes" Text="<%$ Resources: Checkout, ContentText_OrderEmailsYes %>"
                                    AssociatedControlID="chkOrderEmails" runat="server" EnableViewState="true" />
                            </span>
                        </div>
                        <div class="spacer">
                        </div>
                    </div>
                </asp:PlaceHolder>
                <!--
                ===============================
                MAILING LIST OPT-IN
                frontend.users.mailinglist.enabled
                ===============================
                -->
                <asp:PlaceHolder ID="phdMailingList" runat="server">
                <div class="section">
                    <h2>
                        <asp:Literal ID="litMailingList" runat="server" Text="<%$ Resources: Kartris, PageTitle_MailingList%>" EnableViewState="false" /></h2>
                    <p>
                        <asp:Literal ID="litMailingListText" runat="server" Text="<%$ Resources: Checkout, ContentText_WantToMailingList%>"
                            EnableViewState="false" /></p>
                    <div class="inputform">
                        <div>
                            <span class="checkbox">
                                <asp:CheckBox ID="chkMailingList" runat="server" Checked="true" />
                                <asp:Label ID="lblYesAddMe" Text="<%$ Resources: Checkout, ContentText_YesAddMe %>"
                                    runat="server" AssociatedControlID="chkMailingList" EnableViewState="true" /></span>
                        </div>
                        <div class="spacer">
                        </div>
                        <div>
                            <asp:DropDownList ID="ddlMailingList" runat="server">
                                <asp:ListItem Text="<%$ Resources: Checkout, ContentText_SendMailsPlain %>" Value="t" />
                                <asp:ListItem Text="<%$ Resources: Checkout, ContentText_SendMailsHTML %>" Value="h" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="spacer">
                    </div>
                </div>
                </asp:PlaceHolder>
                <!--
                ===============================
                SAVE BASKET
                frontend.checkout.savebasket
                ===============================
                -->
                <asp:PlaceHolder ID="phdSaveBasket" runat="server">
                    <div class="section">
                        <h2>
                            <asp:Literal ID="litSaveBasket" runat="server" Text="<%$ Resources: Basket, ContentText_SaveBasket %>"
                                EnableViewState="false" /></h2>
                        <p>
                            <asp:Literal ID="litSaveBasketText" runat="server" Text="<%$ Resources: Checkout, ContentText_SaveBasketOnCheckout %>"
                                EnableViewState="false" /></p>
                        <div class="inputform">
                            <span class="checkbox">
                                <asp:CheckBox ID="chkSaveBasket" runat="server" Checked="false" />
                                <asp:Label ID="lblSaveBasket" Text="<%$ Resources: Checkout, ContentText_SaveBasketYes %>"
                                    runat="server" AssociatedControlID="chkSaveBasket" EnableViewState="true" /></span>
                        </div>
                        <div class="spacer">
                        </div>
                    </div>
                </asp:PlaceHolder>
                <!--
                ===============================
                TERMS AND CONDITIONS AGREEMENT
                frontend.checkout.termsandconditions
                ===============================
                -->
                <asp:PlaceHolder ID="phdTermsAndConditions" runat="server">
                    <div class="section">
                        <h2>
                            <asp:Literal ID="litContentTextTermsAndConditionsHeader" runat="server" Text="<%$ Resources: Checkout, ContentText_TermsAndConditionsHeader %>"
                                EnableViewState="false" /></h2>
                        <a href="javascript:toggle_visibility('terms');" class="link2 icon_new">
                            <asp:Literal ID="litContentTextTermsAndConditionsPopup" runat="server" Text="<%$ Resources: Checkout, ContentText_TermsAndConditionsPopup %>"
                                EnableViewState="false" /></a>
                        <div id="terms" style="display: none; margin-top: 10px;">
                            <div class="pad">
                                <asp:Literal ID="litContentTextTermsAndConditions" runat="server" Text="<%$ Resources: Checkout, ContentText_TermsAndConditions %>"
                                    EnableViewState="false" /></div>
                        </div>
                        <div class="spacer">
                        </div>
                        <div class="inputform">
                            <span class="checkbox">
                                <asp:CheckBox ID="chkTermsAndConditions" runat="server" />
                                <asp:Label ID="lblTermsAndConditions" Text="<%$ Resources: Checkout, ContentText_TermsAndConditionsCheck%>"
                                    AssociatedControlID="chkTermsAndConditions" runat="server" EnableViewState="true" />
                                <!-- Just remove the AssociatedControlID property if we don't want to disable the proceed button if the Terms checkbox is unchecked -->
                                <user:CheckBoxValidator runat="server" ID="valTermsAndConditions" ControlToValidate="chkTermsAndConditions"
                                    EnableClientScript="true" CssClass="error" ForeColor="" ValidationGroup="Checkout"
                                    Display="Dynamic" Text="<%$ Resources: Kartris, ContentText_RequiredField %>" />
                            </span>
                        </div>
                        <div class="spacer">
                        </div>
                    </div>
                </asp:PlaceHolder>
            </asp:View>
            <!--
            ===============================
            ORDER CONFIRMATION PAGE
            ===============================
            -->
            <asp:View ID="viwCheckoutConfirm" runat="server">
                <div id="confirmation">
                    <p>
                        <strong>
                            <asp:Literal ID="litReviewOrder" runat="server" Text="<%$ Resources: PageTitle_ReviewYourOrder %>"
                                EnableViewState="false" /></strong></p>
                    <!--
                    -------------------------------
                    BILLING ADDRESS
                    -------------------------------
                    -->
                    <div class="checkoutaddress">
                        <h2>
                            <asp:Literal ID="litBillingDetails" runat="server" Text="<%$ Resources: Address, ContentText_BillingAddress %>" EnableViewState="false" /></h2>
                        <user:AddressDetails ID="UC_Billing" runat="server" ShowLabel="false" ShowButtons="false" />
                    </div>
                    <!--
                    -------------------------------
                    SHIPPING ADDRESS
                    -------------------------------
                    -->
                    <div class="checkoutaddress">
                        <h2>
                            <asp:Literal ID="litShippingDetails" runat="server" Text="<%$ Resources: Address, ContentText_Shipping %>"
                                EnableViewState="false" /></h2>
                        <user:AddressDetails ID="UC_Shipping" runat="server" ShowLabel="false" ShowButtons="false" />
                    </div>
                    <div class="spacer">
                    </div>
                    <!--
                    -------------------------------
                    BASKET
                    -------------------------------
                    -->
                    <user:BasketView ID="UC_BasketSummary" runat="server" ViewType="CHECKOUT_BASKET"
                        ViewOnly="true" />
                    <!--
                    -------------------------------
                    ACTUAL AMOUNT
                    Converted to the process
                    currency of the payment gateway
                    if set
                    -------------------------------
                    -->
                    <asp:Panel ID="pnlProcessCurrency" runat="server" CssClass="section">
                        <h2>
                            <asp:Literal ID="litProcessCurrencyText" runat="server" Text="<%$ Resources: Email, EmailText_ProcessCurrencyExp1 %>"
                                EnableViewState="false" />
                        <asp:Label ID="lblProcessCurrency" runat="server"></asp:Label>
                        </h2>
                    </asp:Panel>
                    <!--
                    -------------------------------
                    COMMENTS
                    -------------------------------
                    -->
                    <asp:Panel ID="pnlComments" runat="server" CssClass="section">
                        <h2>
                            <asp:Literal ID="litComments2" runat="server" Text="<%$ Resources: Checkout, SubTitle_Comments %>"
                                EnableViewState="false" /></h2>
                        <asp:Label ID="lblComments" runat="server"></asp:Label>
                    </asp:Panel>
                    <!--
                    -------------------------------
                    CHECKED OPTIONS SUMMARY
                    -------------------------------
                    -->
                    <p>
                        <asp:Literal ID="litFormLabelSelectPayment" runat="server" Text="<%$ Resources: FormLabel_SelectPayment %>"
                            EnableViewState="false" />: <strong>
                                <asp:Literal ID="litPaymentMethod" runat="server" EnableViewState="true" /></strong></p>
                    <div class="tick">
                        <asp:Literal ID="litOrderEmailsYes2" Text="<%$ Resources: Checkout, ContentText_OrderEmailsYes %>"
                            runat="server" EnableViewState="true" /></div>
                    <div class="tick">
                        <asp:Literal ID="litMailingListYes" Text="<%$ Resources: Checkout, ContentText_YesAddMe %>"
                            runat="server" EnableViewState="true" /></div>
                    <div class="tick">
                        <asp:Literal ID="litSaveBasketYes" Text="<%$ Resources: Checkout, ContentText_SaveBasketYes %>"
                            runat="server" EnableViewState="true" /></div>
                    <asp:PlaceHolder ID="phdCreditCardInput" runat="server">
                        <div class="section">
                            <user:CreditCardInput runat="server" ID="UC_CreditCardInput" />
                        </div>
                    </asp:PlaceHolder>
                </div>
            </asp:View>
        </asp:MultiView>
        <!--
        ===============================
        SUBMIT / BACK BUTTONS
        Also validation summary
        ===============================
        -->
        <div class="submitbuttons">
            <p>
                <strong>
                    <asp:Literal ID="litFakeOrTest" runat="server" Text="<%$ Resources: Checkout, ContentText_FakeOrTestStatus %>"
                        EnableViewState="false" Visible="false" />
                </strong>
            </p>
            <asp:Button ID="btnBack" CssClass="button" runat="server" Text="<%$ Resources: Checkout, FormButton_Back %>"
                Visible="false" EnableViewState="true" />
            <asp:Button ID="btnProceed" ValidationGroup="Checkout" CssClass="button" runat="server" Text="<%$ Resources: Checkout, ContentText_Proceed %>"
                Visible="true" EnableViewState="true" CausesValidation="true" OnClientClick="Page_ClientValidate('Checkout');" />
            <asp:ValidationSummary ID="valSummary" ValidationGroup="Checkout" runat="server"
                CssClass="valsummary" DisplayMode="BulletList" ForeColor="" HeaderText="<%$ Resources: Kartris, ContentText_Errors %>" />
        </div>
        <!--
        -------------------------------
        POPUP ERRORS
        General errors
        -------------------------------
        -->
        <user:PopupMessage ID="UC_PopUpErrors" runat="server" />

        <%
            'This function below disables the scrolling function so
            'when the page is submitted, we should see any errors in
            'Validators
            %>
        <script type="text/javascript">
            window.scrollTo = function () { }
        </script>
    </div>
</asp:Content>