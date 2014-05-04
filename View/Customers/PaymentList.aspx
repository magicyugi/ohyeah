<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PaymentList.aspx.cs" Inherits="AppBox.View.Customers.PaymentList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title> 
    <style>
     li.normalli
        {
            text-align: right;
            width: 70%;
            height: 30px;
            padding-top: 5px; 
            padding-bottom: 5px;
        }
     .datagrid-ftable{ color:Red;}
    </style>
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Payment";
        var selectcode = "";

        $().ready(function () {
            appendHM(30);
            if (request('ProcessFlag') == "2") {
                $("#btnstockup").css("display", "none");
                $("#btnshipments").css("display", "none");
                $("#btnSendDate").css("display", "none");
            }
            $.ajax({
                url: url,
                data: "type=dropdown2",
                success: function (msg) {
                    $('#txtPaymentTypeCode').combobox({
                        data: eval(msg)[0].item0,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                }
            });

            $("#btnSave").click(function () {
                $("#txtPaymentType").val($("#txtPaymentTypeCode").combobox("getText"));
                SaveRecord(url, namecode);
            });
            $("#btnSearch").click(function () {
                Search('txtSearch', namecode, 'paysearch');
            });

            //************改单****************
            $("#btnchange").click(function () {
                if ($("#gridPayment").datagrid("getSelections").length <= 0)
                { alert("请选择要修改的合同!"); return; }
                var SaleBill_Code = $("#gridPayment").datagrid("getSelections")[0].SaleBill_Code;
                var Code = $("#gridPayment").datagrid("getSelections")[0].Customer_Code;
                window.location.href = "../Products/Shop.aspx?type=product&code=" + Code + "&SaleBill_Code=" + SaleBill_Code;
            });
            //************end****************

            //************维修****************
            $("#btnfix").click(function () {
                if ($("#gridPayment").datagrid("getSelections").length <= 0)
                { alert("请选择要维修的合同列!"); return; }
                var SaleBill_Code = $("#gridPayment").datagrid("getSelections")[0].SaleBill_Code;
                $('#Fixgrid').datagrid({ "url": "Ajax.aspx?type=getstock&salebill_code=" + SaleBill_Code });
                $('#winFix').window('open');
            });
            $("#btnfixsave").click(function () {
                var row = $('#Fixgrid').datagrid("getRows");
                var txtvalue = "";
                for (var i = 0; i < row.length; i++) {
                    txtvalue += row[i].ID + "-" + $("select[id='txt_" + row[i].ID + "']").val() + ",";
                }
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?type=setfix",
                    data: "&value=" + txtvalue,
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            $("#gridPayment").datagrid("reload");
                            $('#winFix').window('close');
                            alert(msg);
                        }
                        else
                            alert(msg.split(':')[1]);
                    }
                });
            });
            //*************end***************

            //*************发货***************
            $("#btnshipments").click(function () {
                if ($("#gridPayment").datagrid("getSelections").length <= 0)
                { alert("请选择要发货的合同列!"); return; }
                var txtflag = $("#gridPayment").datagrid("getSelections")[0].StatusFlag;
                if (txtflag.toString() == "2") { alert("该单已经发货!"); return; }
                if (confirm("是否确认发货?")) {
                    $.ajax({
                        type: "post",
                        datatype: "json",
                        url: "Ajax.aspx?type=setflag",
                        data: "&id=" + $("#gridPayment").datagrid("getSelections")[0].ID,
                        success: function (msg) {
                            if (msg.indexOf("fail:") == -1) {
                                $("#gridPayment").datagrid("reload");
                                alert(msg);
                            }
                            else
                                alert(msg.split(':')[1]);
                        }
                    });
                }
            });
            //*************end***************

            //***************备货*********
            $("#btnstockup").click(function () {
                if ($("#gridPayment").datagrid("getSelections").length <= 0)
                { alert("请选择要备货的合同列!"); return; }
                var SaleBill_Code = $("#gridPayment").datagrid("getSelections")[0].SaleBill_Code;
                $('#Stockupgrid').datagrid({ "url": "Ajax.aspx?type=getstock&salebill_code=" + SaleBill_Code + "&getstock=1" });
                //                if ($('#Stockupgrid').datagrid("getRows") == 0)
                //                { alert("该单已经备货完毕!"); return; }
                $('#WinStockup').window('open');
            });
            $("#btn_stockup").click(function () {
                var row = $('#Stockupgrid').datagrid("getSelections");
                if (row.length == 0) { alert("请选择已备好的产品!"); return; }
                var txtproduct_code = "";
                for (var i = 0; i < row.length; i++)
                    txtproduct_code += "'" + row[i].Product_Code + "',";
                txtproduct_code = txtproduct_code.substring(0, txtproduct_code.length - 1);
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?type=setstock",
                    data: "&SaleBill_Code=" + row[0].SaleBill_Code + "&Product_Code=" + txtproduct_code,
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            $("#gridPayment").datagrid("reload");
                            $('#WinStockup').window('close');
                            alert(msg);
                        }
                        else
                            alert(msg.split(':')[1]);
                    }
                });
            });

            //**********end******************
            //***************设置交付提醒*********
            $("#btnSendDate").click(function () {
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?type=getSendDate",
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            var q = eval(msg);
                            if (q.length != 0) {
                                $("#txtSendDate1").numberbox("setValue", q[0].Cname);
                                $("#txtSendDate2").numberbox("setValue", q[1].Cname);
                            }
                            else {
                                $("#txtSendDate1").numberbox("setValue", "7");
                                $("#txtSendDate2").numberbox("setValue", "2");
                            }
                        }
                        else
                            alert(msg.split(':')[1]);
                        $('#winSendDate').window('open');
                    }
                });

            });
            $("#btnSendsave").click(function () {
                var txtSendDate1 = $("#txtSendDate1").numberbox("getValue");
                var txtSendDate2 = $("#txtSendDate2").numberbox("getValue");
                if (txtSendDate1 == "" || txtSendDate2 == "") { alert("不能为空!"); return; }
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?type=setSendDate",
                    data: "&SendDate1=" + txtSendDate1 + "&SendDate2=" + txtSendDate2,
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            $('#winSendDate').window('close');
                            alert(msg);
                        }
                        else
                            alert(msg.split(':')[1]);
                    }
                });
            });

            //**********end******************
            $("#btnAlertPay").click(function () {
                if ($("#gridPayment").datagrid("getSelections").length <= 0)
                { alert("请选择要催款的合同列!"); return; }
                var id = $("#gridPayment").datagrid("getSelections")[0].Customer_Code;
                var today = new Date();
                var date = AddDays(today, 7);
                var day = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?type=Alert&CustomerCode=" + id + "&flag=0",
                    data: $('#formAlert').serialize(),
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            $('#hidvalue').val("1");
                            $('#txtAlertDate').datebox('setValue', day);
                            $('#WinAlert').window('open');
                        }
                        else {
                            if (confirm(msg.split(':')[1])) {
                                $('#hidvalue').val("1");
                                $('#txtAlertDate').datebox('setValue', day);
                                $('#WinAlert').window('open');
                            }
                            else
                                $('#hidvalue').val("0");
                        }
                    }
                });

            });
            $("#btnAlert").click(function () {
                var CustomerCode = "";
                if ($("#gridPayment").datagrid("getSelections").length > 0) id = $("#gridPayment").datagrid("getSelections")[0].Customer_Code;

                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?type=" + $("#formAlert").attr("status") + "&CustomerCode=" + id + "&flag=1",
                    data: $('#formAlert').serialize(),
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            $("#gridPayment").datagrid("reload");
                            $('#WinAlert').window('close');
                            alert("保存成功!");
                        }
                        else
                            alert(msg.split(':')[1]);
                    }
                });
            });
            $("#btnPay").click(function () {
                if (selectcode != "") {
                    $("#txtPayMoney").val("") 
                    ShowEditWin(namecode, "pay");
                }
                else
                    alert("请选择要收款的合同");
            });
            $("#btnSupSave").click(function () {
                $("#gridPayment").datagrid({ url: "Ajax.aspx?type=paysearch&value=&" + $("#formSearch").serialize() });
                $('#winSearch').window('close');
            });
            $("#btnurl").click(function () {
                if ($("#txturl").text() == "") { alert("当前没有附件!"); return; }
                window.open($("#txturl").text());
            });
            $("#gridPayment").datagrid({ "onClickRow": function (rowIndex, rowData) {
                selectcode = $("#gridPayment").datagrid("getSelected")["SaleBill_Code"]; 
                $("#txtContractCode1").val($("#gridPayment").datagrid('getSelected')["SaleBill_Code"]);
                $("#txtContractCode").val($("#gridPayment").datagrid('getSelected')["Code"]);
                $("#txtContractPrice").val($("#gridPayment").datagrid('getSelected')["Price"]);
                $("#txtContractPay").val($("#gridPayment").datagrid('getSelected')["PayMoney"]);
                var txturl = $("#gridPayment").datagrid('getSelected')["ContractUrl"];
                if (txturl == null) txturl = "";
                $("#txturl").text(txturl);
                loadPayment(rowData["SaleBill_Code"], "Ajax.aspx");
                $('#Productgrid').datagrid({ "url": "Ajax.aspx?type=getstock&salebill_code=" + $("#gridPayment").datagrid('getSelected')["SaleBill_Code"] })
                                 .datagrid({ "rowStyler": function (index, row) {
                                     if (row.StatusFlag == "0") {
                                         return 'color:#79b900;';
                                     }
                                 }
                                 });
            }
            });
            //权限*************************************
            $.ajax({
                url: url,
                data: "type=Role&RoleCode=0112",
                success: function (msg) {
                    var txtmsg = msg.split(',');
                    for (var i = 0; i < txtmsg.length; i++) {
                        $("#" + txtmsg[i]).css("display", "none");
                    }
                }
            });
        });
        var Common = {
            TimeFormatter: function (value, rec, index) {
                if (value == undefined) {
                    return "";
                }
                /*json格式时间转js时间格式*/
                value = value.replace("T"," ").substr(2, value.length - 5);

                return value;
            },
            StatusFlagFormatter: function (value, rec, index) {
                if (value == undefined || value == "") value = "";
                else if (value == 1) value = "<span style='color:lightblue;font-weight:bolder'>正常</span>";
                else if (value == 2) {
                    value = "<span style='color:green;font-weight:bolder'>已发货</span>";
                }
                else
                    value = "<span style='color:red;font-weight:bolder'>坏账</span>";
                /*json格式时间转js时间格式*/

                return value;
            },
            PayMentFlagFormatter: function (value, rec, index) {
                if (value == undefined || value == "") value = "";
                else if (value == 1) value = "<span style='color:red;font-weight:bolder'>未付款</span>";
                else if (value == 2) {
                    value = "<span style='color:lightblue;font-weight:bolder'>部分付款</span>";
                }
                else
                    value = "<span style='color:green;font-weight:bolder'>全额付款</span>";

                /*json格式时间转js时间格式*/

                return value;
            },
            SendFlagFormatter: function (value, rec, index) {
                if (value == undefined || value == "" ) value = "";
                else if (value == 1) value = "<span style='color:red;font-weight:bolder'>未备货</span>";
                else if (value == 2) {
                    value = "<span style='color:lightblue;font-weight:bolder'>备货中</span>";
                }
                else
                    value = "<span style='color:green;font-weight:bolder'>已备货</span>";

                /*json格式时间转js时间格式*/

                return value;
            }
        };
         
        function formproductStatus(value, rowData, rowIndex) {
            var showvalue = "";
            if (value == '1') showvalue = '<span>未备货</span>';
            if (value == '0') showvalue = '<span>已备货</span>'; 
            return showvalue;
        }
        function formFixFlag(value, rowData, rowIndex) {
            var showvalue = ""; 
            if (value == undefined || value == "" || value == '1' || value == 'null' || value == null) showvalue = "<span style='color:lightblue;font-weight:bolder'>正常</span>";
            else if (value == '2') showvalue = "<span style='color:red;font-weight:bolder'>维修中</span>";
            else if (value == '3') showvalue = "<span style='color:green;font-weight:bolder'>完成</span>";
            
            return showvalue;
        }
        function setpaymentflag(obj) {
            var checked = $(obj).prop("checked");
            if (checked) {
                $("#txtPayMoney").val("");
                $("#txtPayMoney").attr("disabled", "disabled");
            }
            else {
                $("#txtPayMoney").val("");
                $("#txtPayMoney").removeAttr("disabled");
            }

         }
    </script>
