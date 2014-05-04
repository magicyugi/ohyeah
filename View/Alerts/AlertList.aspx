<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AlertList.aspx.cs" Inherits="AppBox.View.Alerts.AlertList" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head runat="server">
<meta http-equiv="Expires" CONTENT="0">
<meta http-equiv="Cache-Control" CONTENT="no-cache">
<meta http-equiv="Pragma" CONTENT="no-cache">
    <script src="../../metro/javascript/jquery.mousewheel.min.js" type="text/javascript"></script>
    <link href="../../common/history/css/history.css" rel="stylesheet" type="text/css" />
    <script src="../../common/history/js/history.js" type="text/javascript"></script> 
    <script src="../SysCodeManage/datagrid-groupview.js" type="text/javascript"></script>
    <title>提醒列表</title>
    <style> 
     li.normalli
        {
            text-align: right;
            width: 70%;
            height: 30px;
            padding-top: 5px; 
            padding-bottom: 5px;
        }  
        .metrouicss .listview li
        {
            width: 600px;
        }
        .datagrid-group{background-color:lightgray;}
    </style>
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var listid = "#lvAlert";
        var rows = 30; 
        $(function () {
            LoadAlertListView(url, listid, rows, "today", 1);
            $("button.alertdate").click(function () {
                $("#alerth1").text($(this).text());
                LoadAlertListView(url, listid, rows, $(this).attr("daytype"), 1);
            })
            $("#btnlasts").click(function () { 
                if ($("#hdncategory").val() != "") {
                    $('#LeveGrid').datagrid({
                        url: '../Visit/Ajax.aspx?type=PGrid&code=' + $("#hdncategory").val() + '&txtcategory='
                    });
                }
            });
            $("#btnmiddles").click(function () {
                if ($("#hdncategory").val() != "") {
                    $('#LeveGrid').datagrid({
                        url: '../Visit/Ajax.aspx?type=PGrid&code=' + $("#hdncategory").val() + '&txtcategory=1'
                    });
                }
            });
            $("#btnfinallys").click(function () {
                if ($("#hdncategory").val() != "") {
                    $('#LeveGrid').datagrid({
                        url: '../Visit/Ajax.aspx?type=PGrid&code=' + $("#hdncategory").val() + '&txtcategory=2'
                    });
                }
            });
            $(".page-back").click(function () { window.location.href = '../../TilePanel.aspx' + '?on=' + request('on'); });
        });
        function getpage(page) {
            var sumpage = $("#spage").text();
            if (page > sumpage) { alert("当前已经是最后一页!"); return; }
            if (page < 1) { alert("当前已经是首页!"); return; }
            var daytype = "";
            if ($("#alerth1").text() == "今日提醒") daytype = "today"
            if ($("#alerth1").text() == "本周提醒") daytype = "week"
            if ($("#alerth1").text() == "过期提醒") daytype = "expire"
            LoadAlertListView(url, listid, rows, daytype, page);

        }
        var Common = { 
            BoolFormatter: function (value, rec, index) {
                if (value == undefined || value == "") value = "<span style='color:red;font-weight:bolder'>×</span>";
                else
                    value = "<span style='color:green;font-weight:bolder'>√</span>";

                /*json格式时间转js时间格式*/

                return value;
            }

        };
    </script>
</head>
<body  >  
    <div region="north"   style="height: 110px">   
        <div class="metrouicss">
        <div class="page secondary">
            <div class="page-header">
                <div class="page-header-content">
                    <h1>
                        <text id="alerth1">今日提醒</text>
                        <small>列表</small><small>
                            <button daytype="today" class="alertdate button bg-color-blueDark fg-color-white">
                            今日提醒</button>
                            <button daytype="week" class="alertdate button bg-color-blueLight fg-color-blue border-color-blue   ">
                                本周提醒</button>
                            <button daytype="expire" class="alertdate button bg-color-gray fg-color-white">
                                    过期提醒</button></small></h1>
                    <a class="back-button big page-back"></a>
                </div>
            </div>
        </div>
        </div>
   </div>
    <div region="center" split="true" title="" style="width:600px;float:left;"> 
              <div class="metrouicss">
                <div class="span10" >
                    <ul class="listview" id="lvAlert">
                    </ul>
                </div> 
                </div>
                </div>
     <div region="east" style="width: 550px;float:left;" split="true" >
     <div class="easyui-tabs" style="height:500px;margin-left:50px"> 

           <div title="工作进度" style="padding: 10px"> 
               <div class="metrouicss"> 
                   <label class="button bg-color-blue fg-color-white" id="btnlasts">售前</label>
                   <label class="button bg-color-blue fg-color-white" id="btnmiddles">售中</label>
                   <label class="button bg-color-blue fg-color-white" id="btnfinallys">售后</label> 
               </div>
               <input type="hidden" id="hdncategory" />
                 <table class="easyui-datagrid" id="LeveGrid" style="width: 500px;height:400px;" 
                         data-options=" rownumbers:true,singleSelect:true,
                    method:'get',view:groupview,groupField:'Pname',
                    groupFormatter:function(value,rows){
                    return '<a style=color:gray>'+value +'</a>';}" >
            <thead>
                <tr>
                    <th data-options="field:'ID',hidden:true,width:80">
                        代码
                    </th> 
                    <th data-options="field:'LevelName',width:120,hidden:true">
                        步骤名
                    </th>
                     <th data-options="field:'clCode',width:40"  formatter="Common.BoolFormatter">
                        状态
                    </th>
                    <th data-options="field:'Cname',width:120" >
                        级别名
                    </th>
                    <th data-options="field:'CreateDate',width:150" >
                        开始时间
                    </th>
                    <th data-options="field:'Category',hidden:true,width:80">
                        Category
                    </th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
            </div> 
            <div title="回访记录" style="padding: 10px; "  > 
               <div class="history"></div>
            </div> 
            <div title="客户档案" style="padding: 10px">  
                  <ul>
                    <li  class='normalli'> <label for='txtAddress'  >地址:</label><input type='text' name='Address' id='txtAddress' class='fieldItem' field='Address'  disabled='disabled'    /></li> 
                    <li  class='normalli'> <label for='txtCustomerLevel'  >客户评级:</label><input type='text' name='CustomerLevelCname' id='txtCustomerLevel' class='fieldItem' field='CustomerLevelCname'   disabled='disabled'   /></li>
                    <li  class='normalli'> <label for='txtClientSource'  >客户来源:</label><input type='text' name='ClientSource' id='txtClientSource' class='fieldItem' field='ClientSource'   disabled='disabled'   /></li>
                    <li  class='normalli checkvisible'> <label for='txtIntroduceName'  >介绍人:</label><input type='text' name='IntroduceName' id='txtIntroduceName' class='fieldItem' field='IntroduceName'   disabled='disabled'   /></li>
                    <li  class='normalli checkvisible'> <label for='txtIntroduceMobile'  >介绍人电话:</label><input type='text' name='IntroduceMobile' id='txtIntroduceMobile' class='fieldItem' field='IntroduceMobile'   disabled='disabled'   /></li>
                  </ul> 
            </div>
            <div title="基础信息" style="padding: 10px">
                <ul class="customerdefine" id="customerDefine"   runat="server">
                </ul>
            </div>
        </div> 
  </div> 
    
</body>
</html>
