<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewVisit1.aspx.cs"
    Inherits="AppBox.View.Visit.NewVisit1" %>
   <%-- **********************售中******************************--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../SysCodeManage/datagrid-groupview.js" type="text/javascript"></script>
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
            margin-left:10px;
            padding-bottom: 5px;
        }
          li.tableli
        {
            text-align: left;
            width: 50%; 
            margin-left:240px; 
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
         #topLoader {
        width: 200px;
        height: 200px;
        margin-bottom: 32px;
      }
     .datagrid-group{background-color:lightgray;}
    </style>
    <script src="../../common/js/Common.js" type="text/javascript"></script> 
    <script src="../../metro/javascript/rating.js" type="text/javascript"></script>
    <script src="src/jquery.percentageloader-0.1.js" charset="gbk"></script>
    <link rel="stylesheet" href="src/jquery.percentageloader-0.1.css"></script> 
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Visit";
        var g5value = 0;
        var g5;
        var $topLoader;
        $().ready(function () {
            $topLoader = $("#topLoader").percentageLoader({ width: 200, height: 200, progress: 0, onProgressUpdate: function (val) {

            }
            });
            $.ajax({
                url: url,
                data: "type=dropdown",
                success: function (msg) {
                    $('#txtVisitTypeCode').combobox({
                        data: eval(msg)[0].item0,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtCustomerLevel').combobox({
                        data: eval(msg)[2].item2,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                }
            });

            $("#btnSave").click(function () {
                if ($("#txtScore").val() == "0") { alert("请选择完成的工作进度!"); return; }
                if (setValidate($("#formVisit"))) {
                    $("#txtVisitType").val($("#txtVisitTypeCode").combobox("getText"));
                    SaveData(url, namecode, request("code"), "../Alerts/AlertList.aspx");
                }
            });

            $("#btnDrop").click(function () {
                $("#winReason").window("open");
            })
            $("#btnSubmit").click(function () {
                if (setValidate($("#formReason"))) {
                    SaveData("Ajax.aspx", "Visit,reason", request("code") + "&reason=" + $("#txtReason").val(), "../Alerts/AlertList.aspx");
                }
            })
            $("#btnDeal").click(function () {
                window.location.href = "NewContract.aspx?code=" + request("code") + "&id=" + request("id");
                //ShowEditWin(namecode, "reason");
            }); 
            LoadData(url, request("code"));
            appendHM(30); 
            
        })
        var topLoaderRunning = false;
        function getScore(oldvalue, newvalue) {
            //g5.refresh(txtscore);
            if (topLoaderRunning) {
                return;
            }
            topLoaderRunning = true;
            $topLoader.setProgress(0);
            $topLoader.setValue('');
            var kb = oldvalue;
            var total = 100;
            var animateFunc = function () {
                if (kb < newvalue) {
                    kb += 1;
                    $topLoader.setProgress(kb / total);
                    //$topLoader.setValue(kb.toString() + '分'); 
                    if (kb < total) {
                        setTimeout(animateFunc, 10);
                    } else {
                        topLoaderRunning = false;
                    }

                }
                else if (kb > newvalue) {
                    kb -= 1;
                    $topLoader.setProgress(kb / total);
                    //$topLoader.setValue(kb.toString() + '分'); 
                    if (kb < total) {
                        setTimeout(animateFunc, 10);
                    } else {
                        topLoaderRunning = false;
                    }
                }
                else topLoaderRunning = false;

            }

            setTimeout(animateFunc, 10);
        }
        function allckonclick(pcode, obj) {
            var rows = $('#Pgrid').datagrid('getRows');
            var $obj = $(obj);
            var chks = $("input[name='ckId']");
            var txtck = $("a[name='txtck']");
            if ($obj.prop("checked")) {
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].Pcode == pcode) {
                        $(chks[i]).prop("checked", 'true');
                        $(txtck[i]).text('完成');
                    }
                }
            } else {
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].Pcode == pcode) {
                        $(chks[i]).prop("checked", '');
                        $(txtck[i]).text('未完成');
                    }
                }
            }
            forck();

        }
        //循环取值
        function forck() {
            var oldvalue = g5value;
            g5value = 0;
            var txtvalue = "";
            var count = -1;
            var chks = $("input[name='ckId']");
            var txtck = $("a[name='txtck']");
            var rows = $('#Pgrid').datagrid('getRows');
            for (var i = 0; i < chks.length; i++) {
                if ($(chks[i]).prop("checked")) {
                    txtvalue += rows[i].Pcode + "-" + rows[i].Pname + "-" + rows[i].Code + "-" + rows[i].Cname + ",";
                    count++;
                    g5value += parseInt(rows[i].score);
                }
            }
            if (count != -1) {
                if (rows[count].Remark2 != null && rows[count].Remark2 != "") {
                    var myDate = new Date();
                    var txtdate = parseInt(myDate.getDate()) + parseInt(rows[count].Remark2);
                    myDate.setDate(txtdate);
                    $("#txtNextVisitDate").datebox("setValue", myDate.getFullYear() + '-' + (myDate.getMonth() + 1) + '-' + myDate.getDate());
                }
                else {
                    $("#txtNextVisitDate").datebox("setValue", "");
                }
            }
            $("#txtValue").val(txtvalue);
            getScore(oldvalue, g5value);
            $("#txtScore").val(g5value);
        }
        function ckonclick(index, obj) {
            //            var txtvalue = "";
            //            var chks = $("input[name='ckId']"); 
            var txtck = $("a[name='txtck']");
            //            var rows = $('#Pgrid').datagrid('getRows');
            if ($(obj).prop("checked")) {
                $(txtck[index]).text('完成');
            }
            else {
                $(txtck[index]).text('未完成');
            }
            forck();
        }
        </script>
