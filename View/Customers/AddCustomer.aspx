<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCustomer.aspx.cs" Inherits="AppBox.View.Customers.AddCustomer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>新增客户</title> 
    <script type="text/javascript">
        $(function () {
            $("#txtBirthday").datepicker({
                changeMonth: true,
                changeYear: true,
                dateFormat:'yy-mm-dd'
            });
        });
        function loadCustomer() {
            ajaxget("../ajax/ajaxCustomer.aspx", "edit");
        }
        function AddCustomer() {
            ajaxpost("../ajax/ajaxCustomer.aspx", "save");
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="container-fluid">
        <div class="row-fluid">
            <ul class="navTitle nav nav-tabs offset1" id="tabCustomer">
                <li class="active"><a href="#tabmain" class="fui-user" data-toggle="tab">基础资料</a></li>
                <li><a href="#tabdetail" class="fui-menu" data-toggle="tab">其他资料</a></li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="tabmain">
                    <div class="offset1 span3">
                        <label>
                            客户姓名</label><input type="text" col="cname" />
                        <label>
                            手机号</label><input type="text" col="mobile" />
                        <label>
                            公司名称</label><input type="text" col="company" />
                        <label>
                            性别</label>
                        <div class="switch switch-square getcheckbox" data-on-label="<i class='fui-user'>先生</i>"
                            data-off-label="<i class='fui-user'>女士</i>">
                            <input type="checkbox" checked="" />
                        </div>
                        <input type="text" col="sex" style="display: none;" /> 
                         <label>
                            生日</label>
                            <input type="text" col="birthday" id="txtBirthday" />
                        <label>
                            客户地址</label>
                            <input type="text" col="address" />
                    </div>
                    <div class="offset1 span3">
                        <label>
                            客户类型</label>
                        <input type="text" col="customertype" style="display: none;" />
                        <select name="herolist" value="请选择" class="flatselect getdropdown select-block span3">
                            <option value="0">零售客户</option>
                            <option value="1">批发客户</option>
                            <option value="2">工程客户</option>
                        </select>
                        <input type="text" col="customersource" style="display: none" />
                        <label>
                            客户来源</label>
                        <select name="customersource" value="请选择" class="flatselect getdropdown select-block span3">
                            <option value="0">朋友介绍</option>
                            <option value="1">网上了解</option>
                            <option value="2">设计师推荐</option>
                        </select>
                        <input type="text" col="introducecode" style="display: none;" />
                        <label>
                            介绍人姓名</label><input type="text" col="introducename" />
                        <label>
                            介绍人手机号</label><input type="text" col="introducemobile" />
                        <input type="text" col="customersource" style="display: none" />
                    </div>
                </div>
                <div class="tab-pane" id="tabdetail" style="height: 360px">
                    <div class="offset1 span3">
                        <label>来源网址</label><input type="text" col="website" />
                        <label>QQ</label><input type="text" col="qq" />
                        <label>微博号</label><input type="text" col="weibo" /> 
                         <label>
                            自动分享</label>
                        <div class="switch switch-square getcheckbox" data-on-label="<i class='fui-check'>是</i>"
                            data-off-label="<i class='fui-cross'>否</i>">
                            <input type="checkbox" checked="" />
                        </div>
                    </div>
                </div>
                <div class="offset1 span3">
                </div>
        </div>
    </div>
    <br />
    <br />
    <div class="row-fluid" style="position: absolute; left: 0px; bottom: 25px;">
        <div class="offset3 span2">
            <a href="#" class="btn btn-large btn-block btn-success  todo-icon fui-check" id="btnSubmit"
                onclick="AddCustomer()">保 存</a>
        </div>
        <div class="span2">
            <a href="#" class="btn btn-large btn-block btn-danger todo-icon fui-cross" id="A1">返
                回</a>
        </div>
    </div>
    </div>
    </form>
    <!--[if lt IE 8]>
      <script src="../../flat/js/icon-font-ie7.js"></script>
      <script src="../../flat/js/icon-font-ie7-24.js"></script>
    <![endif]-->
</body>
</html>
