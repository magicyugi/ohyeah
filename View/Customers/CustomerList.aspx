<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerList.aspx.cs" Inherits="AppBox.View.Customers.CustomerList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title> 
    <link href="../../common/history/css/history.css" rel="stylesheet" type="text/css" />
    <script src="../../common/history/js/history.js" type="text/javascript"></script> 
    <script src="../../common/js/tooltip.js" type="text/javascript"></script>  
    <script src="../SysCodeManage/datagrid-groupview.js" type="text/javascript"></script>   
    <style>
     li.normalli
        {
            text-align: right;
            width: 70%;
            height: 30px;
            padding-top: 5px; 
            padding-bottom: 5px;
        }
        #editul li {
           float:left;
           width:50%;
           list-style:none;
        }
        #visitul li {
            float:left;
           width:50%;
           list-style:none;
           text-align:left;
        }
	.range-picker-axis{padding:0;position:relative;width:198px;height:2px;border:1px solid #CCC;display:inline-block;border-radius:2px;z-index:1;}
	.range-picker{position:absolute;width:10px;height:10px;border:1px solid #BBB;z-index:3;top:-5px;border-radius:2px;cursor:pointer;background-color:#FFF;}
	.range-picker.left{left:-4px;}
	.range-picker.right{right:-4px;}
	.range-picker.active{background-color:#CCC;}
	.range-selected{background-color:#CCC;z-index: 2;position: absolute;width:100%;}
	.datagrid-ftable{ color:Red;}
	.datagrid-group{background-color:lightgray;}
    </style>
   <script src="../../easyui/js/datagrid-detailview.js" type="text/javascript"></script>
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Customer";
        var dealdate = false;
        var boolflag = false;

        var txtwhere = "&ProcessFlag=" + request("ProcessFlag") + "&Category=" + request('Category') + "&Date=" + request("Date");
        $().ready(function () {

            $("#hdnid").val(request('id'));
            $("#hdntxtid").val(request('txtid'));
            $.ajax({
                url: url,
                data: "type=dropdown",
                success: function (msg) {
                    $('#txtSex').combobox({
                        data: eval("[{Code:'先生',Cname:'先生'},{Code:'女士',Cname:'女士'}]"),
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtGuideCode').combobox({
                        data: eval(msg)[0].item0,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtGuideCode1').combobox({
                        data: eval(msg)[0].item0,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtGuide1').combobox({
                        data: eval(msg)[0].item0,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtQuestionCode').combobox({
                        data: eval(msg)[1].item1,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtWareHouse_Code').combobox({
                        data: eval(msg)[4].item4,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                }
            });
            $("#btnSave").click(function () {  
                SaveRecord(url, namecode);
            });

            $("#btn_Visit").click(function () {
                if ($("#txtNextVisitDate").datebox("getValue") == "") { alert("请输入下次联系时间!"); return;}
                var gridid = "#gridCustomer";
                var id = "";
                if ($(gridid).datagrid("getSelections").length > 0) id = $(gridid).datagrid("getSelections")[0].ID; 
                $.ajax({
                    url: url,
                    type: "post",
                    data: "type=addvisit&" + $("#formvisit").serialize()+"&id="+id,
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            alert("保存成功!");
                            $("#winvisit").window("close");
                            $(gridid).datagrid('clearSelections');
                        }
                        else
                            alert(msg.split(':')[1]);
                    }
                });
            });
            $('#gridPayment').datagrid({
                view: detailview,
                detailFormatter: function (index, row) {
                    return '<div style="padding:2px"><table class="ddv"></table></div>';
                },
                onExpandRow: function (index, row) {
                    var ddv = $(this).datagrid('getRowDetail', index).find('table.ddv');
                    ddv.datagrid({
                        url: 'Ajax.aspx?type=gridPaymentDetail&code=' + row.Code + '&id=' + row.ID,
                        fitColumns: true,
                        singleSelect: true,
                        rownumbers: true,
                        loadMsg: '',
                        height: 'auto',
                        sortName: 'Price',
                        sortOrder: 'desc',
                        columns: [[
                            { field: 'Product_Code', title: '商品SKU', width: 200 },
                            { field: 'ProductName', title: '商品名称', width: 100 },
                            { field: 'Price', title: '单价', width: 100, align: 'right', sortable: 'true' },
                            { field: 'TotalCount', title: '数量', width: 100, align: 'right' },
                            { field: 'ProductVCode', title: '商品编号', width: 100 },
                            { field: 'Key1', title: '商品编号', width: 100, align: 'right', hidden: true },
                            { field: 'Key2', title: '颜色', width: 100, align: 'center' },
                            { field: 'Key3', title: '尺码', width: 100, align: 'center' },
                            { field: 'Unit_Code', title: '单位', width: 100, align: 'center', hidden: true }
                        ]],
                        onResize: function () {
                            $('#gridPayment').datagrid('fixDetailRowHeight', index);
                        },
                        onLoadSuccess: function () {
                            setTimeout(function () {
                                $('#gridPayment').datagrid('fixDetailRowHeight', index);
                            }, 0);
                        }
                    });
                    $('#gridPayment').datagrid('fixDetailRowHeight', index);
                }
            });
            $('#ddpCountry').combobox({
                onSelect: function (s) {
                    $('#ddpCity').combobox('clear');
                    $('#ddpProvince').combobox({
                        url: 'Ajax.aspx?type=Province&Pcode=' + s.Code + '&rd=' + Math.random(),
                        onSelect: function (ss) {
                            $('#ddpCity').combobox({
                                url: 'Ajax.aspx?type=City&Pcode=' + ss.District + '&rd=' + Math.random()
                            });
                        }
                    });

                }
            });
            //$("#btn_Search").click(function () {
            //    Search('txtSearch', 'Customer', 'search');
            //    txtwhere = "&value=" + $("#txtSearch").val() + "&ProcessFlag=" + request("ProcessFlag") + "&Category=" + request('Category') + "&Date=" + request("Date");
            //});
            $("#btnSupSave").click(function () {
                SupSearch("Ajax.aspx?ProcessFlag=" + request("ProcessFlag") + "&Category=" + request('Category') + "&Date=" + request("Date"), 'Customer', 'Search');
                txtwhere = "&ProcessFlag=" + request("ProcessFlag") + "&" + $("#winSearch").serialize() + "&Category=" + request('Category') + "&Date=" + request("Date");
            });
            $("#btnGuide").click(function () {
                if ($("#txtGuideCode1").combobox('getText') == "") { alert("请选择分配的业务员!"); return; }
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?type=" + $("#formGuide").attr("status") + "&id=" + $("#gridCustomer").datagrid("getSelections")[0].ID + "&guidename=" + $("#txtGuideCode1").combobox('getText'),
                    data: $('#formGuide').serialize(),
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            $("#gridCustomer").datagrid("reload");
                            $('#WinGuide').window('close');
                            alert("分配成功!");
                        }
                        else
                            alert(msg.split(':')[1]);
                    }
                });
            });
             
            $(".page-back").click(function () { window.location.href = '../../TilePanel.aspx' + '?on=' + request('on'); });
            //权限*************************************
            $.ajax({
                url: url,
                data: "type=Role&RoleCode=0504",
                success: function (msg) {
                    var txtmsg = msg.split(',');
                    for (var i = 0; i < txtmsg.length; i++) {
                        $("#" + txtmsg[i]).css("display", "none");
                    }
                }
            });
            appendHM(30);
        });

        function btntype(flag) {
            if (flag == undefined) flag = "";
            $("#gridCustomer").datagrid({ "url": "Ajax.aspx?type=list&intentionflag=" + flag + "&Category=" + request('Category') + "&Date=" + request('Date') });
            //window.location.href = "CustomerList.aspx?intentionflag=" + flag;
        }

        //拖动drag和drop都是datagrid的头的datagrid-cell  
        function drag() {
            $('.datagrid-header-inner .datagrid-cell').draggable({
                revert: true,
                proxy: 'clone'
            }).droppable({
                accept: '.datagrid-header-inner .datagrid-cell',
                onDrop: function (e, source) { //取得拖动源的html值  
                    var src = $(e.currentTarget.innerHTML).html(); //取得拖动目标的html值  
                    var sou = $(source.innerHTML).html();
                    var tempcolsrc;//拖动后源和目标列交换  
                    var tempcolsou; var tempcols = [];
                    for (var i = 0; i < cols.length; i++) {
                        if (cols[i].title == sou) {
                            tempcolsrc = cols[i];//循环读一遍列把源和目标列都记下来 
                        }
                        else if (cols[i].title == src) {
                            tempcolsou = cols[i];
                        }
                    }
                    for (var i = 0; i < cols.length; i++) { //再循环一遍，把源和目标的列对换  
                        var col = {
                            field: cols[i].field,
                            title: cols[i].title,
                            align: cols[i].align,
                            width: cols[i].width
                        };
                        if (cols[i].title == sou) {
                            col = tempcolsou;
                        }
                        else if (cols[i].title == src) {
                            col = tempcolsrc;
                        }
                        tempcols.push(col);
                    }
                    cols = tempcols; //1秒后执行重绑定datagrid操作。可能是revert需要时间,这边如果没有做延时就直接重绑 就会出错。
                    //我目前的水平就想到这个笨办法,各位如果有好的想法建议可以提出来讨论下。 
                    // timeid = setTimeout("init()", 1000);
                }
            });
        }

        var Common = {

            TimeFormatter: function (value, rec, index) {
                if (value == undefined) {
                    return "";
                }
                /*json格式时间转js时间格式*/
                value = value.substr(2, value.length - 5);

                return value;
            },
            CustomerTypeFormatter: function (value, rowData, rowIndex) {
                var showvalue = "";
                if (value == '私海') showvalue = '<a  href="JavaScript:btn_Customertype(\'放弃\',\'' + rowData["Code"] + '\')" class="editbutton">放弃</a>';
                if (value == '公海') showvalue = '<a  href="JavaScript:btn_Customertype(\'跟进\',\'' + rowData["Code"] + '\')" class="editbutton">跟进</a>';
                return showvalue;
            },
            BoolFormatter: function (value, rec, index) {
                if (value == undefined || value == "") value = "<span style='color:red;font-weight:bolder'>×</span>";
                else
                    value = "<span style='color:green;font-weight:bolder'>√</span>";

                /*json格式时间转js时间格式*/

                return value;
            }

        };

        function btn_Customertype(type,code) { 
            if (confirm("是否确定" + type + "该用户!"))
            {
                $.ajax({
                    type: "post",
                    datatype: "json",
                    url: "Ajax.aspx?type=ChangeCustomer&value=" + type + "&code=" + code,
                    success: function (msg) {
                        if (msg.indexOf("fail:") == -1) {
                            $("#gridCustomer").datagrid("reload"); 
                            alert(type+"成功!");
                        }
                        else
                            alert(msg.split(':')[1]);
                    }
                });
            } 
        }

        function btnXlsExport_Click() {
            var frozenColumns = $("#gridCustomer").datagrid("options").frozenColumns;
            var columns = $("#gridCustomer").datagrid("options").columns;
            var txttitle = "";
            var txtfiles = "";
            for (var i = 0; i < frozenColumns[0].length; i++) {
                if (!frozenColumns[0][i].hidden) {
                    txttitle += frozenColumns[0][i].title + ",";
                    txtfiles += frozenColumns[0][i].field + ",";
                }
            }
            for (var i = 0; i < columns[0].length; i++) {
                if (!columns[0][i].hidden) {
                    txttitle += columns[0][i].title + ",";
                    txtfiles += columns[0][i].field + ",";
                }
            }
            txttitle = txttitle.substring(0, txttitle.length - 1);
            txtfiles = txtfiles.substring(0, txtfiles.length - 1);
            $("#hdntitle").val(txttitle);
            $("#hdnfiles").val(txtfiles);
            $("#hdnintentionflag").val(request("ProcessFlag"));
            $("#hdncategory").val(request('Category'));
            $("#hdndate").val(request('Date'));
            $("input[type=submit]").eq(0).click();
            //        $.ajax({
            //            url: url,
            //            data: "type=getExecl&txttitle=" + txttitle + "&txtfiles=" + txtfiles + txtwhere,
            //            success: function (msg) {
            //                alert(msg);
            //            }
            //        });
        }
        function setCreditLevel() {

            //        setTimeout(, 10);
        }


        function keypress() {
            if (event.keyCode == 13) {
                event.returnValue = false;
            }
        }
        function btn_onclick(type) { 
            if (type == "edit") {
                if ($("#gridCustomer").datagrid("getSelected") != null) { 
                    if ($("#gridCustomer").datagrid("getSelections")[0].CustomerType1 == "公海") { alert("不能编辑公海客户,请跟进后操作!"); return; }
                    $("#winCustomer").window("open");
                }
                else
                    alert("请选中需要编辑的客户!");
            }
            else if (type == "add") {
                if ($("#gridCustomer").datagrid("getSelected") != null) { 
                    if ($("#gridCustomer").datagrid("getSelections")[0].CustomerType1 == "公海") { alert("不能联系公海客户,请跟进后操作!"); return; }
                    $("#winvisit").window("open");
                }
                else
                    alert("请选中需要联系的客户!");
            }
            else if (type == "visit") {
                if ($("#gridCustomer").datagrid("getSelected") != null) {
                    
                    $("#winhistory").window("open");
                }
                else
                    alert("请选中需要查看的客户!");
            }
            else if (type == "salebill") {
                if ($("#gridCustomer").datagrid("getSelected") != null) {
                    
                    $("#wingridPayment").window("open");
                }
                else
                    alert("请选中需要查看的客户!");
            }
            else if (type == "excel") { btnXlsExport_Click(); }
            else if (type == "print") {
                if ($("#gridCustomer").datagrid("getSelected") != null) {
                    var obj = new Object();
                    window.showModalDialog("CustomerPrint.aspx?type=print&code=" + $("#gridCustomer").datagrid("getSelections")[0].Code, obj, "dialogWidth=1024px;dialogHeight=700px");
                }
                else
                    alert("请选中需要打印的客户!");
            }
            else if (type == "search") {
                var txtsearch = $("#txtSName").val() + ";" + $("#txtSCname").val() + ";" + $("#txtSPhone").val();
                $('#gridCustomer').datagrid({
                    url: 'Ajax.aspx?type=list&strSearch=' + txtsearch + '&id=' + request('id') + '&txtid=' + request('txtid')
                });
            }
        }
        function LoadPayment(code) {
            $('#gridPayment').datagrid({
                url: 'Ajax.aspx?type=gridPayment&code=' + code
            });
              
        }
    </script>
    
