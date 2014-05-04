<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewContract.aspx.cs" Inherits="AppBox.View.Visit.NewContract" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        li
        {
            float: left;
            padding: 5px;
        }
        li.normalli
        {
            text-align: right;
            width: 40%;
            padding-top: 5px;
            padding-bottom: 5px;
        }
        li.allli
        {
            text-align: right;
            width: 80%;
            padding-top: 5px;
            margin-left: 10px;
            padding-bottom: 5px;
        }
        li.comboli
        {
            text-align: right;
            width: 40%;
            padding-top: 9px;
            padding-bottom: 9px;
        }
        label, input
        {
            font-size: 20px;
        }
    </style>
    <script src="../../common/js/Common.js" type="text/javascript"></script>
    <script src="../../metro/javascript/rating.js" type="text/javascript"></script>
    <link href="../MutiUpload/uploadify.css" rel="stylesheet" type="text/css" />
    <script src="../MutiUpload/jquery.uploadify.js" type="text/javascript"></script> 
    <script src="../MutiUpload/swfobject.js" type="text/javascript"></script> 
  
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Contract";
        var obj;
        function uploadFiles() {
            $('#File1').uploadifyUpload();
            //            var a = document.getElementById("fileQueue").innerText;
            //            var ty = document.getElementById("hidJian").value;
            //            if (a == "") {
            //                alert("请选择要上传的声音文件！");
            //            }
            //            else {
            //                PageMethods.GetSound(a, ty);
            //            }
        }
        function onready() { obj = window.dialogArguments; }
        $().ready(function () {
            FnUpload($("#File1"), "Contract");
            $("#txtPrice").numberbox('setValue', request("billAmount"));
            $("#txtPayMoney").numberbox('setValue', request("billAmount"));
            if (request("processflag") == "1") {
                $("#lbPrice").text("预约合同总价");
            }
            else {
                $("#txtPayMoney").attr("disabled", "disabled");

                $("#lbPrice").text("合同总价");
            }
            if (request("SaleBill_Code") != "") {
                var SaleBill_Code = request("SaleBill_Code");
                $("#ckli").css("display","none");
                $.ajax({
                    url: 'Ajax.aspx',
                    data: "type=getsalebill&SaleBill_Code=" + SaleBill_Code + "&code=" + request("code"),
                    success: function (result) {
                        var txtsplit = result.split('|');
                        $("#txtContractCode").val(txtsplit[0]);
                        //$("#txtVisitTypeCode").combobox("setValue", txtsplit[1]);
                        $("#txtSendDate").datebox("setValue", txtsplit[2]);
                        $("#txtNextVisitDate").datebox("setValue", txtsplit[3]);
                        $("#txtHM").val(txtsplit[4]);
                        $("#txtNextVisitContent").val(txtsplit[5]);
                        $("#txtContractContent").val(txtsplit[6]);
                        $("#fileNameList").val(txtsplit[7]);
                        $("#txtPrice").numberbox('setValue', txtsplit[11]);
                        $("#txtPayMoney").numberbox('setValue', txtsplit[10]);
                        $.ajax({
                            url: url,
                            data: "type=dropdown",
                            success: function (msg) {
                                $('#txtStylist').combobox({
                                    data: eval(msg)[3].item3,
                                    valueField: 'Code',
                                    textField: 'Cname',
                                    onLoadSuccess: function () {
                                        $("#txtStylist").combobox("setValue", txtsplit[9]);
                                    }
                                });
                                $('#txtHelper').combobox({
                                    data: eval(msg)[4].item4,
                                    valueField: 'Code',
                                    textField: 'Cname',
                                    onLoadSuccess: function () {
                                        $("#txtHelper").combobox("setValue", txtsplit[8]);
                                    }
                                });

                            }
                        });
                    }
                });
            }
            onready();

            $("#btnSave").click(function () { 
                var str = JSON.stringify(obj, null, '\t') == undefined ? "" : JSON.stringify(obj, null, '\t');
                                if (setValidate($("#formContract"))) {
                                    $.ajax({
                                        url: '../Products/ProductProvide.aspx',
                                        data: 'query=' + str + '&type=bill&billAmount=' + request('billAmount') + '&totalAmount=' + $("#txtPayMoney").val()
                                              + '&totalCount=' + request("totalCount") + '&SaleBill_Code=' + request('SaleBill_Code') + '&customercode=' + request("code") + '&ContractCode=' + $("#txtContractCode").val(),
                                        success: function (result) {
                                            //$("#txtVisitType").val($("#txtVisitTypeCode").combobox("getText"));
                                            //$("#txtCustomerLevel").val("4");
                                            $.ajax({
                                                url: url,
                                                data: "type=contract&code=" + request("code") + "&SaleBill_Code=" + request("SaleBill_Code") + "&salebill=" + result + "&id=" + request("id") + "&" + $("#formContract").serialize(),
                                                success: function (msg) {
                                                    if (msg.indexOf("fail:") == -1) {
                                                        if (request("SaleBill_Code") != "null" & request("SaleBill_Code") != "")
                                                            alert("保存成功");
                                                        else
                                                            alert("保存成功，该客户已转为售中客户！");
                                                        window.returnValue = "true";
                                                        setvalue();
                                                    }
                                                    else
                                                        alert(msg.split(':')[1]);
                                                },
                                                error: function (msg) {
                                                    alert("保存失败");
                                                }
                                            });

                                            //setvalue();
                                        }
                                    });

                 }
            })

            LoadData(url, request("code"));
            //$("#txtNextVisitDate").datebox("setValue", decodeURI(request("nextdate")));
            //$("#txtNextVisitContent").val(decodeURI(request("visitcontent")));
            $("#txtContractContent").val(decodeURI(request("content")));
            appendHM(30);
        })
    </script>
