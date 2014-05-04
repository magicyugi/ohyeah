<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserList.aspx.cs" Inherits="AppBox.View.Users.UserList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "User";
        $().ready(function () {
            //权限*************************************
            $.ajax({
                url: url,
                data: "type=Role&RoleCode=0307",
                success: function (msg) {
                    
                    var txtmsg = msg.split(',');
                    for (var i = 0; i < txtmsg.length; i++) { 
                        $("#" + txtmsg[i]).css("display", "none");
                    }
                }
            });
            $("#btnSave").click(function () {
                if (setValidate($("#formUser"))) {
                    //$("#txtUserLevelPoint").val( $('#txtUserLevel').combogrid('grid').datagrid('getSelected').LevelPoint);
                    SaveUserRecord(url, namecode, "combWarehouse,combUser");
                }
            })

        })
        function formatterStatus(value, rowData, rowIndex) {
            var showvalue = "";
            showvalue = (value == '1' ? '经营分析' : '业务操作');
            return '<span>' + showvalue + '</span>';
        }
    </script>
</head>
<body>
    <form runat="server">
    <div class="metrouicss">
        <div class="page secondary">
            <div class="page-header">
                <div class="page-header-content">
                    <h1>
                        用户<small>查询</small> &nbsp;<small><input id="txtSearch"  type="text" placeholder="请输入用户名、姓名进行查询"  />
                        <input type="button" name="btnSearch" class=" bg-color-grayLight fg-color-blackLight" value="查询"
                            onclick="Search('txtSearch','User','search')" />
                        </small>
                    </h1>
                    <a class="back-button big page-back"></a>
                </div>
            </div>
        </div>
    </div>
    <div class="easyui-panel" title="用户列表【用于对用户进行密码修改，数据权限分配，角色权限分配】">  
        <table class="easyui-datagrid" id="gridUser" data-options="pageList:[15,50,100],rownumbers:true,pagination:true,singleSelect:true,url:'Ajax.aspx?type=list',toolbar:toolbar">
            <thead>
                <tr>
                    <th data-options="field:'ID',hidden:true,width:80">
                        代码
                    </th>
                    <th data-options="field:'Code',width:120">
                        用户名
                    </th> 
                    <th data-options="field:'Cname',width:120">
                        姓名
                    </th>
                    <th data-options="field:'Mobile',width:100">
                        手机
                    </th>
                    <th data-options="field:'UserLevelPoint',width:120">
                        角色等级
                    </th>  
                    <th data-options="field:'OrgName',width:120">
                        所属组织
                    </th>  
                    <th data-options="field:'UserGroupName',width:300">
                        信息数据权限
                    </th>
                    <th data-options="field:'UserRoleName',width:300">
                        角色权限
                    </th>
                    <th data-options="field:'DeleteFlag',width:40,hidden:true">
                        是否可以删除
                    </th>
                    <th data-options="field:'MenuFlag',width:100" formatter="formatterStatus">
                        默认首页
                    </th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
        <script type="text/javascript">
            var toolbar = [{
                id: 'btnAdd',
                text: '新增',
                iconCls: 'icon-add',
                handler: function () {
                    $("#txtMenuFlag").combobox('setValue', "0");
                    ShowEditWin(namecode, "add");
                    $("#txtCode").removeAttr("disabled");
                }

            }, '-', {
                id: 'btnEdit',
                text: '编辑',
                iconCls: 'icon-edit',
                handler: function () {
                    $("#txtMenuFlag").combobox('setValue', $("#gridUser").datagrid('getSelected')["MenuFlag"]);
                    ShowEditWin(namecode, "edit");

                    $.ajax({
                        url: url,
                        datatype: "json",
                        type: "get",
                        data: "type=getcomb&id=" + $("#gridUser").datagrid("getSelections")[0].ID,
                        success: function (msg) {
                            $("#txtCode").prop("disabled", "disabled");
                            var txtGroup = msg.split('|')[0].split(';');
                            var txtRole = msg.split('|')[1].split(';');
                            var txtWareHouse = msg.split('|')[2];
                            $('#txtWareHouse').combogrid('grid').datagrid('selectRecord', txtWareHouse);
                            for (var i = 0; i < txtGroup.length; i++) {
                                $('#combWarehouse').combogrid('grid').datagrid('selectRecord', txtGroup[i]);
                            }
                            for (var i = 0; i < txtRole.length; i++) {
                                $('#combUser').combogrid('grid').datagrid('selectRecord', txtRole[i]);
                            }

                        },
                        error: function (msg) {
                            //alert( msg)
                        }
                    })
                }
            }, '-', {
                id: 'btnDelete',
                text: '删除',
                iconCls: 'icon-remove',
                handler: function () {
                    if (confirm("是否确认删除!")) {
                        if (parseInt($("#gridUser").datagrid("getSelections")[0].DeleteFlag) == 0) {
                            alert("该用户属于管理员用户，不能删除！");
                        }
                        else
                            DelRecord(url, namecode);
                    }
                    else return;
                }
            }];
 
        </script>
    </div>
    </form>
    <div id="winUser" class="easyui-window" data-options="title:'用户编辑',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 350px; height: 400px;">
        <form name="formUser" id="formUser">
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0;">
            <ul>
                <li>
                    <label for="txtCode">
                        用户名:</label><input  type="text" name="Code" id="txtCode" class="easyui-validatebox fieldItem"
                            required="true" field="Code" /></li>
                <li>
                    <label for="txtPassword">
                        密码:</label>
                    <input type="password" id="txtPassword" name="Password" class="easyui-validatebox fieldItem"
                        required="true" field="Password" />
                </li>
                <li>
                    <label for="txtCname">
                        姓名:</label><input type="text" name="Cname" id="txtCname" class="easyui-validatebox fieldItem"
                            required="true" field="Cname" /></li>
                <li>
                    <label for="txtMobile">
                        手机号:</label><input type="text" maxlength="11" name="Mobile" id="txtMobile" class="easyui-validatebox fieldItem"
                            required="true" field="Mobile" /></li>
                <li>
                    <label for="txtTel">
                        联系电话:</label><input type="text" name="Tel" id="txtTel" class="fieldItem" field="Tel" /></li> 
                <li>
                    <label for="txtWarehouse">
                        所属组织:</label>
                    <select id="txtWareHouse" class="easyui-combogrid easyui-validatebox fieldItem" name="WareHouse" field="WareHouse"  required="true"
                        style="width:150px;" data-options="
                            panelWidth: 400, 
                            idField: 'Code',
                            textField: 'Cname',
                            url: 'Ajax.aspx?type=combox&table=Warehouse',
                            columns: [[ 
                                {field:'ID',title:'ID',hidden:true,width:40},
                                {field:'Code',title:'编号',hidden:true,width:80},
                                {field:'VCode',title:'编号',width:80},
                                {field:'Cname',title:'名称',width:120},
                                {field:'Address',title:'地址',width:100} 
                            ]],
                            fitColumns: true 
                        ">
                    </select>
                </li>
                <li>
                    <label for="txtOrgName">
                        数据权限:</label>
                    <select id="combWarehouse" class="easyui-combogrid easyui-validatebox fieldItem" name="OrgName" field="OrgName" required="true"
                        style="width: 150px" data-options="
                            panelWidth: 400,
                            multiple: true,
                            idField: 'Code',
                            textField: 'Cname',
                            url: 'Ajax.aspx?type=combox&table=Warehouse',
                            columns: [[
                                {field:'ck',checkbox:true},
                                {field:'ID',title:'ID',hidden:true,width:40},
                                {field:'Code',title:'编号',hidden:true,width:80},
                                {field:'VCode',title:'编号',width:80},
                                {field:'Cname',title:'名称',width:120},
                                {field:'Address',title:'地址',width:100} 
                            ]],
                            fitColumns: true 
                        ">
                    </select>
                </li>
                <li>
                    <label for="txtCommission">
                        角色权限:</label>
                    <select id="combUser" class="easyui-combogrid easyui-validatebox fieldItem" field="RoleName" style="width: 150px" required="true" data-options="
                            panelWidth: 400,
                            multiple: true,
                            idField: 'Code',
                            textField: 'Cname',
                            url: 'Ajax.aspx?type=combox&table=SysRole',
                            columns: [[
                                {field:'ck',checkbox:true},
                                {field:'ID',title:'ID',hidden:true,width:40},
                                {field:'Code',title:'编号',width:80},
                                {field:'Cname',title:'名称',width:120},
                                {field:'LevelPoint',title:'级别',width:100} 
                            ]],
                            fitColumns: true 
                        ">
                    </select>
                </li>
                <li>
                <label for="txtCommission">
                        默认首页:</label>
                 <select class="easyui-combobox fieldItem" name="txtMenuFlag" field="MenuFlag" style="width: 150px"   data-options="panelHeight:'auto'"  id="txtMenuFlag" style="width:80px;">
                    <option value="0" selected="selected">业务操作</option>
		            <option value="1">经营分析</option>
                 </select>
                </li>
            </ul>
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0;">
                <a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winUser').window('close');">取消</a> 
            </div>
        </div>
        </form>
    </div>
</body>
</html>
