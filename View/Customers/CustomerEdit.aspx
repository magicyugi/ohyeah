<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerEdit.aspx.cs" Inherits="AppBox.View.Customers.CustomerEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title> 
    <script src="../SysCodeManage/datagrid-groupview.js" type="text/javascript"></script>
    
    <style type="text/css">
        li
        {
            float: left;
            padding: 5px;
            height:40px;
        }
        li.basic
        {
            float:none;
            margin-left:280px; 
            }
        li.normalli
        {
            text-align: right;
            width: 40%;
            height: 40px;
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
            height: 40px;
            padding-top: 9px;
            padding-bottom: 9px;
        }
        label, input
        {
            font-size: 20px;
        }
    </style>
    <script src="../../common/js/jquery.hotkeys-0.7.9.min.js" type="text/javascript"></script>
    <link href="../Visit/src/jquery.percentageloader-0.1.css" rel="stylesheet" type="text/css" />
    <script src="../Visit/src/jquery.percentageloader-0.1.js" type="text/javascript" charset="gbk"></script>
    <link href="../../common/css/Helper/CustomerEditHelper/Helper.css" rel="stylesheet" type="text/css" />
    <script src="../../common/css/Helper/CustomerEditHelper/Helper.js" type="text/javascript"></script>
    <script src="../../common/js/jquery.cookie.js" type="text/javascript"></script>
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Customer";
        var g5value = 0;
        var g5;
        var $topLoader;
        $(function () {
            $topLoader = $("#topLoader").percentageLoader({ width: 200, height: 200, progress: 0, onProgressUpdate: function (val) {

            }
            });
            if (request("ProcessFlag") == "1") {
                $("#txtTitle").html("售前<small>客户编辑</small>");
                $(".alertli").hide();
            }
            else if (request("ProcessFlag") == "2") {
                $("#txtTitle").html("售中<small>客户编辑</small>");
                $(".alertli").hide();
            }
            else if (request("ProcessFlag") == "3") {
                $("#txtTitle").html("售后<small>编辑</small>");
                $(".alertli").hide();
            }

            $("#txtCname").focus();

            $(".fieldItem").bind('keydown', 'return', function () {
                var txttabindex = parseInt($(this).attr('tabindex')) + 1;
                $("#divtabs").find("input[tabindex=" + txttabindex + "]").focus();
            }).bind('keydown', 'tab', function () {
                return false;
            });

            $.ajax({
                url: url,
                data: "type=dropdown",
                success: function (msg) {
                    $('#txtClientSourceCode').combobox({
                        data: eval(msg)[1].item1,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtthirdCode').combobox({
                        data: eval(msg)[3].item3,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtIntentionLevel').combobox({
                        data: eval(msg)[5].item5,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    LoadData(url, request("code"));
                }
            });
            
            $("#btnSave").click(function () {
                forck(1);
                if ($("#txtScore").val() == "0") { alert("请选择客户到达的步骤!"); return; }
                if (setValidate($("#formCustomer"))) {
                    //$("#txtGuide").val($("#txtGuideCode").combobox("getText"));
                    $("#txtClientSource").val($("#txtClientSourceCode").combobox("getText"));
                    $("#txtthird").val($("#txtthirdCode").combobox("getText"));
                    if (request("code") != undefined && request("code") != "") $("#formCustomer").attr("status", "edit");
                    else $("#formCustomer").attr("status", "add");
                    if (request("flag") != "") {
                        SaveData(url, namecode, request("code"), "CustomerList.aspx?ProcessFlag=" + request("ProcessFlag") + "&flag=" + request("flag"));
                    }
                    else
                        SaveData(url, namecode, request("code"), "CustomerList.aspx?ProcessFlag=" + request("ProcessFlag"));

                }
            });
            $(".back-button").click(function () {
                var backtype = "";
                if (request("type") == null || request("type") == "") backtype = "?ProcessFlag=" + request("ProcessFlag");
                if ($.trim($("#txtTitle").text()) == "意向登记") window.history.go(-1);
                else
                    window.location.href = "CustomerList.aspx" + backtype;
            });
            $('#txtClientSourceCode').combobox({
                onChange: function (newValue, oldValue) {
                    if (newValue == 0) {
                        $("#hidli").css("display", "block"); $("#hidli1").css("display", "block");
                        $("#hidli2").css("display", "none");
                        $("#txtIntroduceName").select();

                    }
                    else if (newValue == 1) {
                        $("#hidli2").css("display", "block");
                        $("#hidli").css("display", "none"); $("#hidli1").css("display", "none");
                    }
                    else
                    { $("#hidli").css("display", "none"); $("#hidli1").css("display", "none"); $("#hidli2").css("display", "none"); }
                }
            });
            var today = new Date();
            var date = AddDays(today, 7);
            var day = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
            $('#txtAlertDate').datebox('setValue', day);
        })
        function btnclick(tabid, selectindex, basicid) {
            if (selectindex == 1) {
                if ($("#txtCname").val() == "") { alert("请输入客户姓名!"); return; }
                if ($("#txtMobile").val() == "") { alert("请输入联系电话!"); return; }
//                if ($("#txtAddress").val() == "") { alert("请输入地址!"); return; }
                $.ajax({
                    url: url,
                    data: "type=CheckCustomer&code=" + request("code") + "&cname=" + $("#txtCname").val() + "&mobile=" + $("#txtMobile").val() + "&address=" + $("#txtAddress").val(),
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            $(tabid).tabs("select", selectindex);
                            $(basicid).find("input").eq(0).focus();
                        }
                        else {
                            alert(msg.split(':')[1]);
                            $("#txtMobile").select();
                        }
                    }
                });
            }
            else {
                $(tabid).tabs("select", selectindex);
                $(basicid).find("input").eq(0).focus();
            }
        }
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
                        setTimeout(animateFunc, 5);
                    } else {
                        topLoaderRunning = false;
                    }

                }
                else if (kb > newvalue) {
                    kb -= 1;
                    $topLoader.setProgress(kb / total);
                    //$topLoader.setValue(kb.toString() + '分'); 
                    if (kb < total) {
                        setTimeout(animateFunc, 5);
                    } else {
                        topLoaderRunning = false;
                    }
                }
                else { $topLoader.setProgress(kb / total); topLoaderRunning = false; }

            }

            setTimeout(animateFunc, 5);  ;
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
        function forck(type) {
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
                    g5value += parseFloat(rows[i].score);
                }
            } 
            if (count != -1&&type!=1) {
                if (rows[count].Remark2 != null && rows[count].Remark2 != "") {
                    var myDate = new Date();
                    var txtdate = parseInt(myDate.getDate()) + parseInt(rows[count].Remark2);
                    myDate.setDate(txtdate);
                    $("#txtAlertDate").datebox("setValue", myDate.getFullYear() + '-' + (myDate.getMonth() + 1) + '-' + myDate.getDate());
                }
                else {
                    $("#txtAlertDate").datebox("setValue", "");
                }
            }
            g5value = Math.round(g5value); 
            $("#txtValue").val(txtvalue);
            getScore(oldvalue, g5value);
            $("#txtScore").val(g5value);
            var txtprocess = request("processflag");
            if (txtprocess != "") txtprocess = parseInt(request("processflag")) - 1;
            $("#txtCustomerLevel").val(txtprocess); 
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
<body id="showbody" style="min-width:1366px; ">

    <div class="metrouicss">
        <div class="page secondary">
            <div class="page-header">
                <div class="page-header-content">
                    <h1 id="txtTitle">
                        意向<small>登记</small></h1>
                    <a class="back-button big page-back"></a>
                </div>
            </div>
        </div>
    </div> 
    <div  id="nipic_search" class="tipSwitch" style="top:112px;left:990px; z-index:100;"></div>
    <div data-options="region:'north',border:false" style="padding: 10px 0 0; height: 450px"
        class="formItem">
        <form id="formCustomer" status="add">
        <div id="divtabs" class="easyui-tabs" style="">
            <div id="a123" title="客户档案" style="padding: 10px">
                <ul id="customerul">
                    <li  class="basic">
                        <label for="txtCname">
                            客户名称:</label><input type="text" name="Cname" id="txtCname" tabindex="0" class="easyui-validatebox fieldItem" required="true" field="Cname" />
                        
                    </li>
                    <li  class="basic">
                        <label for="txtMobile">
                            手 机 号:</label><input type="text" maxlength="11" name="Mobile" tabindex="1" id="txtMobile" class="easyui-validatebox fieldItem"     required="true" field="Mobile" /></li>
                    <%--<li  class="basic" >
                        <label for="txtTel">
                            电话号码:</label><input type="text" name="Tel" id="txtTel" tabindex="2" class="fieldItem" field="Tel"  /></li>--%>
                    <%--<li class="basic"  >
                         <label for="txtSex" style="float:left;">
                            性&nbsp;&nbsp;&nbsp;&nbsp;别:</label>   <div style="width:150px;float:left; font-size:20px">
                        <input type="radio" name="Sex" id="txtSex1" checked="checked"  value="先生"  class="fieldItem" field="Sex" />先生  
                        <input type="radio" name="Sex" id="txtSex2"  value="女士"  class="fieldItem"  field="Sex" />女士</div>
                    </li>--%>
                    <li class="basic">
                        <label for="txtTel">
                            地&nbsp;&nbsp;&nbsp;&nbsp;址:</label><input type="text" tabindex="2"  name="Address" id="txtAddress" class="fieldItem" field="Address" /></li>
                    <li class="basic metrouicss"  >
                        <div   style="float:left; font-size:20px">
                            <input  type="button" id="btnnext"  name="btnnext"  value="下一页"  tabindex="3"  onclick="btnclick(divtabs,1,customerDefine)"  class="nextbtn fg-color-white bg-color-blue"/>
                             <input  type="button" id="btncancle"  name="btncancle"  value="取消" onclick="window.history.back(-1);"  class="btncancle fg-color-white bg-color-blue"/>
                        </div>
                    </li>
                    <%--<li class="comboli">
                        <label for="txtGuideCode">
                            业务员:</label>
                        <input type="hidden" id="txtGuide" name="Guide" class="fieldItem" field="Guide" />
                        <input type="combo" id="txtGuideCode" name="GuideCode" class="easyui-combobox  fieldItem"   field="GuideCode" />
                    </li>--%>
                    
                </ul>
            </div>
            <div title="基础信息" style="padding: 10px">
                <ul style="width:80%" class="customerdefine" id="customerDefine" runat="server">
                </ul>
                
            </div>
            <div title="详细信息" style="padding: 10px">
            <div id="topLoader" style=" z-index:99; position:absolute"> </div>
                <ul id="basicul" runat="server" >
                    <li class="basic">
                          <label >
                            工 作 进 度:&nbsp;</label> 
                           <a class="easyui-linkbutton" id="btnProcess" data-options="iconCls:'icon-edit'"  onclick="$('#winProcess').window('open');" >点击修改</a>  
                           
                          <a id="txtProcess"></a>
                          <input type="hidden" id="txtValue" name="txtValue"  class="fieldItem"   />
                          <input type="hidden" id="txtScore" name="Score" value="0" class="fieldItem"   />
                          <input type="hidden" name="txtCustomerLevel"  class="fieldItem"  id="txtCustomerLevel" value="CustomerLevel"/>
                      <%--  <label for="txtClientSourceCode">
                            客 户 评 级:&nbsp;</label>  
                        <input type="combo" tabindex="49" id="txtCreditLevel" name="CreditLevel" class="easyui-combobox fieldItem"
                            field="CreditLevel" />--%>
                        
                    </li>
                    <li class="basic">
                        <label for="txtIntentionLevel">
                            客 户 评 级:&nbsp;</label>
                        <input type="combo" tabindex="49" id="txtIntentionLevel" name="txtIntentionLevel" class="easyui-combobox fieldItem"
                            field="txtIntentionLevel" />
                    </li>
                    <li class="basic">
                        <label for="txtClientSourceCode">
                            客 户 来 源:&nbsp;</label>
                        <input type="hidden"  id="txtClientSource" name="ClientSource" class="fieldItem" field="ClientSource" />
                        <input type="combo" tabindex="50" id="txtClientSourceCode" name="ClientSourceCode" class="easyui-combobox fieldItem"
                            field="ClientSourceCode" />
                    </li> 
                    <li id="hidli" class="basic" style="display:none;">
                        <label for="txtIntroduceName">
                            介 &nbsp;绍 &nbsp;人:&nbsp;</label>
                        <input type="text" id="txtIntroduceName"  name="IntroduceName" tabindex="50" class="fieldItem" field="IntroduceName" />
                    </li>
                    <li id="hidli1" class="basic" style="display:none;">
                        <label for="txtIntroduceMobile">
                            介绍人电话:&nbsp;</label>
                        <input type="text" onkeydown="if(event.keyCode==13) $('#txtDescription').focus();" id="txtIntroduceMobile" name="IntroduceMobile" tabindex="51" class="fieldItem" field="IntroduceMobile" />
                    </li>
                    <li id="hidli2" class="basic" style="display:none;">
                        <label for="txtthirdCode">
                            第 &nbsp;三 &nbsp;方:&nbsp;</label>
                        <input type="hidden"  id="txtthird" name="ClientSource1" class="fieldItem" field="ClientSource1" />
                        <input type="combo" tabindex="50" id="txtthirdCode" name="ClientSourceCode1" class="easyui-combobox fieldItem"
                            field="ClientSourceCode1" />
                    </li>
                   <%-- <li class="basic">
                        <label for="txtVIPNumber">
                            会员卡号:</label><input type="text" name="VIPNumber" id="txtVIPNumber" class="fieldItem"
                                field="VIPNumber" />
                    </li>--%>
                     <li class="basic" style="height:60px;"  >
                        <label for="txtDescription">
                            交 流 情 况:&nbsp;</label>
                            <textarea tabindex="52" cols="4" rows="4" name="Description" id="txtDescription" class="fieldItem"
                                field="Description" style="width:400px"  ></textarea> 
                    </li>
                    <li class="basic"  >
                        <label for="txtAlertDate">
                            下次回访时间:</label>
                            <input   type="text"  tabindex="52" name="AlertDate" id="txtAlertDate" style="width:147px"     field="AlertDate" 
                                field="AlertDate"  class="easyui-datebox fieldItem" required="required" />  
                           <select name="HM" id="txtHM"  tabindex="53" class="fieldItem hm" field="HM" ></select>  
                           <input type="checkbox" id="txtMsgFlag"  tabindex="54" name="MsgFlag" class="fieldItem" title="是否短信提醒" field="MsgFlag" /> 
                           是否短信提醒
                    </li>  
                    <li class="basic">
                    
                        <label for="txtAlertContent">
                            联 系 计 划: &nbsp;</label><input type="text" tabindex="55" name="AlertContent" id="txtAlertContent" class="fieldItem"
                                field="AlertContent" />
                    </li>
                </ul>
                <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;width:100%"
            class="formItem metrouicss">
            <input  type="button" id="txtlast1"   name="txtlast1"  value="上一页"   onclick="btnclick(divtabs,1,customerDefine)"   class="txtlast1 fg-color-white bg-color-blue"/>
            <input  type="button" id="btnSave" value="保存"    class="fg-color-white bg-color-blue"/>
            <input  type="button" id="btnBack"  name="btnBack"  value="返回"    onclick="window.history.go(-1)"   class="nextbtn fg-color-white bg-color-blue"/>
            <%--<a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="window.history.go(-1)">返回</a>--%>
        </div>
            </div>
        </div>
        </form>
        
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
                url: '../Visit/Ajax.aspx?type=PGrid&code=' + request('code'),
                onLoadSuccess: function (data) {
                      forck();
                },
                groupField:'Pname', 
                groupFormatter:function(value,rows){
                    return '<a style=color:gray>'+value +'</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type=\'checkbox\' onclick=\'allckonclick(&quot;'+rows[0].Pcode+'&quot;,this);\' />该项全选';
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
</body>
</html>
