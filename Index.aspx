<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="AppBox.Index" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
    <title>首页</title>
    <link href="easyui/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <link href="easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="easyui/themes/bigicon.css" rel="stylesheet" type="text/css" /> 
    <script src="easyui/js/jquery-1.9.0.min.js" type="text/javascript"></script>  
    <script src="easyui/js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="easyui/js/outlook2.js" type="text/javascript"></script> 
   <script type="text/javascript">

       var _menus = { "menus": [
						{ "menuid": "1", "icon": "icon-sys", "menuname": "控件使用",
						    "menus": [
                                    { "menuname": "基础管理", "icon": "bigicon-plus", "url": "View/Customers/CustomerList.aspx" },
									{ "menuname": "添加用户", "icon": "bigicon-user", "url": "View/Invests/InvestList.aspx" },
									{ "menuname": "云问卷", "icon": "bigicon-gps", "url": "View/CloudInvests/CloudInvestList.aspx" }, 
									{ "menuname": "新增问卷", "icon": "bigicon-user", "url": "View/Invests/InvestEdit.aspx" },
									{ "menuname": "定时提醒", "icon": "bigicon-build", "url": "View/Alerts/AlertList.aspx" },
									{ "menuname": "系统日志", "icon": "bigicon-wifi", "url": "demo.html" }, 
									{ "menuname": "系统日志", "icon": "bigicon-wifi", "url": "demo.html" },
									{ "menuname": "系统日志", "icon": "bigicon-wifi", "url": "demo.html" },
									{ "menuname": "系统日志", "icon": "bigicon-wifi", "url": "demo.html" }
								    ]
						} ]		
       };
    
    </script>

</head>
<body class="easyui-layout" style="overflow-y: hidden"  scroll="no">

    <div region="north" split="true" border="false" style="overflow: hidden; height: 30px;
        background: url(images/layout-browser-hd-bg.gif) #7f99be repeat-x center 50%;
        line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
        <span style="float:right; padding-right:20px;" class="head">欢迎 ook <a href="#" id="editpass">修改密码</a> <a href="#" id="loginOut">安全退出</a></span>
        <span style="padding-left:10px; font-size: 16px; ">
    </div>
    <div region="west" split="true" title="导航菜单" style="width:180px;" id="west">
         <div class="easyui-accordion" fit="true" border="false"  style="overflow:auto;">
		<!--  导航内容 -->	
		 </div>
    </div>

    <div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
        <div id="tabs" class="easyui-tabs"  fit="true" border="false" >
			<div title="欢迎使用" style="padding:20px;overflow:hidden;" id="home"> 
			<h1>Welcome to jQuery UI!</h1> 
			</div>
		</div>
    </div>
    
    
  
    

	<div id="mm" class="easyui-menu" style="width:150px;">
		<div id="mm-tabclose">关闭</div>
		<div id="mm-tabcloseall">全部关闭</div>
		<div id="mm-tabcloseother">除此之外全部关闭</div>
		<div class="menu-sep"></div>
		<div id="mm-tabcloseright">当前页右侧全部关闭</div>
		<div id="mm-tabcloseleft">当前页左侧全部关闭</div>
		<div class="menu-sep"></div>
		<div id="mm-exit">退出</div>
	</div>
    <div region="south" split="true" style="height: 30px; background: #D2E0F2; ">
        <div class="footer">&nbsp</div>
    </div>

</body>
</html>