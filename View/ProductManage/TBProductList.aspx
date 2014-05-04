<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TBProductList.aspx.cs" Inherits="UI.Module.ProductManage.TBProductList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../themes/icon.css" rel="stylesheet" type="text/css" /> 
    <script src="../../js/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.easyui.min.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
     <div class="easyui-panel" title="产品列表">

     <table class="easyui-datagrid" data-options="rownumbers:true,singleSelect:true,toolbar:toolbar">
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
          <tr>
            <td>1232dfsfd3213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            </tr>
              <tr>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            </tr>
              <tr>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            </tr>
              <tr>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            <td>12323213</td>
            </tr>
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
                        alert(msg);
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
	</script>
    	<div class="easyui-pagination" style="border:1px solid #ddd;" data-options="displayMsg: ''"></div>
		</div>		
			
    </form>
</body>
</html>
