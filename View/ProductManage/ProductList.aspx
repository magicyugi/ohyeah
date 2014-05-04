<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" Inherits="AppBox.ProductManage.ProductList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../easyui/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../easyui/themes/icon.css" rel="stylesheet" type="text/css" /> 
    <script src="../../media/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../../easyui/js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../easyui/js/easyui-lang-zh_CN.js" type="text/javascript"></script> 
     <link href="../../easyui/css/bigicon.css" rel="stylesheet" type="text/css" />
  
    <script language="javascript" type="text/javascript">

        $().ready(function () {

            $("#btnSave").click(function () {
                var error = '';
                 if ($('#txtVCode').val() == '')
                   error += "请输入产品编号！";
                if ($('#txtCname').val() == '')
                    error += "请输入产品名称！";
                if (error == '') {
                    var keytype;
                    if ($('#wind').attr('title') == "新增")
                        keytype = "insert";
                    else
                        keytype = "update";
                    $.ajax({
                        type: "post",
                        datatype: "json",
                        url: "Ajax.aspx?key=" + keytype,
                        data: $('#windform').serialize(),
                        success: function (msg) {
                            if (msg == "success") {
                                $("#grid").datagrid("reload");
                                windClear();
                                $('#wind').window('close');
                            }
                            else
                                $.messager.alert('注意', msg, 'warning');

                        }
                    });
                }
                else
                    $.messager.alert('注意', error, 'warning');

            });



            $('#treeProductType').tree({
                checkbox: false,
                url: "Ajax.aspx?key=TreeLoad",
                onClick: function (node) {
                    $("#grid").datagrid({
                        url: "Ajax.aspx?key=Search&type=" + node.id
                    });
                },
                animate: true
            });

            $("#grid").datagrid({
                onClickRow: function (index, data) {
                    $('#produtImage').attr('src', data.Photo);
                    $('#lblVCode').val(data.VCode);
                    $('#lblCname').val(data.Cname);
                    $('#lblCType_Code').val(data.CTypeName);
                    $('#lblBrand_Code').val(data.BrandName);
                    $('#lblPrice').val(data.Price);
                    $('#lblMainStuff').val(data.MainStuff);
                    $('#lblSalePoint').val(data.SalePoint);
                    $('#lblWeakPoint').val(data.WeakPoint);
                }
            });

            

        })

        function windClear() {     
            $('#produtImage').attr('src', '');
            $('#txtVCode').val('');
            $('#txtCname').val('');
            $('#txtCTypeCode').combotree('setValue', "");
            $('#txtBrandCode').combobox('clear');
            $('#txtPrice').val('');
            $('#txtMainStuff').val('');
            $('#txtSalePoint').val('');
            $('#txtWeakPoint').val(''); 
        }
    </script>
