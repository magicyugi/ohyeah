<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysRoleEdit.aspx.cs" Inherits="AppBox.View.SysRoles.SysRoleEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title> 
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Customer"; 
        function ActionChecked(clientID, itemCount, hdnClientID) {
            var a = document.getElementById(clientID);
            var ar = a.getElementsByTagName("input");
            var cnt = 0;
            for (i = 0; i < ar.length; i++) {
                if (ar[i].checked)
                    cnt = cnt + Math.pow(2, i);
            }
            document.getElementById(hdnClientID).value = cnt;
        }
        $().ready(function () {

            $("#btnAll").click(function () {

                $("input:checkbox").prop("checked", 'true'); //全选
            });
            $("#btnNO").click(function () {
                $("input:checkbox").removeAttr("checked"); //取消全选
            });
            $("#btnF").click(function () {
                $("input:checkbox").each(function ()      //反选
                {
                    if ($(this).prop("checked")) {
                        $(this).removeAttr("checked");
                    }
                    else {
                        $(this).prop("checked", 'true');
                    }
                })

            });
            var classcount = $(".pnameclass").length;
            var txtcount = 0;
            $(".pnameclass").each(function ()      //反选
            {
                txtcount++
                if ($(this).text().trim() != "") {

                    $(this).parent().css("border-top", "1px solid gray");
                }

                if (txtcount == classcount) { 
                    $(this).parent().css("border-bottom", "1px solid gray");
                }
            })
        }) 
    </script>
</head>
<body>  
<div class="metrouicss">
        <div class="page secondary">
            <div class="page-header">
                <div class="page-header-content">
                    <h1>
                        权限<small>编辑</small>  
                    </h1>
                    <a class="back-button big page-back"></a>
                </div>
            </div>
        </div>
    </div>
<div data-options="region:'north',border:false" style="padding: 10px 10px 10px; height: 450px"    class="formItem">
        <form name="formGuide" id="formGuide"  runat="server">
       <div data-options="region:'north',border:false" class="wincss" style="padding:5px 0 0; ">
            <div data-options="region:'south',border:false"  style="padding:5px 0 0;  " class="metrouicss"> 
                 <asp:Button ID="btn_Save" CssClass="bg-color-blue" runat="server" Text="保存" onclick="btn_Save_Click" /> 
                 <input type="button" id="cancel"  CssClass="bg-color-blue"  onclick="window.location.href = 'SysRoleList.aspx';" value="取消"/> 
             </div>
             <div>&nbsp;</div>
           <table width="350px" >
             <tr style="display:none">
               <td class="style1"><label for="txtCode" >代码:<a style="color:Red;">*</a></label></td>
               <td><input type="text" name="Code" runat="server" style="display:none" id="txtCode"  class="fieldItem" field="Code"  /></td>
             </tr>
             <tr>
               <td class="style1"><label for="txtCname" >角色名称:<a style="color:Red;">*</a></label></td>
               <td><input type="text" name="Cname" runat="server" id="txtCname"  class="fieldItem" field="Cname"  /></td>
             </tr>
               <tr>
               <td class="style1"><label for="txtLevelPoint" >角色等级:<a style="color:Red;">*</a></label></td>
               <td><input type="text" name="LevelPoint" runat="server" id="txtLevelPoint"  class="fieldItem" field="LevelPoint"  /></td>
             </tr>
           </table>
           <asp:Repeater ID="pivotGrids" runat="server">
            <HeaderTemplate>
                <div id="ext-gen17">
                    <div id="Div1">
                        <table style="border:1px solid gray;" >
                            <tr >
                                <td  style="width: 100px;border:1px solid gray; ">
                                    菜单
                                </td>
                                <td  style="display: none; width: 100px;border:1px solid gray;">
                                    菜单编号
                                </td>
                                <td  style="width: 100px;border:1px solid gray;">
                                    关联角色
                                </td>
                                <td  style="width: 50px;border:1px solid gray;">
                                    查看
                                </td>
                                <td  style="width: 600px;border:1px solid gray;" class="metrouicss">
                                    功能权限
                                    <%--  //********************2012.8.24 lsp ********************--%>
                                    <input type="button" id="btnAll" class="bg-color-blue fg-color-white" value="全选" />
                                    <input type="button" id="btnNO"  class="bg-color-blue fg-color-white"  value="取消全选"/>
                                    <input type="button" id="btnF"  class="bg-color-blue fg-color-white"  value="反选" />
                                    <%--  //********************2012.8.24 lsp ********************--%>
                                </td>
                            </tr>
                        </table>
                    </div>
            </HeaderTemplate>
            <ItemTemplate>
                <div >
                    <table style="border-left:1px solid gray;border-right:1px solid gray; " >
                        <tr>
                            <td style="width: 100px; border-top: 0px;" class="pnameclass">
                                <asp:Label ID="lable3" runat="server" Text='<%#Eval ("pname") %>'></asp:Label>
                            </td>
                            <td style="width: 100px; display: none;">
                                <asp:Label ID="Label1" runat="server" Text='<%#Eval ("code") %>'></asp:Label>
                            </td>
                            <td  style="width: 100px;">
                                <asp:Label ID="Label2" runat="server" Text='<%#Eval ("cname") %>'></asp:Label>
                            </td>
                            <td  style="width: 50px;text-align:center;">
                                <asp:CheckBox ID="chbRole" runat="server" />
                            </td>
                            <td  style="width: 600px;">
                                <asp:CheckBoxList ID="cblRoleLists" runat="server" TextAlign="Left" RepeatDirection="Horizontal">
                                </asp:CheckBoxList>
                                <asp:HiddenField ID="hdnActionValue" runat="server" Value='<%#Eval("rolekey") %>' />
                            </td>
                        </tr>
                    </table>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                </div>
            </FooterTemplate>
        </asp:Repeater>
               

        </div> </form>
        
    </div>
</body>
</html>
