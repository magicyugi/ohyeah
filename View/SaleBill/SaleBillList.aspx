<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SaleBillList.aspx.cs" Inherits="AppBox.View.SaleBillManage.SaleBillList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../easyui/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../media/js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../../easyui/js/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../easyui/css/bigicon.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript">
        var Common = {

            TimeFormatter: function (value, rec, index) {
                if (value == undefined) {
                    return "";
                }
                /*json格式时间转js时间格式*/
                value = value.substr(2, value.length -5).replace("T"," "); 
                return value;
            },
            DateFormatter: function (value, rec, index) {
                if (value == undefined) {
                    return "";
                }
                /*json格式时间转js时间格式*/
                value = value.substr(2, value.length - 10).replace("T", " ");
                return value;
            },
            formatterStatus: function (value, rowData, rowIndex) {
                var showvalue = "";
                if (value == '1') showvalue = '<span>正常</span>';
                if (value == '2') showvalue = '<span>已完成</span>';
                if (value == '3') showvalue = "<span style='color:red'>坏账</span>";
                return showvalue;
            },
            BoolFormatter: function (value, rec, index) {
                if (value == undefined || value == "") value = "<span style='color:red;font-weight:bolder'>×</span>";
                else
                    value = "<span style='color:green;font-weight:bolder'>√</span>";

                /*json格式时间转js时间格式*/

                return value;
            }

        };
        $(function () {

            $("#grid").datagrid({
                onClickRow: function (index, data) {
                    $("#dgrid").datagrid({
                        url: "SaleBillAjax.aspx?key=LoadDGrid&Code=" + data.Code
                    });
                }
            });

            $("#editGrid").datagrid({
                onClickRow: function (index, data) {
                    $("#txtOldCount").val(data.TotalCount);
                    $("#txtNewCount").val(data.TotalCount);
                    $("#txtNewCount").select();
                }
            });

            $("#btnSearch").click(function () {
                $("#grid").datagrid({
                    url: "SaleBillAjax.aspx?key=LoadGrid&CN=" + $("#txtCustomerName").val()
                    + "&CE=" + $("#txtCustomerEmail").val() + "&CL=" + $("#txtCustomerLevel").val()
                    + "&CS=" + $("#txtCustomerSname").val() + "&CS=" + $("#txtCustomerSname").val()
                    + "&BF=" + $("#txtBillFrom").val() + "&BC=" + $("#txtBillCode").val()
                    + "&BT=" + $("#txtBillType").val() + "&BS=" + $("#txtBillStatus").val()
                    + "&SD=" + $("#txtStartDate").val() + "&ED=" + $("#txtEndDate").val()
                });
            });
            $("#btnSave").click(function () {
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "SaleBillAjax.aspx?key=Allot&sid=" + $("#sgrid").datagrid("getSelected").Code + "&id=" + $("#grid").datagrid("getSelected").Code,
                    success: function (msg) {
                        if (msg == "SUCCESS") {
                            $("#grid").datagrid("reload");
                            $('#winEdit').window('close');
                        }
                    }
                });
            });

            //修改订单
            $("#btnEdit").click(function () {
                if ($("#grid").datagrid('getSelected') != null) {
                    $("#editGrid").datagrid({
                        url: "SaleBillAjax.aspx?key=LoadEditGrid&Code=" + $("#grid").datagrid('getSelected').Code
                    });
                    $('#winEdit').window('open');
                }
                else alert("请选择要修改的订单");
            });
            $("#btnSearchBill").click(function () {
                $("#winSearchBill").window("open");
            });
            //优惠申请弹窗
            $("#btnDiscount").click(function () {
                if ($("#grid").datagrid('getSelected') != null) {
                    $("#txtOldAmount").val($("#grid").datagrid('getSelected').BillAmount);
                    $("#txtOldFreight").val($("#grid").datagrid('getSelected').Freight);
                    $("#txtApplyAmount").removeAttr("disabled", "disabled");
                    $("#txtApplyFreight").removeAttr("disabled", "disabled");
                    $("#txtApplyDate").hide();
                    $("#btnAskDiscountCommit").show();
                    $("#btnCommitDiscountCommit").hide();
                    $('#winAskDiscount').window('open');
                }
                else alert("请选择要申请优惠的订单");
            });
            //优惠审批弹窗
            $("#btnDiscountSumit").click(function () {
                if ($("#grid").datagrid('getSelected') != null) {
                    $("#txtOldAmount").val($("#grid").datagrid('getSelected').BillAmount);
                    $("#txtOldFreight").val($("#grid").datagrid('getSelected').Freight);

                    $("#btnAskDiscountCommit").hide();
                    $("#btnCommitDiscountCommit").show();
                    $.ajax({
                        datatype: "json",
                        url: "SaleBillAjax.aspx?key=GetApply&Code=" + $("#grid").datagrid("getSelected").Code,
                        success: function (msg) {
                            var result = eval(msg)[0];
                            $("#txtApplyAmount").val(result.ApplyAmount);
                            $("#txtApplyAmount").attr("disabled", "disabled");
                            $("#txtApplyFreight").val(result.ApplyFreight);
                            $("#txtApplyFreight").attr("disabled", "disabled");
                            $("#txtApplyDate").show();
                            $("#txtApplyDate").text("申请日期 " + result.ApplyDate.replace('T', ' '));
                            $("#txtApplyMemo").val(result.ApplyMemo);
                        }
                    });

                    $('#winAskDiscount').window('open');
                }
                else alert("请选择要申请优惠的订单");
            });
            //优惠申请确认
            $("#btnAskDiscountCommit").click(function () {
                $.ajax({
                    datatype: "json",
                    url: "SaleBillAjax.aspx?key=AskDiscountCommit&Code=" + $("#grid").datagrid("getSelected").Code
                    + "&OldAmount=" + $("#txtOldAmount").val() + "&OldFreight=" + $("#txtOldFreight").val()
                    + "&ApplyAmount=" + $("#txtApplyAmount").val() + "&ApplyFreight=" + $("#txtApplyFreight").val()
                    + "&ApplyMemo=" + $("#txtApplyMemo").val(),
                    success: function (msg) {
                        if (msg == "SUCCESS") {
                            $("#grid").datagrid("reload");
                            $('#winAskDiscount').window('close');
                        }
                    }
                });
            });
            //优惠审批确认
            $("#btnCommitDiscountCommit").click(function () {
                $.ajax({
                    datatype: "json",
                    url: "SaleBillAjax.aspx?key=CommitDiscountCommit&Code=" + $("#grid").datagrid("getSelected").Code
                        + "&NewAmount=" + $("#txtNewAmount").val() + "&NewFreight=" + $("#txtNewFreight").val()
                        + "&CommitMemo=" + $("#txtCommitMemo").val(),
                    success: function (msg) {
                        if (msg == "SUCCESS") {
                            $("#grid").datagrid("reload");
                            $('#winAskDiscount').window('close');
                        }
                    }
                });
            });
            //编辑确认
            $("#btnEditCommit").click(function () {
                if ($("#editGrid").datagrid("getSelected") == null) { alert("请选择要修改的记录"); return; }
                if (parseFloat($("#txtNewCount").val()).toString() == "NaN") {
                    alert("输入数据格式有误");
                    $("#txtNewCount").select();
                    return;
                }
                var totalcount = parseFloat($("#txtNewCount").val());
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "SaleBillAjax.aspx?key=EditCommit&ID=" + $("#editGrid").datagrid("getSelected").ID + "&TotalCount=" + totalcount,
                    success: function (msg) {
                        if (msg == "SUCCESS") {
                            $("#dgrid").datagrid("reload");
                            $("#editGrid").datagrid("reload");
                            $("#txtNewCount").val(0);
                            $("#txtOldCount").val(0);
                        }
                    }
                });
            });
            $("#btnPay").click(function () {
                $('#winPay').window('open');
            });
            $("#btnMultiPay").click(function () {
                for(var i=0;i<5;i++) {
                $("#multiDiv").append("<ul style=\"width:700px;\">"
                       +"<li style=\"float:left;width:120px;margin:5px;  \">"
                       +"<input value=\"0\" style=\"width:100px;margin:5px;text-align:right\"/></li>"
                       +"<li  style=\"float:left;width:120px;margin:5px; \"><input value=\"\"  style=\"width:100px;margin:5px; margin:5px;text-align:right\"/></li>"
                       +"<li  style=\"float:left;width:120px;margin:5px;  \"><input value=\"\"      style=\"width:100px;margin:5px; margin:5px;text-align:right\"/></li>"
                       +"<li  style=\"float:left;width:120px;margin:5px;  \"><input value=""   style="width:100px;margin:5px; margin:5px;text-align:right"/></li>
           
                <li  style="float:left;width:120px;margin:5px;  "><input value="0"     style="width:100px;margin:5px; margin:5px;text-align:right" ></li>
               
               </ul>");
               }
                $('#winMultiPay').window('open');
            });

            $("#btnLevelUp").click(function () {
                $.ajax({
                    datatype: "json",
                    url: "SaleBillAjax.aspx?key=LevelUp&ID=" + $("#grid").datagrid("getSelected").ID,
                    success: function (msg) {
                        if (msg == "SUCCESS") {
                            alert("订单提级成功,最高5级");
                            $("#grid").datagrid("reload");
                        }
                    }
                });
            });
            $('#dateStart').datebox({
                formatter: function (date) {
                    var y = date.getFullYear();
                    var m = date.getMonth() + 1;
                    var d = date.getDate();
                    return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
                }
            });

            $('#dateEnd').datebox({
                formatter: function (date) {
                    var y = date.getFullYear();
                    var m = date.getMonth() + 1;
                    var d = date.getDate();
                    return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
                }
            });

            //            $("#grid").datagrid('getPager').pagination({
            //                showPageList: false,
            //                showRefresh: false,
            //                displayMsg: ''
            //            });
        })
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'center',split:true" style="height: 500px;padding: 5px">
      <div class="easyui-panel" style="float: left; padding: 5px; vertical-align: middle;"> 
                <a class="l-btn l-btn-plain" id="btnEdit"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    修改订单</span></span></a> 
                     <a class="l-btn l-btn-plain" id="btnDiscount"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    优惠申请</span></span></a> 
                        <a class="l-btn l-btn-plain" id="btnDiscountSumit"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    优惠审批</span></span></a> 
                        <a class="l-btn l-btn-plain" id="btnReturnSubmit"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    退款审批</span></span></a> 
                        <a class="l-btn l-btn-plain" id="btnLevelUp"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    订单提级</span></span></a> 
                        <a class="l-btn l-btn-plain" id="btnBillSubmit"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    提交订单</span></span></a> 
                       <a class="l-btn l-btn-plain" id="btnSearchBill"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    高级查询</span></span></a> 
                       <a class="l-btn l-btn-plain" id="btnPay"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    到账录入</span></span></a>  
                        <a class="l-btn l-btn-plain" id="btnMultiPay"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    批量录入款项</span></span></a> 
                        <a class="l-btn l-btn-plain" id="btnSendSubmit"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    确认发货</span></span></a>  
                        <a class="l-btn l-btn-plain" id="btnBillClose"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    关闭交易</span></span></a> 
                     
        </div>
        <div class="easyui-panel" style="float: left; padding: 5px; vertical-align: middle;">
            <div style="float: left"> 
                <label>
                    订单来源:</label><select id="txtBillFrom" style="width: 120px;">
                    <option value="">全部</option>
                    <option value="1">B2C</option>
                    <option value="2">速卖通</option>
                    </select>
                <label>
                    订单状态:</label><select id="txtBillStatus" style="width:120px">
                         <option value="">全部</option>
                        <option value="1">正常单</option>
                        <option value="2">已改单</option>
                        <option value="3">优惠申请</option>
                        <option value="4">已提交</option>
                        <option value="5">已付款</option>
                        <option value="6">已发货</option>
                        <option value="7">已收货</option>
                        <option value="8">已申请退货</option>
                        <option value="9">已退货</option>
                        <option value="10">已关闭</option>
                    </select>
                  <label>
                    订单编号:</label><input type="text" id="txtBillCode" /> 
            </div>
            <div style="float: left"> 
                <label>
                    客户等级:</label><select id="txtCustomerLevel" style="width: 120px;"><option>全部</option>
                        <option value="">全部</option>
                        <option value="A">A</option>
                        <option value="">B</option>
                    </select>
                <label>
                    订单类型:</label><select id="txtBillType" style="width: 120px;">
                     <option value="">全部</option>
                     <option value="1">类型一</option>
                     <option value="2">类型二</option>
                     </select> 
                        <label>
                    订单日期:</label>
                <input id="txtStartDate" class="easyui-datebox" type="text" style="width: 100px;" />
                <label>
                    -</label>
                <input id="txtEndDate" class="easyui-datebox" type="text" style="width: 100px;" /> 
                <a class="l-btn l-btn-plain" id="btnSearch"><span class="l-btn-left"><span class="l-btn-text icon-save l-btn-icon-left">
                    查询</span></span></a>
            </div>
        </div>
        
        <table class="easyui-datagrid" id="grid" data-options="url: 'SaleBillAjax.aspx?key=LoadGrid', pagination: true, rownumbers:true,singleSelect:true,pageSize:10"
            style="height: 300px;"> 
            <thead>
                <tr> 
                    <th data-options="field:'BillLevel',width:50">
                         等级
                    </th>  
                    <th data-options="field:'Code',width:130">
                        订单号
                    </th>
                    <th data-options="field:'Bill_Code',width:110">
                        来源单号
                    </th>
                    <th data-options="field:'BillFromName',width:80">
                        交易来源
                    </th>
                    <th data-options="field:'BuyerCode',width:80,hidden:true">
                        买家昵称
                    </th>
                    <th data-options="field:'BuyerName',width:80">
                        买家昵称
                    </th> 
                    <th data-options="field:'TotalCount',width:60,align:'right'">
                        数量
                    </th>
                    <th data-options="field:'Weight',width:60,align:'right'">
                        总重量
                    </th>
                    <th data-options="field:'BillAmount',width:80,align:'right'">
                        总金额
                    </th>
                    <th data-options="field:'Freight',width:80,align:'right'">
                        运费
                    </th>
                    <th data-options="field:'TotalAmount',width:80,align:'right'">
                        整单实收
                    </th>
                    <th data-options="field:'BillDate',width:110" formatter="Common.TimeFormatter">
                        下单时间
                    </th>
                    <th data-options="field:'PayDate',width:110" formatter="Common.TimeFormatter">
                        收款时间
                    </th>
                    <th data-options="field:'ReceiverName',width:60">
                        收件人
                    </th>
                    <th data-options="field:'ReceiverZip',width:60,hidden:true">
                        收件邮编
                    </th>
                    <th data-options="field:'ReceiverEmail',width:60">
                        邮件地址
                    </th>
                    <th data-options="field:'ReceiverMobile',width:60,hidden:true">
                        手机号码
                    </th>
                    <th data-options="field:'ReceiverPhone',width:60,hidden:true">
                        电话
                    </th>
                    <th data-options="field:'ReceiverCountry',width:60">
                        国家
                    </th>
                    <th data-options="field:'ReceiverState',width:60,hidden:true">
                        省
                    </th>
                    <th data-options="field:'ReceiverCity',width:60,hidden:true">
                        市
                    </th>
                    <th data-options="field:'ReceiverDistrict',width:60,hidden:true">
                        县、区
                    </th>
                    <th data-options="field:'Address',width:300,hidden:true">
                        地址
                    </th> 
                    <th data-options="field:'StatusName',width:40">
                        状态
                    </th>
                </tr>
            </thead>
        </table>
        
        <script type="text/javascript">
            var toolbar = [{
                text: '反审',
                iconCls: 'icon-edit',
                handler: function () {
                    if ($("#grid").datagrid('getSelected') != null) {
                        $.messager.confirm('注意', '是否确认反审！', function (r) {
                            if (r) {
                                $("#grid").datagrid({
                                    url: "SaleBillAjax.aspx?key=ReCheck&id=" + $('#grid').datagrid('getSelected').Code
                                });
                            }
                        });
                    }
                }
            }, {
                text: '挂起',
                iconCls: 'icon-save',
                handler: function () {
                    if ($("#grid").datagrid('getSelected') != null) {
                        $.messager.confirm('注意', '是否确认挂起该单据！', function (r) {
                            if (r) {
                                $("#grid").datagrid({
                                    url: "SaleBillAjax.aspx?key=HangUp&id=" + $('#grid').datagrid('getSelected').Code
                                });
                            }
                        });
                    }
                }
            }, {
                text: '派单',
                iconCls: 'icon-edit',
                handler: function () {
                    if ($("#grid").datagrid('getSelected') != null) {
                        $("#sgrid").datagrid({
                            url: "SaleBillAjax.aspx?key=LoadSGrid"
                        });
                        $('#wind').window('open');
                    }
                    else
                        $.messager.alert('注意', "请选择需要配单的记录！", 'warning');
                }
            }, {
                text: '接收派单',
                iconCls: 'icon-edit',
                handler: function () {
                    if ($("#grid").datagrid('getSelected') != null) {

                    }
                    else
                        $.messager.alert('注意', "请选择需要接收的单据！", 'warning');
                }
            }
        ];      
        </script>
    </div>
    <div data-options="region:'south',split:true" style="height: 180px; padding: 5px">
        <table class="easyui-datagrid" id="dgrid" style="height: 160px" data-options="rownumbers:true,singleSelect:true">
            <thead>
                <tr>
                    <th data-options="field:'Product_Code'" width="120">
                        款号
                    </th>
                    <th data-options="field:'ProductName'" width="300">
                        名称
                    </th>
                    <th data-options="field:'Key1',align:'center',hidden:true" width="100">
                        编号
                    </th>
                    <th data-options="field:'Key2',align:'center'" width="100">
                        颜色
                    </th>
                    <th data-options="field:'Key3',align:'center'" width="100">
                        尺码
                    </th>
                    <th data-options="field:'Price',align:'right'" width="40">
                        单价
                    </th>
                    <th data-options="field:'TotalCount',align:'right'" width="40">
                        数量
                    </th> 
                     <th data-options="field:'TotalMoney',align:'right'" width="40">
                        金额
                    </th>
                    <th data-options="field:'ProductVCode',align:'center',hidden:true" width="100">
                        商品编号
                    </th>   
                    <th data-options="field:'Unit_Code',hidden:true" width="100">
                        单位
                    </th>
                </tr>
            </thead>
        </table>
    </div>
    <div id="winEdit" class="easyui-window" title="修改订单" data-options="modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 630px; height: 420px; padding: 5px;">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'center',split:true">
                <label style="margin:5px;">原数量</label><input value="0" disabled="disabled" id="txtOldCount"  style="width:40px;margin:5px;text-align:right"/><label  style="margin:5px;">新数量</label><input value="0"  id="txtNewCount"     style="width:40px;margin:5px;width:30px;margin:5px;text-align:right"/>
                <a class="easyui-linkbutton" id="btnEditCommit" data-options="iconCls:'icon-save'">确认修改</a>
                <table class="easyui-datagrid" id="editGrid" style="height: 300px;" data-options="singleSelect:true,rownumbers:true">
                    <thead>
                        <tr> 
                            <th data-options="field:'ID',width:120,hidden:true">
                                编号
                            </th>
                            <th data-options="field:'Key1',width:120">
                                款号
                            </th>
                            <th data-options="field:'ProductName',width:200">
                                名称
                            </th>
                            <th data-options="field:'Key2',width:80">
                                颜色
                            </th>
                            <th data-options="field:'Key3',width:80">
                                尺码
                            </th>
                            <th data-options="field:'TotalCount',width:80">
                                数量
                            </th>
                        </tr>
                    </thead>
                </table>
            </div>
            <div data-options="region:'south',border:false" style="text-align: right; padding: 5px 0 0;">
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winEdit').window('close');">取消修改</a>
            </div>
        </div>
    </div>

      <div id="winAskDiscount" class="easyui-window" title="优惠申请" data-options="modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 500px; height: 450px; padding: 5px;">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'center',split:true">
                <label style="margin:5px;">原单金额</label><input value="0" disabled="disabled"  id="txtOldAmount"  style="width:40px;margin:5px;text-align:right"/>
                <br />
                 <label  style="margin:5px;">原单运费</label><input value="0"  id="txtOldFreight"  disabled="disabled"    style="width:40px;margin:5px; margin:5px;text-align:right"/>
                 <br />
                <div id="dvApplyDiscount" style="width:350px; border-top:1px solid #383838">
                 <label style="margin:5px;">申请金额</label><input value="0" id="txtApplyAmount"  style="width:40px;margin:5px;text-align:right"/>
                 <br />
                 <label  style="margin:5px;">申请运费</label><input value="0"  id="txtApplyFreight"     style="width:40px;margin:5px; margin:5px;text-align:right"/>
             
                <br />
                  <label  style="margin:5px;">申请备注</label>  
                  <br />
                  <textarea id="txtApplyMemo" style="width:300px;"> </textarea>
                  
                <br />
                    <label  style="margin:5px;" id="txtApplyDate">申请日期</label> 
             
                </div>
                  
                <br />
                    <div id="dvCommitDiscount" style="width:350px; border-top:1px solid #383838">
                 <label style="margin:5px;">批准金额</label><input value="0" id="txtNewAmount"  style="width:40px;margin:5px;text-align:right"/>
                 <br />
                 <label  style="margin:5px;">批准运费</label><input value="0"  id="txtNewFreight"     style="width:40px;margin:5px; margin:5px;text-align:right"/>
                   <br /> <label  style="margin:5px;">审核备注</label><br />
                   <textarea id="txtNewMemo" style="width:300px;"> </textarea>
                </div>
            </div>
            <div data-options="region:'south',border:false" style="text-align: right; padding: 5px 0 0;"> 
                <a class="easyui-linkbutton" id="btnAskDiscountCommit" data-options="iconCls:'icon-save'">确认申请</a>
                <a class="easyui-linkbutton" id="btnCommitDiscountCommit" data-options="iconCls:'icon-save'">确认审核</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winAskDiscount').window('close');">取消</a>
            </div>
        </div>
    </div>
    
    <div id="winSearchBill" class="easyui-window" title="到款查询" data-options="modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 500px; height: 450px; padding: 5px;">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'center',split:true"> 
                 <label style="margin:5px; ">原单实收</label><input value="0"   id="txtBillAmount"  style="width:100px;margin:5px;text-align:right"/>
                <br />
                 <label  style="margin:5px;">未付金额</label><input value="0"  id="txtLeftAmount"    style="width:100px;margin:5px; margin:5px;text-align:right"/>
                 <br />
                <div id="Div1" style="width:350px; border-top:1px solid #383838">
                 <label  style="margin:5px; padding-right:21px;">Email</label><input   id="txtCustomerEmail"     style="width:150px;margin:5px; margin:5px;text-align:right"/>
                 <br />
                 <label style="margin:5px;padding-right:28px;">Line</label><input   id="txtLine"  style="width:150px;margin:5px;text-align:right"/>
                 <br /> 
                 <label  style="margin:5px;padding-right:14px;">Paypal</label><input   id="txtPaypal"     style="width:150px;margin:5px; margin:5px;text-align:right"/>
                 <br />
                 <label  style="margin:5px;;padding-right:4px;">下单时间</label><input    id="txtBillDate"  class="easyui-datebox"   style="width:156px;margin:5px; margin:5px;text-align:right"/>
                <br />   
               <label  style="margin:5px;">客户昵称</label><input    id="txtCustomerSname"     style="width:150px;margin:5px; margin:5px;text-align:right"/>
               <br />
                 <label  style="margin:5px;">客户名称</label><input    id="txtCustomerName"     style="width:150px;margin:5px; margin:5px;text-align:right"/>
               <br />
                <label  style="margin:5px;">客户地址</label><input   id="txtAddress"     style="width:150px;margin:5px; margin:5px;text-align:right"/>
             
                <br /> 
            </div>
            <div data-options="region:'south',border:false" style="text-align: right; padding: 5px 0 0;"> 
                <a class="easyui-linkbutton" id="btnSearchBillCommit" data-options="iconCls:'icon-save'">确认</a> 
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winSearchBill').window('close');">取消</a>
            </div>
        </div>
    </div>
    </div>