</head>
<body class="easyui-layout">
 <div data-options="region:'north',border:false" style="height:5px;"></div>
 <div data-options="region:'south',border:false" style="height:5px;"></div>
   <div data-options="region:'west',split:true,title:'类型'" style="width:150px;">
     <ul id="treeProductType" class="easyui-tree">
     </ul>
   </div>
   <div data-options="region:'center'">
   <div class="easyui-panel" title="产品信息" style="height:215px; float:left;">
     <div style=" width:650px; float:left;">
      <ul>
      <li>
      <label>编号：</label><input type="text" readonly="readonly" id="lblVCode" style=" width:80px;"/>
      <label>名称：</label><input type="text" readonly="readonly" id="lblCname" style=" width:80px;"/>
      <label>类别：</label><input type="text" readonly="readonly" id="lblCType_Code" style=" width:80px;"/>
      </li>
      <li>
      <label>品牌：</label><input type="text" readonly="readonly" id="lblBrand_Code" style=" width:80px;" />
      <label>价格：</label><input type="text" readonly="readonly" id="lblPrice" style=" width:80px;"/>
      <label>主要材料：</label><input type="text" readonly="readonly" id="lblMainStuff" style=" width:208px;"/>
      </li>
       <li>
        <label>卖点：</label><textarea id="lblSalePoint" readonly="readonly" rows="10" style=" width:500px; height:35px;"></textarea>
       </li>
      <li>
        <label>缺点：</label><textarea id="lblWeakPoint" readonly="readonly" rows="10" style=" width:500px; height:35px;"></textarea>
       </li>
      </ul>
      </div>
      <div style=" width:160px; float:left; margin-top:10px;">
        <img id="produtImage" src="" width="160" height="160"/>
      </div>
   </div>
    <form id="mainform" runat="server"  >
     <div class="easyui-panel" title="产品列表">
     <table class="easyui-datagrid" id="grid"  style=" height:440px;"
     data-options="url: 'Ajax.aspx?key=LoadGrid', pagination: true,
     rownumbers:true,singleSelect:true,toolbar:toolbar,pageSize:15">
		<thead>
			<tr>
                <th data-options="field:'Code',width:120,hidden:true">Code</th>
                <th data-options="field:'VCode',width:100">编号</th>
				<th data-options="field:'Cname',width:120">名称</th>
                <th data-options="field:'key2',width:120">颜色</th>
                <th data-options="field:'key3',width:120">尺码</th>
				<th data-options="field:'Price',width:80">价格</th>
                <th data-options="field:'CType_Code',width:80,hidden:true">类别</th>
                <th data-options="field:'CTypeName',width:80">类别</th>
                <th data-options="field:'Brand_Code',width:80,hidden:true">品牌</th>
                <th data-options="field:'BrandName',width:80">品牌</th>
                <th data-options="field:'UnitCode',width:80,hidden:true">单位</th>
                <th data-options="field:'MainStuff',width:100">主要材料</th>
                 <th data-options="field:'Custom1Code',width:80, hidden:true">自定义属性1</th>
                 <th data-options="field:'Custom2Code',width:80, hidden:true">自定义属性2</th>
                 <th data-options="field:'Custom3Code',width:80, hidden:true">自定义属性3</th>
                 <th data-options="field:'Custom4Code',width:80, hidden:true">自定义属性4</th>
                 <th data-options="field:'Custom5Code',width:80, hidden:true">自定义属性5</th>
                 <th data-options="field:'Custom6Code',width:80, hidden:true">自定义属性6</th>
                 <th data-options="field:'Custom7Code',width:80, hidden:true">自定义属性7</th>
                 <th data-options="field:'Custom8Code',width:80, hidden:true">自定义属性8</th>
                <th data-options="field:'Photo',width:80, hidden:true">照片</th>
                <th data-options="field:'SalePoint',width:200">卖点</th>
                 <th data-options="field:'WeakPoint',width:200">缺点</th>
			</tr>
		</thead>
       
	</table>
    <script type="text/javascript">
        var toolbar = [{
            text: '新增产品',
            iconCls: 'icon-add',
            handler: function () {
                $('#wind').attr('title', '新增');
                windClear();
                $('#wind').window('refresh');
                $('#wind').window('open');
            }
        }, {
            text: '修改产品',
            iconCls: 'icon-edit',
            handler: function () {
                if ($("#grid").datagrid('getSelected') != null) {
                    $('#wind').attr('title', '修改');
                    $('#txtCode').val($("#grid").datagrid('getSelected')["Code"]);
                    $('#txtVCode').val($("#grid").datagrid('getSelected')["VCode"]);
                    $('#txtCname').val($("#grid").datagrid('getSelected')["Cname"]);
                    $('#txtPrice').val($("#grid").datagrid('getSelected')["Price"]);
                    if ($("#grid").datagrid('getSelected')["CType_Code"] != "")
                        $('#txtCTypeCode').combotree('setValue', $("#grid").datagrid('getSelected')["CType_Code"]);
                    else
                        $('#txtCTypeCode').combotree('clear');
                    if ($("#grid").datagrid('getSelected')["Brand_Code"] != "")
                        $('#txtBrandCode').combobox('setValue', $("#grid").datagrid('getSelected')["Brand_Code"]);
                    else
                        $('#txtBrandCode').combobox('clear');
                    $('#txtUnitCode').val($("#grid").datagrid('getSelected')["UnitCode"]);
                    $('#txtMainStuff').val($("#grid").datagrid('getSelected')["MainStuff"]);
                    $('#txtSalePoint').val($("#grid").datagrid('getSelected')["SalePoint"]);
                    $('#txtWeakPoint').val($("#grid").datagrid('getSelected')["WeakPoint"]);
                    $('#wind').window('open');
                }
                else
                    $.messager.alert('注意', "请选择需要编辑的行！", 'warning');
            }
        }
        , {
            text: '删除产品',
            iconCls: 'icon-delete',
            handler: function () {
                if ($("#grid").datagrid('getSelected') != null) {
                    $.messager.confirm('注意', '是否确认删除该行记录！', function (r) {
                        if (r) {
                            $("#grid").datagrid({
                                url: "Ajax.aspx?key=del&id=" + $("#grid").datagrid('getSelected')["Code"]
                            });
                        }
                    });
                }
            }
        }
        ];      
	</script>
    
  </form>
  </div>
 	<div id="wind" class="easyui-window" title="编辑"
       data-options="modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false" 
       style="width:600px;height:420px;padding:10px;">
		<div class="easyui-layout" data-options="fit:true">
         
			<div data-options="region:'center',split:true">
            <form id="windform">
            <ul class="u3wind">
            <li> <div>编号:</div><input type="text" name="txtVCode" id="txtVCode"/>
            <input type="hidden" id="txtCode" style="visibility:hidden" name="txtCode"/></li>
            <li> <div>名称:</div><input type="text" name="txtCname" id="txtCname" /></li>
            <li> <div>价格:</div><input type="text" name="txtPrice" id="txtPrice"/></li>
            <li> <div>类别:</div><input class="easyui-combotree" data-options=" url: 'Ajax.aspx?key=EditTreeLoad',panelHeight:'auto'" name="txtCTypeCode" id="txtCTypeCode"/></li>
            <li> <div>品牌:</div><input type="text" class="easyui-combobox" 
            data-options=" url: 'Ajax.aspx?key=Brand',panelHeight:'auto',valueField:'Code',textField:'Cname',editable:false"
             name="txtBrandCode" id="txtBrandCode" />
            </li>

            <li> <div>主要材料:</div><input type="text" name="txtMainStuff" id="txtMainStuff" style="width:400px;"/></li>
            <li> <div>卖点:</div><textarea id="txtSalePoint" name="txtSalePoint"  rows="10" style="width:400px; height:50px;"></textarea></li>
            <li> <div>缺点:</div><textarea id="txtWeakPoint"  name="txtWeakPoint" rows="10" style="width:400px; height:50px;"></textarea></li>
            <!--<li> <lable>&nbsp;&nbsp;&nbsp;&nbsp;单位:</lable><input type="text" name="txtUnitCode" id="txtUnitCode" /></li>-->
            </ul>
             </form> 
            </div>     	
   			<div data-options="region:'south',border:false" style="text-align:right;padding:5px 0 0;">
				<a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript: $('#wind').window('close'); windClear();">取消</a>
			</div>
		</div>
	</div>
   
</body>
</html>

