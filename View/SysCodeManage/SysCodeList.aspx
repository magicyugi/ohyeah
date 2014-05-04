a<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysCodeList.aspx.cs" Inherits="AppBox.View.SysCodeManage.SysCodeList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<style>
    #pgridul li{ float:left; text-decoration:none;}
</style>
    <script src="datagrid-groupview.js" type="text/javascript"></script> 
    <link href="../../common/css/SysCode.css" rel="stylesheet" type="text/css" />
    <title>基础档案维护</title> 
    <script language="javascript" type="text/javascript">
             var Sselect = "";
             $().ready(function () {

                 $("#grid").datagrid({
                     onClickRow: function (index, data) {
                         var txtselect = data.Cname;
                         if (txtselect == "售前步骤子级" || txtselect == "售中步骤子级" || txtselect == "售后步骤子级") {
                             $('#divPgrid').panel('open');
                             $('#divdgrid').panel('close');
                             if (txtselect == "售前步骤子级") Sselect = "1";
                             if (txtselect == "售中步骤子级") Sselect = "2";
                             if (txtselect == "售后步骤子级") Sselect = "3";
                             $("#Pgrid").datagrid({
                                 url: "Ajax.aspx?key=PGrid&id=" + data.Code + "&category=" + Sselect
                             });
                             $("#btnPrecent").css("display", "none");
                             $.ajax({
                                 url: "Ajax.aspx",
                                 data: "type=dropdown&category=" + Sselect,
                                 success: function (msg) {
                                     $('#txtPcode').combobox({
                                         data: eval(msg)[0].item0,
                                         valueField: 'Code',
                                         textField: 'Cname'
                                     });
                                 }
                             });

                         }
                         else { 
                             if (txtselect == "售前步骤" || txtselect == "售中步骤" || txtselect == "售后步骤") {
                                 $('#dgrid').datagrid('showColumn', 'BindModule'); 
                             }
                             else {
                                 $('#dgrid').datagrid('hideColumn', 'BindModule'); 
                             }
                             $('#divPgrid').panel('close');
                             $('#divdgrid').panel('open');
                             $("#dgrid").datagrid({
                                 url: "Ajax.aspx?key=DGrid&id=" + data.Code
                             });
                             Sselect = ""; 
                         }
                         //权限*************************************
                         $.ajax({
                             url: "Ajax.aspx",
                             data: "type=Role&RoleCode=0311",
                             success: function (msg) {
                                 var txtmsg = msg.split(',');
                                 for (var i = 0; i < txtmsg.length; i++) {
                                     $("#" + txtmsg[i]).css("display", "none");
                                 }
                             }
                         });
                     }
                 });
                 //权限*************************************
                 $.ajax({
                     url: "Ajax.aspx",
                     data: "type=Role&RoleCode=0311",
                     success: function (msg) {
                         var txtmsg = msg.split(',');
                         for (var i = 0; i < txtmsg.length; i++) {
                             $("#" + txtmsg[i]).css("display", "none");
                         }
                     }
                 });
                 
                 $("#btnSave").click(function () {
                     var keytype;
                     $("#txtPcodeName").val($('#txtPcode').combobox('getValue'));
                     if ($('#wind').attr('title') == "新增")
                         keytype = "insert";
                     else
                         keytype = "update";
                     $("#hdnRemark2").val($("#txtRemark2").numberspinner('getValue'));
                     $("#hdnRemark1").val($("#txtRemark1").numberspinner('getValue'));
                     //var txtselect = $("#grid").datagrid('getSelected')["CategoryName"];
                     $.ajax({
                         type: "post",
                         datatype: "json",
                         url: "Ajax.aspx?key=" + keytype + "&SType=" + Sselect,
                         data: $('#windform').serialize(),
                         success: function (msg) {
                             if (msg.indexOf("fail:") == -1) {
                                 if (Sselect != "")
                                     $("#Pgrid").datagrid("reload");
                                 else
                                     $("#dgrid").datagrid("reload");
                                 $('#wind').window('close');
                                 windClear();
                             }
                             else
                                 alert(msg.split(':')[1]);
                         }
                     });
                 });
                 $("#btnSubmit").click(function () {
                     var txtid = ""; var txtvalue = "";
                     $("input[type='range']").each(function () {
                         txtid += $(this).attr("id") + ",";
                         txtvalue += $(this).val() + ",";
                     });
                     $.ajax({
                         type: "post",
                         datatype: "json",
                         url: "Ajax.aspx?type=precent&txtid=" + txtid + "&txtvalue=" + txtvalue,
                         success: function (msg) {
                             if (msg.indexOf("fail:") == -1) {
                                 if (Sselect != "")
                                     $("#Pgrid").datagrid("reload");
                                 else
                                     $("#dgrid").datagrid("reload");
                                 $('#winPrecent').window('close');
                             }
                             else
                                 alert(msg.split(':')[1]);
                         }
                     });
                 });
             })

         function windClear() {
             $('#txtCode').val("");
             $('#txtVCode').val("");
             $('#txtCname').val("");
             $('#txtStatusFlag').combobox('setValue', "1");
         }

         function formatterStatus(value, rowData, rowIndex) {
             var showvalue = "";
             showvalue = (value=='1'?'是':'否');
             return '<span>' + showvalue + '</span>';
         }
         function formatterModule(value, rowData, rowIndex) {
             var showvalue = "";
             switch (value) {
                 case 'Contract': showvalue='合同签订'; break;
                 case 'ContractDetail': showvalue = '付款管理'; break;
             } 
             return '<span>' + showvalue + '</span>';
         }
         </script>
