 
    <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerPrint.aspx.cs" Inherits="AppBox.View.Customers.CustomerPrint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head  id="Head1"  runat="server"> 
<title></title>  
    <link href="../../common/css/metrohead.css" rel="stylesheet" type="text/css" media="all" /> 
    <link href="../../easyui/themes/metro/easyui.css" rel="stylesheet" type="text/css" media="all" />  
    <script src="../../easyui/js/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../../easyui/js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../SysCodeManage/datagrid-groupview.js" type="text/javascript"></script>  
    <script src="../../common/js/jquery.PrintArea.js" type="text/javascript"></script> 
    <script src="../../common/js/Common.js" type="text/javascript"></script>
 <script type="text/javascript">

     function print() { 
           $(".areaItem").printArea();   
     } 
        
    </script>  
</head>
<body>
    
   
    <form runat="server">
    <input type="button" value="打印" onclick="print()" /> 
    <asp:HiddenField ID="hdncode" runat="server" Value="" />   
    <div class='areaItem'>
        <fieldset><legend>客户信息</legend>
            <table class='customerdt'>
                <tr>
                  <td class='customerdt-title'>姓&nbsp;&nbsp;&nbsp;&nbsp;名：</td>
                  <td class='customerdt-show'><label id="txtname" runat="server"></label></td>
                  <td class='customerdt-title'>手&nbsp;&nbsp;&nbsp;&nbsp;机：</td>
                  <td class='customerdt-show'><label id="txtphone" runat="server"></label></td>
                </tr>
                <tr>
                  <td>地&nbsp;&nbsp;&nbsp;&nbsp;址：</td>
                  <td colspan='3'><label id="txtaddress" runat="server"></label></td> 
                </tr>
                <tr>
                  <td>客户评级：</td>
                  <td><label id="txtlevel" runat="server"></label></td>
                  <td>状&nbsp;&nbsp;&nbsp;&nbsp;态：</td>
                  <td><label id="txtflag" runat="server"></label></td>
                </tr>
                <tr>
                  <td>跟&nbsp;单&nbsp;人：</td>
                  <td><label id="txtguide" runat="server"></label></td>
                  <td>创&nbsp;建&nbsp;人：</td>
                  <td><label id="txtcreater" runat="server"></label></td>
                </tr>
            </table> 
       </fieldset>
       <fieldset><legend>基础信息</legend>
            <ul class="customerdefine" id="customerDefine" runat="server">
            </ul>
       </fieldset>
       <fieldset><legend>工作进度</legend>
             <table class="easyui-datagrid" id="LeveGrid" style="width: 700px;" 
        data-options=" rownumbers:true,singleSelect:true,
                    url: 'Ajax.aspx?type=Level&code=' + request('code'),
                    method:'get',view:groupview,groupField:'LevelName',
                    groupFormatter:function(value,rows){
                    return '<a style=color:gray>'+value +'</a>';}" >
            <thead>
                <tr>
                    <th data-options="field:'ID',hidden:true,width:80">
                        代码
                    </th>
                    <th data-options="field:'Level_Code',width:80,hidden:true">
                        步骤代码
                    </th>
                    <th data-options="field:'LevelName',width:120,hidden:true">
                        步骤名
                    </th>
                    <th data-options="field:'Code',width:80">
                        级别代码
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
       </fieldset>
       <fieldset><legend>合同信息</legend>
            <table class="easyui-datagrid" id="gridPayment" style="width: 700px;" 
                    data-options="rownumbers:true,singleSelect:true,
                      showFooter: true,
                      url: 'Ajax.aspx?type=printContract&code=' +request('code')"
                     >
                    <thead>
                        <tr>
                            <th data-options="field:'StatusFlag', width:80,formatter:function(value, rowData, rowIndex){
            var showvalue = '';
            if (value == '1') showvalue = '<span>正常</span>';
            if (value == '2') showvalue = '<span>已完成</span>';
            if (value == '3') showvalue = '<span style=\'color:red\'>坏账</span>';
            return showvalue;
        }">
                                状态
                            </th>
                             <th data-options="field:'Code', width:110">
                                合同号
                            </th> 
                            <th data-options="field:'UserName',width:120">
                                业务员
                            </th>  
                            <th data-options="field:'Price',  width:110" sortable="true">
                                合同金额
                            </th> 
                              <th data-options="field:'PayMoney',  width:110" sortable="true">
                                已收款
                            </th>
                            <th data-options="field:'LeftMoney', width:110" sortable="true">
                                余款 
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
       </fieldset>
       <fieldset><legend>回访记录</legend>
            <table class="easyui-datagrid" id="gridAlert" style="width: 700px;" 
                    data-options="rownumbers:true,singleSelect:true,
                    url: 'Ajax.aspx?type=printVisit&code=' + request('code')"
                     sortName="LeftMoney" sortOrder="desc">
                    <thead>
                        <tr>
                            <th data-options="field:'VisitDate', width:110,formatter:function(value, rec, index){
            if (value == undefined) {
                return '';
            } 
            value = value.substr(2, value.length - 5); 
            return value;
        }">
                                时间
                            </th>
                            <th data-options="field:'VisitName', width:90">
                                回访人
                            </th> 
                             <th data-options="field:'VisitTitle', width:110">
                                标题
                            </th> 
                            <th data-options="field:'VisitContent',width:345">
                                内容
                            </th>   
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
       </fieldset>
      </div>
    </form> 
 </body>
</html>