</head>
<body class="easyui-layout">
    <form runat="server">
    <div region="north" style="height: 110px">
        <div class="metrouicss">
            <div class="page secondary">
                <div class="page-header">
                    <div class="page-header-content">
                        <h1>
                            合同<small>款项</small> &nbsp;<small><input id="txtSearch" type="text"  placeholder="请输入合同号、客户名、手机、业务员、协助人进行查询" /><input type="button" name="btnSearch" id="btnSearch"
                                class=" bg-color-grayLight fg-color-blackLight" value="查询" />
                            </small><small><input type="button" name="btnsupSearch" class="fg-color-blackLight bg-color-grayLight"
                                value="高级查询" onclick="$('#winSearch').window('open');" /></small>
                        </h1>
                        <a class="back-button big page-back"></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div region="center" split="true" title="合同收款【用于合同收款、查询合同款项的情况，设置催款提醒】 默认按照余额排序">
           <div  class="metrouicss" >
               <label class="button bg-color-blue fg-color-white" id="btnPay">收款</label>
               <label class="button bg-color-blue fg-color-white" id="btnAlertPay">催款提醒</label>
               <label class="button bg-color-blue fg-color-white" id="btnchange" style="display:none;">改单</label>
               <label class="button bg-color-blue fg-color-white" id="btnstockup"  style="display:none;">备货</label> 
               <label class="button bg-color-blue fg-color-white" id="btnfix"  style="display:none;">维修</label>  
               <label class="button bg-color-blue fg-color-white" id="btnshipments" style="display:none;">发货</label>
               <label class="button bg-color-blue fg-color-white" id="btnSendDate">设置交付提醒</label>
               </div>
        <table class="easyui-datagrid" id="gridPayment" style="width: 800px; " 
        data-options=" pageList:[15,50,100],rownumbers:true,pagination:true,singleSelect:true,
                     url:'Ajax.aspx?type=paymentlist&ProcessFlag='+request('ProcessFlag')+'&CreateTime='+request('CreateTime')+'&SendFlag='+request('SendFlag'), toolbar:toolbar,showFooter: true,
                     rowStyler: function(index,row){
                                if (row.colorflag == 0){
                                    return 'color:red;font-weight:bold;';
                                }
                                }"
                     sortName="LeftMoney" sortOrder="desc">
            <thead>
                <tr>
                    <th data-options="field:'ID',hidden:true,width:80">
                        代码
                    </th>
                    <th data-options="field:'StatusFlag', width:70,align:'center'"  formatter="Common.StatusFlagFormatter">
                        单据状态
                    </th>
                    <th data-options="field:'PayMentFlag', width:70,align:'center'" formatter="Common.PayMentFlagFormatter">
                        付款状态
                    </th>
                    <th data-options="field:'SendFlag', width:70,align:'center',hidden:true" formatter="Common.SendFlagFormatter">
                        备货状态
                    </th>
                     <th data-options="field:'Code', width:80">
                        合同号
                    </th>
                    <th data-options="field:'SaleBill_Code', width:80,hidden:true">
                        订单号
                    </th>
                    <th data-options="field:'ContractUrl', width:80,hidden:true">
                        附件
                    </th>
                    <th data-options="field:'Customer_Code',hidden:true,width:120">
                        客户号
                    </th>
                     <th data-options="field:'colorflag',hidden:true,width:120">
                        是否高亮表示
                    </th> 
                    <th data-options="field:'CustomerName',width:120">
                        客户名
                    </th> 
                    <th data-options="field:'UserName',width:120">
                        业务员
                    </th>  
                    <th data-options="field:'HelperName',width:120">
                        协助人
                    </th> 
                      <th data-options="field:'StylistName',width:120">
                        设计师
                    </th>  
                    <th data-options="field:'ContractDate',width:120" formatter="Common.TimeFormatter">
                        合同日期
                    </th> 
                    <th data-options="field:'Price',  width:100" sortable="true">
                        合同金额
                    </th> 
                     <th data-options="field:'PayMoney',  width:100" sortable="true">
                        已收款
                    </th>
                    <th data-options="field:'LeftMoney', width:100" sortable="true">
                        余款 
                    </th>
                     <th data-options="field:'ContractContent',  width:80">
                        合同备注
                    </th> 

                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
    <div region="east" style="width: 550px;" split="true">
        <div class="easyui-tabs" style="height:500px">
            <div title="收款记录" style="padding: 10px;">
               <div class="paymentdetail">
                <table class="easyui-datagrid" id="paydetailgrid" style="width: 500px" data-options=" pageList:[15,50,100],rownumbers:true,pagination:true,singleSelect:true, toolbar:toolbar">
            <thead>
                <tr>   
                     <th data-options="field:'PayType', width:80">
                        收款方式 
                    </th>
                       <th data-options="field:'Price',  width:80">
                        收款金额
                    </th> 
                      <th data-options="field:'PayDate', width:120 " formatter="Common.TimeFormatter">
                        收款日期
                    </th>
                     <th data-options="field:'Creater',  width:80">
                        经手人
                    </th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
               </div>
            </div> 
            <div title="订单详细" style="padding: 10px;">
             <table class="easyui-datagrid" id="Productgrid" style="width: 500px;" data-options=" rownumbers:true,singleSelect:true">
            <thead>
                <tr>   
                    <th data-options="field:'StatusFlag', width:80" formatter="formproductStatus">
                        状态
                    </th>
                    <th data-options="field:'FixFlag', width:80" formatter="formFixFlag">
                        维修状态
                    </th>
                    <th data-options="field:'Product_Code', width:80">
                        产品编号 
                    </th>
                    <th data-options="field:'ProductName',  width:80">
                        产品名称
                    </th> 
                     <th data-options="field:'Model',  width:80">
                        型号
                    </th>
                     <th data-options="field:'Format', width:80">
                        规格
                    </th> 
                     <th data-options="field:'DiscountPrice', width:80">
                        价格
                    </th>
                     <th data-options="field:'TotalCount',  width:80">
                        数量
                    </th>
                     <th data-options="field:'TotalAmount',  width:80">
                        总金额
                    </th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
            </div>
            <div title="附件下载" style="padding: 10px;">
                <label id="txturl"></label>
                <div  class="metrouicss" >
                <label class="button bg-color-blue fg-color-white" id="btnurl">点击下载</label>
                </div>
            </div>
        </div>
    </div> 
    </form>
    <div id="winPayment" class="easyui-window" data-options="title:'客户收款',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 350px; height: 400px;" >
        <form name="formPayment" id="formPayment" status="pay" >
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0;">
            <ul> 
                <li>
                        <label for="txtContractCode">
                        合同号:</label> 
                          <input type="hidden" name="Code" id="txtContractCode1" class="fieldItem" field="Code"   /> 
                        <input type="text" name="ContractCode" id="txtContractCode" class="fieldItem" field="ContractCode" disabled="disabled" /> 
                </li>
                <li>
                        <label for="txtContractPrice">
                        合同金额:</label>  
                        <input type="text" name="ContractPrice" id="txtContractPrice" class="fieldItem" field="ContractPrice" disabled="disabled" /> 
                </li>
                <li>
                    <label for="txtContractPay">
                        已收金额:</label>  
                        <input type="text" name="ContractPay" id="txtContractPay" class="fieldItem" field="ContractPay"  disabled="disabled" /> 
                </li>
                <li>
                    <label for="txtPaymentTypeCode">
                        收款类型:</label>  
                   <input type="hidden" id="txtPaymentType" name="PaymentType" class="fieldItem" field="PaymentType" /> 
                    <input type="combo" style="width:150px" name="PaymentTypeCode" id="txtPaymentTypeCode" class="easyui-combobox fieldItem"
                        field="PaymentTypeCode" />
                </li>
                <li>
                     <label for="txtPayMoney">
                        收款金额:</label>
                       <input type="text" name="PayMoney" id="txtPayMoney" class="fieldItem" field="PayMoney" />
                </li>
                 <li class="normalli" style="display:none" >
                        <label for="txtPayDate">
                            收款日期:</label>
                            <input   type="text" name="PayDate" id="txtPayDate" style="width:147px" field="PayDate" 
                                field="PayDate"  class="easyui-datebox fieldItem" required="required" />   
                 </li> 
                 <li>
                     <label for="paymentflag">
                        坏账:</label>
                       <input type="checkbox" name="paymentflag" onchange="setpaymentflag(this);" value="3" id="paymentflag" class="fieldItem"  />
                </li> 
            </ul>
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0;">
                <a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winPayment').window('close');">取消</a>
            </div>
        </div>
        </form>
    </div>
    <div id="WinAlert" class="easyui-window" data-options="title:'催款提醒',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 400px; height: 150px;" >
        <form name="formAlert" id="formAlert" status="Alert" >
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0;">
             <ul> 
                <li>
                        <label for="txtContractCode">
                        提醒时间:</label> 
                         <input type="text"  tabindex="52" name="AlertDate" id="txtAlertDate" style="width:147px"     field="AlertDate" 
                                field="AlertDate"  class="easyui-datebox fieldItem" required="required" />  
                           <select name="HM" id="txtHM"  tabindex="53" class="fieldItem hm" field="HM" ></select> 
                           <input type="hidden" name="hidvalue" id="hidvalue" /> 
                </li> 
            </ul>
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0;">
                <a class="easyui-linkbutton" id="btnAlert" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#WinAlert').window('close');">取消</a>
            </div>
        </div>
        </form>
    </div>
     <div id="winSearch" class="easyui-window" data-options="title:'高级查询',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 550px; height: 180px;"> 
        <form name="formSearch" id="formSearch">
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0;"> 
             <div class="easyui-panel" data-options="title:'时间查询'"> 
             <table style="text-align:right;">
                <tr  title="时间查询">
                    <td style="width:100px">开始时间:</td>
                    <td><input type="text" name="txtStartDate" id="txtStartDate" class="fieldItem easyui-datebox"  style="width:140px"   /> </td>
                    <td style="width:100px">结束时间:</td>
                    <td><input type="text" name="txtEndDate" id="txtEndDate" class="fieldItem easyui-datebox"  style="width:140px"   /> </td>
                </tr>
                <tr>
                    <td style="width:100px"><label for="txtStatusFlag">单据状态:</label></td>
                    <td style="text-align:left"><select class="easyui-combobox fieldItem" name="txtStatusFlag" data-options="panelHeight:'auto'"  id="txtStatusFlag" style="width:140px;">
                                                    <option value="1,3,4">全部</option>
		                                            <option value="1">正常</option> 
                                                    <option value="3">坏账</option>
                                                    <option value="4">已发货</option>
                                               </select>
                                                
                    <%--<input type="checkbox" name="ckflag" value="3" id="ckflag" class="fieldItem"/> --%>
                    </td>
                    <td style="width:100px"><label for="txtPayMentFlag">付款状态:</label></td>
                    <td style="text-align:left"><select class="easyui-combobox fieldItem" name="txtPayMentFlag"   data-options="panelHeight:'auto'"  id="txtPayMentFlag" style="width:140px;">
                                                    <option value="1,2,3">全部</option>
		                                            <option value="1">未付款</option>
                                                    <option value="2">部分付款</option> 
                                                    <option value="3">全额付款</option> 
                                               </select>
                                                
                    <%--<input type="checkbox" name="ckflag" value="3" id="ckflag" class="fieldItem"/> --%>
                    </td>
                </tr>
                <tr>
                <td style="width:100px"><label for="txtSendFlag">备货状态:</label></td>
                    <td style="text-align:left"><select class="easyui-combobox fieldItem" name="txtSendFlag"   data-options="panelHeight:'auto'"  id="txtSendFlag" style="width:140px;">
                                                    <option value="1,2,3">全部</option>
		                                            <option value="1">未备货</option>
                                                    <option value="2">备货中</option> 
                                                    <option value="3">已备货</option> 
                                               </select>
                                                
                    <%--<input type="checkbox" name="ckflag" value="3" id="ckflag" class="fieldItem"/> --%>
                    </td>
                </tr>
                </table>
                </div> 
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0;">
                <a class="easyui-linkbutton" id="btnSupSave" data-options="iconCls:'icon-save'">确定</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winSearch').window('close');">取消</a>
            </div>
        </div>
        </form>
    </div>
    <div id="WinStockup" class="easyui-window" data-options="title:'备货',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 710px; height: 410px;" >
        <form name="formStockup" id="formStockup" status="Stockup" >
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 5px 0;">
              <table class="easyui-datagrid" id="Stockupgrid" style="width: 680px;height:320px; margin-left:10px;" data-options=" rownumbers:true,singleSelect:false">
            <thead>
                <tr>   
                    <th data-options="field:'ck',checkbox:true"></th>
                     <th data-options="field:'SaleBill_Code',  width:80">
                        订单号
                    </th> 
                     <th data-options="field:'Product_Code', width:80">
                        产品编号 
                    </th>
                    <th data-options="field:'ProductName',  width:80">
                        产品名称
                    </th> 
                     <th data-options="field:'Model',  width:80">
                        型号
                    </th>
                     <th data-options="field:'Format', width:80">
                        规格
                    </th> 
                     <th data-options="field:'DiscountPrice', width:80">
                        价格
                    </th>
                     <th data-options="field:'TotalCount',  width:80">
                        数量
                    </th>
                     <th data-options="field:'TotalAmount',  width:80">
                        总金额
                    </th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0;">
                <a class="easyui-linkbutton" id="btn_stockup" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#WinStockup').window('close');">取消</a>
            </div>
        </div>
        </form>
    </div>
    <div id="winFix" class="easyui-window" data-options="title:'维修',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 710px; height: 410px;" >
        <form name="formFix" id="formFix" status="Fix" >
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 5px 0;">
              <table class="easyui-datagrid" id="Fixgrid" style="width: 680px;height:320px; margin-left:10px;" data-options=" rownumbers:true,singleSelect:false">
            <thead>
                <tr>    
                    <th data-options="field:'FixFlag',  width:80,formatter: function(value,row,index){var txts=new Array();txts[0]='';for(var i=1;i<4;i++){if(value==i.toString())txts[i]='selected=\'selected\'';else txts[i]='';} return '<select id=\'txt_'+row.ID+'\' class=\'easyui-combobox\' ><option '+txts[1]+' value=\'1\'>正常</option><option '+txts[2]+' value=\'2\'>维修</option><option '+txts[3]+' value=\'3\'>完成</option></select>';}">
                        维修状态
                    </th> 
                    <th data-options="field:'ID',hidden:true ,width:80">
                        ID
                    </th> 
                    <th data-options="field:'SaleBill_Code',  width:80">
                        订单号
                    </th> 
                     <th data-options="field:'Product_Code', width:80">
                        产品编号 
                    </th>
                    <th data-options="field:'ProductName',  width:80">
                        产品名称
                    </th> 
                     <th data-options="field:'Model',  width:80">
                        型号
                    </th>
                     <th data-options="field:'Format', width:80">
                        规格
                    </th> 
                     <th data-options="field:'DiscountPrice', width:80">
                        价格
                    </th>
                     <th data-options="field:'TotalCount',  width:80">
                        数量
                    </th>
                     <th data-options="field:'TotalAmount',  width:80">
                        总金额
                    </th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0;">
                <a class="easyui-linkbutton" id="btnfixsave" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winFix').window('close');">取消</a>
            </div>
        </div>
        </form>
    </div>
    <div id="winSendDate" class="easyui-window" data-options="title:'设置交付提醒',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 430px; height: 200px;" >
        <form name="formSendDate" id="formSendDate" status="SendDate" >
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 5px 0;">
                <ul> 
                <li>
                        <label for="txtSendDate1">
                        备货提醒天数:</label> 
                        <input class="easyui-numberbox" id="txtSendDate1" name="txtSendDate1" />
                            
                </li> 
                <li>
                        <label for="txtSendDate2">
                        发货提醒天数:</label> 
                        <input class="easyui-numberbox" id="txtSendDate2" name="txtSendDate2" />
                            
                </li> 
            </ul>
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0;">
                <a class="easyui-linkbutton" id="btnSendsave" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winSendDate').window('close');">取消</a>
            </div>
        </div>
        </form>
    </div>
</body>
</html>
