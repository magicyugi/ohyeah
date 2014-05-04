<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerDetailEdit.aspx.cs" Inherits="AppBox.View.Customers.CustomerDetailEdit" %>

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
            float:left;
            width:40%;
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
        var namecode = "Detail";
        
        $(function () {
          
            $("#CText1").focus();
            $(".fieldItem").bind('keydown', 'return', function () {
                var txttabindex = parseInt($(this).attr('tabindex')) + 1;
                $("#Detailul").find("input[tabindex=" + txttabindex + "]").focus();
            }).bind('keydown', 'tab', function () {
                return false;
            });
            $("#btnSave").click(function () { 
                $.ajax({
                    url: url,
                    data: "type=SaveDetail&" + $("#formDetail").serialize(),
                    success: function (msg) {
                        if (msg == "success") {
                            alert("保存成功!!");
                            window.location.href = '../../TilePanel.aspx' + '?on=' + request('on');
                        }
                    }
                }); 
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
                        自定义<small>信息</small></h1>
                    <a class="back-button big page-back"></a>
                </div>
            </div>
        </div>
    </div>
    <script>
        var txtuser = "<% =txtuser%>"
        $.ajax({
            url: url,
            datatype: "json",
            type: "get",
            data: "type=CustomerDetail&WareHouse=" + txtuser,
            success: function (msg) {
                var result = eval("(" + msg + ")")[0];
                for (var i = 0; i < $(".fieldItem").length; i++) {
                    var txtValue = result[$(".fieldItem").eq(i).attr("field")];

                    $(".fieldItem").eq(i).val(txtValue);
                }
            },
            error: function (msg) {
                //alert( msg)
            }
        })
    </script>
    <div data-options="border:false" style="padding: 10px 0 0; height: 450px"
        class="formItem">
        <form id="formDetail" status="add"> 
                <ul id="Detailul">
                    <li  class="basic">
                       &nbsp;1.<input type="text" name="CText1" style="width:100px;" id="CText1" tabindex="1" class="fieldItem"  field="CText1" /></li>
                    <li  class="basic">
                        &nbsp;2.<input type="text" name="CText2" style="width:100px;" id="CText2" tabindex="2" class="fieldItem"  field="CText2" /></li>
                    <li  class="basic">
                        &nbsp;3.<input type="text" name="CText3" style="width:100px;" id="CText3" tabindex="3" class="fieldItem"  field="CText3" /></li>
                    <li  class="basic">
                        &nbsp;4.<input type="text" name="CText4" style="width:100px;" id="CText4" tabindex="4" class="fieldItem"  field="CText4" /></li>
                    <li  class="basic">
                        &nbsp;5.<input type="text" name="CText5" style="width:100px;" id="CText5" tabindex="5" class="fieldItem"  field="CText5" /></li>
                    <li  class="basic">
                        &nbsp;6.<input type="text" name="CText6" style="width:100px;" id="CText6" tabindex="6" class="fieldItem"  field="CText6" /></li>
                    <li  class="basic">
                        &nbsp;7.<input type="text" name="CText7" style="width:100px;" id="CText7" tabindex="7" class="fieldItem"  field="CText7" /></li>
                    <li  class="basic">
                        &nbsp;8.<input type="text" name="CText8" style="width:100px;" id="CText8" tabindex="8" class="fieldItem"  field="CText8" /></li>
                    <li  class="basic">
                        &nbsp;9.<input type="text" name="CText9" style="width:100px;" id="CText9" tabindex="9" class="fieldItem"  field="CText9" /></li>
                    <li  class="basic">
                       10.<input type="text" name="CText10" style="width:100px;" id="CText10" tabindex="10" class="fieldItem"  field="CText10" /></li>
                    <li  class="basic">
                       11.<input type="text" name="CText11" style="width:100px;" id="CText11" tabindex="11" class="fieldItem"  field="CText11" /></li>
                    <li  class="basic">
                       12.<input type="text" name="CText12" style="width:100px;" id="CText12" tabindex="12" class="fieldItem"  field="CText12" /></li>
                    <li  class="basic">
                       13.<input type="text" name="CText13" style="width:100px;" id="CText13" tabindex="13" class="fieldItem"  field="CText13" /></li>
                    <li  class="basic">
                       14.<input type="text" name="CText14" style="width:100px;" id="CText14" tabindex="14" class="fieldItem"  field="CText14" /></li>
                    <li  class="basic">
                       15.<input type="text" name="CText15" style="width:100px;" id="CText15" tabindex="15" class="fieldItem"  field="CText15" /></li>
                    <li  class="basic">
                       16.<input type="text" name="CText16" style="width:100px;" id="CText16" tabindex="16" class="fieldItem"  field="CText16" /></li>
                    <li  class="basic">
                       17.<input type="text" name="CText17" style="width:100px;" id="CText17" tabindex="17" class="fieldItem"  field="CText17" /></li>
                    <li  class="basic">
                       18.<input type="text" name="CText18" style="width:100px;" id="CText18" tabindex="18" class="fieldItem"  field="CText18" /></li>
                    <li  class="basic">
                       19.<input type="text" name="CText19" style="width:100px;" id="CText19" tabindex="19" class="fieldItem"  field="CText19" /></li>
                    <li  class="basic">
                       20.<input type="text" name="CText20" style="width:100px;" id="CText20" tabindex="20" class="fieldItem"  field="CText20" /></li>

                   <li class="basic metrouicss"  >
                        <div   style="float:left; font-size:20px">
                            <input  type="button" id="btnSave"   name="btnSave"  value="保存"  tabindex="21"     class="fg-color-white bg-color-blue"/>
                             <input  type="button" id="btncancle"   name="btncancle"  value="取消" onclick="window.history.back(-1);"   class="fg-color-white bg-color-blue"/>
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
