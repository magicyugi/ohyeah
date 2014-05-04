<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TBSaleBill.aspx.cs" Inherits="UI.Module.SaleBillManage.TBSaleBill" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../themes/icon.css" rel="stylesheet" type="text/css" /> 
    <script src="../../js/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../js/easyui-lang-zh_CN.js" type="text/javascript"></script>
     <script src="../../js/u3.js" type="text/javascript"></script>
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

          

            $("#grid").datagrid({
                onClickRow: function (index, data) {
                    $('#txtBuyerNick').val(data.BuyerNick);
                    $('#txtStatus').val(data.Status);
                    $('#txtTid').val(data.Tid);
                    $('#txtReceiverZip').val(data.ReceiverZip);
                    $('#txtReceiverName').val(data.ReceiverName);
                    $('#txtReceiverMobile').val(data.ReceiverMobile);
                    $('#txtBuyerArea').val(data.ReceiverState + data.ReceiverCity + data.ReceiverDistrict);
                    $('#txtReceiverAddress').val(data.ReceiverAddress);
                    $('#txtBuyerMessage').val(data.BuyerMessage);
                    $('#txtSellerMemo').val(data.SellerMemo);
                    $("#ordergrid").datagrid({
                        url: "Ajax.aspx?key=product&id=" + data.Tid
                    });
                }
            });

            $("#ordergrid").datagrid({
                onClickRow: function (index, data) {
                    $('#produtImage').attr('src', data.pic_path);
                }
            });

            $("#btnDownload").click(function () {
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?key=download",
                    success: function (msg) {
                        if (msg == "success") {
                            $("#grid").datagrid('load');
                        }
                    }
                });
            });

            $("#btnCheck").click(function () {
                if ($("#grid").datagrid('getSelected') != null) {
                    if ($("#grid").datagrid('getSelected').NShenh == "1") {
                        $.messager.alert('注意', '该记录已审核！', 'warning');
                        return;
                    }
                    $.ajax({
                        type: "post",
                        datatype: "json",
                        url: "Ajax.aspx?key=Check&id=" + $("#grid").datagrid('getSelected')["Tid"]
                        + "&ddpGuid=" + $('#ddpGuide').combobox('getValue') + "&cheat=" + $('#cbbCheat').is(":checked"),
                        success: function (msg) {
                            if (msg == "SUCCESS") {
                                $.messager.alert('提示', '审核成功！', '');
                                $("#grid").datagrid("reload");
                            }
                            else {
                                $.messager.alert('注意', msg + '不存在，请确认！', 'warning');
                            }
                        }
                    });
                }
                else {
                    $.messager.alert('注意', '请选择要审核的记录！', 'warning');
                }
            });

        
        })
    </script>
