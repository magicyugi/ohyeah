<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WarehouseList.aspx.cs" Inherits=" AppBox.View.WareHouseManage.WarehouseList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>组织管理</title>  
   
    <script language="javascript" type="text/javascript">

        $().ready(function () {
            //权限*************************************
            $.ajax({
                url: 'Ajax.aspx',
                data: "key=Role&RoleCode=0412",
                success: function (msg) {
                    var txtmsg = msg.split(',');
                    for (var i = 0; i < txtmsg.length; i++) {
                        $("#" + txtmsg[i]).css("display", "none");
                    }
                }
            });
            $('#txtProvince_Code').combobox({
                onSelect: function (s) {
                    $('#txtArea_Code').combobox('clear');
                    $('#txtCity_Code').combobox({
                        url: 'Ajax.aspx?key=City&Pcode=' + s.Code+'&rd='+Math.random(),
                        onSelect: function (ss) {
                            $('#txtArea_Code').combobox({
                                url: 'Ajax.aspx?key=Area&Pcode=' + ss.Code+'&rd='+Math.random()
                            });
                        }
                    });

                }
            });

            $('#ddpProvince').combobox({
                onSelect: function (s) {
                    $('#ddpArea').combobox('clear');
                    $('#ddpCity').combobox({
                        url: 'Ajax.aspx?key=City&Pcode=' + s.Code+'&rd='+Math.random(),
                        onSelect: function (ss) {
                            $('#ddpArea').combobox({
                                url: 'Ajax.aspx?key=Area&Pcode=' + ss.Code+'&rd='+Math.random(),
                            });
                        }
                    });

                }
            });


            $("#btnSave").click(function () {
                var txttype = "";
                var txttitle = $('#wind').attr('title'); 
                if (setValidate($("#windform"))) { 
                    if (txttitle == "新增")
                        txttype = "insert";
                    else
                        txttype = "update";

                    $.ajax({
                        type: "post",
                        datatype: "json",
                        url: "Ajax.aspx?key=" + txttype,
                        data: $('#windform').serialize(),
                        success: function (msg) {
                            if (msg.indexOf("fail:") == -1) {
                                $("#grid").datagrid("reload");
                                $('#wind').window('close');
                                windClear();
                            }
                            else
                                alert(msg.split(':')[1]);
                             
                        }
                    });
                } 
            });

            $("#btnSearch").click(function () {

                $("#grid").datagrid({
                    url: "Ajax.aspx?key=LoadGrid&txtSearch=" + $("#txtSearch").val() + "&ddpProvince=" + $("#ddpProvince").combobox('getValue')
                      + "&ddpCity=" + $("#ddpCity").combobox('getValue') + "&ddpArea=" + $("#ddpArea").combobox('getValue')
                });
            });



        })

        function windClear() {
            $('#txtCode').val("");
            $('#txtVCode').val("");
            $('#txtCname').val("");
            $('#txtTel').val("");
            $('#txtFax').val("");
            $('#txtAddress').val("");
            $('#txtProvince_Code').val("");
            $('#txtCity_Code').val("");
            $('#txtArea_Code').val("");
            $('#txtCredit').val("");
            $('#txtDiscount1').val("");
            $('#txtAccount').val("");
            $('#txtOverdraft').val("");
            $('#txtPayType').val("");
            $('#txtStoreFlag').val("");
            $('#txtStatusFlag').val("");
        }

        function formatItem(row) {
            var s = '<span style="font-weight:bold">' + row.text + '</span><br/>' +
					'<span style="color:#888">' + row.desc + '</span>';
            return s;
        }
    </script>
</head>
<body>
     <div class="metrouicss">
        <div class="page secondary">
            <div class="page-header">
                <div class="page-header-content">
                    <h1>
                        组织<small>管理</small></h1>
                    <a  class="back-button big page-back"  ></a>
                </div>
            </div>
        </div>
    </div>
     <div class="easyui-panel" title="组织管理【用于对部门、店铺等组织结构进行设置管理、用于用户所属组织分配】">
   <!-- -BEGIN 查询框  --> 
     <form id="mainform">
     <div class="easyui-panel" style=" height:40px;">
    <label>查询：</label><input type="text" id="txtSearch" name="txtSearch" style="width:200px;"  placeholder="请输入组织名进行查询"   />
    <label>地区：</label> 
     <input  class="easyui-combobox" name="ddpProvince" id="ddpProvince"  style=" width:100px" data-options="
                url:'Province.aspx?rd='+Math.random(), 
                valueField: 'Code',
                textField: 'ProvinceName',
                editable:false
            "/>  
<span>&nbsp;&nbsp;</span>
            <input class="easyui-combobox" name="ddpCity" id="ddpCity" style=" width:100px" data-options="
                valueField: 'Code',
                textField: 'CityName',
                editable:false,
                panelHeight:'auto'
            "/>
