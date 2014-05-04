<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Add.aspx.cs" Inherits="AppBox.SaleBillManage.Add" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../themes/icon.css" rel="stylesheet" type="text/css" /> 
    <script src="../../js/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.easyui.min.js" type="text/javascript"></script>
     <link href="../../css/bigicon.css" rel="stylesheet" type="text/css" />
      <script language="javascript" type="text/javascript">

          $().ready(function () {

              $("#btnSave").click(function () {
                  $.ajax({
                      type: "post",
                      datatype: "json",
                      url: "Ajax.aspx?key=update",
                      data: $('#windform').serialize(),
                      success: function (msg) {
                          if (msg == "success") {
                              $("#grid").datagrid("reload");
                              $('#wind').window('close');
                          }
                      }
                  });
              });

              $("#btnCancel").click(function () {
                
              });

          })
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="p" class="easyui-panel" title="新增" style="width:500px;height:300px;padding:10px;">
          <div data-options="region:'center',split:true">
            <ul>
            <li> <a>交易编号:</a><input type="text" name="txtTid" id="txtTid"/></li>
            <li> <a>&nbsp;&nbsp;&nbsp;&nbsp;标题:</a><input type="text" id="txtTitle" name="txtTitle" /></li>
            <li> <a>商品总价:</a><input type="text" name="txtPrice" id="txtPrice"/></li>
            <li> <a>优惠金额:</a><input type="text" name="txtDiscountFee" id="txtDiscountFee"/></li>
            <li> <a>实付金额:</a><input type="text" name="txtPayment" id="txtPayment" /></li>
            <li> <a>&nbsp;&nbsp;&nbsp;&nbsp;数量:</a><input type="text" name="txtNum" id="txtNum" /></li>
            </ul>
            </div>
			<div data-options="region:'south',border:false" style="text-align:right;padding:5px 0 0;">
				<a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
				<a class="easyui-linkbutton" id="btnCancel" data-options="iconCls:'icon-cancel'">取消</a>
			</div>
    </div>
    </form>
</body>
</html>
