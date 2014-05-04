<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportEdit.aspx.cs" Inherits="AppBox.View.ReportSetting.ReportEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../metro/css/modern.css" rel="stylesheet" type="text/css" /> 
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
            height: 40px;
            padding-top: 5px;
            padding-bottom: 5px;
        }
        li.comboli
        {
            text-align: right;
            width: 40%;
            height: 40px;
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
        var namecode = "Report";
        $(function () { 
            $.ajax({
                url: url,
                data: "type=dropdown",
                success: function (msg) {
                    $('#txtTableCode').combobox({
                        data: eval(msg)[0].item0,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtOptCode').combobox({
                        data: eval("[{Code:'Group',Cname:'按分组'},{Code:'Count',Cname:'记录数'},{Code:'Sum',Cname:'合计数量'}]"),
                        valueField: 'Code',
                        textField: 'Cname'
                    }); 
                    LoadData(url, request["code"]);
                }
            });

            $("#btnSave").click(function () {  
                SaveData(url, namecode, request("code"),"");
            }); 
        })
    </script>
</head>
<body>
    <div class="metrouicss">
        <div class="page secondary">
            <div class="page-header">
                <div class="page-header-content">
                    <h1>
                        报表<small>设计</small></h1>
                    <a class="back-button big page-back"></a>
                </div>
            </div>
        </div>
    </div>
    <div data-options="region:'north',border:false" style="padding: 10px 0 0; height: 450px"
        class="formItem">
        <form id="formReport" status="add"> 
            <div title="报表设计" style="padding: 10px">
                <ul>
                    <li class="normalli">
                        <label for="txtCname">
                            选择数据来源:</label> <input type="hidden" id="txtTableName" name="TableName" class="fieldItem" field="TableName" />
                        <input type="combo" id="txtTableCode" name="TableCode" class="easyui-combobox fieldItem"
                            field="TableCode" /></li>
                    
                </ul>
            </div> 
        </form>
        <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;"
            class="formItem">
            <a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="javascript: $('#winReport').window('close');">关闭</a>
        </div>
    </div>
</body>
</html>
