<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" Inherits="AppBox.View.Customers.ProductList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../easyui/themes/metro/easyui.css" rel="stylesheet" type="text/css" /> 
    <link href="../../easyui/themes/icon.css" rel="stylesheet" type="text/css" /> 
    <script src="../../easyui/js/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../../easyui/js/jquery.easyui.min.js" type="text/javascript"></script>
   
</head>
<body>
    <form id="form1" runat="server">
     <div class="easyui-panel" title="客户列表">

     <table class="easyui-datagrid" id="customergrid" data-options="rownumbers:true,singleSelect:true,toolbar:toolbar">
		<thead>
			<tr>
				<th data-options="field:'itemid',width:80">Item ID</th>
				<th data-options="field:'productid',width:100">Product</th>
				<th data-options="field:'listprice',width:80,align:'right'">List Price</th>
				<th data-options="field:'unitcost',width:80,align:'right'">Unit Cost</th>
				<th data-options="field:'attr1',width:250">Attribute</th>
				<th data-options="field:'status',width:60,align:'center'">Status</th>
			</tr>
		</thead>
        <tbody> 
        </tbody>
	</table>
    <script type="text/javascript">
        var toolbar = [{
            text: 'Add',
            iconCls: 'icon-plus',
            handler: function () {
                $.ajax({
                    type: "post",
                    datatype: "text",
                    url: "Ajax.aspx?key=download",
                    success: function (msg) {
                        alert("msg");
                    }
                });
            }
        }, {
            text: 'Del',
            iconCls: 'icon-remove',
            handler: function () { alert('del') }
        }, '-', {
            text: 'Save',
            iconCls: 'icon-ok',
            handler: function () { alert('save') }
        }];
        $('#customergrid').datagrid({
            url: 'Ajax.aspx?type=customer',
            columns: [[
        { field: 'code', title: 'Code', width: 100 },
        { field: 'name', title: 'Name', width: 100 },
        { field: 'price', title: 'Price', width: 100, align: 'right' }
             ]]
        }); 
    </script> 
	</script>
    	<div class="easyui-pagination" style="border:1px solid #ddd;" data-options="displayMsg: ''"></div>
		</div>		
			
    </form>
</body>
</html>
