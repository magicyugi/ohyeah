<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerConnect.aspx.cs"
    Inherits="AppBox.View.Customers.CustomerConnect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../metro/css/modern.css" rel="stylesheet" type="text/css" />
    <script src="../../common/js/Common.js" type="text/javascript"></script>
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
            margin-left:10px;
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
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Customer";
        $().ready(function () {
            $.ajax({
                url: url,
                data: "type=dropdown",
                success: function (msg) { 
                    $('#txtVisitType').combobox({
                        data: eval(msg)[0].item0,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtVisitProcess').combobox({
                        data: eval(msg)[1].item1,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                }
            });
            $("#btnSave").click(function () {
                SaveRecord(url, namecode);
            })
        })
        </script>
</head>
<body>
    <div class="metrouicss">
        <div class="page secondary">
            <div class="page-header">
                <div class="page-header-content">
                    <h1>
                        新增<small>回访记录</small></h1>
                    <a class="back-button big page-back"></a>
                </div>
            </div>
        </div>
    </div>
    <div data-options="region:'north',border:false" style="padding: 10px 0 0; height: 450px"
        class="formItem">
        <div class="easyui-tabs">
            <div title="客户回访表" style="padding: 10px">
                <ul>
                    <li class="normalli">
                        <label for="txtCode">
                            客户姓名:</label><input type="text" name="Code" id="txtCode" disabled="disabled" class="fieldItem"
                                field="Code" readonly="true" /></li>
                    <li class="normalli">
                        <label for="txtMobile">
                            手机号:</label><input type="text" name="Mobile" id="txtMobile" disabled="disabled" class="fieldItem"
                                field="Mobile" /></li>
                    <li class="normalli">
                        <label for="txtTel">
                            地址:</label><input type="text" name="Address" id="txtAddress" disabled="disabled"
                                class="fieldItem" field="Address" /></li>
                    <li class="comboli">
                        <label for="txtVisitProcess">
                            当前进度:</label>
                        <input type="text" id="txtVisitProcess" name="VisitProcess" class="easyui-combobox fieldItem"
                            field="VisitProcess" />
                    </li>
                    <li class="comboli">
                        <label for="txtContactType">
                            沟通方式:</label>
                        <input type="text" id="txtVisitType" name="VisitType" class="easyui-combobox fieldItem"
                            field="VisitType" />
                    </li>
                    <li class="normalli">
                        <label for="txtVisitTitle">
                            主题:</label><input type="text" name="VisitTitle" id="txtVisitTitle" class="fieldItem"
                                field="VisitTitle" />
                          </li>
                    <li class="allli">
                        <label for="txtVisitContent" style="margin-right:10px;" >
                            内容:</label><textarea name="VisitContent" id="txtVisitContent" style="width:71%;"  rows="8" class="fieldItem" field="VisitContent"  ></textarea>
                       </li>
                </ul>
            </div>
            <%--<div title="其他信息" style="padding: 10px">
                <ul class="customerdefine" id="customerDefine" runat="server">
                </ul>
            </div>--%>
        </div>
        <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;"
            class="formItem">
            <a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="javascript: $('#winCustomer').window('close');">关闭</a>
        </div>
    </div>
</body>
</html>
