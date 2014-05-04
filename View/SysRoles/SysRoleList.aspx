<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysRoleList.aspx.cs" Inherits="AppBox.View.SysRoles.SysRoleList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>  
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Guide";


        $().ready(function () {

            //权限*************************************
            $.ajax({
                url: url,
                data: "type=Role&RoleCode=0309",
                success: function (msg) {
                    var txtmsg = msg.split(',');
                    for (var i = 0; i < txtmsg.length; i++) {
                        $("#" + txtmsg[i]).css("display", "none");
                    }
                }
            });
            $("#btnSave").click(function () {
                SaveGuideRecord(url, namecode, "txtCname,txtMobile");
            });
            $(".page-back").click(function () { window.location.href = '../../TilePanel.aspx' + '?on=' + request('on') ; });
        });
        function addData() {
            window.location.href = "SysRoleEdit.aspx";
            //addDataWin.window('open');
        }
        function editData() {
            if ($("#gridGuide").datagrid("getSelections").length == 0) { alert("请选择编辑行"); return; }
            window.location.href = "SysRoleEdit.aspx?id=" + $("#gridGuide").datagrid("getSelections")[0].ID + "&Code=" + $("#gridGuide").datagrid("getSelections")[0].Code + "&Cname=" + $("#gridGuide").datagrid("getSelections")[0].Cname + "&LevelPoint=" + $("#gridGuide").datagrid("getSelections")[0].LevelPoint + "&EditType=Edit&on=" + request("on") ;
            //editDataWin.window('open');
        }
        </script>
</head>
<body>
    <form>
<div class="metrouicss">
  <div class="page secondary">
        <div class="page-header">
            <div class="page-header-content" >
                <h1>权限<small >管理</small> 
                </h1>
                <a class="back-button big page-back"  ></a>
            </div>
        </div> 
    </div>  
</div>
    <div class="easyui-panel" title="角色管理【用于对具有不同系统菜单访问权限、操作权限的角色权限进行更改】">
        <table class="easyui-datagrid" id="gridGuide" data-options=" pageList:[15,50,100],pagination:true,singleSelect:true,url:'Ajax.aspx?type=list',toolbar:toolbar">
            <thead>
                <tr>
                    <th data-options="field:'ID',hidden:true,width:80">
                        ID
                    </th>
                    <th data-options="field:'Code',hidden:true,width:50">
                        代码
                    </th>
                    <th data-options="field:'Cname',width:120">
                        角色名
                    </th> 
                     <th data-options="field:'LevelPoint',width:120">
                        角色等级
                    </th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
        <script type="text/javascript">
            var toolbar = [{
                id:'btnAdd',
                text: '新增',
                iconCls: 'icon-add',
                handler: function () {
                    addData(); // ShowAlertEditWin(namecode, "add", "请选中要编辑的行");
                }
            }, '-', {
                id: 'btnEdit',
                text: '编辑',
                iconCls: 'icon-edit',
                handler: function () {
                    editData();// ShowAlertEditWin(namecode, "edit", "请选中要编辑的行");
                }
            }, '-', {
                id: 'btnDelete',
                text: '删除',
                iconCls: 'icon-remove',
                handler: function () {
                  if(confirm("是否确定删除!"))
                    DelRecord(url, namecode);
                }
            }];

            
        </script>
    </div>
  
    </form>  
    <div id="winGuide" class="easyui-window"    data-options="title:'角色编辑',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false" 
       style="width:650px;height:500px; ">  
       
    </div>
</body>
</html>