</head>
<body class="easyui-layout">
    <form id="form1" runat="server">
    <div region="north" style="height: 110px">
    <div class="metrouicss">
  <div class="page secondary">
        <div class="page-header">
            <div class="page-header-content" >
                <h1>基础<small >档案</small> 
                </h1>
                <a class="back-button big page-back"  ></a>
            </div>
        </div> 
    </div>  
</div></div>
    <div data-options="region:'west',split:true" style="width:180px;">
    <table class="easyui-datagrid" id="grid" 
      data-options="url: 'Ajax.aspx?key=LoadGrid',singleSelect:true">
		<thead>
			<tr>
                <th data-options="field:'Code',width:170,hidden:true">编号</th>
                <th data-options="field:'CategoryName',width:170,align:'center'">类型名称</th>
                <th data-options="field:'Category',width:170,hidden:true">类型</th>
			</tr>
		</thead>
	</table>
      </div>
    <div data-options="region:'center',split:true">
    <div  id="divPgrid" class="easyui-panel" closed="true">
     <table class="easyui-datagrid" id="Pgrid" 
            data-options=" 
                singleSelect:true, 
                rownumbers:true, 
                toolbar:toolbar,
                groupField:'Pname',
                view:groupview,
                groupFormatter:function(value,rows){
                    return '<div style=color:red>'+value + ' -  总:' + rows.length + ' 行数据'+'</div>';
                }
            ">
        <thead>
            <tr>
                <th data-options="field:'ID',hidden:true,width:120">ID</th>
                <th data-options="field:'Pname',hidden:true,width:120">父级</th>
                <th data-options="field:'Pcame',hidden:true,width:120">父级编号</th>
                <th data-options="field:'Code',hidden:true,width:120">编号</th>
                <th data-options="field:'VCode',width:120,hidden:true">编号</th>
                <th data-options="field:'Cname',width:120">名称</th>
                <th data-options="field:'StatusFlag',width:120" formatter="formatterStatus">启用</th> 
                <th data-options="field:'Remark1',width:120">步骤</th> 
                <th data-options="field:'Remark2',width:120,hidden:true">天数</th> 
                
            </tr>
        </thead>
    </table>
    </div>
    <div  id="divdgrid" class="easyui-panel" closed="false">
     <table class="easyui-datagrid" id="dgrid" 
      data-options="singleSelect:true,rownumbers:true,toolbar:toolbar">
		<thead>
			<tr>
                <th data-options="field:'ID',hidden:true,width:120">ID</th>
                <th data-options="field:'Code',width:120">编号</th>
                <th data-options="field:'VCode',width:120,hidden:true">编号</th>
                <th data-options="field:'Cname',width:120">名称</th>
                <th data-options="field:'StatusFlag',width:120" formatter="formatterStatus">启用</th>
                <th data-options="field:'Remark1',width:120,hidden:true">步骤</th> 
                <th data-options="field:'Remark2',width:120,hidden:true">分数</th> 
                <th data-options="field:'BindModule',width:120,hidden:true" formatter="formatterModule">绑定模块</th> 
                <th data-options="field:'KeyFlag',width:120,hidden:true" formatter="formatterStatus">是否关键</th>
			</tr>
		</thead>
	</table>
    </div>
     <script type="text/javascript">
         var toolbar = [{
             id: 'btnAdd',
             text: '新增',
             iconCls: 'icon-edit',
             handler: function () {
                 if ($("#grid").datagrid('getSelected') != null) {
                     $('#txtID').val("");
                     $('#txtCode').val("");
                     $('#txtVCode').val("");
                     $('#txtCname').val("");
                     $('#txtStatusFlag').combobox('setValue', "1");
                     $('#txtFlag').combobox('setValue', "");
                     $('#txtModule').combobox('setValue', "");
                     var txtcategory = "";
                     $('#wind').attr("title", "新增");
                     //                   $('#txtVCode').removeAttr("readonly");


                     if (Sselect != "") {
                         $("#txtRemark1").numberspinner("setValue", "1");
                         $("#hdnRemark1").val("1");
                         $("#customerli").css("display", "block");
                         $("#dateli").css("display", "block");
                         $("#numli").css("display", "block");
                         $("#flagli").css("display", "none");
                         $("#modulli").css("display", "none");
                         if (Sselect - 1 == 0)
                             txtcategory = "CustomerLevelSon";
                         else
                             txtcategory = "CustomerLevelSon" + (Sselect - 1).toString();
                     }
                     else {
                         $("#dateli").css("display", "none");
                         $("#customerli").css("display", "none");

                         var txtCategory = $("#grid").datagrid('getSelected')["CategoryName"];
                         if (txtCategory == "售前步骤" || txtCategory == "售中步骤" || txtCategory == "售后步骤") {
                             $("#numli").css("display", "block"); $("#txtRemark1").val("1");
                             $("#flagli").css("display", "block");
                             $("#modulli").css("display", "block");
                         }
                         else {
                             $("#numli").css("display", "none");
                             $("#flagli").css("display", "none");
                             $("#modulli").css("display", "none");
                         }
                         txtcategory = $("#grid").datagrid('getSelected')["Code"];
                     }
                     $('#txtCategory').val(txtcategory);
                     $('#txtCategoryName').val($("#grid").datagrid('getSelected')["CategoryName"]);
                     $('#wind').window('open');
                 }
                 else
                     $.messager.alert('注意', '请先选择类型名称！');
             }
         }, {
             id: 'btnEdit',
             text: '修改',
             iconCls: 'icon-edit',
             handler: function () {
                 if ($("#dgrid").datagrid('getSelected')["VCode"] == "0") { alert("该数据不可被修改!"); return; }
                 var txtselect = "", txtgrid = "";
                 if ($("#grid").datagrid('getSelected') != null) {
                     txtselect = "notnull"; //$("#grid").datagrid('getSelected')["CategoryName"]; 
                     if (Sselect != "")
                     { if ($("#Pgrid").datagrid('getSelected') == null) { txtselect = ""; } else txtgrid = "#Pgrid"; }
                     else
                     { if ($("#dgrid").datagrid('getSelected') == null) { txtselect = ""; } else txtgrid = "#dgrid"; }
                 }
                 $('#txtModule').combobox('setValue', "");
                 if (txtselect != "") {
                     $('#wind').attr("title", "修改");
                     $('#txtID').val($(txtgrid).datagrid('getSelected')["ID"]);
                     $('#txtCode').val($(txtgrid).datagrid('getSelected')["Code"]);
                     $('#txtVCode').val($(txtgrid).datagrid('getSelected')["VCode"]);
                     $('#txtCname').val($(txtgrid).datagrid('getSelected')["Cname"]);
                     $('#txtStatusFlag').combobox('setValue', $(txtgrid).datagrid('getSelected')["StatusFlag"]);
                     $('#txtCategory').val($("#grid").datagrid('getSelected')["Code"])
                     //$('#txtFlag').combobox('setValue', $(txtgrid).datagrid('getSelected')["KeyFlag"]);
                     if (Sselect != "") {
                         $("#numli").css("display", "block");
                         $("#dateli").css("display", "block");
                         $("#customerli").css("display", "block");
                         $("#flagli").css("display", "none");
                         $("#modulli").css("display", "none");
                         var txtRemark2 = $("#Pgrid").datagrid('getSelected')["Remark2"] == null ? "1" : $("#Pgrid").datagrid('getSelected')["Remark2"];
                         var txtRemark1 = $("#Pgrid").datagrid('getSelected')["Remark1"] == null ? "1" : $("#Pgrid").datagrid('getSelected')["Remark1"]; ;
                         $("#txtRemark2").numberspinner("setValue", txtRemark2);
                         $("#txtRemark1").numberspinner("setValue", txtRemark1);
                         $('#txtPcode').combobox('setValue', ($("#Pgrid").datagrid('getSelected')["Pcode"]));
                     }
                     else {

                         $("#dateli").css("display", "none");
                         $("#customerli").css("display", "none");
                         var txtCategory = $("#grid").datagrid('getSelected')["CategoryName"];
                         var txtRemark1 = $("#dgrid").datagrid('getSelected')["Remark1"] == null ? "1" : $("#dgrid").datagrid('getSelected')["Remark1"]; ;
                         if (txtCategory == "售前步骤" || txtCategory == "售中步骤" || txtCategory == "售后步骤") {
                             $("#numli").css("display", "block");
                             $("#txtRemark1").numberspinner("setValue", txtRemark1);
                             $("#flagli").css("display", "block");
                             $("#modulli").css("display", "block");
                             $('#txtModule').combobox('setValue', $("#dgrid").datagrid('getSelected')["BindModule"]);
                             $('#txtFlag').combobox('setValue', $("#dgrid").datagrid('getSelected')["KeyFlag"]);
                         }
                         else {
                             $("#numli").css("display", "none");
                             $("#flagli").css("display", "none");
                             $("#modulli").css("display", "none");
                             $('#txtFlag').combobox('setValue', "");
                             $('#txtModule').combobox('setValue', '');
                         }
                     }
                     $('#wind').window('open');
                 }
                 else
                     $.messager.alert('注意', "请选择需要编辑的行！", 'warning');
             }
         }, {
             id: 'btnDelete',
             text: '删除',
             iconCls: 'icon-save',
             handler: function () {
                 var txtselect = "";
                 var txtid = "";
                 if ($("#grid").datagrid('getSelected') != null) {
                     if ($("#dgrid").datagrid('getSelected')["VCode"] == "0") { alert("该数据不可被删除!"); return; }
                     txtselect = "notnull"; //$("#grid").datagrid('getSelected')["CategoryName"];
                     if (Sselect != "") {
                         if ($("#Pgrid").datagrid('getSelected') == null) { txtselect = ""; }
                         else txtid = $("#Pgrid").datagrid('getSelected')["ID"] + "&type=PCode";
                     }
                     else {
                         if ($("#dgrid").datagrid('getSelected') == null) { txtselect = ""; }
                         else txtid = $("#dgrid").datagrid('getSelected')["ID"];
                     }
                 }  
                 if (txtselect != "") {
                     $.messager.confirm('注意', '是否确认删除该行记录！', function (r) {
                         if (r) {
                             if (Sselect == "") {
                                 $("#dgrid").datagrid({
                                     url: "Ajax.aspx?key=del&id=" + txtid + "&pid=" + $("#grid").datagrid('getSelected')["Code"]
                                 });
                                 $("#dgrid").datagrid("reload");
                             }
                             else {
                                 $("#Pgrid").datagrid({
                                     url: "Ajax.aspx?key=del&id=" + txtid + "&pid=" + $("#grid").datagrid('getSelected')["Code"] + "&category=" + Sselect
                                 });
                                 $("#Pgrid").datagrid("reload");
                             }

                         }
                     });
                 }
             }
         }, {
             id: 'btnPrecent',
             text: '设置分值',
             iconCls: 'icon-edit',
             handler: function () {
                 if ($("#grid").datagrid('getSelected') != null) {
                     var txtselect = $("#grid").datagrid('getSelected')["CategoryName"];
                     if (txtselect == "售前步骤" || txtselect == "售中步骤" || txtselect == "售后步骤") {
                         var rows = $('#dgrid').datagrid('getRows');
                         if (rows.length <= 0) { alert("当前没有项可以设置分值!"); return; }
                         else {
                             var txtcontrol = "<table id='Precentdt' style='width:100%;'>";
                             for (var i = 0; i < rows.length; i++) {
                                 var txtvalue = "0";
                                 if (rows[i].Remark2 != "0" && rows[i].Remark2 != "") txtvalue = rows[i].Remark2;
                                 txtcontrol += "<tr><td>" + rows[i].Cname + ":</td><td><div>"
                                + "<input style='margin-left:12px;' id='" + rows[i].ID + "' name='range' type='range' min=0 max=100 value=" + txtvalue + ">"
                                + "<output for='" + rows[i].ID + "'>" + txtvalue + "</output>"
                                + "</div></td></tr>";
                             }
                             txtcontrol += "</table>";
                             $("#divPrecent").html(txtcontrol);
                             $('#winPrecent').window('open');
                             var el, newPoint, newPlace, offset;
                             var txtM = 100;
                             $("input[type='range']").change(function () {
                                 txtM = 100;
                                 el = $(this);

                                 $("input[type='range']").each(function () {
                                     txtM = txtM - parseInt($(this).val());
                                 });
                                 $("input[type='range']").each(function () {
                                     var txtvalue = parseInt($(this).val());
                                     if ($(this).val() == "0") {
                                         $(this).attr("max", txtM);
                                     }
                                     else {
                                         $(this).attr("max", txtM + txtvalue);
                                         $(this).val($(this).val());
                                     }
                                     $(this).next("output").css({ left: selectoutput(this).split(',')[0], marginLeft: selectoutput(this).split(',')[1] + "%" }).text($(this).val());
                                 });

                                 el.next("output").css({ left: selectoutput(this).split(',')[0], marginLeft: selectoutput(this).split(',')[1] + "%" }).text(el.val());
                             }).trigger('change');
                         }
                     }
                     else
                     { alert("只有售前步骤,售中步骤,售后步骤可以设置分值"); return; }
                 }
                 else
                 { alert("当前没有项可以设置分值!"); return; }
             }
         }
        ];
         function selectoutput(obj) {
             el = $(obj);
             width = el.width();
             newPoint = (el.val() - el.attr("min")) / (el.attr("max") - el.attr("min"));
             offset = -1.3;
             if (newPoint < 0) { newPlace = 0; }
             else if (newPoint > 1) { newPlace = width; }
             else { newPlace = width * newPoint + offset; offset -= newPoint; }
             return newPlace + ',' + offset;
         }
	</script>
      </div>
    </form>
    
    <div id="wind" class="easyui-window" title="编辑"
       data-options="modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false" 
       style="width:320px;height:250px;padding:10px;">
		<div class="easyui-layout" data-options="fit:true">

			<div data-options="region:'center',split:true">
             <form id="windform">
             <input type="hidden" name="txtID" id="txtID"/>
            <input type="hidden" name="txtCode" id="txtCode"/>
            <input type="hidden" name="txtCategory" id="txtCategory"/>
            <input type="hidden" name="txtCategoryName" id="txtCategoryName"/>
            <input type="hidden" name="txtPcodeName" id="txtPcodeName"/>
            <input type="hidden" name="txtvalue" id="txtvalue"/>
            <ul>
            <%--<li> <label>编号:</label><input type="text" name="txtVCode" id="txtVCode" readonly="true"/></li>--%>
            <li> <label>名&nbsp;&nbsp;&nbsp;&nbsp;称:</label>
            <input type="text" id="txtCname" name="txtCname" /> 
            </li>
            <li id="customerli" style="display:block"> <label>评&nbsp;&nbsp;&nbsp;&nbsp;级:</label> 
                <input type="combo" id="txtPcode" name="Pcode" class="easyui-combobox fieldItem" style="width:150px;"
                                field="Pcode" />
            </li>
            <li id="numli" style="display:block"> <label>步&nbsp;&nbsp;&nbsp;&nbsp;骤:</label> 
            <input id="txtRemark1" class="easyui-numberspinner fieldItem"  name="Remark1"  data-options="min:1"
             style="width:80px;" field="Remark1" ></input>
             <input type="hidden" name="hdnRemark1" id="hdnRemark1"/>
            </li>
            <li id="dateli" style="display:block"> <label>多久提醒:</label> 
            <input id="txtRemark2" class="easyui-numberspinner fieldItem" name="Remark2"  data-options="min:1"
                style="width:80px;" field="Remark2"  ></input>天
            <input type="hidden" name="hdnRemark2" id="hdnRemark2"/>
            </li>
            <li id="flagli" style="display:block"> <label>是否关键:</label> 
            <select class="easyui-combobox" name="txtFlag" data-options="panelHeight:'auto'"  id="txtFlag" style="width:80px;">
            <option value="0">否</option>
		    <option value="1">是</option>
           </select>
            </li> 
            <li id="modulli" style="display:block"> <label>绑定模块:</label> 
            <select class="easyui-combobox" name="txtModule" data-options="panelHeight:'auto'"  id="txtModule" style="width:80px;">
            <option value="Contract">合同签订</option>
		    <option value="ContractDetail">付款</option>
           </select>
            </li> 
            <li> <label>启&nbsp;&nbsp;&nbsp;&nbsp;用:&nbsp;</label><select class="easyui-combobox" name="txtStatusFlag"   data-options="panelHeight:'auto'"  id="txtStatusFlag" style="width:80px;">
            <option value="1">启 用</option>
		    <option value="2">停 用</option>
           </select>
           </li>
            </ul>
             </form> 
            </div>     
  	
   			<div data-options="region:'south',border:false" style="text-align:right;padding:5px 0 0;">
				<a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript: $('#wind').window('close');windClear();">取消</a>
			</div>
		</div>
	</div>
     <div id="winPrecent" class="easyui-window" data-options="title:'设定分值',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 400px; height: 500px;">
        <form name="formPrecent" id="formPrecent" status="precent">
          <div id="divPrecent"></div>
          <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;"
            class="formItem"> 
            <a class="easyui-linkbutton" id="btnSubmit" data-options="iconCls:'icon-save'">确认</a> 
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="javascript: $('#winPrecent').window('close');">关闭</a>
        </div>
        </form>
    </div>
     <div id="winPgrid" class="easyui-window" data-options="title:'步骤设定',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 800px; height: 500px;">
        <form name="formPgrid" id="form2" status="Pgrid">
        
        <ul id="pgridul">
            <%--<li> <label>编号:</label><input type="text" name="txtVCode" id="txtVCode" readonly="true"/></li>--%>
            <li> <label>名&nbsp;&nbsp;&nbsp;&nbsp;称:</label>
            <input type="text" id="Text4" name="txtCname" /> 
            </li>
            
            <li> <label>步&nbsp;&nbsp;&nbsp;&nbsp;骤:</label> 
            <input id="Text5" class="easyui-numberspinner fieldItem"  name="Remark1"  data-options="min:1"
             style="width:80px;" field="Remark1" ></input>
             <input type="hidden" name="hdnRemark1" id="Hidden1"/>
            </li> 
            <li> <label>是否关键:</label> 
            <select class="easyui-combobox" name="txtFlag" data-options="panelHeight:'auto'"  id="Select2" style="width:80px;">
            <option value="0">否</option>
		    <option value="1">是</option>
           </select>
            </li> 
            <li> <label>绑定模块:</label> 
            <select class="easyui-combobox" name="txtModule" data-options="panelHeight:'auto'"  id="Select3" style="width:80px;">
            <option value="Contract">合同签订</option>
		    <option value="ContractDetail">付款</option>
           </select>
            </li> 
            <li> <label>启&nbsp;&nbsp;&nbsp;&nbsp;用:&nbsp;</label><select class="easyui-combobox" name="txtStatusFlag"   data-options="panelHeight:'auto'"  id="Select4" style="width:80px;">
            <option value="1">启 用</option>
		    <option value="2">停 用</option>
           </select>
           </li>
            </ul>
          <table style="width: 700px; height: 400px;">
            <thead>
              <th>名称</th>
              <th>步骤</th>
              <th>多久提醒</th>
              <th>启用</th>
            </thead>
            <tbody>
              <tr>
                <td><input type="text" id="Text1" name="txtCname" /> </td>
                <td><input id="Text2" class="easyui-numberspinner fieldItem"  name="Remark1"  data-options="min:1"
             style="width:80px;" field="Remark1" ></input> </td>
                <td><input id="Text3" class="easyui-numberspinner fieldItem" name="Remark2"  data-options="min:1"
                style="width:80px;" field="Remark2"  ></input>天 </td>
                <td><select class="easyui-combobox" name="txtStatusFlag"  data-options="panelHeight:'auto'"  id="Select1" style="width:80px;">
            <option value="1">启 用</option>
		    <option value="2">停 用</option>
           </select> </td>
              </tr>
            </tbody>
          </table>
          <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;"
            class="formItem"> 
            <a class="easyui-linkbutton" id="A1" data-options="iconCls:'icon-save'">确认</a> 
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="javascript: $('#winPrecent').window('close');">关闭</a>
        </div>
        </form>
    </div>
</body>
</html>
