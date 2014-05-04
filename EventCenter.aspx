<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventCenter.aspx.cs" Inherits="AppBox.EventCenter" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html" lang="en" class="no-js">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="" name="description" />
    <meta content="" name="author" />
    <!-- BEGIN GLOBAL MANDATORY STYLES -->
    <link href="media/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="media/css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />
    <link href="media/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="media/css/style-metro.css" rel="stylesheet" type="text/css" />
    <link href="media/css/style.css" rel="stylesheet" type="text/css" />
    <link href="media/css/style-responsive.css" rel="stylesheet" type="text/css" />
    <link href="media/css/default.css" rel="stylesheet" type="text/css" id="style_color" />
    <link href="media/css/uniform.default.css" rel="stylesheet" type="text/css" />
    <!-- END GLOBAL MANDATORY STYLES -->
    <!-- BEGIN PAGE LEVEL STYLES -->
    <link href="media/css/bootstrap-fileupload.css" rel="stylesheet" type="text/css" />
    <link href="media/css/chosen.css" rel="stylesheet" type="text/css" />
    <link href="media/css/profile.css" rel="stylesheet" type="text/css" />
    <!-- END PAGE LEVEL STYLES -->
    <link rel="shortcut icon" href="media/image/favicon.ico" />
    <script src="common/js/Common.js" type="text/javascript"></script>
    <title>事务中心</title> 
    <style type="text/css">
        label
        {
            display: inline-block;
        }
    </style>
