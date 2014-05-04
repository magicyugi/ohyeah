a<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysCategoryList.aspx.cs" Inherits="AppBox.View.SysCodeManage.SysCategoryList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<style>
    #pgridul li{ float:left; list-style:none; width:50%;}
     .typediv {text-align: center;height:100px; font-size:30px; vertical-align:middle;line-height:100px;cursor:pointer;box-shadow: 2px 2px 2px rgba(0,0,0, 0.3);}
      .typediv:hover {
        background-color: #FFD09C;
        box-shadow: 2px 2px 2px rgba(0,0,0, 0.3);
        text-shadow: none;
        }
</style>
    <script src="datagrid-groupview.js" type="text/javascript"></script> 
    <link href="../../common/css/SysCode.css" rel="stylesheet" type="text/css" />
    <title>进度设置</title> 
    <script language="javascript" type="text/javascript">
        var url = "Ajax.aspx";


        //获取字符串指定字符出现次数
        function getsum(str, txtsplit) { 
            var len = str.length;  //获得字符串的长度
            var seleLen = txtsplit.length;
            var i = 0;  //统计
            var getindex = str.indexOf(txtsplit);//定义出现首位置
            var getleng = (getindex + seleLen);//定义截取长度
            while (getleng <= len && getindex != -1) { 
                getindex = str.substring(getleng, str.length).indexOf(txtsplit); 
                ++i;
                if (getindex != -1) {
                    getleng = (getindex + seleLen) + getleng; 
                }
                else
                    getleng = len
            } 
         return i;
     }

     $().ready(function () {
         getloading("");
         $("#btnsave").click(function () {
             if ($("#txtpname").val() == "") { alert("请输入大步骤名称!"); return; }
             if ($("#txtCname_1").val() == "") { if (!confirm("如果没有输入小步骤,将会自动添加默认步骤!")) return; }
             var txtset = "";
             var row = $("#Pgrid").datagrid("getRows");
             for (var i = 0; i < row.length; i++) {
                 txtset += row[i].BindModule;
             }
             for (var i = 1; i < 11; i++) {
                 txtset += $("#txtBind_" + i).val();
             }

             var getcount = getsum(txtset, "Contract");
             if (getcount > 1) { alert("签订合同只能绑定一次!"); return; }
             getcount = getsum(txtset, "Detail");
             if (getcount > 1) { alert("付款只能绑定一次!"); return; }
             getcount = getsum(txtset, "StockUp");
             if (getcount > 1) { alert("备货只能绑定一次!"); return; }
             getcount = getsum(txtset, "Deliver");
             if (getcount > 1) { alert("发货只能绑定一次!"); return; }
             $.ajax({
                 type: "get",
                 url: "Ajax.aspx",
                 data: "type=savelevel&level=" + $("#hdnLevel").val() + "&levelname=" + $("#hdnLevelname").val() + "&" + $("#formPgrid").serialize(),
                 success: function (msg) {
                     if (msg.indexOf("fail:") == -1) {
                         $('#winPgrid').window('close');
                         $("#Pgrid").datagrid("reload");
                         alert(msg);
                     }
                     else
                         alert(msg.split(':')[1]);
                 }
             });
         });
         $("#btnSubmit").click(function () {
             var txtid = ""; var txtvalue = "";
             var intvalue = 0;
             $("input[type='range']").each(function () {
                 txtid += $(this).attr("id") + ",";
                 txtvalue += $(this).val() + ",";
                 intvalue += parseInt($(this).val());
             });
             if (intvalue != 100) { alert("总分值没有100分,请重新调整!"); return; }
             $.ajax({
                 type: "post",
                 datatype: "json",
                 url: "Ajax.aspx?type=precent&txtid=" + txtid + "&txtvalue=" + txtvalue,
                 success: function (msg) {
                     if (msg.indexOf("fail:") == -1) {
                         $("#Pgrid").datagrid("reload");
                         $('#winPrecent').window('close');
                     }
                     else
                         alert(msg.split(':')[1]);
                 }
             });
         });
     })
       

        function getloading(category) {
            $("#Pgrid").datagrid({
                url: "Ajax.aspx?type=LevelGrid&category=" + category
            });
            $("#hdnLevel").val(category);
            if (category == "") $("#hdnLevelname").val("售前步骤");
            else if (category == "1") $("#hdnLevelname").val("售中步骤");
            else if (category == "2") $("#hdnLevelname").val("售后步骤"); 
        }
        function formatterStatus(value, rowData, rowIndex) {
            var showvalue = "";
            showvalue = (value == '1' ? '是' : '否');
            return '<span>' + showvalue + '</span>';
        }
        function formatterModule(value, rowData, rowIndex) {
            var showvalue = "";
            switch (value) {
                case 'Contract': showvalue = '合同签订'; break;
                case 'ContractDetail': showvalue = '付款管理'; break;
                case 'StockUp': showvalue = '备货'; break;
                case 'Deliver': showvalue = '发货'; break;
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
                <h1>进度<small >设置</small> 
                </h1>
                <a class="back-button big page-back"  ></a>
            </div>
        </div> 
    </div>  
</div></div>
    <div data-options="region:'west',split:true" style="width:180px;">
            <div class="typediv" onclick="getloading('')">售前进度</div>
            <div class="typediv" onclick="getloading('1')">售中进度</div>
            <div class="typediv" onclick="getloading('2')">售后进度</div>
      </div>
    <div data-options="region:'center',split:true">
     
     <table class="easyui-datagrid" id="Pgrid" 
            data-options=" 
                singleSelect:true, 
                rownumbers:true, 
                toolbar:toolbar,
                groupField:'Pname',
                view:groupview,
                groupFormatter:function(value,rows){ 
                    return '<div name=\'pdiv\' premark1=\''+rows[0].PRemark1+'\'  style=color:red>步骤:'+rows[0].PRemark1+' '+value + ' -  总:' + rows.length + ' 行数据 分数:'+rows[0].precent+'</div>';
                }
            ">
        <thead>
            <tr>
                <th data-options="field:'ID',hidden:true,width:120">ID</th>
                <th data-options="field:'Pname',hidden:true,width:120">父级</th>
                <th data-options="field:'Pcode',hidden:true,width:120">父级编号</th>
                <th data-options="field:'pid',hidden:true,width:120">父级id</th>
                <th data-options="field:'Code',hidden:true,width:120">编号</th>
                <th data-options="field:'VCode',width:120,hidden:true">编号</th> 
                <th data-options="field:'Cname',width:120">名称</th>
                <th data-options="field:'StatusFlag',width:120" formatter="formatterStatus">启用</th> 
                <th data-options="field:'Remark1',width:120">步骤</th> 
                <th data-options="field:'Remark2',width:120,hidden:true">天数</th> 
                <th data-options="field:'BindModule',width:120" formatter="formatterModule">模块</th>
                
            </tr>
        </thead>
    </table>
    <input type="hidden" id="hdnLevel"/>
    <input type="hidden" id="hdnLevelname"/>
    </div>
    <script type="text/javascript">
         function returnDecimal(e, obj) {
             if (e < 8)
                 event.returnValue = false;
             if (e > 8 && e < 46)
                 event.returnValue = false;
             if ((e > 46 && e < 48) || (e > 105 && e != 229 && e != 110))
                 event.returnValue = false;
             if (e > 57 && e < 96)
                 event.returnValue = false;
             if ((e == 229 || e == 110) )
                 event.returnValue = false;
             counted = parseInt($(obj).val());
         }
         var toolbar = [{
             id: 'btnAdd',
             text: '新增',
             iconCls: 'icon-edit',
             handler: function () {
                 var txtcontrol = "";
                 $("#hdnid").val("");
                 $("#txtpname").val("");
                 if ($("#Pgrid").datagrid('getRows') == 0)
                     $("#txtpRemark1").numberspinner("setValue", "1");
                 else {
                     var txtmax = 1;
                     $("div[name=pdiv]").each(function () {
                         if (parseInt($(this).attr("premark1")) > txtmax)
                             txtmax = parseInt($(this).attr("premark1"));
                     });
                     $("#txtpRemark1").numberspinner("setValue", txtmax + 1);
                 }
                 $("#txtpFlag").combobox("setValue", "0");
                 $("#txtpModule").combobox("setValue", "");
                 $("#txtpStatusFlag").combobox("setValue", "1");
                 for (var i = 1; i < 11; i++) {
                     txtcontrol += "<tr>"
                                    + "<td>" + i + "</td>"
                                    + "<td><input type='text' id='txtCname_" + i + "' name='txtCname_" + i + "' class='fieldItem' field='txtCname_" + i + "' /> </td>"
                                    + "<td><input id='Remark1_" + i + "' name='Remark1_" + i + "' field='Remark1_" + i + "' class='fieldItem'  data-options='min:1' onkeydown='returnDecimal(event.keyCode,this)' style='width:80px;text-align:right;' value='" + i + "' ></input> </td>"
                                    + "<td><input id='Remark2_" + i + "' name='Remark2_" + i + "' field='Remark2_" + i + "' class='fieldItem' data-options='min:1' onkeydown='returnDecimal(event.keyCode,this)' style='width:80px;text-align:right;'></input>天 </td>"
                                     + "<td><select id='txtBind_" + i + "' name='txtBind_" + i + "' class='easyui-combobox fieldItem'   style='width:80px;'><option value='' selected='selected'>不绑定</option><option value='Contract'>签订合同</option><option value='Detail'>付款</option><option value='StockUp'>备货</option><option value='Deliver'>发货</option></select> </td>"
                                    + "<td><select id='txtStatusFlag_" + i + "' name='txtStatusFlag_" + i + "' class='easyui-combobox fieldItem'   style='width:80px;'><option value='1'>启 用</option><option value='2'>停 用</option></select> </td>"
                                 + "</tr>";
                 }
                 $("#tb").html(txtcontrol);
                 $('#winPgrid').window('open');
             }
         }, {
             id: 'btnEdit',
             text: '修改',
             iconCls: 'icon-edit',
             handler: function () {
                 if ($("#Pgrid").datagrid('getSelected') == null) { alert("请选择要修改的数据!"); return; }
                 $.ajax({
                     type: "get",
                     url: url,
                     data: "type=getLevel&pcode=" + $("#Pgrid").datagrid('getSelected').Pcode + "&level=" + $("#hdnLevel").val(),
                     success: function (request) {
                         var q = eval(request);
                         var txtcontrol = "";
                         $("#txtpname").val(q[0].Cname);
                         $("#txtpRemark1").numberspinner("setValue", q[0].Remark1);
                         $("#txtpFlag").combobox("setValue", q[0].PRemark1);
                         $("#txtpModule").combobox("setValue", q[0].Pcode);
                         $("#txtpStatusFlag").combobox("setValue", q[0].StatusFlag);
                         $("#hdnid").val(q[0].ID);
                         for (var i = 1; i < q.length; i++) {
                             var txtselect = "<option value='1' selected='selected'>启 用</option><option value='2'>停 用</option>";
                             var txtbind = "<option value='' selected='selected'>不绑定</option><option value='Contract'>签订合同</option><option value='Detail'>付款</option><option value='StockUp'>备货</option><option value='Deliver'>发货</option>";
                              
                             if (q[i].BindModule == "Contract") txtbind = "<option value='' >不绑定</option><option value='Contract' selected='selected'>签订合同</option><option value='Detail'>付款</option><option value='StockUp'>备货</option><option value='Deliver'>发货</option>";
                             if (q[i].BindModule == "Detail") txtbind = "<option value=''>不绑定</option><option value='Contract'>签订合同</option><option value='Detail' selected='selected'>付款</option><option value='StockUp'>备货</option><option value='Deliver'>发货</option>";
                             if (q[i].BindModule == "StockUp") txtbind = "<option value=''>不绑定</option><option value='Contract'>签订合同</option><option value='Detail'>付款</option><option value='StockUp' selected='selected'>备货</option><option value='Deliver'>发货</option>";
                             if (q[i].BindModule == "Deliver") txtbind = "<option value=''>不绑定</option><option value='Contract'>签订合同</option><option value='Detail'>付款</option><option value='StockUp'>备货</option><option value='Deliver' selected='selected'>发货</option>";
                             if (q[i].StatusFlag != "1") txtselect = "<option value='1'>启 用</option><option value='2' selected='selected'>停 用</option>";
                             txtcontrol += "<tr>"
                                    + "<td>" + i + "</td>"
                                    + "<td><input value='" + q[i].Cname + "' type='text' id='txtCname_" + i + "' name='txtCname_" + i + "' class='fieldItem' field='txtCname_" + i + "' /> </td>"
                                    + "<td><input value='" + q[i].Remark1 + "' id='Remark1_" + i + "' name='Remark1_" + i + "' field='Remark1_" + i + "' class='fieldItem'  data-options='min:1' onkeydown='returnDecimal(event.keyCode,this)' style='width:80px;text-align:right;' value='" + i + "' ></input> </td>"
                                    + "<td><input value='" + q[i].Remark2 + "' id='Remark2_" + i + "' name='Remark2_" + i + "' field='Remark2_" + i + "' class='fieldItem' data-options='min:1' onkeydown='returnDecimal(event.keyCode,this)' style='width:80px;text-align:right;'></input>天 </td>"
                                   //  + "<td><select id='txtBind_" + i + "' name='txtBind_" + i + "' class='easyui-combobox fieldItem'   style='width:80px;'>" + txtbind + "</select> </td>"
                                    + "<td><select id='txtStatusFlag_" + i + "' name='txtStatusFlag_" + i + "' class='easyui-combobox fieldItem'   style='width:80px;'>" + txtselect + "</select> </td>"
                                + "</tr>";
                         }
                         for (var i = 11 - (11 - q.length); i < 11; i++) {
                             txtcontrol += "<tr>"
                                    + "<td>" + i + "</td>"
                                    + "<td><input type='text' id='txtCname_" + i + "' name='txtCname_" + i + "' class='fieldItem' field='txtCname_" + i + "' /> </td>"
                                    + "<td><input id='Remark1_" + i + "' name='Remark1_" + i + "' field='Remark1_" + i + "' class='fieldItem'  data-options='min:1' onkeydown='returnDecimal(event.keyCode,this)' style='width:80px;text-align:right;' value='" + i + "' ></input> </td>"
                                    + "<td><input id='Remark2_" + i + "' name='Remark2_" + i + "' field='Remark2_" + i + "' class='fieldItem' data-options='min:1' onkeydown='returnDecimal(event.keyCode,this)' style='width:80px;text-align:right;'></input>天 </td>"
                                     // + "<td><select id='txtBind_" + i + "' name='txtBind_" + i + "' class='easyui-combobox fieldItem'   style='width:80px;'><option value='' selected='selected'>不绑定</option><option value='Contract'>签订合同</option><option value='Detail'>付款</option><option value='StockUp'>备货</option><option value='Deliver'>发货</option></select> </td>"
                                    + "<td><select id='txtStatusFlag_" + i + "' name='txtStatusFlag_" + i + "' class='easyui-combobox fieldItem'   style='width:80px;'><option value='1' selected='selected'>启 用</option><option value='2'>停 用</option></select> </td>"
                                 + "</tr>";
                         }
                         $("#tb").html(txtcontrol);
                         $('#winPgrid').window('open');
                     }
                 });


             }
         }, {
             id: 'btnDelete',
             text: '删除',
             iconCls: 'icon-remove',
             handler: function () {
                 if ($("#Pgrid").datagrid('getSelected') == null) { alert("请选择要删除的数据!"); return; }
                 var count = 0;
                 for (var i = 0; i < $("#Pgrid").datagrid('getRows').length; i++) {
                     if ($("#Pgrid").datagrid('getSelected').Pcode == $("#Pgrid").datagrid('getRows')[i].Pcode)
                         count++;
                 }
                 $("#hdnpid").val($("#Pgrid").datagrid('getSelected').pid);
                 $("#hdnsid").val($("#Pgrid").datagrid('getSelected').ID);
                 $("#hdnpcode").val($("#Pgrid").datagrid('getSelected').Pcode);
                 if (count < 2) {
                     alert("因为当前仅有一步小步,故只能删除大步!");
                     $("#btnsdelete").css("display", "none");
                     $('#winDelete').window('open');
                 }
                 else {

                     $("#btnsdelete").css("display", "block");
                     $("#btnsdelete").css("width", "120px");
                     $('#winDelete').window('open');
                 }
             }
         }, {
             id: 'btnPrecent',
             text: '设置分值',
             iconCls: 'icon-edit',
             handler: function () {
                 if ($("#Pgrid").datagrid('getRows') != 0) {
                     $.ajax({
                         type: "get",
                         url: url,
                         data: "type=getPLevel&level=" + $("#hdnLevel").val(),
                         success: function (request) {
                             var q = eval(request);
                             var txtcontrol = "<table id='Precentdt' style='width:100%;'>";
                             for (var i = 0; i < q.length; i++) {
                                 var txtvalue = "0";
                                 if (q[i].Remark2 != "0" && q[i].Remark2 != "") txtvalue = q[i].Remark2;
                                 txtcontrol += "<tr style='vertical-align: bottom;'><td>" + q[i].Cname + ":</td><td><div>"
                                + "<input style='margin-left:12px;' id='" + q[i].ID + "' name='range' type='range' min=0 max=100 value=" + txtvalue + ">"
                                + "<output for='" + q[i].ID + "'>" + txtvalue + "</output>"
                                + "</div></td><td><input onkeydown='txtkeydown(this)' onkeyup='txtkeyup(this,true)' onchange='txtkeyup(this,false)' name='rangevalue' type='number' id='txt" + q[i].ID + "' value='" + txtvalue + "' style='width:60px'></td></tr>";
                             }
                             txtcontrol += "</table>";
                             $("#divPrecent").html(txtcontrol);
                             $('#winPrecent').window('open');
                             setoutput();
                         }
                     });
                 }
                 else
                 { alert("当前没有项可以设置分值!"); return; }
             }
         }
        ];
         var rangeoldvalue = 0;
         function txtkeydown(obj) {
             var el = $(obj);  
             rangeoldvalue = el.val(); 
         }
         function txtkeyup(obj,boolflag) {
             var el, newPoint, newPlace, offset;
             var txtM = 100;
             txtM = 100;
             el = $(obj); 
             $("input[name='rangevalue']").each(function () {
                 txtM = txtM - parseInt($(this).val()); 
             });
             if (txtM < 0) {
                 if (boolflag) el.val(rangeoldvalue);
                 else el.val(parseInt(el.val()) - 1);
                 return;
             }
             $("input[type='range']").each(function () {
                 var txtvalue = parseInt($(this).parent().parent().next("td").find("input").eq(0).val());
                 if (txtvalue == 0) {
                     $(this).attr("max", txtM);
                 }
                 else {
                     $(this).attr("max", txtM + txtvalue);
                     $(this).val(txtvalue);  
                 }
                 $(this).next("output").css({ left: selectoutput(this).split(',')[0], marginLeft: selectoutput(this).split(',')[1] + "%" }).text($(this).val());
             });
           }
         function setoutput() {
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
                     $(this).parent().parent().next("td").find("input").eq(0).val($(this).val());
                     $(this).next("output").css({ left: selectoutput(this).split(',')[0], marginLeft: selectoutput(this).split(',')[1] + "%" }).text($(this).val());
                 });

                 el.next("output").css({ left: selectoutput(this).split(',')[0], marginLeft: selectoutput(this).split(',')[1] + "%" }).text(el.val());
             }).trigger('change');
         }
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
         function deletepgrid(type, txtid) {
             var txtshow = "是否确认删除?";
             if (type == "P") txtshow = "是否确认删除?\r(注:删除大步骤将同时删除该步骤下的所有小步骤!)";
             if (confirm(txtshow)) {
                 $.ajax({
                     type: "post",
                     datatype: "json",
                     url: "Ajax.aspx?type=deletegrid&txtid=" + txtid + "&isPcode=" + type + "&pcode=" + $("#hdnpcode").val(),
                     success: function (msg) {
                         if (msg.indexOf("fail:") == -1) {
                             $("#Pgrid").datagrid("reload");
                             $('#winDelete').window('close');
                             alert(msg);
                         }
                         else
                             alert(msg.split(':')[1]);
                     }
                 });
             }
         }
	</script> 
    </form> 
    <div id="winDelete" class="easyui-window" data-options="title:'删除操作',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 370px; height: 90px;">
        <input type="hidden" name="hdnpid" id="hdnpid"/>
        <input type="hidden" name="hdnpcode" id="hdnpcode"/>
        <input type="hidden" name="hdnsid" id="hdnsid"/>
        <a class="easyui-linkbutton" style="float:left;" id="btnpdelete" data-options="iconCls:'icon-remove'"
                onclick="javascript: deletepgrid( 'P',$('#hdnpid').val());">删除大步骤</a> 
        <a class="easyui-linkbutton" style="float:left; id="btnsdelete" data-options="iconCls:'icon-remove'" 
                onclick="javascript: deletepgrid( 'S',$('#hdnsid').val());">删除小步骤</a>
        <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="javascript: $('#winDelete').window('close');">取消</a>
    </div>
    <div id="winPrecent" class="easyui-window" data-options="title:'设定分值',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 500px; height: 500px;">
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
        style="width: 800px; height: 580px;">
        <form name="formPgrid" id="formPgrid" status="Pgrid">
        <fieldset><legend>大步骤</legend>
        <input type="hidden" name="hdnid" id="hdnid"/>
        <table> 
            <%--<li> <label>编号:</label><input type="text" name="txtVCode" id="txtVCode" readonly="true"/></li>--%>
            <tr> 
                <td>名称:</td>
                <td><input type="text" id="txtpname" name="txtpname" /> </td>
                <td>步骤:</td>
                <td>
                 <input id="txtpRemark1" class="easyui-numberspinner fieldItem"  name="txtpRemark1"  data-options="min:1"
                 style="width:80px;" field="Remark1" ></input> 
                </td>
                <td>是否关键:</td>
                <td> 
                    <select class="easyui-combobox" name="txtpFlag" data-options="panelHeight:'auto'"  id="txtpFlag" style="width:80px;">
                        <option value="0">否</option>
		                <option value="1">是</option>
                    </select> 
               </td>
               <td>启用:</td>
                <td>
                    <select class="easyui-combobox" name="txtpStatusFlag"   data-options="panelHeight:'auto'"  id="txtpStatusFlag" style="width:80px;">
                        <option value="1" >启 用</option>
		                <option value="2">停 用</option>
                    </select> 
               </td> 
            </tr>
            <%--<tr>  
                <td>绑定模块:</td>
               <td>
                    <select class="easyui-combobox" name="txtpModule" data-options="panelHeight:'auto'"  id="txtpModule" style="width:170px;">
                        <option value="">无</option>
                        <option value="Contract">合同签订</option>
		                <option value="ContractDetail">付款</option>
                    </select>
               </td> 
               <td>启用:</td>
                <td>
                    <select class="easyui-combobox" name="txtpStatusFlag"   data-options="panelHeight:'auto'"  id="txtpStatusFlag" style="width:80px;">
                        <option value="1" >启 用</option>
		                <option value="2">停 用</option>
                    </select> 
               </td> 
            </tr>  --%>
           </table>
        </fieldset>
        <fieldset><legend>小步骤</legend>
        <div class="metrouicss">
          <table style="width: 700px;">
            <thead>
              <th>NO.</th>
              <th style="text-align:center">名称</th>
              <th style="text-align:center">步骤</th>
              <th style="text-align:center">多久提醒</th>
              <th style="text-align:center">绑定模块</th>
              <th style="text-align:center">启用</th>
            </thead>
            <tbody id="tb" style="text-align:center">
              
            </tbody>
          </table>
          </div>
        </fieldset>
          <div data-options="region:'south',border:false" style="text-align: center; padding: 10px 0 0;"
            class="formItem"> 
            <a class="easyui-linkbutton" id="btnsave" data-options="iconCls:'icon-save'">确认</a> 
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                onclick="javascript: $('#winPgrid').window('close');">关闭</a>
          </div>
        </form>
    </div>
</body>
</html>
