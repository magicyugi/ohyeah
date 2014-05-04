<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserEdit.aspx.cs" Inherits="AppBox.View.Users.UserEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title> 
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
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Guide";
        $(function () {
            $("#txtCode").focus();
            $(".fieldItem").bind('keydown', 'return', function () {
                var txttabindex = parseInt($(this).attr('tabindex')) + 1;
                $("#Guideul").find("input[tabindex=" + txttabindex + "]").focus();
            }).bind('keydown', 'tab', function () {
                return false;
            });
            $("#btnSave").click(function () {
                if (setValidate($("#formGuide"))) {
                    $.ajax({
                        url: url,
                        data: "type=add&" + $("#formGuide").serialize(),
                        success: function (msg) {
                            if (msg.indexOf("fail:") == -1) {
                                if (confirm("保存成功!继续添加请点击确定,取消将返回首页!")) {
                                    window.location.href = window.location.href;
                                }
                                else
                                    window.history.back(-1);
                            }
                            else
                                alert(msg.split(':')[1]);
                        } 
                    });
                }
                else { alert("输入框不能为空!"); return; }
            });
        });
    </script>
</head>
<body>
    <div class="metrouicss">
        <div class="page secondary">
            <div class="page-header">
                <div class="page-header-content">
                    <h1 id="txtTitle">
                        业务员<small>登记</small></h1>
                    <a class="back-button big page-back"></a>
                </div>
            </div>
        </div>
    </div>
    <div data-options="border:false" style="padding: 10px 0 0; height: 450px"
        class="formItem">
        <form id="formGuide" status="add"> 
                <ul id="Guideul">
                    <li  class="basic">
                        <label for="txtCode">
                            用 户 名:</label><input type="text" name="Code" id="txtCode" tabindex="1" class="easyui-validatebox fieldItem" required="true" field="Code" /></li>
                    <li  class="basic">
                        <label for="txtPassword">
                            密&nbsp;&nbsp;&nbsp;&nbsp;码:</label><input type="password"  name="Password" tabindex="2" id="txtPassword" class="easyui-validatebox fieldItem" required="true" field="Password" /></li>
                    <li class="basic">
                        <label for="txtCname">
                            姓&nbsp;&nbsp;&nbsp;&nbsp;名:</label><input type="text" tabindex="3"  name="Cname" id="txtCname" class="easyui-validatebox fieldItem" required="true" field="Cname" /></li>
                    <li class="basic">
                        <label for="txtMobile">
                            手 机 号:</label><input type="text" tabindex="4" maxlength="11"  name="Mobile" id="txtMobile" class="easyui-validatebox fieldItem" required="true" field="Mobile" /></li>
                    <li class="basic metrouicss"  >
                        <div   style="float:left; font-size:20px">
                            <input  type="button" id="btnSave"   name="btnSave"  value="保存"  tabindex="5"     class="fg-color-blackLight bg-color-grayLight"/>
                             <input  type="button" id="btncancle" class="btncancle" name="btncancle"  value="取消" onclick="window.history.back(-1);"   class="fg-color-blackLight bg-color-grayLight"/>
                        </div>
                    </li>
                    <%--<li class="comboli">
                        <label for="txtGuideCode">
                            业务员:</label>
                        <input type="hidden" id="txtGuide" name="Guide" class="fieldItem" field="Guide" />
                        <input type="combo" id="txtGuideCode" name="GuideCode" class="easyui-combobox  fieldItem"   field="GuideCode" />
                    </li>--%>
                    
                </ul>
            
        </form>
        
    </div>
</body>
</html>
