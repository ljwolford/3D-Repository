<%--
Copyright 2011 U.S. Department of Defense

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--%>



<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ManageUsers.ascx.cs" Inherits="Administrators_ManageUsers" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<div class="ListTitle">
    User Profiles</div>
<br />
<asp:GridView ID="UserProfilesGridView" SkinID="GridView" runat="server" AllowPaging="True"
    OnPageIndexChanging="UserProfilesGridView_PageIndexChanged" OnRowCommand="UsersGridView_RowCommand" OnRowDeleting="UserProfilesGridView_RowDeleting">
    <Columns>
        <asp:TemplateField HeaderText="Name">
            <ItemTemplate>
                <asp:Label ID="NameLabel" runat="server" Text='<%# Eval("FirstName").ToString() + "  " +  Eval("LastName").ToString() %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Username">
            <ItemTemplate>
                <asp:Label ID="UsernameLabel" runat="server" Text='<%# Eval("Username") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Email">
            <ItemTemplate>
                <asp:HyperLink ID="EmailHyperLink" runat="server" Text='<%# Eval("Email") %>' NavigateUrl='<%# Website.Pages.Types.FormatEmail(Eval("Email")) %>'
                    ToolTip="Send Email"></asp:HyperLink>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Date Created">
            <ItemTemplate>
                <asp:Label ID="DateCreatedLabel" runat="server" Text='<%# String.Format("{0:d}" , Eval("CreatedDate")) %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:HyperLink ID="ViewProfileHyperLink" runat="server" NavigateUrl='<%# Website.Pages.Types.FormatProfileUrl(Eval("UserID")) %>'
                    Text="View/Edit" ToolTip="View/Edit Profile"></asp:HyperLink>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton ID="DeleteProfileHyperLink" runat="server" CommandName='Delete'
                    CommandArgument='<%# Eval("Email") %>' Text='Delete' ToolTip="Delete Profile"></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton ID="BanProfileHyperLink" runat="server" CommandName='Ban'
                    CommandArgument='<%# Eval("Email") %>' Text='Ban' ToolTip="Ban Profile"></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        There are no users.
    </EmptyDataTemplate>
</asp:GridView>
<br />
<div class="ListTitle">
    Banned Users</div>
<br />
<asp:GridView ID="NotApprovedUsersGridView" SkinID="GridView" runat="server" AllowPaging="True"
    OnRowCommand="NotApprovedUsersGridView_RowCommand" OnPageIndexChanging="NotApprovedUsersGridView_PageIndexChanged">
    <Columns>
        <asp:TemplateField HeaderText="Name">
            <ItemTemplate>
                <asp:Label ID="NameLabel" runat="server" Text='<%# FormatName(Eval("Comment")) %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Username">
            <ItemTemplate>
                <asp:Label ID="UsernameLabel" runat="server" Text='<%# Eval("Username") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Email">
            <ItemTemplate>
                <asp:HyperLink ID="EmailHyperLink" runat="server" Text='<%# Eval("Email") %>' NavigateUrl='<%# Website.Pages.Types.FormatEmail(Eval("Email")) %>'
                    ToolTip="Send Email"></asp:HyperLink>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Date Created">
            <ItemTemplate>
                <asp:Label ID="DateCreatedLabel" runat="server" Text='<%# String.Format("{0:d}" , Eval("CreationDate")) %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <ItemTemplate>
                <asp:Button ID="ApproveButton" runat="server" CausesValidation="false" CommandName="ApproveUser"
                    CommandArgument='<%# Eval("Username") %>' Text="Approve" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <ItemTemplate>
                <asp:Button ID="Delete" runat="server" CausesValidation="false" CommandName="DeleteUser"
                    CommandArgument='<%# Eval("Username") %>' Text="Delete" OnClientClick='<%# Eval("Username", "return confirm(\"Are you sure you want to delete user {0}? This will delete all user and profile information. Click OK to continue.\");") %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        There are no banned users.
    </EmptyDataTemplate>
</asp:GridView>
<br />
<br />
<div class="ListTitle">
    Locked Out Users</div>
<br />
<asp:GridView ID="LockedOutUsersGridView" SkinID="GridView" runat="server" AllowPaging="True"
    OnPageIndexChanging="LockedOutUsersGridView_PageIndexChanged" OnRowCommand="LockedUsersGridView_RowCommand">
    <Columns>
        <asp:TemplateField HeaderText="Name">
            <ItemTemplate>
                <asp:Label ID="NameLabel" runat="server" Text='<%# FormatName(Eval("Comment")) %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Username">
            <ItemTemplate>
                <asp:Label ID="UsernameLabel" runat="server" Text='<%# Eval("Username") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Email">
            <ItemTemplate>
                <asp:HyperLink ID="EmailHyperLink" runat="server" Text='<%# Eval("Email") %>' NavigateUrl='<%# Website.Pages.Types.FormatEmail(Eval("Email")) %>'
                    ToolTip="Send Email"></asp:HyperLink>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Date Created">
            <ItemTemplate>
                <asp:Label ID="DateCreatedLabel" runat="server" Text='<%# String.Format("{0:d}" , Eval("CreationDate")) %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <ItemTemplate>
                <asp:Button ID="UnlockButton" runat="server" CausesValidation="false" CommandName="UnlockUser"
                    CommandArgument='<%# Eval("Username") %>' Text="Unlock" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        There are no locked out users.
    </EmptyDataTemplate>
</asp:GridView>