</head>
<body> 
    <div data-options="region:'north',border:false" style="padding: 10px 0 0; height: 450px"
        class="formItem"> 
        <div class="easyui-tabs">
            <div title="本次回访" style="padding: 10px">
                <form id="formContract" status="contract">
                <ul>
                    <li class="normalli">
                        <label for="txtCode">
                            客户姓名:</label>
                        <input type="hidden" name="Cname" id="txtCname1" class="fieldItem" field="Cname" />
                        <input type="text" name="Cname" id="txtCname" disabled="disabled" class="fieldItem"
                            field="Cname" readonly="true" /></li>
                    <li class="normalli">
                        <label for="txtMobile">
                            手机号:</label>
                        <input type="hidden" name="Mobile" id="txtMobile1" class="fieldItem" field="Mobile" />
                        <input type="text" name="Mobile" id="txtMobile" disabled="disabled" class="fieldItem"
                            field="Mobile" /></li>
                    <li class="allli" >
                        <label for="txtTel">
                            地址:</label>
                        <input type="hidden" name="Address" id="txtAddress1" class="fieldItem" field="Address" />
                        <input type="text" style="width: 71%;" name="Address" id="txtAddress" disabled="disabled" class="fieldItem"
                            field="Address" /></li>  
                   <%-- <li class="comboli">
                        <label for="txtContactType">
                            沟通方式:</label>
                        <input type="hidden" id="txtVisitType" name="VisitType" class="fieldItem" field="VisitType" />
                        <input type="combo" style="width:213px;" id="txtVisitTypeCode" name="VisitTypeCode" class="easyui-combobox fieldItem"
                            field="VisitTypeCode" />
                    </li>  --%>
                    <%--<li class="comboli">
                        <label for="txtContactType">
                            产品信息:</label>  
                            <a class="easyui-linkbutton"  id="btn_product" data-options="iconCls:'icon-edit'" onclick="productclick()">产品信息</a>  
                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    </li>--%>  
                     <%--<li class="comboli">
                        <label for="txtNextVisitTime"   >
                            下次提醒时间:</label>
                            <input type="text" name="NextVisitDate" id="txtNextVisitDate" class="fieldItem easyui-datebox" required="true"    style="width:140px"    field="NextVisitDate" /> 
                           <select name="HM" id="txtHM"   class="fieldItem hm"   style="font-size:16px"   field="HM" ></select>  
                     </li>--%>
                     <li class="comboli">
                        <label for="txtNextVisitTime"   >
                            <%--交付日期:--%>
                            设计师:
                            </label>
                            <input type="combo" style="width:213px;" id="txtStylist" name="stylist" class="easyui-combobox fieldItem"
                            field="Stylist" />
                           <%-- <input type="text" name="SendDate" id="txtSendDate" class="fieldItem easyui-datebox"    style="width:213px"    field="SendDate" />  --%>
                     </li>
                     <%--<li class="normalli" style="height:44px;">
                        <label for="txtNextVisitContent"   >
                            联系计划: </label><input name="NextVisitContent" id="txtNextVisitContent"  class="easyui-validatebox fieldItem" field="VisitContent"    required="true"     /> 
                    </li>--%>
                     <li class="normalli" style="height:44px">
                        <label for="txtVisitTitle">
                            协助人:</label>  
                            <input type="combo" style="width:213px;" id="txtHelper" name="helper" class="easyui-combobox fieldItem"
                            field="Helper" />
                        <%--<input type="text"  name="helper" id="txthelper" class="fieldItem" field="Helper"  />--%>
                    </li>
                    <li class="normalli" id="ckli">
                        <input type="checkbox" class="fieldItem" name="ckpay"  id="ckpay" />支付全款
                        <input type="checkbox" class="fieldItem" name="ckdeal"  id="ckdeal" />转为售后
                    </li>
                    <li class="normalli">
                        <label for="txtVisitTitle">
                            合同号:</label>  
                        <input type="text"  name="ContractCode" id="txtContractCode" class="fieldItem" field="ContractCode" />
                    </li>
                       <li class="normalli">
                        <label id="lbPrice" for="txtPrice">
                            合同总价:</label> 
                        <input type="hidden" name="VisitTitle" id="txtVisitTitle" class="fieldItem" value="签订合同"  field="VisitTitle" />
                        <input type="text"  data-options="precision:2" class="easyui-numberbox easyui-validatebox fieldItem"  name="Price" id="txtPrice"  field="Price" value="0.00" />
                    </li>
                      <li class="normalli">
                        <label for="txtPayMoney">
                            定金:</label>  
                        <input type="text" data-options="precision:2" class="easyui-numberbox fieldItem"  name="PayMoney" id="txtPayMoney"  field="PayMoney" value="0.00" />
                    </li>
                    <li class="allli">
                        <label for="txtContractContent" style="margin-right: 10px;">
                            合同备注:</label><textarea name="ContractContent" id="txtContractContent" style="width: 71%;"
                                rows="5" class="fieldItem" field="ContractContent"></textarea>
                    </li>
                    <li class="allli">
                        <label for="txtContractUrl" style="margin-right: 10px; width: 280px; float: left">
                            合同附件:</label>
                            <div style="width: 71%; float: left; text-align: left;" class="metrouicss">
                                    <input type="file" name="File1" id="File1" style="float: left" />
                                      <div id="fileQueue" >
                                      </div>
                                      <input type="hidden" name="fileNameList" id="fileNameList"  />
                            </div>
                    </li>
                     
                </ul>
                </form>
            </div>
            <%--<div title="其他信息" style="padding: 10px">
                <ul class="customerdefine" id="customerDefine" runat="server">
                </ul>
            </div>--%>
        </div>
        <script>
            function setvalue() {
                window.location.href = '../../TilePanel.aspx?on=' + request('on');
                //window.history.go(-1);
                    //this.close();

                }
            </script>
        <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;"
            class="formItem">
            <a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存合同</a> 
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="setvalue()">返回</a>
                <%--history.go(-1)--%>
        </div>
    </div>  
</body>
</html>
