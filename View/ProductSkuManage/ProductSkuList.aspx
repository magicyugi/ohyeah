<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductSkuList.aspx.cs" Inherits="UI.Module.ProductSkuManage.ProductSkuList" %>

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
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?key=insert&pid=" + $("#grid").datagrid('getSelected').Code + "&kid="
                    + $("#dgrid").datagrid('getSelected').Code + "&sid=" + $("#sgrid").datagrid('getSelected').Code,
                    success: function (msg) {
                        if (msg == "success") {
                            $('#kgrid').datagrid({
                                url: 'Ajax.aspx?key=LoadKGrid&kid=' + $("#dgrid").datagrid('getSelected').Code + '&pid=' + $('#grid').datagrid('getSelected').Code
                            });
                            $('#wind').window('close');
                        }
                    }
                });
            });


            $('#grid').datagrid({
                onClickRow: function (index, data) {
                    $('#dgrid').datagrid({
                        url: 'Ajax.aspx?key=LoadDGrid&id=' + data.Code
                    });
                }
            });


            $('#dgrid').datagrid({
                onClickRow: function (index, data) {
                    $('#kgrid').datagrid({
                        url: 'Ajax.aspx?key=LoadKGrid&kid=' + data.Code + '&pid=' + $('#grid').datagrid('getSelected').Code
                    });
                }
            });

            $("#grid").datagrid('getPager').pagination({
                showPageList: false,
                showRefresh: false,
                displayMsg: ''
            });


        });
    


    </script>

</head>
<body  class="easyui-layout">
<div data-options="region:'west',split:true" style="width:430px; padding:10px">
    <table class="easyui-datagrid" id="grid" 
      data-options="url: 'Ajax.aspx?key=LoadGrid',singleSelect:true,rownumbers:true,pagination:true,pageSize:20">
		<thead>
			<tr>
             <th data-options="field:'Code',width:120,hidden:true">Code</th>
                <th data-options="field:'VCode',width:80">编号</th>
				<th data-options="field:'Cname',width:120">名称</th>
                <th data-options="field:'CTypeCode',width:80">类别</th>
                <th data-options="field:'BrandCode',width:80">品牌</th>
			</tr>
		</thead>
	</table>
</div>
 <div data-options="region:'center'" style="width:300px;padding:10px">
     <table class="easyui-datagrid" id="dgrid" 
      data-options="singleSelect:true,rownumbers:true">
		<thead>
			<tr>
                <th data-options="field:'Code',width:170,hidden:true">颜色编号</th>
                <th data-options="field:'VCode',width:100">颜色编号</th>
                <th data-options="field:'Cname',width:120">颜色名称</th>
			</tr>
		</thead>
	</table>
     
      </div>
<div data-options="region:'east',split:true" style="width:500px;padding:10px">
 <table class="easyui-datagrid" id="kgrid" 
      data-options="singleSelect:true,toolbar:toolbar">
		<thead>
			<tr>
              <th data-options="field:'Code',width:120,hidden:true">编号</th>
                <th data-options="field:'VCode',width:120">编号</th>
                <th data-options="field:'Cname',width:120">名称</th>
                <th data-options="field:'Sku_Code',width:120">自定义SKU</th>
                </tr>
		</thead>
	</table>
    <script type="text/javascript">
        var toolbar = [{
            text: '新增',
            iconCls: 'icon-edit',
            handler: function () {
                if ($("#grid").datagrid('getSelected') == null) {
                    $.messager.alert('注意', "请选择商品！", 'warning');
                    return;
                }
                if ($("#dgrid").datagrid('getSelected') == null) {
                    $.messager.alert('注意', "请选择商品颜色！", 'warning');
                    return;
                }
               // alert($("#dgrid").datagrid('getSelected').Code);
                $('#sgrid').datagrid({
                    url: 'Ajax.aspx?key=LoadSGrid&pid=' + $("#grid").datagrid('getSelected').Code + '&kid=' + $("#dgrid").datagrid('getSelected').Code
                });
                $('#wind').window('open');
            }
        }, {
            text: '删除',
            iconCls: 'icon-save',
            handler: function () {
                if ($("#kgrid").datagrid('getSelected') != null) {
                    $.messager.confirm('注意', '是否确认删除该行记录！', function (r) {
                        if (r) {
                            $('#kgrid').datagrid({
                                url: 'Ajax.aspx?key=del&kid=' + $('#dgrid').datagrid('getSelected').Code + '&pid=' + $('#grid').datagrid('getSelected').Code
                                + '&sid=' + $('#kgrid').datagrid('getSelected').Code
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
       style="width:320px;height:400px;padding:5px;">
       <div class="easyui-layout" data-options="fit:true">

   <div data-options="region:'center',split:true">
    <table class="easyui-datagrid" id="sgrid" 
      data-options="singleSelect:true,rownumbers:true">
		<thead>
			<tr>
                <th data-options="field:'Code',width:170,hidden:true">规格编号</th>
                <th data-options="field:'VCode',width:100">规格编号</th>
                <th data-options="field:'Cname',width:120">规格名称</th>
			</tr>
		</thead>
	</table>
    </div>
    <div data-options="region:'south',border:false" style="text-align:right;padding:5px 0 0;">
				<a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript: $('#wind').window('close');">取消</a>
			</div>
		</div>
       </div>
</body>
</html>