</head>
<body style="background-color: #27a9e3; overflow: hidden" page-header-fixed>
    <div class="header navbar navbar-inverse navbar-fixed-top">
        <!-- BEGIN TOP NAVIGATION BAR -->
        <div class="navbar-inner">
            <div class="container-fluid">
                <!-- BEGIN LOGO -->
                <a class="brand" href="TilePanel.aspx">
                    <img src="media/image/log.png" style="height: 30px;" alt="logo">
                </a>
                <!-- END LOGO -->
                <div class="navbar hor-menu hidden-phone hidden-tablet">
                    <div class="navbar-inner">
                        <ul class="nav">
                            <li class="visible-phone visible-tablet">
                                <!-- BEGIN RESPONSIVE QUICK SEARCH FORM -->
                                <form class="sidebar-search">
                                <div class="input-box">
                                    <a href="javascript:;" class="remove"></a>
                                    <input type="text" placeholder="Search...">
                                    <input type="button" class="submit" value=" ">
                                </div>
                                </form>
                                <!-- END RESPONSIVE QUICK SEARCH FORM -->
                            </li>
                            <li ><a href="CustomerTilePanel.aspx">客户分层 <span  ></span></a></li>
                            <li class="active"><a href="#">事务中心 <span class="selected"></span></a></li>
                            <li><a href="#">数据分析 <span  ></span></a></li>
                            <li><a href="#">系统设置 <span ></span></a></li>
                            <%--
                            <li><span class="hor-menu-search-form-toggler">&nbsp;</span>
                                <div class="search-form hidden-phone hidden-tablet">
                                    <form class="form-search">
                                    <div class="input-append">
                                        <input type="text" placeholder="Search..." class="m-wrap">
                                        <button type="button" class="btn">
                                        </button>
                                    </div>
                                    </form>
                                </div>
                            </li>--%>
                        </ul>
                    </div>
                </div>
                <!-- BEGIN RESPONSIVE MENU TOGGLER -->
                <a href="javascript:;" class="btn-navbar collapsed" data-toggle="collapse" data-target=".nav-collapse">
                    <img src="media/image/menu-toggler.png" alt="">
                </a>
                <!-- END RESPONSIVE MENU TOGGLER -->
                <!-- BEGIN TOP NAVIGATION MENU -->
                <ul class="nav pull-right">
                   <!-- BEGIN NOTIFICATION DROPDOWN -->
                    <li class="dropdown" id="header_notification_bar" style="outline: 0px; box-shadow: rgba(102, 188, 230, 0) 0px 0px 13px;
                        outline-offset: 20px;"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i
                            class="icon-warning-sign"></i><span class="badge">9</span> </a>
                        <ul class="dropdown-menu extended notification">
                            <li>
                                <p>
                                    You have 14 new notifications</p>
                            </li>
                            <li><a href="#"><span class="label label-success"><i class="icon-plus"></i></span>New
                                user registered. <span class="time">Just now</span> </a></li>
                            <li><a href="#"><span class="label label-important"><i class="icon-bolt"></i></span>
                                Server #12 overloaded. <span class="time">15 mins</span> </a></li>
                            <li><a href="#"><span class="label label-warning"><i class="icon-bell"></i></span>Server
                                #2 not respoding. <span class="time">22 mins</span> </a></li>
                            <li><a href="#"><span class="label label-info"><i class="icon-bullhorn"></i></span>Application
                                error. <span class="time">40 mins</span> </a></li>
                            <li><a href="#"><span class="label label-important"><i class="icon-bolt"></i></span>
                                Database overloaded 68%. <span class="time">2 hrs</span> </a></li>
                            <li><a href="#"><span class="label label-important"><i class="icon-bolt"></i></span>
                                2 user IP blocked. <span class="time">5 hrs</span> </a></li>
                            <li class="external"><a href="#">See all notifications <i class="m-icon-swapright"></i>
                            </a></li>
                        </ul>
                    </li>
                    <!-- END NOTIFICATION DROPDOWN -->
                    <!-- BEGIN INBOX DROPDOWN -->
                    <li class="dropdown" id="header_inbox_bar" style="outline: 0px; box-shadow: rgba(221, 81, 49, 0) 0px 0px 13px;
                        outline-offset: 20px;"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i
                            class="icon-envelope"></i><span class="badge">7</span> </a>
                        <ul class="dropdown-menu extended inbox">
                            <li>
                                <p>
                                    You have 12 new messages</p>
                            </li>
                            <li><a href="inbox.html?a=view"><span class="photo">
                                <img src="media/image/avatar2.jpg" alt=""></span> <span class="subject"><span class="from">
                                    Lisa Wong</span> <span class="time">Just Now</span> </span><span class="message">Vivamus
                                        sed auctor nibh congue nibh. auctor nibh auctor nibh... </span></a></li>
                            <li><a href="inbox.html?a=view"><span class="photo">
                                <img src="./media/image/avatar3.jpg" alt=""></span> <span class="subject"><span class="from">
                                    Richard Doe</span> <span class="time">16 mins</span> </span><span class="message">Vivamus
                                        sed congue nibh auctor nibh congue nibh. auctor nibh auctor nibh... </span>
                            </a></li>
                            <li><a href="inbox.html?a=view"><span class="photo">
                                <img src="./media/image/avatar1.jpg" alt=""></span> <span class="subject"><span class="from">
                                    Bob Nilson</span> <span class="time">2 hrs</span> </span><span class="message">Vivamus
                                        sed nibh auctor nibh congue nibh. auctor nibh auctor nibh... </span></a>
                            </li>
                            <li class="external"><a href="inbox.html">See all messages <i class="m-icon-swapright">
                            </i></a></li>
                        </ul>
                    </li>
                    <!-- END INBOX DROPDOWN -->
                    <!-- BEGIN TODO DROPDOWN -->
                    <li class="dropdown" id="header_task_bar"><a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="icon-tasks"></i><span class="badge">5</span> </a>
                        <ul class="dropdown-menu extended tasks">
                            <li>
                                <p>
                                    You have 12 pending tasks</p>
                            </li>
                            <li><a href="#"><span class="task"><span class="desc">New release v1.2</span> <span
                                class="percent">30%</span> </span><span class="progress progress-success "><span
                                    style="width: 30%;" class="bar"></span></span></a></li>
                            <li><a href="#"><span class="task"><span class="desc">Application deployment</span>
                                <span class="percent">65%</span> </span><span class="progress progress-danger progress-striped active">
                                    <span style="width: 65%;" class="bar"></span></span></a></li>
                            <li><a href="#"><span class="task"><span class="desc">Mobile app release</span> <span
                                class="percent">98%</span> </span><span class="progress progress-success"><span style="width: 98%;"
                                    class="bar"></span></span></a></li>
                            <li><a href="#"><span class="task"><span class="desc">Database migration</span> <span
                                class="percent">10%</span> </span><span class="progress progress-warning progress-striped">
                                    <span style="width: 10%;" class="bar"></span></span></a></li>
                            <li><a href="#"><span class="task"><span class="desc">Web server upgrade</span> <span
                                class="percent">58%</span> </span><span class="progress progress-info"><span style="width: 58%;"
                                    class="bar"></span></span></a></li>
                            <li><a href="#"><span class="task"><span class="desc">Mobile development</span> <span
                                class="percent">85%</span> </span><span class="progress progress-success"><span style="width: 85%;"
                                    class="bar"></span></span></a></li>
                            <li class="external"><a href="#">See all tasks <i class="m-icon-swapright"></i></a>
                            </li>
                        </ul>
                    </li>
                    <!-- END TODO DROPDOWN -->
                    <!-- BEGIN USER LOGIN DROPDOWN -->
                    <li class="dropdown user"><a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <img alt="" src="media/image/avatar1_small.jpg">
                        <span class="username">
                            <label runat="server" id="lbUserName" style="width: 100px;">
                            </label>
                        </span><i class="icon-angle-down"></i></a>
                        <ul class="dropdown-menu"> 
                            <li><a onclick="password()"><i class="icon-key"></i>更改密码</a></li>  
                            <li><a onclick=" "><i class="icon-key"></i>跟单员</a></li> 
                            <li><a onclick=" "><i class="icon-key"></i>经理</a></li> 
                            <li><a onclick=" "><i class="icon-key"></i>仓库</a></li> 
                            <li><a onclick=" "><i class="icon-key"></i>财务</a></li> 
                            <li><a onclick=" "><i class="icon-key"></i>老板</a></li> 
                            <li><a href="login.aspx"><i class="icon-key"></i>退出</a></li>
                        </ul>
                    </li>
                    <!-- END USER LOGIN DROPDOWN -->
                </ul>
                <!-- END TOP NAVIGATION MENU -->
            </div>
        </div>
        <!-- END TOP NAVIGATION BAR -->
    </div>
    <div class="page-container row-fluid"   style="margin-top:40px;" >
        <!-- BEGIN HORIZONTAL MENU PAGE  SIDEBAR1 -->
        <div class="page-sidebar nav-collapse collapse" style="width:199px; ">
            <ul class="page-sidebar-menu hidden-phone hidden-tablet">
                <li style="height:10px;">&nbsp;
                </li>
                <li> 
                </li>
                     <li class="start active"><a href="javascript:;"><i class="icon-th-list"></i><span class="title">事务中心</span>
                     <span class="selected"></span><span class="arrow open"></span></a> 
                    <ul class="sub-menu">
                        <li class="active"><a href="#">我的申请</a></li>
                        <li><a href="#">我的审批</a></li> 
                    </ul>
                </li> 
                 
              </ul>  
        </div>
        <!-- END BEGIN HORIZONTAL MENU PAGE SIDEBAR -->
        <!-- BEGIN PAGE -->
        <div class="page-content" style="margin-left:200px; "  >
                  <iframe src="View/SaleBill/SaleBillList.aspx" frameborder="0" width="100%" height="620px"></iframe>
        </div>
        <!-- END PAGE -->
    </div>
    <%--以下為自定義分組查詢--%>
    <%--<div class="tabbable tabbable-custom">

				<ul class="nav nav-tabs" id="Menutabs"> 
					<li  class="active"><a href="#menutab_1" data-toggle="tab">客戶筛选</a></li> 
                    <li  class=""><a href="#menutab_2" data-toggle="tab">自定义筛选</a></li> 
				</ul>

				<div class="tab-content" id="MenuContent">

					<div class="tab-pane active" id="menutab_1" runat="server">
 
					</div>
                    <div class="tab-pane" id="menutab_2" runat="server">
                         
					</div>
 

				</div>

			</div>--%>
    <%--  <div class="page-content" style="margin-top: 42px;">
     <iframe src="View/MainBill/MainBills.aspx" id="iframepage" frameBorder=0 width="100%"  scrolling=no onLoad="iFrameHeight()" ></iframe>
   </div>
   <script>
       function MenuOnClick(url) {
           $("#iframepage").attr("src",url); 
       }
       function iFrameHeight() {
           var ifm = document.getElementById("iframepage");
           var subWeb = document.frames ? document.frames["iframepage"].document : ifm.contentDocument;
           if (ifm != null && subWeb != null) {
               ifm.height = subWeb.body.scrollHeight;
           }
       }   
   </script>--%>
     
        <!-- END TAB PORTLET-->
        <%--<iframe src="View/MainBill/MainBills.aspx" id="iframepage" frameBorder=0 width="100%" height="620px" ></iframe>
    </div>--%>
    <script>
        var num = 1;
        function delli(obj, id) {
            $(obj).prev().attr("class", "active");
            $("#" + id).prev().attr("class", "tab-pane active");
            $(obj).remove();
            $("#" + id).remove();

        }
        function MenuOnClick(url, cname) {
            //$("#iframepage").attr("src", url);
            var $a = $("#panelul").find("li");
            var $div = $("#panelcontent").find("div");
            num++;
            $a.each(function () {
                $(this).attr("class", "");
            });
            $("#panelcontent").find("div").each(function () {
                $(this).attr("class", "tab-pane");
            });
            for (var i = 0; i < $a.length; i++) {
                var contral = $a[i];
                var divcontral = $div[i];
                if ($(contral).attr("url") == url) {
                    $(contral).attr("class", "active");
                    $(divcontral).attr("class", "tab-pane active");
                    return;
                }
            }
            $("#panelul").append("<li class='active' url='" + url + "' ondblclick='delli(this,\"tab_" + num + "\")'><a href='#tab_" + num + "'  data-toggle='tab'>" + cname + "</a></li>");
            $("#panelcontent").append("<div class='tab-pane active' id='tab_" + num + "'><iframe src='" + url + "' frameBorder=0 width='100%' height='620px' ></iframe></div>");
        }
        function iFrameHeight() {
            var ifm = document.getElementById("iframepage");
            var subWeb = document.frames ? document.frames["iframepage"].document : ifm.contentDocument;
            if (ifm != null && subWeb != null) {
                ifm.height = subWeb.body.scrollHeight;
            }
        }   
    </script>
    <link href="easyui/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <script src="easyui/js/jquery.easyui.min.js" type="text/javascript"></script>
    <%-- <div id="WinPassWord" class="easyui-window" data-options="title:'密码修改',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 400px; height: 250px;" >
        <form name="formPassWord" id="formPassWord" status="PassWord" >
            <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0; text-align:center">
                 <ul> 
                    <li class="basic">
                            <label for="txtPassword">
                            原始密码:</label>  
                            <input type="password"  name="Password" tabindex="1" id="txtPassword" class="fieldItem" required="true"  />
                    </li> 
                    <li class="basic">
                            <label for="txtNew">
                            新&nbsp;密&nbsp;码: </label>  
                            <input type="password"  name="New" tabindex="2" id="txtNew" class="fieldItem" required="true"  />
                    </li> 
                    <li class="basic">
                            <label for="txtNew1">
                            确认密码:</label>  
                            <input type="password"  name="New1" tabindex="3" id="txtNew1" class="fieldItem" required="true"  />
                    </li> 
                    <li class="basic">
                      <a class="easyui-linkbutton" id="btnPassWord"  >确认修改</a>
                    <a class="easyui-linkbutton"   href="javascript:void(0)"
                       onclick="javascript: $('#WinPassWord').window('close');">取消</a>
                    </li>
                </ul>
                
            </div> 
        </form>
    </div>--%>
    <!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
    <!-- BEGIN CORE PLUGINS -->
    <script src="media/js/jquery-1.10.1.min.js" type="text/javascript"></script>
    <script src="media/js/jquery-migrate-1.2.1.min.js" type ="text/javascript"></script>
    <!-- IMPORTANT! Load jquery-ui-1.10.1.custom.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->
    <script src="media/js/jquery-ui-1.10.1.custom.min.js" type="text/javascript"></script>
    <script src="media/js/bootstrap.min.js" type="text/javascript"></script>
    <!--[if lt IE 9]>

	<script src="media/js/excanvas.min.js"></script>

	<script src="media/js/respond.min.js"></script>  

	<![endif]-->
    <script src="media/js/jquery.slimscroll.min.js" type="text/javascript"></script>
    <script src="media/js/jquery.blockui.min.js" type="text/javascript"></script>
    <script src="media/js/jquery.cookie.min.js" type="text/javascript"></script>
    <script src="media/js/jquery.uniform.min.js" type="text/javascript"></script>
    <!-- END CORE PLUGINS -->
    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <script src="media/js/jquery.vmap.js" type="text/javascript"></script>
    <script src="media/js/jquery.vmap.russia.js" type="text/javascript"></script>
    <script src="media/js/jquery.vmap.world.js" type="text/javascript"></script>
    <script src="media/js/jquery.vmap.europe.js" type="text/javascript"></script>
    <script src="media/js/jquery.vmap.germany.js" type="text/javascript"></script>
    <script src="media/js/jquery.vmap.usa.js" type="text/javascript"></script>
    <script src="media/js/jquery.vmap.sampledata.js" type="text/javascript"></script>
    <script src="media/js/jquery.flot.js" type="text/javascript"></script>
    <script src="media/js/jquery.flot.resize.js" type="text/javascript"></script>
    <script src="media/js/jquery.pulsate.min.js" type="text/javascript"></script>
    <script src="media/js/date.js" type="text/javascript"></script>
    <script src="media/js/daterangepicker.js" typ e="text/javascript"></script>
    <script src="media/js/jquery.gritter.js" type="text/javascript"></script>
    <script src="media/js/fullcalendar.min.js" type="text/javascript"></script>
    <script src="media/js/jquery.easy-pie-chart.js" type="text/javascript"></script>
    <script src="media/js/jquery.sparkline.min.js" type="text/javascript"></script>
    <!-- END PAGE LEVEL PLUGINS -->
    <!-- BEGIN PAGE LEVEL SCRIPTS -->
    <script src="media/js/app.js" type="text/javascript"></script>
    <script src="media/js/index.js" type="text/javascript"></script>
    <!-- END PAGE LEVEL SCRIPTS -->
    <script>
        jQuery(document).ready(function () { 
            App.init(); // initlayout and core plugins
            Index.init();
            Index.initJQVMAP(); // init index page's custom scripts
            Index.initCalendar(); // init index page's custom scripts
            Index.initCharts(); // init index page's custom scripts
            Index.initChat();
            Index.initMiniCharts();
            Index.initDashboardDaterange();
            Index.initIntro();
        });

    </script>
    <!-- END JAVASCRIPTS -->
    <script type="text/javascript">        var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-37564768-1']); _gaq.push(['_setDomainName', 'keenthemes.com']); _gaq.push(['_setAllowLinker', true]); _gaq.push(['_trackPageview']); (function () { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script>
</body>
<!-- END BODY -->
</html>
