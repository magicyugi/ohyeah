<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintTest.aspx.cs" Inherits="AppBox.View.Users.PrintTest" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>   
    <link href="../../easyui/themes/metro/easyui.css" rel="stylesheet" type="text/css" media="screen" />
    <script src="../../easyui/js/jquery-1.9.0.min.js" type="text/javascript"></script> 
    <script src="../../easyui/js/jquery.easyui.min.js" type="text/javascript"></script> 
    <script src="../../common/js/Common.js" type="text/javascript"></script>
    <script src="../../common/js/jquery.PrintArea.js" type="text/javascript"></script>
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var  namecode = "User";
        $().ready(function () {
         
            $("#btnPrint").click(function () {
                $("#printarea").printArea();
                //SaveUserRecord(url, namecode, "combWarehouse,combUser");
            })
        })
        </script>
</head>
<body>
    <form runat="server">
    <input type="button" value="打印" id="btnPrint"  />
    <div class="metrouicss" id="printarea">
    aaaaaa
    </div>
    </form>
</body>
</html>
