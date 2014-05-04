<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductTypeList.aspx.cs" Inherits="AppBox.ProductTypeManage.ProductTypeList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>商品类别</title>
    <link href="../../themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../themes/icon.css" rel="stylesheet" type="text/css" /> 
    <script src="../../js/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.easyui.min.js" type="text/javascript"></script>
     <script src="../../js/u3.js" type="text/javascript"></script>
     <link href="../../css/bigicon.css" rel="stylesheet" type="text/css" />
      <script language=〉"javascript" type="text/javascript">
          $(function () {
              $('#grid').treegrid({
                  url: 'Ajax.aspx?key=LoadGrid',
                  onClickRow: function (index, data) {
                      $('#txtVCode').val($('#grid').treegrid('getSelected').VCode);
                      $('#txtCname').val($('#grid').treegrid('getSelected').Cname);
                      $('#txtCode').val($('#grid').treegrid('getSelected').Code);
                      $('#txtRemark1').val($('#grid').treegrid('getSelected').Remark1);
                      $('#txtPCode').val($('#grid').treegrid('getSelected').PCode);
                      $('#txtCodeList').val($('#grid').treegrid('getSelected').CodeList);
                      $('#txtLevelValue').val($('#grid').treegrid('getSelected').LevelValue);
                  }
              });

              $('#btnSave').click(function () {
                  var error = "";
                  if ($('#grid').treegrid('getSelected').Code == "0")
                      $.messager.alert('注意', "顶级父类无法修改！", 'warning');
                  else {
                      if ($('#txtVCode').val() == "")
                          error += "请填写编号！<br/>";
                      if ($('#txtCname').val() == "")
                          error += "请填写名称！<br/>";
                      if (error == "") {
                          $.ajax({
                              type: "post",
                              datatype: "json",
                              url: "Ajax.aspx?key=update",
                              data: $('#windform').serialize(),
                              success: function (msg) {
                                  if (msg == "success") {
                                      $("#grid").treegrid("reload");
                                  }
                                  else
                                      $.messager.alert('注意', msg, 'warning');

                              }
                          });
                      }
                  }
              });

              $('#btnDel').click(function () {

                  if ($('#grid').treegrid('getSelected') != null) {
                      if ($('#grid').treegrid('getSelected').Code == "0")
                          $.messager.alert('注意', "顶级父类无法删除！", 'warning');
                      else {
                          $('#grid').treegrid({
                              url: 'Ajax.aspx?key=del&id=' + $('#grid').treegrid('getSelected').CodeList
                          });
                      }
                  }
              });

              $('#btnAdd').click(function () {
                  var error = "";
                  if ($('#txtNewVCode').val() == "")
                      error += "请填写编号！<br/>";
                  if ($('#txtNewCname').val() == "")
                      error += "请填写名称！<br/>";
                  if (error == "") {
                      $.ajax({
                          type: "post",
                          datatype: "json",
                          url: "Ajax.aspx?key=insert",
                          data: $('#windform').serialize(),
                          success: function (msg) {
                              if (msg == "success") {
                                  $("#grid").treegrid("reload");
                              }
                              else
                                  $.messager.alert('注意', msg, 'warning');

                          }
                      });
                  }
              });

          })
      </script>
</head>
<body class="easyui-layout">
 <div data-options="region:'north',border:false" style="height:5px;"></div>
   <div data-options="region:'west',split:true,title:'类型'" style="width:458px;padding:5px;">
  <table title="商品类别" class="easyui-treegrid" id="grid" style=" height:653px;"
    data-options="rownumbers: true,idField:'Code',treeField: 'Cname'">
		<thead>
		   <tr>
           <th data-options="field:'Cname',width:120">名称</th>
           <th data-options="field:'Code',width:120,hidden:true">Code</th>
           <th data-options="field:'VCode',width:80">编号</th>
		   <th data-options="field:'Remark1',width:200">备注</th>
           <th data-options="field:'PCode',width:120,hidden:true">PCode</th>
           <th data-options="field:'CodeList',width:120,hidden:true">CodeList</th>
           <th data-options="field:'LevelValue',width:120,hidden:true">LevelValue</th>
			</tr>
		</thead>
	</table>
   </div>
   <div data-options="region:'center',title:'编辑'" style="padding:10px;">

   <form id="windform">

     <div class="easyui-panel" title="修改" > 
     <ul>
      <li><span>编号</span><input type="text" name="txtVCode" id="txtVCode" readonly="true"/>
      <input type="hidden" id="txtCode" style="visibility:hidden" name="txtCode"/>
      <input type="hidden" id="txtPCode" style="visibility:hidden" name="txtPCode"/>
      <input type="hidden" id="txtCodeList" style="visibility:hidden" name="txtCodeList"/>
      <input type="hidden" id="txtLevelValue" style="visibility:hidden" name="txtLevelValue"/>
      </li>
      <li><span>名称</span><input type="text" name="txtCname" id="txtCname"/></li>
      <li><span>备注</span><textarea rows="10" id="txtRemark1" name="txtRemark1" style=" width:450px; height:50px;" ></textarea></li>
      <li></li>
      <li><a class="easyui-linkbutton" id="btnSave" data-options="iconCls:'icon-save'">修改</a>
         <a class="easyui-linkbutton" id="btnDel" data-options="iconCls:'icon-delete'">删除</a>
      </li>
     </ul>
    </div>
    <div style=" height:10px;"></div>
    <div class="easyui-panel" title="新增"> 
     <ul>
      <li><span>编号</span><input type="text" name="txtNewVCode" id="txtNewVCode"/>
      </li>
      <li><span>名称</span><input type="text" name="txtNewCname" id="txtNewCname"/></li>
      <li><span>备注</span><textarea rows="10" id="txtNewRemark1" name="txtNewRemark1" style=" width:450px; height:50px;" ></textarea></li>
      <li></li>
      <li><a class="easyui-linkbutton" id="btnAdd" data-options="iconCls:'icon-save'">新增</a>
      </li>
     </ul>
    </div>
    </form>
   </div>
</body>
</html>