</head>
<body class="easyui-layout">
    <form id="Form1" runat="server">
    <asp:Button ID="btnExcel" runat="server" Visible="true" OnClick="btnExcel_Click"/>
    <div region="north" style="height: 110px;">
        <div style="padding:5px 0;margin-top: 5px">
            <a href="JavaScript:btn_onclick('edit')" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">客户编辑</a>
            <a href="JavaScript:btn_onclick('add')" class="easyui-linkbutton" data-options="iconCls:'icon-add'">联系客户</a>
            <a href="JavaScript:btn_onclick('visit')" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查看通讯记录</a>
            <a href="JavaScript:btn_onclick('salebill')" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查看购买记录</a>
            <a href="JavaScript:btn_onclick('excel')" class="easyui-linkbutton" data-options="iconCls:'icon-undo'">批量导出</a>
            <a href="JavaScript:btn_onclick('print')" class="easyui-linkbutton" data-options="iconCls:'icon-print'">打印</a>
        
        </div>
        <fieldset style="margin-top: 15px"> 
               客户昵称:<input type="text" id="txtSName" runat="server" placeholder="请输入客户昵称." />
               姓名:<input type="text" id="txtSCname" runat="server" placeholder="请输入姓名." />  
               手机:<input type="text" id="txtSPhone" runat="server" placeholder="请输入手机." />   
               <a href="JavaScript:btn_onclick('search')" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>         
                               
        </fieldset> 
    </div>  
    <asp:HiddenField ID="hdntitle" runat="server" Value="" />
    <asp:HiddenField ID="hdnfiles" runat="server" Value="" />
    <asp:HiddenField ID="hdnintentionflag" runat="server" Value="" />
    <asp:HiddenField ID="hdncategory" runat="server" Value="" />
    <asp:HiddenField ID="hdndate" runat="server" Value="" /> 
     <asp:HiddenField ID="hdnid" runat="server" Value="" />
    <asp:HiddenField ID="hdntxtid" runat="server" Value="" />

    <div region="center" style="width:100%" title="<div id=divbutton >客户列表【用于对客户信息进行维护、进行客户回访、签约、客户转移】</div>">
         
        <table class="easyui-datagrid"  id="gridCustomer" style=" height:450px;"  
         data-options=" pageList: [15, 50, 100], rownumbers: true, pagination: true, singleSelect: true,fit:true,
                onClickRow: function (rowIndex, rowData) {
                loadHistory(rowData['Code'], '../Visit/Ajax.aspx', '');
                LoadData(url, rowData['Code']);
                
                LoadPayment( rowData['Code']);
               
            }, onLoadSuccess: function (data) { 
                //drag();
                $('#gridCustomer').datagrid('doCellTip', { cls: { 'background-color': 'white' }, delay: 300 }); 
                $('.editbutton').linkbutton({plain:true,iconCls:'icon-edit'});  
                //$.parser.parse('.divparse');
              
            },url: 'Ajax.aspx?type=list&ProcessFlag=' + request('ProcessFlag') + '&Date=' + request('Date') + '&Category=' + request('Category')+'&id='+request('id')+'&txtid='+request('txtid')+ '&StartDate=' +request('StartDate')  + '&EndDate=' + request('EndDate') 
                "
         sortName="CreditLevel" sortOrder="desc" rownumbers="true" pagination="true">
            <thead>
                <tr>
                    <th data-options="field:'ID',hidden:true,width:80">
                        代码
                    </th>
                    <th data-options="field:'CustomerType1',width:50" >
                        类型
                    </th>
                    <th data-options="field:'CustomerType',width:80,align:'center'"  formatter="Common.CustomerTypeFormatter">
                        操作
                    </th>
                    <th data-options="field:'Code',hidden:true,width:80">
                        代码
                    </th>
                    <th data-options="field:'IntentionFlagName',width:50,align:'right'">
                        状态
                    </th>
                    <th data-options="field:'Cname',width:120" sortable="true">
                        名称
                    </th>
                    <th data-options="field:'Company',hidden:true,width:100">
                        公司
                    </th>    
                    <th data-options="field:'Mobile',width:100">
                        手机
                    </th> 
                   <th data-options="field:'Country',width:100">
                        国家
                    </th>
               <th data-options="field:'Province',  width:80" sortable="true">
                        省份
                    </th>  
                    <th data-options="field:'City',width:100">
                            市级
                        </th>
                        <th data-options="field:'Email',width:100">
                            Email
                        </th>
                         <th data-options="field:'Price',width:100 ">
                        交易金额
                        </th>
                        <th data-options="field:'Creater',width:100 ">
                        交易次数
                        </th> 
                    <th formatter="Common.TimeFormatter" data-options="field:'DealDate', width:120" sortable="true">
                        最近下单时间
                    </th>
                    
             </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
       
    </div>
     
    </form> 
    <div id="winhistory" class="easyui-window" data-options="title:'回访记录',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 500px; height: 500px;"> 
            <div class="history"></div>  
    </div>
    <div id="wincustomerDefine" class="easyui-window" data-options="title:'基础信息',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 350px; height: 400px;"> 
           <ul class="customerdefine" id="customerDefine" runat="server">
                </ul> 
    </div>
    <div id="winvisit" class="easyui-window" data-options="title:'联系客户',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 500px; height: 320px;"  status="addvisit"> 
            <form name="formvisit" id="formvisit" status="addvisit">
        
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0;">
            <ul id="visitul" style="overflow: hidden;">
                <li>
                    <label for="txtCode">
                        客户卡号:</label><input type="text" name="Code" id="txtVcode" style="width:150px;height:23px;"  class="fieldItem" field="Code"
                            readonly="true" /></li>
                <li>
                    <label for="txtCname">
                        客户名称:</label><input type="text" name="Cname" id="txtVcname" style="width:150px;height:23px;"  class="fieldItem" field="Cname" /></li>
                <li>
                    <label for="txtMobile">
                        手&nbsp;&nbsp;机&nbsp;&nbsp;号:</label><input type="text" name="Mobile" id="txtVMobile" style="width:150px;height:23px;"  class="fieldItem" field="Mobile" /></li>
                <li>
                    <label for="txtVisitTitle">
                        主&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;题:</label><input type="text" name="VisitTitle" id="txtVisitTitle" style="width:150px;height:23px;"  class="fieldItem" field="VisitTitle" /></li>
                <li style="width:100%">
                    <label for="txtSex">
                        内容:</label>
                    <textarea name="VisitContent" id="txtVisitContent" style="width:438px;" rows="5" class="fieldItem" field="VisitContent"></textarea>
                </li>
                <li style="width:100%">
                        <label for="txtNextVisitTime"  style="float:left;"   >
                            下次提醒时间:</label><div style="float:left;"><input type="text" name="NextVisitDate" id="txtNextVisitDate" class="fieldItem easyui-datebox" required="true"    style="width:140px;"    field="NextVisitDate" /> 
                           <select name="HM" id="txtHM"   class="fieldItem hm"   style="font-size:16px;"   field="HM" ></select>  
                           </div>
                </li> 
                <li style="width:100%">
            <%-- <div style="float:left">是否短信提醒</div>--%>
                <label for="txtNextVisitContent" style="float:left;"  >
                    联&nbsp;&nbsp;系&nbsp;&nbsp;计&nbsp;&nbsp;划:</label><input name="NextVisitContent" style="float:left;"  id="txtNextVisitContent"  class="easyui-validatebox fieldItem" field="NextVisitContent"    required="true"     /> 
               </li>
            </ul>
            <div data-options="region:'south',border:false" style="text-align:center; padding: 5px 0 0; width:100%;">
                <a class="easyui-linkbutton" id="btn_Visit" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winvisit').window('close');">取消</a>
            </div>
        </div>
        </form>
    </div>
    <div id="wingridPayment" class="easyui-window" data-options="title:'订单记录',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 950px; height: 530px;"> 
            <table class="easyui-datagrid" id="gridPayment" style="width: 930px;height:480px;" 
                    data-options=" pageList:[15,50,100],rownumbers:true,pagination:true,singleSelect:true,
                      showFooter: true"
                     sortName="LeftMoney" sortOrder="desc">
                    <thead>
                        <tr>
                            <th data-options="field:'Code',width:130">
                        订单号
                    </th>
                    <th data-options="field:'Bill_Code',width:110">
                        来源单号
                    </th>
                    <th data-options="field:'BillFromName',width:80">
                        交易来源
                    </th>
                    <th data-options="field:'BuyerCode',width:80,hidden:true">
                        买家昵称
                    </th>
                    <th data-options="field:'BuyerName',width:80,hidden:true">
                        买家昵称
                    </th>
                    <th data-options="field:'TotalCount',width:60,align:'right'">
                        数量
                    </th>
                    <th data-options="field:'Weight',width:60,align:'right'">
                        总重量
                    </th>
                    <th data-options="field:'BillAmount',width:80,align:'right'">
                        总金额
                    </th>
                    <th data-options="field:'Freight',width:80,align:'right'">
                        运费
                    </th>
                    <th data-options="field:'TotalAmount',width:80,align:'right'">
                        整单实收
                    </th>
                    <th data-options="field:'BillDate',width:80">
                        下单时间
                    </th>
                    <th data-options="field:'PayDate',width:80">
                        收款时间
                    </th>
                    <th data-options="field:'ReceiverName',width:60">
                        收件人
                    </th>
                    <th data-options="field:'ReceiverZip',width:60,hidden:true">
                        收件邮编
                    </th>
                    <th data-options="field:'ReceiverEmail',width:60">
                        邮件地址
                    </th>
                    <th data-options="field:'ReceiverMobile',width:60,hidden:true">
                        手机号码
                    </th>
                    <th data-options="field:'ReceiverPhone',width:60,hidden:true">
                        电话
                    </th>
                    <th data-options="field:'ReceiverCountry',width:60">
                        国家
                    </th>
                    <th data-options="field:'ReceiverState',width:60">
                        省
                    </th>
                    <th data-options="field:'ReceiverCity',width:60">
                        市
                    </th>
                    <th data-options="field:'ReceiverDistrict',width:60">
                        县、区
                    </th>
                    <th data-options="field:'Address',width:300">
                        地址
                    </th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
    </div>
    <div id="winCustomer" class="easyui-window" data-options="title:'客户编辑',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 550px; height: 250px;" status="addcustomer">
        <form name="formCustomer" id="formCustomer" status="addcustomer">
        
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0;">
            <ul id="editul" style="overflow: hidden;">
                <li>
                    <label for="txtCode">
                        客户卡号:</label><input type="text" name="Code" id="txtCode" style="width:150px;height:23px;"  class="fieldItem" field="Code"
                            readonly="true" /></li>
                <li>
                    <label for="txtCname">
                        客户名称:</label><input type="text" name="Cname" id="txtCname" style="width:150px;height:23px;"  class="fieldItem" field="Cname" /></li>
                <li>
                    <label for="txtMobile">
                        手机号:</label><input type="text" name="Mobile" id="txtMobile" style="width:150px;height:23px;"  class="fieldItem" field="Mobile" /></li>
                <li>
                    <label for="txtTel">
                        Email:</label><input type="text" name="Email" id="txtEmail" style="width:150px;height:23px;"  class="fieldItem" field="txtEmail" /></li>
               
                <li>
                    <label for="txtAddress">
                        地址:</label>
                    <input type="text" id="txtAddress" name="Address" style="width:150px;height:23px;" class="fieldItem" field="Address" />
                </li>
                <li  style="width:100%">
                  <div style="float:left;width: 20%;"><label style="float: right;">国家：</label></div>
                     <div style="width:80%;float:left;text-align: left;"><input  class="easyui-combobox" name="ddpCountry" id="ddpCountry" field="Country"  style=" width:100px" data-options="
                                url:'Ajax.aspx?type=Country&rd='+Math.random(), 
                                valueField: 'Code',
                                textField: 'Name_CN',
                                editable:false
                            "/>  
                <span>&nbsp;-&nbsp;</span>
                            <input class="easyui-combobox" name="ddpProvince" id="ddpProvince" style=" width:100px" field="Province" data-options="
                                valueField: 'District',
                                textField: 'District',
                                editable:false
                            "/>
                <span>&nbsp;-&nbsp;</span>
                            <input class="easyui-combobox" name="ddpCity" id="ddpCity" style=" width:100px" field="City" data-options="
                                valueField: 'ID',
                                textField: 'Name',
                                editable:false
                            "/></div>
                </li>
                 
                <li>
                    <label for="txtClientSourceCode">
                        渠道:</label> 
                    <input type="combo" id="txtClientSourceCode" name="ClientSourceCode" style="width:155px;" class="easyui-combobox fieldItem"
                        field="ClientSourceCode" />
                </li>
            </ul>
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0; width:100%;">
                <a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#winCustomer').window('close');">取消</a>
            </div>
        </div>
        </form>
    </div>
    <div id="winSearch" class="easyui-window" data-options="title:'高级查询',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 550px; height: 350px;"> 
        <form name="formSearch" id="formSearch">
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0;">
            <div class="easyui-panel" data-options="title:'店铺查询'">
              <table style="text-align:right;">
                <tr  title="时间查询">
                    <td style="width:100px">店铺:</td>
                    <td><input type="combo" id="txtWareHouse_Code" data-options="multiple:true,panelHeight:'auto'" name="txtWareHouse_Code" class="easyui-combobox  fieldItem" style="width:140px"/></td>
                </tr>
              </table>
            </div>
             <div class="easyui-panel" data-options="title:'时间查询'"> 
             <table style="text-align:right;">
                <tr  title="时间查询">
                    <td style="width:100px">登记时间:</td>
                    <td><input type="text" name="RegDate" id="txtRegDate" class="fieldItem easyui-datebox"  style="width:140px"   /> </td>
                    <td style="width:100px">成交时间:</td>
                    <td><input type="text" name="ContractDate" id="txtContractDate" class="fieldItem easyui-datebox"  style="width:140px"   /> </td>
                </tr>
                <tr >
                    <td>到:</td>
                    <td><input type="text" name="RegDate1" id="txtRegDate1" class="fieldItem easyui-datebox"  style="width:140px"   /> </td>
                    <td>到:</td>
                    <td><input type="text" name="ContractDate1" id="txtContractDate1" class="fieldItem easyui-datebox"  style="width:140px"   /> </td>
                </tr>
                </table>
                </div>
                <div class="easyui-panel" data-options="title:'金额查询'">
                <table style="text-align:right;">
                 <tr title="金额查询">
                    <td style="width:100px">收款金额区间:</td>
                    <td><input class="fieldItem" type="text" name="CustomerMoney" id="txtCustomerMoney" style="width:140px"  /></td>
                    <td style="width:100px">回访时间区间:</td>
                    <td><input type="text" name="VisitDate" id="txtVisitDate" class="fieldItem easyui-datebox"  style="width:140px"   /> </td>
                </tr>
                <tr >
                    <td>到:</td>
                    <td><input type="text" name="CustomerMoney1" id="txtCustomerMoney1" class="fieldItem"  style="width:140px"   /> </td>
                    <td>到:</td>
                    <td><input type="text" name="VisitDate1" id="txtVisitDate1" class="fieldItem easyui-datebox"  style="width:140px"   /> </td>
                </tr> 
                </table>
                </div>
                <div class="easyui-panel" data-options="title:'其他查询'">
                <table style="text-align:right;">
                <tr title="其他查询">
                    <%--<td style="width:100px">客户级别:</td>
                    <td><input type="combo" id="txtCreditLevel" name="CreditLevel" class="easyui-combobox fieldItem"
                             style="width:140px" />
                    </td>--%>
                     <td style="width:100px">工作进度:</td>
                    <td><input id="txtCreditLevel" class="easyui-numberspinner fieldItem"  name="txtCreditLevel"  data-options="min:0,max:100"
              style="width:60px;" value="0"></input>
              —<input id="txtCreditLevel1" class="easyui-numberspinner fieldItem"  name="txtCreditLevel1"  data-options="min:0,max:100"
              style="width:60px;" value="100"></input></td>
                    <td style="width:100px">导购:</td>
                    <td><input type="combo" id="txtGuide1" name="GuideCode1" class="easyui-combobox fieldItem"  style="width:140px" 
                        field="GuideCode1" /></td> 
                </tr> 
                <tr>
                    <td style="width:100px">朋友介绍:</td>
                    <td style="text-align:left;">
                       <input type="checkbox" name="friendflag" value="3" id="friendflag" class="fieldItem"  />
                    </td>
                     <td style="width:100px">放弃客户:</td>
                    <td style="text-align:left;">
                       <input type="checkbox" name="giveup" value="3" id="ckgiveup" class="fieldItem"  />
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
    <div id="WinGuide" class="easyui-window" data-options="title:'客户分配',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 350px; height: 120px;" >
        <form name="formGuide" id="formGuide" status="Guide" >
        <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0;">
             <ul> 
                <li>
                        <label for="txtGuideCode1">
                        业务员:</label> 
                         <input type="hidden" id="Hidden1" name="Guide1" class="fieldItem" field="Guide" />
                        <input type="combo" id="txtGuideCode1"  name="GuideCode1" class="easyui-combobox  fieldItem"   field="GuideCode" />  
                </li> 
            </ul>
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0;">
                <a class="easyui-linkbutton" id="btnGuide" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#WinGuide').window('close');">取消</a>
            </div>
        </div>
        </form>
    </div>
    <div id="Winprint" class="easyui-window" data-options="title:'打印',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 760px; height: 650px;" >
        <form name="formPrint" id="formPrint" status="Print" >
        
        </form>
    </div>
</body>
</html>