</head>
<body>
<%-- <script type="text/javascript">
     var rows1 = $('#Pgrid').datagrid('getRows');

     for (var i = 0; i < rows.length; i++) {
         $('#Pgrid').datagrid('beginEdit', i);
         alert(rows);
     }
    </script>--%>
    <div class="metrouicss">
        <div class="page secondary">
            <div class="page-header">
                <div class="page-header-content">
                    <h1>
                        新增<small>回访记录</small></h1>
                    <a  class="back-button big page-back" href="../Alerts/AlertList.aspx"></a>
                </div>
            </div>
        </div>
    </div>
    <div data-options="region:'north',border:false" style="padding: 10px 0 0; height: 450px" 
        class="formItem">
        <div class="easyui-tabs">
            <div title="本次回访" style="padding: 10px">
            <form id="formVisit" status="add"> 
            <div id="topLoader" style=" z-index:99; position:absolute"> </div>
                <ul>
                    <li class="normalli">
                        <label for="txtCode">
                            客户姓名:</label>
                            <input type="hidden" name="Cname" id="txtCname1"   class="fieldItem"
                                field="Cname"   />
                            <input type="text" name="Cname" id="txtCname"  disabled="disabled" class="fieldItem"
                                field="Cname" readonly="true" /></li>
                    <li class="normalli">
                        <label for="txtMobile">
                            手机号:</label> 
                                        <input type="hidden" name="Mobile" id="txtMobile1"   class="fieldItem"
                                field="Mobile"   />
                            <input type="text" name="Mobile" id="txtMobile" disabled="disabled" class="fieldItem"
                                field="Mobile" /></li>
                    <li class="normalli">
                        <label for="txtTel">
                            地址:</label> 
                          <input type="hidden" name="Address" id="txtAddress1"   class="fieldItem"
                                field="Address"   />
                            <input type="text" name="Address" id="txtAddress" disabled="disabled"
                                class="fieldItem" field="Address" /></li> 
                   <li class="tableli"> 
                       <label >
                            工作进度:</label> 
                          <input type="button" name="btnProcess" class="fg-color-blackLight bg-color-grayLight"
                                value="点我修改" onclick="$('#winProcess').window('open');" />
                          <a id="txtProcess"></a>
                       <%-- <label for="txtCustomerLevel">
                            客户等级:</label>  
                        <input type="combo" id="txtCustomerLevel" name="CustomerLevel" class="easyui-combobox fieldItem"
                            field="CustomerLevel" />--%>
                            <%--<input type="hidden" name="CustomerLevel"   id="txtCustomerLevel" 
                                class="fieldItem" field="CustomerLevel" value="0" />
                            <div class="metrouicss" style="width:214px;float:right">
                          <div id="txtRate" data-role="rating" class="rating" > 
                          </div>
                          </div>--%>
                    </li>  
                    <li class="normalli">
                        <label for="txtVisitTitle">
                            主题:</label>
                           <input type="combo" name="VisitTitle" id="txtVisitTitle" class=" easyui-validatebox fieldItem" 
                                field="VisitTitle"  required="true" />
                          </li> <li class="comboli">
                        <label for="txtContactType">
                            沟通方式:</label> 
                        <input type="hidden" id="txtVisitType" name="VisitType" class="fieldItem"  
                            field="VisitType" />
                        <input type="combo" id="txtVisitTypeCode" name="VisitTypeCode" class="easyui-combobox  fieldItem"
                            field="VisitTypeCode" />
                    </li>
                     <li class="allli">
                        <label for="txtVisitContent" style="margin-right:10px;" >
                            内容:</label><textarea name="VisitContent" id="txtVisitContent" style="width:71%;"  rows="5" class="fieldItem" field="VisitContent"  ></textarea>
                     </li> 
                     <li class="normalli" >
                        <label for="txtNextVisitTime"   >
                            下次提醒时间:</label><input type="text" name="NextVisitDate" id="txtNextVisitDate" class="fieldItem easyui-datebox" required="true"    style="width:140px"    field="NextVisitDate" /> 
                           <select name="HM" id="txtHM"   class="fieldItem hm"   style="font-size:16px"   field="HM" ></select>  
                           <input type="checkbox" id="txtMsgFlag" name="MsgFlag" class="fieldItem" title="是否短信提醒" field="MsgFlag" /> 
                     </li> 
                     <li class="normalli">
                     <div style="float:left">是否短信提醒</div>
                        <label for="txtNextVisitContent"   >
                            联系计划:</label><input name="NextVisitContent" id="txtNextVisitContent"  class="easyui-validatebox fieldItem" field="VisitContent"    required="true"     /> 
                    </li>

                </ul>
                <input type="hidden" id="txtValue" name="txtValue"  class="fieldItem"   />
    <input type="hidden" id="txtScore" name="Score" value="0" class="fieldItem"   />
    <input type="hidden" name="txtCustomerLevel" id="txtCustomerLevel" value="CustomerLevel"/>
                </form>
            </div>
            <%--<div title="其他信息" style="padding: 10px">
                <ul class="customerdefine" id="customerDefine" runat="server">
                </ul>
            </div>--%>
        </div>
        <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;"
            class="formItem">
            <a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存回访单</a>  
            <a class="easyui-linkbutton" id="btnDrop" data-options="iconCls:'icon-save'">放弃客户</a> 
            <a class="easyui-linkbutton" id="btnDeal" data-options="iconCls:'icon-save'">转为成交</a> 
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="window.history.go(-1);">返回</a>
        </div>
    </div>
    <div id="winProcess" class="easyui-window" data-options="title:'进度设置',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 470px; height: 310px;">
        <form name="formReason" id="form1" status="reason">
             <table id="Pgrid" class="easyui-datagrid"  style="width:450px;height:210px;"
            data-options=" 
                singleSelect: true,
                rownumbers:true,
                method: 'get', 
                view:groupview,
                url: 'Ajax.aspx?type=PGrid&category=1&code=' + request('code'),
                onLoadSuccess: function (data) {
                      forck();
                },
                groupField:'Pname', 
                groupFormatter:function(value,rows){
                    return '<a style=color:gray>'+value +'</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type=\'checkbox\' onclick=\'allckonclick('+rows[0].Pcode+',this);\' />该项全选';
                }
            ">
        <thead>
            <tr>
                <th data-options="field:'ID',hidden:true,width:120">ID</th>
                <th data-options="field:'Pname',hidden:true,width:120">父级</th>
                <th data-options="field:'Pcode',hidden:true,width:120">父级编号</th>
                <th data-options="field:'Code',hidden:true,width:120">编号</th>
                <th data-options="field:'VCode',width:120,hidden:true">编号</th>
                <th data-options="field:'Cname',width:120">名称</th> 
                <th data-options="field:'Remark2',width:120,hidden:true">Remark2</th>
                <th data-options="field:'score',width:120,hidden:true">Score</th>
                <th data-options="field:'clCode',width:120,formatter: function(value,row,index){  var txtsp;var txtreturn='<input type=\'checkbox\'  name=\'ckId\' onclick=\'ckonclick('+index+',this);\' />&nbsp;&nbsp;<a name=\'txtck\'>未完成</a>';if(value!=null){txtsp=value;if(row.Code==txtsp){txtreturn='<input type=\'checkbox\'  checked=\'checked\' name=\'ckId\'  onclick=\'ckonclick('+index+',this);\' />&nbsp;&nbsp;<a name=\'txtck\'>完成</a>';}} return txtreturn;}">是否完成</th>
            </tr>
        </thead>
    </table> 
    <%--'<input type=\'checkbox\'  checked=\'checked\' name=\'ckId\'  onclick=\'ckonclick('+index+',this);\' />&nbsp;&nbsp;<a name=\'txtck\'>完成</a>';
                  }else{
                     return '<input type=\'checkbox\'  name=\'ckId\' onclick=\'ckonclick('+index+',this);\' />&nbsp;&nbsp;<a name=\'txtck\'>未完成</a>';}--%>
    
          <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;"
            class="formItem"> 
            <a class="easyui-linkbutton"  data-options="iconCls:'icon-save'" onclick="javascript: $('#winProcess').window('close');">确认</a> 
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="javascript: $('#winProcess').window('close');">关闭</a>
        </div>
        </form>
    </div>
    <div id="winReason" class="easyui-window" data-options="title:'放弃原因',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 350px; height: 200px;">
        <form name="formReason" id="formReason" status="reason">
            <textarea name="Reason" id="txtReason" value=""  class="easyui-validatebox" required="true"  rows="6" style="width:98%" ></textarea>
          <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;"
            class="formItem"> 
            <a class="easyui-linkbutton" id="btnSubmit" data-options="iconCls:'icon-save'">确认</a> 
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="javascript: $('#winReason').window('close');">关闭</a>
        </div>
        </form>
    </div>
</body>
</html>
