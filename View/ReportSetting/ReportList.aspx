<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportList.aspx.cs" Inherits="AppBox.View.ReportSetting.ReportList" %>

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
    </style>
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Report";
        $().ready(function () { 
            
//            $("#gridReport").datagrid({ "onClickRow": function (rowIndex, rowData) {
//                loadHistory(rowData["Code"],"../Visit/Ajax.aspx");
//            }
//            });
        })
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
                            报表<small>查询</small> &nbsp;<small><input id="txtSearch" /><input type="button" name="btnSearch"
                                class=" bg-color-blue fg-color-white" value="查询" />
                            </small>
                        </h1>
                        <a class="back-button big page-back"></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div region="center" split="true" title="报表列表">
        <table class="easyui-datagrid" id="gridReport" style="width: 800px" data-options=" pageList:[15,50,100],rownumbers:true,pagination:true,singleSelect:true,url:'Ajax.aspx?type=list', toolbar:toolbar">
            <thead>
                <tr>
                    <th data-options="field:'Id',hidden:true,width:80">
                        序列
                    </th>
                    <th data-options="field:'Code',width:80">
                        编号
                    </th>
                    <th data-options="field:'Cname',width:120">
                        名称
                    </th> 
                    <th data-options="field:'TableName',width:80">
                        表名
                    </th>
                     <th data-options="field:'ColCount',width:80">
                        字段数
                    </th> 
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div> 
    <script type="text/javascript">
        var toolbar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function () {
                ShowEditWin(namecode, "add");
            }
        }, '-', {
            text: '编辑',
            iconCls: 'icon-edit',
            handler: function () { 
                window.location.href = "ReportEdit.aspx?code=" + $("#gridReport").datagrid("getSelections")[0].Code;
            }
        }, '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function () {
                DelRecord(url, namecode);
            }
        }];

            
    </script>
    </form> 
</body>
</html>
