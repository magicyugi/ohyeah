<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MenuList.aspx.cs" Inherits="UI.Module.SysMenuManage.MenuList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../themes/icon.css" rel="stylesheet" type="text/css" /> 
    <script src="../../js/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.easyui.min.js" type="text/javascript"></script>
     <script src="../../js/u3.js" type="text/javascript"></script>
     <link href="../../css/bigicon.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript">

        $(function () {

            $("#btnSave").click(function () {
                var error = "";
                if ($('#txtCname').val() == "") {
                    error += "请填写模块名称！\r\n";
                }
                if (error == "") {
                    var keytype;
                    if ($('#wind').attr('title') == "新增")
                        keytype = "insert";
                    else
                        keytype = "update";
                    $.ajax({
                        type: "post",
                        datatype: "json",
                        url: "Ajax.aspx?key=" + keytype,
                        data: $('#windform').serialize(),
                        success: function (msg) {
                            if (msg == "success") {
                                $("#grid").datagrid("reload");
                                $('#wind').window('close');
                                windClear();
                            }
                            else
                                $.messager.alert("错误", msg, "warning");
                        }
                    });
                }
                else
                    $.messager.alert("错误", error, "warning");
            });

        
        })

        function windClear() {
            $('#txtCode').val('');
            $('#txtCname').val('');
            $('#txtUrl').val('');
            $('#txtDescCode').val('');
            $('#txtDescription').val('');
            $('#txtIcon').val('');
        }


    </script>
</head>

<body class="easyui-layout">
  <div data-options="region:'north',border:false" style="height:5px;"></div>
 <div data-options="region:'south',border:false" style="height:5px;"></div>
<div data-options="region:'center'">
     <table class="easyui-treegrid" id="grid"  title="模块管理"
      data-options="url:'Ajax.aspx?key=LoadGrid',singleSelect:true,idField:'Code',treeField: 'Cname',
      rownumbers:true,toolbar:toolbar " style=" height:700px;">
		<thead>
			<tr>
                <th data-options="field:'Code',hidden:true">编号</th>
                <th data-options="field:'Cname',width:120">模块名称</th>
                <th data-options="field:'Url',width:150">Url</th>
                <th data-options="field:'Icon',width:100">图标</th>
                <th data-options="field:'DescCode',width:60">排序</th>
                <th data-options="field:'Description',width:200">备注</th>
                
			</tr>
		</thead>
	</table>
     <script type="text/javascript">
         var toolbar = [{
             text: '新增',
             iconCls: 'icon-add',
             handler: function () {
                 windClear();
                 $('#wind').attr("title", "新增");
                 $('#wind').window('open');
             }
         }, {
             text: '修改',
             iconCls: 'icon-edit',
             handler: function () {
                 if ($("#grid").datagrid('getSelected') != null) {
                     $('#wind').attr("title", "修改");
                     $('#txtCode').val($("#grid").datagrid('getSelected')["Code"]);
                     $('#txtCname').val($("#grid").datagrid('getSelected')["Cname"]);
                     $('#txtUrl').val($("#grid").datagrid('getSelected')["Url"]);
                     $('#txtDescCode').val($("#grid").datagrid('getSelected')["DescCode"]);
                     $('#txtDescription').val($("#grid").datagrid('getSelected')["Description"]);
                     $('#txtIcon').val($("#grid").datagrid('getSelected')["Icon"]);
                     $('#wind').window('open');
                 }
                 else
                     $.messager.alert('注意', "请选择需要编辑的行！", 'warning');
             }
         }, {
             text: '删除',
             iconCls: 'icon-save',
             handler: function () {
                 if ($("#grid").datagrid('getSelected') != null) {
                     $.messager.confirm('注意', '是否确认删除该行记录！', function (r) {
                         if (r) {
                             $("#grid").datagrid({
                                 url: "Ajax.aspx?key=del&id=" + $("#grid").datagrid('getSelected')["Code"]
                             });

                         }
                     });
                 }
             }
         }
        ];  
        
            
	</script>
      </div>

     <div id="wind" class="easyui-window" title="编辑"
       data-options="modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false" 
       style="width:500px;height:340px;padding:10px;">
		<div class="easyui-layout" data-options="fit:true">
			<div data-options="region:'center',split:true">
             <form id="windform">
            <input type="hidden" name="txtCode" id="txtCode"/>
            <ul class="u3wind">
            <li> <div style="font-size:12px; padding-left:20px; width:250px;">*标注为必填项，排序按数值由小到大</div></li>
            <li> <div>*模块名称:</div><input type="text" id="txtCname" name="txtCname" /></li>
            <li> <div>*Url:</div><input type="text" id="txtUrl" name="txtUrl" /></li>
            <li> <div>*排序:</div><input type="text" id="txtDescCode" name="txtDescCode" /></li>
            <li> <div>所属模块:</div><input type="text" id="txtPCode" name="txtPCode" class="easyui-combobox" style="width:155px;"
             data-options=" url: 'Ajax.aspx?key=ComBoBox',panelHeight:'auto'"  /></li>
            <li> <div>图标:</div><input type="text" id="txtIcon" name="txtIcon"  /></li>
            <li> <div>备注:</div><textarea id="txtDescription" rows="10" name="txtDescription" style="width:300px; height:60px;"></textarea></li>
            <li> <div>启用:</div><select class="easyui-combobox" name="txtStatusFlag"   data-options="panelHeight:'auto'"  id="txtStatusFlag" style="width:80px;">
            <option value="1">启 用</option>
		    <option value="2">停 用</option>
           </select>
           </li>
            </ul>
             </form> 
            </div>     
  	
   			<div data-options="region:'south',border:false" style="text-align:right;padding:5px 0 0;">
				<a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript: $('#wind').window('close');windClear();">取消</a>
			</div>
		</div>
	</div>
</body>
</html>