<div id="winMultiPay" class="easyui-window" title="款项批量录入" data-options="modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 770px; height: 350px; padding: 5px;">
        <div class="easyui-layout" data-options="fit:true">

            <div data-options="region:'center',split:true" id="multiDiv"> <ul style="width:700px; height:30px; border-bottom:1px solid black" >
                 <li style="float:left; width:120px;margin:5px;  ">到账金额</li> 
                 <li  style="float:left;width:120px;margin:5px;  ">到账时间</li>  
                  <li  style="float:left;width:120px;margin:5px;  ">付款人姓名</li>  
                 <li  style="float:left;width:120px;margin:5px;  ">地址信息</li> 
           
                <li  style="float:left;width:120px;margin:5px; padding-right:35px;">PayPal</li> 
               </ul>
               
            </div>
            <div data-options="region:'south',border:false" style="text-align: right; padding: 5px 0 0;"> 
                <a class="easyui-linkbutton" id="btnPayCommit" data-options="iconCls:'icon-save'">确认</a> 
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winPay').window('close');">取消</a>
            </div>
        </div>
    </div>
    <div id="winPay" class="easyui-window" title="款项录入" data-options="modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 400px; height: 350px; padding: 5px;">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'center',split:true"> 
                 <label style="margin:5px; padding-right:21px; ">到账金额</label><input value="0"   id="txtArrivedAmount"  style="width:100px;margin:5px;text-align:right"/>
                <br />
                 <label  style="margin:5px; padding-right:21px;">到账时间</label><input value=""  id="txtArrivedDate"    style="width:100px;margin:5px; margin:5px;text-align:right"/>
                 <br /> 
                  <label  style="margin:5px; padding-right:7px;">付款人姓名</label><input value=""  id="txtPayName"    style="width:100px;margin:5px; margin:5px;text-align:right"/>
                 <br /> 
                 <label  style="margin:5px; padding-right:21px;">地址信息</label><input value=""  id="txtPayAddress"    style="width:100px;margin:5px; margin:5px;text-align:right"/>
                <br /> 
                <label  style="margin:5px; padding-right:35px;">PayPal</label><input value="0"  id="txtPayPal"    style="width:100px;margin:5px; margin:5px;text-align:right"/>
                <br /> 
            </div>
            <div data-options="region:'south',border:false" style="text-align: right; padding: 5px 0 0;"> 
                <a class="easyui-linkbutton" id="btnPayCommit" data-options="iconCls:'icon-save'">确认</a> 
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winPay').window('close');">取消</a>
            </div>
        </div>
    </div>
</body>
</html>