<span>&nbsp;&nbsp;</span>
            <input class="easyui-combobox" name="ddpArea" id="ddpArea" style=" width:100px" data-options="
                valueField: 'Code',
                textField: 'AreaName',
                editable:false,
                panelHeight:'auto'
            "/>
    <a class="easyui-linkbutton" id="btnSearch" data-options="iconCls:'icon-save'">查询</a>
     </div>
    <!-- END 查询框-->

    <!--BEGAIN列表  -->

     <table class="easyui-datagrid" id="grid" 
     data-options="url: 'Ajax.aspx?key=LoadGrid', pagination:true,
     rownumbers:true,singleSelect:true,toolbar:toolbar">
		<thead>
			<tr>
                <th data-options="field:'ID',width:120,hidden:true">编号</th>
                <th data-options="field:'Code',width:120,hidden:true">编号</th>
                <th data-options="field:'VCode',width:120,hidden:true">编号</th>
				<th data-options="field:'Cname',width:200">名称</th>
				<th data-options="field:'Tel',width:80">电话</th>
                <th data-options="field:'Fax',width:80">传真</th>
                <th data-options="field:'Address',width:80">地址</th>
                <th data-options="field:'ProvinceName',width:80">省</th>
                <th data-options="field:'CityName',width:80">市</th>
                <th data-options="field:'AreaName',width:80">县、区</th>
                <th data-options="field:'Credit',width:80,hidden:true">信用等级</th>
                <th data-options="field:'Discount1',width:80,hidden:true">折扣</th>
                <th data-options="field:'Account',width:80,hidden:true">预付款</th>
                <th data-options="field:'Overdraft',width:80,hidden:true">信用金额</th>
                <th data-options="field:'PayType',width:80,hidden:true">付款方式</th> 
                <th data-options="field:'UserNum',width:80">用户数</th>
                <th data-options="field:'StoreFlag',width:80,hidden:true">标记</th>
                <th data-options="field:'StatusFlag',width:80">状态</th>
			</tr>
		</thead>
       
	</table>
      <script type="text/javascript">
          var toolbar = [{
              id: 'btnAdd',
              text: '新增',
              iconCls: 'icon-edit',
              handler: function () {
                  $('#wind').attr("title", "新增");
                  $('#txtVCode').removeAttr("readonly");
                  $('#wind').window('open');
              }
          }, '-', {
              id: 'btnEdit',
              text: '修改',
              iconCls: 'icon-edit',
              handler: function () {
                  if ($("#grid").datagrid('getSelected') != null) {
                      $('#txtCode').val($("#grid").datagrid('getSelected')["Code"]);
                      $('#txtVCode').val($("#grid").datagrid('getSelected')["VCode"]);
                      $('#txtCname').val($("#grid").datagrid('getSelected')["Cname"]);
                      $('#txtTel').val($("#grid").datagrid('getSelected')["Tel"]);
                      $('#txtFax').val($("#grid").datagrid('getSelected')["Fax"]);
                      $('#txtAddress').val($("#grid").datagrid('getSelected')["Address"]);
                      $('#txtProvince_Code').combobox('setValue', $("#grid").datagrid('getSelected')["Province_Code"]);
                      $('#txtCity_Code').combobox({
                          url: 'Ajax.aspx?key=City&Pcode=' + $("#grid").datagrid('getSelected')["Province_Code"] + '&rd=' + Math.random(),
                          onLoadSuccess: function () {
                              $('#txtCity_Code').combobox('setValue', $("#grid").datagrid('getSelected')["City_Code"]);
                              $('#txtArea_Code').combobox({
                                  url: 'Ajax.aspx?key=Area&Pcode=' + $("#grid").datagrid('getSelected')["City_Code"] + '&rd=' + Math.random(),
                                  onLoadSuccess: function () {
                                      $('#txtArea_Code').combobox('setValue', ($("#grid").datagrid('getSelected')["Area_Code"]));
                                  }
                              });
                          }
                      });


                      $('#txtProvinceName').val($("#grid").datagrid('getSelected')["ProvinceName"]);
                      $('#txtCityName').val($("#grid").datagrid('getSelected')["CityName"]);
                      $('#txtAreaName').val($("#grid").datagrid('getSelected')["AreaName"]);
                      $('#txtCredit').val($("#grid").datagrid('getSelected')["Credit"]);
                      $('#txtDiscount1').val($("#grid").datagrid('getSelected')["Discount1"]);
                      $('#txtAccount').val($("#grid").datagrid('getSelected')["Account"]);
                      $('#txtOverdraft').val($("#grid").datagrid('getSelected')["Overdraft"]);
                      $('#txtPayType').val($("#grid").datagrid('getSelected')["PayType"]);
                      $('#txtStatusFlag').val($("#grid").datagrid('getSelected')["StatusFlag"]);
                      $('#txtVCode').attr("readonly", "readonly");
                      $('#wind').attr("title", "修改");
                      $('#wind').window('open');
                  }
                  else
                      $.messager.alert('注意', "请选择需要编辑的行！", 'warning');
              }
          }, '-', {
              id: 'btnDelete',
              text: '删除',
              iconCls: 'icon-save',
              handler: function () {
                  if ($("#grid").datagrid('getSelected') != null) {
                      $.messager.confirm('注意', '是否确认删除该行记录！', function (r) {
                          if (r) {
                              if (parseInt($("#grid").datagrid('getSelected')["UserNum"]) > 0)
                                  alert("该组织用户数量大于0，不允许删除！");
                              else
                                  $("#grid").datagrid({
                                      url: "Ajax.aspx?key=del&id=" + $("#grid").datagrid('getSelected')["ID"]
                                  });
                          }
                      });
                  }
              }
          }
       ];
	</script>
  </form>
    <!--END列表  -->

 	<div id="wind" class="easyui-window" title="编辑"
       data-options="modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false" 
       style="width:400px;height:600px;padding:10px;">
		<div class="easyui-layout" data-options="fit:true">       
			<div data-options="region:'center',split:true">
             <form id="windform">
            <ul>
            <li style="display:none"> <span>&nbsp;&nbsp;&nbsp;&nbsp;编号:&nbsp;</span><input type="text" name="txtVCode" class="fieldItem"  id="txtVCode" />
            <input type="hidden" id="txtCode" name="txtCode"/></li>
            <li> <span>&nbsp;&nbsp;&nbsp;&nbsp;名称:&nbsp;</span><input type="text" name="txtCname"  class="easyui-validatebox fieldItem" required="true" id="txtCname"/></li>
            <li> <span>&nbsp;&nbsp;&nbsp;&nbsp;电话:&nbsp;</span><input type="text" name="txtTel" id="txtTel"/></li>
            <li> <span>&nbsp;&nbsp;&nbsp;&nbsp;传真:&nbsp;</span><input type="text" name="txtFax" id="txtFax"/></li>
            <li> <span>&nbsp;&nbsp;&nbsp;&nbsp;地址:&nbsp;</span><textarea  name="txtAddress" id="txtAddress" style=" width:150px; height:60px;"></textarea></li>
            <li> <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;省:</span>
            <input  class="easyui-combobox" style="width:150px;" name="txtProvince_Code" id="txtProvince_Code" data-options="
                url:'Province.aspx', 
                valueField: 'Code',
                textField: 'ProvinceName',
                editable:false 
            "/> </li>
            <li> <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;市:</span>
            <input class="easyui-combobox" style="width:150px;" name="txtCity_Code" id="txtCity_Code" data-options="
                valueField: 'Code',
                textField: 'CityName',
                editable:false,
                panelHeight:'auto'
            "/></li>
            <li> <span>&nbsp;&nbsp;县、区:</span>
            <input class="easyui-combobox" style="width:150px;" name="txtArea_Code" id="txtArea_Code" data-options="
                valueField: 'Code',
                textField: 'AreaName',
                editable:false,
                panelHeight:'auto'
            "/></li>
            <li style="display:none"> <span>信用等级:&nbsp;</span><input type="text" class="easyui-numberspinner" data-options="min:1,max:10" name="txtCredit" id="txtCredit" /></li>
            <li style="display:none"> <span>&nbsp;&nbsp;&nbsp;&nbsp;折扣:&nbsp;</span><input type="text" name="txtDiscount1" id="txtDiscount1" /></li>
            <li style="display:none"> <span>&nbsp;&nbsp;预付款:&nbsp;</span><input type="text" data-options="precision:2" class="easyui-numberbox" name="txtAccount" id="txtAccount" /></li>
            <li style="display:none"> <span>信用金额:&nbsp;</span><input type="text" data-options="precision:2" class="easyui-numberbox" name="txtOverdraft" id="txtOverdraft" /></li>
            <li style="display:none"> <span>付款方式:&nbsp;</span><input type="text" name="txtPayType" id="txtPayType"  /></li>
            <li> <span>&nbsp;&nbsp;&nbsp;&nbsp;状态:&nbsp;</span>
            <select class="easyui-combobox" name="txtStatusFlag"   data-options="panelHeight:'auto'"  id="txtStatusFlag" style="width:80px;">
            <option value="1">启 用</option>
		    <option value="2">停 用</option>
           </select></li>

            </ul>
             </form> 
            </div>     	
   			<div data-options="region:'south',border:false" style="text-align:right;padding:5px 0 0;">
				<a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">保存</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript: $('#wind').window('close');windClear();">取消</a>
			</div>
		</div>
	</div>
   <!--End编辑-->
</body>
</html>