</head>
<body>
    <form id="mainform" runat="server"  >
     <div class="easyui-panel" title="产品列表">
     <table class="easyui-datagrid" id="grid" 
     data-options="url: 'Ajax.aspx?key=LoadGrid', pagination: true,
     rownumbers:true,singleSelect:true,toolbar:'#gridtoolbar',pageSize:10">
		<thead>
			<tr>
                <th data-options="field:'Tid',width:120">交易编号</th>
				<th data-options="field:'Title',width:200">标题</th>
				<th data-options="field:'Price',width:80">商品总价</th>
                <th data-options="field:'DiscountFee',width:80">优惠金额</th>
                <th data-options="field:'Payment',width:80">实付金额</th>
                <th data-options="field:'Num',width:80,align:'right'">数量</th>
				<th data-options="field:'BuyerNick',width:80,align:'right'">买家昵称</th>
                <th data-options="field:'Created',width:80,align:'right'">开单时间</th>
                <th data-options="field:'ReceiverZip',width:60,align:'center'">收件邮编</th>
                <th data-options="field:'ReceiverName',width:60,align:'center'">收件人</th>
                <th data-options="field:'ReceiverMobile',width:60,align:'center'">手机号码</th>
                <th data-options="field:'ReceiverState',width:60,align:'center'">省</th>
                <th data-options="field:'ReceiverCity',width:60,align:'center'">市</th>
                <th data-options="field:'ReceiverDistrict',width:60,align:'center'">县、区</th>
				<th data-options="field:'ReceiverAddress',width:60,align:'center'">地址</th>
                <th data-options="field:'BuyerMessage',width:60,align:'center'">买家留言</th>
                <th data-options="field:'SellerMemo',width:60,align:'center'">卖家备注</th>
                <th data-options="field:'NShenh'">是否审核</th>
			</tr>
		</thead>
       
	</table>
    
    <div id="gridtoolbar">
      <a class="l-btn l-btn-plain"  id="btnDownload"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">下载订单</span></span></a>
    </div>
  </form>
  
    <div class="easyui-layout" style="height:300px;">
		<div data-options="region:'east',split:true" title="" style="width:210px;">
          <img id="produtImage" src="" width="200" height="200"/>
        </div>
		<div data-options="region:'center',title:'',iconCls:'icon-ok'">
           <div class="easyui-layout" style="height:90px;">
             <div class="easyui-panel" data-options="region:'west',split:true" style="width:610px;">
               <div style="padding-left:3px; padding-top:5px;">
               <label>卖家昵称</label><input type="text" id="txtBuyerNick" style=" width:100px; margin-left:2px;"/>
                 <label >交易状态</label><input type="text" id="txtStatus" style=" width:100px; margin-left:2px;"/>
                 <label >订单号</label><input type="text" id="txtTid" style=" width:130px; margin-left:2px;"/>
                 <label >邮编</label><input type="text" id="txtReceiverZip" style=" width:70px; margin-left:2px;"/>
                 </div>
                  <div style="padding-left:3px">
               <label >收 货 人</label><input type="text" id="txtReceiverName" style=" width:100px; margin-left:2px;"/>
                  <label >物流方式</label><input type="text" id="txtSendWay" style=" width:100px; margin-left:2px;"/>
                  <label >电   话&nbsp;</label><input type="text" id="txtReceiverMobile" style=" width:100px; margin-left:2px;"/>
              </div>
               <div style="padding-left:3px">
                 <label >收货区域</label><input type="text" id="txtBuyerArea" style=" width:120px; margin-left:2px;"/>
                   <label >地  址</label><input type="text" id="txtReceiverAddress" style=" width:300px; margin-left:2px;"/>
             </div>
              </div>    
             <div class="easyui-panel" data-options="region:'center',split:true" style="width:200px; padding:5px;">
               <label>买家留言</label>
               <textarea id="txtBuyerMessage" maxlength="10" style=" width:180px; height:55px;"></textarea>
             </div>
             <div class="easyui-panel" data-options="region:'east',split:true" style="width:210px; padding:5px;">
               <label>卖家备注</label>
               <textarea  id="txtSellerMemo"  maxlength="10" style=" width:170px; height:55px;"></textarea>
             </div>
            </div>
			<table class="easyui-datagrid" id="ordergrid"  style=" height:200px" data-options="rownumbers:true,singleSelect:true">
				<thead>
					<tr>
						<th data-options="field:'title'" width="300">宝贝名称</th>
						<th data-options="field:'price',align:'right'"  width="40">单价</th>
						<th data-options="field:'num',align:'right'" width="40">数量</th>
						<th data-options="field:'total_fee',align:'right'" width="60">应付金额</th>
						<th data-options="field:'payment',align:'right'" width="60">实付金额</th>
                        <th data-options="field:'sku_id'" width="80">商品SKU</th>
                        <th data-options="field:'sku_properties_name'" width="200">SKU值</th>
                        <th data-options="field:'outer_iid',align:'center'" width="100">商品编号</th>
                        <th data-options="field:'outer_sku_id',align:'center'" width="100">公司SKU</th>
                        <th data-options="field:'pic_path',hidden:true" width="100">商品编号</th>
					</tr>
				</thead>
			</table>
		</div>
    </div>

</body>
</html>

