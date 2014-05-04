<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerTilePanel.aspx.cs" Inherits="AppBox.CustomerTilePanel" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html" lang="en" class="no-js">
<head>
<meta charset="utf-8" />
 
  
   <meta content="width=device-width, initial-scale=1.0" name="viewport" />

	<meta content="" name="description" />

	<meta content="" name="author" />

	<!-- BEGIN GLOBAL MANDATORY STYLES --> 
	<link href="media/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>

	<link href="media/css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css"/>

	<link href="media/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>

<%--	<link href="media/css/style-metro.css" rel="stylesheet" type="text/css"/>--%>

	<link href="media/css/style.css" rel="stylesheet" type="text/css"/>

	<link href="media/css/style-responsive.css" rel="stylesheet" type="text/css"/>

	<link href="media/css/default.css" rel="stylesheet" type="text/css" id="style_color"/>

	<link href="media/css/uniform.default.css" rel="stylesheet" type="text/css"/>

	<!-- END GLOBAL MANDATORY STYLES -->

	<!-- BEGIN PAGE LEVEL STYLES -->

	<link href="media/css/bootstrap-fileupload.css" rel="stylesheet" type="text/css" />

	<link href="media/css/chosen.css" rel="stylesheet" type="text/css" />

	<link href="media/css/profile.css" rel="stylesheet" type="text/css" />
   
	<!-- END PAGE LEVEL STYLES -->

	<link rel="shortcut icon" href="media/image/favicon.ico" />
    <script src="common/js/Common.js" type="text/javascript"></script>    
    <title>三联客户关系系统</title>
    <script type="text/javascript">
        
    </script>
    <style type="text/css">
         label{display:inline-block;}
      .popover-content form {
        margin: 0 auto;
        width: 213px;
      }
      .popover-content form .btn{
        margin-right: 10px
      }
.popover-content form .controls{
        font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
font-size: 13px;
line-height: 18px;
color: #333;
margin-left:0px;
      }
#target{
        min-height: 200px;
        border: 1px solid #ccc;
        padding: 5px;
      }
      #target .component{
        border: 1px solid #fff;
      }
      #temp{
        width: 500px;
        background: white;
        border: 1px dotted #ccc;
        border-radius: 10px;
      }
        .valtype {
            float:left;
        }
    </style>
</head>
<body style=" background-color:#27a9e3;overflow:hidden" > 
     
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
                            <li class="active"><a href="#">客户分层 <span class="selected"></span></a></li>
                            <li ><a href="EventCenter.aspx">事务中心 <span ></span></a></li>
                            <li><a href="#">数据分析 <span ></span></a></li>
                            <li><a href="#">系统设置 <span></span></a></li>
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
					<li class="dropdown" id="header_notification_bar" style="outline: 0px; box-shadow: rgba(102, 188, 230, 0) 0px 0px 13px; outline-offset: 20px;">

						<a href="#" class="dropdown-toggle" data-toggle="dropdown">

						<i class="icon-warning-sign"></i>

						<span class="badge">9</span>

						</a>

						<ul class="dropdown-menu extended notification"> 
							<li>

								<p>You have 14 new notifications</p>

							</li>

							<li>
                                
								<a href="#">

								<span class="label label-success"><i class="icon-plus"></i></span>

								New user registered. 

								<span class="time">Just now</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="label label-important"><i class="icon-bolt"></i></span>

								Server #12 overloaded. 

								<span class="time">15 mins</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="label label-warning"><i class="icon-bell"></i></span>

								Server #2 not respoding.

								<span class="time">22 mins</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="label label-info"><i class="icon-bullhorn"></i></span>

								Application error.

								<span class="time">40 mins</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="label label-important"><i class="icon-bolt"></i></span>

								Database overloaded 68%. 

								<span class="time">2 hrs</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="label label-important"><i class="icon-bolt"></i></span>

								2 user IP blocked.

								<span class="time">5 hrs</span>

								</a>

							</li>

							<li class="external">

								<a href="#">See all notifications <i class="m-icon-swapright"></i></a>

							</li>

						</ul>

					</li>

					<!-- END NOTIFICATION DROPDOWN -->

					<!-- BEGIN INBOX DROPDOWN -->

					<li class="dropdown" id="header_inbox_bar" style="outline: 0px; box-shadow: rgba(221, 81, 49, 0) 0px 0px 13px; outline-offset: 20px;">

						<a href="#" class="dropdown-toggle" data-toggle="dropdown">

						<i class="icon-envelope"></i>

						<span class="badge">7</span>

						</a>

						<ul class="dropdown-menu extended inbox">

							<li>

								<p>You have 12 new messages</p>

							</li>

							<li>

								<a href="inbox.html?a=view">

								<span class="photo"><img src="media/image/avatar2.jpg" alt=""></span>

								<span class="subject">

								<span class="from">Lisa Wong</span>

								<span class="time">Just Now</span>

								</span>

								<span class="message">

								Vivamus sed auctor nibh congue nibh. auctor nibh

								auctor nibh...

								</span>  

								</a>

							</li>

							<li>

								<a href="inbox.html?a=view">

								<span class="photo"><img src="./media/image/avatar3.jpg" alt=""></span>

								<span class="subject">

								<span class="from">Richard Doe</span>

								<span class="time">16 mins</span>

								</span>

								<span class="message">

								Vivamus sed congue nibh auctor nibh congue nibh. auctor nibh

								auctor nibh...

								</span>  

								</a>

							</li>

							<li>

								<a href="inbox.html?a=view">

								<span class="photo"><img src="./media/image/avatar1.jpg" alt=""></span>

								<span class="subject">

								<span class="from">Bob Nilson</span>

								<span class="time">2 hrs</span>

								</span>

								<span class="message">

								Vivamus sed nibh auctor nibh congue nibh. auctor nibh

								auctor nibh...

								</span>  

								</a>

							</li>

							<li class="external">

								<a href="inbox.html">See all messages <i class="m-icon-swapright"></i></a>

							</li>

						</ul>

					</li>

					<!-- END INBOX DROPDOWN -->

					<!-- BEGIN TODO DROPDOWN -->

					<li class="dropdown" id="header_task_bar">

						<a href="#" class="dropdown-toggle" data-toggle="dropdown">

						<i class="icon-tasks"></i>

						<span class="badge">5</span>

						</a>

						<ul class="dropdown-menu extended tasks">

							<li>

								<p>You have 12 pending tasks</p>

							</li>

							<li>

								<a href="#">

								<span class="task">

								<span class="desc">New release v1.2</span>

								<span class="percent">30%</span>

								</span>

								<span class="progress progress-success ">

								<span style="width: 30%;" class="bar"></span>

								</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="task">

								<span class="desc">Application deployment</span>

								<span class="percent">65%</span>

								</span>

								<span class="progress progress-danger progress-striped active">

								<span style="width: 65%;" class="bar"></span>

								</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="task">

								<span class="desc">Mobile app release</span>

								<span class="percent">98%</span>

								</span>

								<span class="progress progress-success">

								<span style="width: 98%;" class="bar"></span>

								</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="task">

								<span class="desc">Database migration</span>

								<span class="percent">10%</span>

								</span>

								<span class="progress progress-warning progress-striped">

								<span style="width: 10%;" class="bar"></span>

								</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="task">

								<span class="desc">Web server upgrade</span>

								<span class="percent">58%</span>

								</span>

								<span class="progress progress-info">

								<span style="width: 58%;" class="bar"></span>

								</span>

								</a>

							</li>

							<li>

								<a href="#">

								<span class="task">

								<span class="desc">Mobile development</span>

								<span class="percent">85%</span>

								</span>

								<span class="progress progress-success">

								<span style="width: 85%;" class="bar"></span>

								</span>

								</a>

							</li>

							<li class="external">

								<a href="#">See all tasks <i class="m-icon-swapright"></i></a>

							</li>

						</ul>

					</li>

					<!-- END TODO DROPDOWN -->

					<!-- BEGIN USER LOGIN DROPDOWN -->

					<li class="dropdown user">

						<a href="#" class="dropdown-toggle" data-toggle="dropdown">

						<img alt="" src="media/image/avatar1_small.jpg">

						<span class="username"><label runat="server" id="lbUserName"  style="width:100px;" ></label></span>

						<i class="icon-angle-down"></i>

						</a>

						<ul class="dropdown-menu">  
							<li><a><i class="icon-home"></i><label runat="server" id="lbTime"  style="width:100px"  ></label></a> </li>
                            <li><a href="extra_profile.html"><i class="icon-user"></i> My Profile</a></li>

							<li><a href="page_calendar.html"><i class="icon-calendar"></i> My Calendar</a></li>

							<li><a href="inbox.html"><i class="icon-envelope"></i> My Inbox(3)</a></li>

							<li><a href="#"><i class="icon-tasks"></i> My Tasks</a></li>

							<li class="divider"></li>
                            <li><a  onclick="password()" ><i class="icon-key"></i>更改密码</a></li>
							<li><a href="extra_lock.html"><i class="icon-lock"></i> Lock Screen</a></li>

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
     
    <%--<div id="Menudiv" runat="server" class="page-sidebar nav-collapse collapse"> 
		 	
	</div>--%>

    <%--以下為自定義分組查詢--%>
    <div class="tabbable tabbable-custom page-sidebar nav-collapse collapse"> 
		<ul class="nav nav-tabs" id="Menutabs"> 
			<li  class="active"><a href="#Menudiv" data-toggle="tab">客戶筛选</a></li> 
            <li  class=""><a href="#MenuGroup" data-toggle="tab">自定义筛选</a></li>  
		</ul>

		<div class="tab-content" id="MenuContent">

			<div class="tab-pane active" id="Menudiv" runat="server">
 
			</div>
            <div class="tab-pane" id="MenuGroup" runat="server">
                         
			</div>
 

		</div> 
     </div>
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

   <div class="page-content" style="margin-top: 42px;"> 

	<!-- BEGIN TAB PORTLET-->   

	<div class="portlet box blue tabbable">
<%--
		<div class="portlet-title"> 
			<div class="caption"><i class="icon-reorder"></i>主页</div> 
		</div>
--%>
		<div class="portlet-body">
         <div id="showSearch"  style="overflow:hidden;">
             <input id="hdnsearchvalue" type="hidden" value=""/>
         </div>
		 <div class="tab-content" >
             <div id="tabShow" class="tab-pane active" ><iframe id="showIframe" src="View/Customers/CustomerList.aspx"  frameBorder=0 width="100%" height="620px" ></iframe> </div>
             <div id="tabGroup" class="tab-pane" style="OVERFLOW-Y: auto;height:620px;" >
                 
                 <div class="container">
      <div class="row clearfix">
        <div class="span6">
          <div class="clearfix">
            <h2>您的分组</h2>
            <hr>
            <div id="build">
              <form id="target" class="form-horizontal">
                <fieldset>
                  <div id="legend" class="component" rel="popover" trigger="manual">
                    <legend class="valtype" data-valtype="text"> <input id="txtGroupName" name="GroupName" type="text" placeholder="请输入分组名." class="input-xlarge "> 

                        <div style="float:right;">
                         <a class="btn btn-success" style="margin-right:5px;" onclick="onsaveGroup()">保存<i class="icon-plus-sign"></i></a> 
                         <a class="btn btn-success" onclick="onrefresh()">重置<i class="icon-refresh"></i></a> 
                        </div>
                        </legend>
                    
                  </div> 
                </fieldset>
              </form>
            </div>
          </div>
        </div> 
     
        <div class="span6">
            <h2>拖拽下面的组件到左侧</h2>
            <hr>
          <div class="tabbable">
            <ul class="nav nav-tabs" id="navtab">
              <li class="active"><a href="#1" data-toggle="tab">输入框</a></li>
              <li class=""><a href="#2" data-toggle="tab">选择框</a></li>
              <li class=""><a href="#3" data-toggle="tab">单选/复选</a></li>
              <li class=""><a href="#4" data-toggle="tab">自定义代码</a></li> 
            </ul>
            <form class="form-horizontal" id="components">
              <fieldset>
                <div class="tab-content">

                  <div class="tab-pane active" id="1">

                    <div class="control-group component" style="float:left;" name="Cname" data-type="text" rel="popover" title="输入姓名搜索." trigger="manual" >

                      <!-- Text input-->
                      <label class="control-label valtype" data-valtype="label">姓名:</label>
                      <div class="controls">
                        <select class="input-small valtype" name="Cname_Type" data-valtype="option">
                          <option value="like">等于</option> 
                          <option value="<>">不等于</option> 
                        </select>
                        <input type="text" name="Cname"  placeholder="请输入姓名." style="width:176px;" class="input-xlarge valtype" data-valtype="placeholder"> 
                            
                      </div>
                        
                    </div>
                    <div class="control-group component" data-type="text" name="Address" rel="popover" title="输入地址搜索." trigger="manual" >

                      <!-- Text input-->
                      <label class="control-label valtype" data-valtype="label">地址:</label>
                      <div class="controls">
                        <select class="input-small valtype" name="Address_Type" data-valtype="option">
                          <option value="like">等于</option> 
                          <option value="<>">不等于</option> 
                        </select>
                        <input type="text" name="Address" placeholder="请输入地址." style="width:176px;" class="input-xlarge valtype" data-valtype="placeholder"> 
                      </div>
                    </div>
                    <div class="control-group component" data-type="text" name="Phone" rel="popover" title="输入任意手机号搜索." trigger="manual" >

                      <!-- Text input-->
                      <label class="control-label valtype" data-valtype="label">手机:</label>
                      <div class="controls">
                        <select class="input-small valtype" name="Phone_Type" data-valtype="option">
                          <option value="like">等于</option> 
                          <option value="<>">不等于</option> 
                        </select>
                        <input type="text" name="Phone" placeholder="请输入任意手机号."  style="width:176px;" class="input-xlarge valtype" data-valtype="placeholder"> 
                      </div>
                    </div>
                    <div class="control-group component" data-type="text" name="Description" rel="popover" title="输入备注搜索." trigger="manual" >

                      <!-- Text input-->
                      <label class="control-label valtype" data-valtype="label">备注:</label>
                      <div class="controls">
                           <select class="input-small valtype" name="Description_Type" data-valtype="option">
                          <option value="like">等于</option> 
                          <option value="<>">不等于</option> 
                        </select>
                        <input type="text" name="Description" placeholder="请输入备注."  style="width:176px;" class="input-xlarge valtype" data-valtype="placeholder"> 
                      </div>
                    </div> 

                  </div>
                   
                  <div class="tab-pane" id="2">

                    <div class="control-group component" name="VisitDate" rel="popover" title="Search Input" trigger="manual">

                      <!-- Select Basic -->
                      <label class="control-label valtype" data-valtype="label">最近回访时间:</label>
                      <div class="controls">
                        <select class="input-small valtype" name="VisitDate_Type" data-valtype="option">
                          <option value="=">等于</option>
                          <option value=">">大于</option>
                          <option value="<">小于</option> 
                        </select>

                       <div class="divdatebox" style="width:190px;float:left;">
                           <input type="text" name="VisitDate" style="width:190px;height:30px;float:left;" class="easyui-datebox" /> 
                       </div> 
                      </div> 
                    </div>
                      <div class="control-group component" name="DealDate" rel="popover" title="Search Input" trigger="manual">

                      <!-- Select Basic -->
                      <label class="control-label valtype" data-valtype="label">最近成单时间:</label>
                      <div class="controls">
                        <select class="input-small valtype" name="DealDate_Type"  data-valtype="option">
                          <option value="=">等于</option>
                          <option value=">">大于</option>
                          <option value="<">小于</option> 
                        </select>

                       <div class="divdatebox" style="width:190px;float:left;">
                           <input type="text" name="DealDate"  style="width:190px;height:30px;float:left;" class="easyui-datebox" /> 
                       </div> 
                      </div> 
                    </div>
                      <div class="control-group component" name="CreateDate" rel="popover" title="Search Input" trigger="manual">

                      <!-- Select Basic -->
                      <label class="control-label valtype" data-valtype="label">注册时间:</label>
                      <div class="controls">
                        <select class="input-small valtype" name="DealDate_Type"  data-valtype="option">
                          <option value="=">等于</option>
                          <option value=">">大于</option>
                          <option value="<">小于</option> 
                        </select>

                       <div class="divdatebox" style="width:190px;float:left;">
                           <input type="text" name="DealDate"    style="width:190px;height:30px;float:left;" class="easyui-datebox" /> 
                       </div> 
                      </div> 
                    </div>
                    <div class="control-group component" name="ClientSource" rel="popover" title="Search Input" trigger="manual">

                      <!-- Select Basic -->
                      <label class="control-label valtype" data-valtype="label">客户来源:</label>
                      <div class="controls">
                        <select class="input-small valtype" name="ClientSource"  data-valtype="option">
                          <option value="=">等于</option>
                          <option value=">">大于</option>
                          <option value="<">小于</option> 
                        </select> 
                      </div> 
                    </div>
                    <div class="control-group component" name="IntentionFlag" rel="popover" title="Search Input" trigger="manual">

                      <!-- Select Basic -->
                      <label class="control-label valtype" data-valtype="label">客户类型:</label>
                      <div class="controls">
                        <select class="input-small valtype" name="IntentionFlag" data-valtype="option">
                          <option value="0">意向</option>
                          <option value="1">成交</option>
                          <option value="2">已付款</option>
                          <option value="3">未付款</option>  
                        </select> 
                      </div> 
                    </div> 
                  </div>

                  <div class="tab-pane" id="3">

                    <div class="control-group component" rel="popover" title="Multiple Checkboxes" trigger="manual" data-content="
                      <form class='form'>
                        <div class='controls'>
                          <label class='control-label'>Label Text</label> <input class='input-large' type='text' name='label' id='label'>
                          <label class='control-label'>Options: </label>
                          <textarea style='min-height: 200px' id='checkboxes'> </textarea>
                          <hr/>
                          <button class='btn btn-info'>Save</button><button class='btn btn-danger'>Cancel</button>
                        </div>
                      </form>">
                      <label class="control-label valtype" data-valtype="label">Checkboxes</label>
                      <div class="controls valtype" data-valtype="checkboxes">

                        <!-- Multiple Checkboxes -->
                        <label class="checkbox">
                          <input type="checkbox" value="Option one">
                          Option one
                        </label>
                        <label class="checkbox">
                          <input type="checkbox" value="Option two">
                          Option two
                        </label>
                      </div>

                    </div>

                    <div class="control-group component" rel="popover" title="Multiple Radios" trigger="manual" data-content="
                      <form class='form'>
                        <div class='controls'>
                          <label class='control-label'>Label Text</label> <input class='input-large' type='text' name='label' id='label'>
                          <label class='control-label'>Group Name Attribute</label> <input class='input-large' type='text' name='name' id='name'>
                          <label class='control-label'>Options: </label>
                          <textarea style='min-height: 200px' id='radios'></textarea>
                          <hr/>
                          <button class='btn btn-info'>Save</button><button class='btn btn-danger'>Cancel</button>
                        </div>
                      </form>">
                      <label class="control-label valtype" data-valtype="label">Radio buttons</label>
                      <div class="controls valtype" data-valtype="radios">

                        <!-- Multiple Radios -->
                        <label class="radio">
                          <input type="radio" value="Option one" name="group" checked="checked">
                          Option one
                        </label>
                        <label class="radio">
                          <input type="radio" value="Option two" name="group">
                          Option two
                        </label>
                      </div>

                    </div>

                    <div class="control-group component" rel="popover" title="Inline Checkboxes" trigger="manual" data-content="
                      <form class='form'>
                        <div class='controls'>
                          <label class='control-label'>Label Text</label> <input class='input-large' type='text' name='label' id='label'>
                          <textarea style='min-height: 200px' id='inline-checkboxes'></textarea>
                          <hr/>
                          <button class='btn btn-info'>Save</button><button class='btn btn-danger'>Cancel</button>
                        </div>
                      </form>">
                      <label class="control-label valtype" data-valtype="label">Inline Checkboxes</label>

                      <!-- Multiple Checkboxes -->
                      <div class="controls valtype" data-valtype="inline-checkboxes">
                        <label class="checkbox inline">
                          <input type="checkbox" value="1"> 1
                        </label>
                        <label class="checkbox inline">
                          <input type="checkbox" value="2"> 2
                        </label>
                        <label class="checkbox inline">
                          <input type="checkbox" value="3"> 3
                        </label>
                      </div>

                    </div>

                    <div class="control-group component" rel="popover" title="Inline radioes" trigger="manual" data-content="
                      <form class='form'>
                        <div class='controls'>
                          <label class='control-label'>Label Text</label> <input class='input-large' type='text' name='label' id='label'>
                          <label class='control-label'>Group Name Attribute</label> <input class='input-large' type='text' name='name' id='name'>
                          <textarea style='min-height: 200px' id='inline-radios'></textarea>
                          <hr/>
                          <button class='btn btn-info'>Save</button><button class='btn btn-danger'>Cancel</button>
                        </div>
                      </form>">
                      <label class="control-label valtype" data-valtype="label">Inline radios</label>
                      <div class="controls valtype" data-valtype="inline-radios">

                        <!-- Inline Radios -->
                        <label class="radio inline">
                          <input type="radio" value="1" checked="checked" name="group">
                          1
                        </label>
                        <label class="radio inline">
                          <input type="radio" value="2" name="group">
                          2
                        </label>
                        <label class="radio inline">
                          <input type="radio" value="3">
                          3
                        </label>
                      </div>
                    </div>

                  </div>

                  <div class="tab-pane" id="4">
                    <!-- 设置代码-->
                       <textarea id="source" style="height: 430px;" class="span6"></textarea>
                  </div> 
                </div></fieldset>
              </form>
            </div>
          </div> <!-- row -->       
           <script src="common/js/jquery-1.9.0.min.js"></script> 
           <script src="media/js/bootstrap.min.js"></script>  
           <script src="common/js/fb.js"></script> 
            <script src=" http://hm.baidu.com/h.js?3d8e7fc0de8a2a75f2ca3bfe128e6391" type="text/javascript"></script>
          
</div>

             </div> 
		 </div>
         </div>
	</div>

	<!-- END TAB PORTLET--> 
     <%--<iframe src="View/MainBill/MainBills.aspx" id="iframepage" frameBorder=0 width="100%" height="620px" ></iframe>--%>
   </div>
        <div id="WinDate" class="easyui-window" data-options="title:'日期选择',modal:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false"
        style="width: 410px; height: 150px;" >
        <form name="formDate" id="formDate" status="Date" >
            <div data-options="region:'north',border:false" class="wincss" style="padding: 5px 0 0;">
        开始日期:<input type="text"  name="StartDate" id="txtStartDate" style="width:100px" class="easyui-datebox fieldItem" />  
      -结束日期:<input type="text"  name="EndDate" id="txtEndDate" style="width:100px" class="easyui-datebox fieldItem" />  
                
            <div data-options="region:'south',border:false" style="text-align: center; padding: 5px 0 0;">
                <a class="easyui-linkbutton" id="btnSaveDate" data-options="iconCls:'icon-save'">保存</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
                    onclick="javascript: $('#WinDate').window('close');">取消</a>
            </div>

            </div>
        </form>
    </div>
   <script>
       function delli(obj, id) {
           $(obj).prev().attr("class", "active");
           $("#" + id).prev().attr("class", "tab-pane active");
           $(obj).remove();
           $("#" + id).remove();
           
       }
       function MenuGroup() { 
           $("#tabShow").attr("class", "tab-pane");
           $("#tabGroup").attr("class", "tab-pane active");

       }
       function CustomerMenuGroup(id) {
           $("#tabGroup").attr("class", "tab-pane");
           $("#tabShow").attr("class", "tab-pane active");
           var $iframe = $("#showIframe");
           var $a = $("#showSearch");
           var $hdninput = $("#hdnsearchvalue");
           $a.html("");
           $hdninput.val("");
           $iframe.attr("src", "View/Customers/CustomerList.aspx?txtid=" + id);
       }
       function MenuOnClick(txtcode,txtcname) {
           //$("#iframepage").attr("src", url); 
           $("#tabShow").attr("class", "tab-pane active");
           $("#tabGroup").attr("class", "tab-pane");
           var $a = $("#showSearch").find("div");
           var $iframe = $("#showIframe");
           var $hdninput = $("#hdnsearchvalue");
           if ($hdninput.val() == "") {
               $("#showSearch").append("<div type='" + txtcode.split(':')[0] + "' code='" + txtcode.split(':')[1] + "' onclick='divonclick(this)'  style='margin-left: 5px;float:left;cursor: pointer;border: 1px solid gray;padding: 5px;'><a style='color:gray'>" + txtcname.split(':')[0] + "</a><a>:" + txtcname.split(':')[1] + "</a> <i class='icon-remove-sign'></i> </div>");
               $hdninput.val($hdninput.val() + txtcode + ";");
               $iframe.attr("src", "View/Customers/CustomerList.aspx?id=" + $hdninput.val()); 
           }
           else {
               var boolflag = true;
               $hdninput.val("");
               $a.each(function () {
                   if (txtcode.split(':')[0] != "10") {
                       if ($(this).attr("type") == txtcode.split(':')[0]) {
                           alert("已有相同类型的搜索,请删除后继续!");
                           boolflag = false;
                       }
                       else {$hdninput.val($hdninput.val() + $(this).attr("type") + ":" + $(this).attr("code") + ";"); }
                   }
                   else {
                       if ($(this).attr("code") == txtcode.split(':')[1]) {
                           alert("已有" + txtcname.split(':')[1] + "的搜索,请删除后继续!");
                           boolflag = false;
                       }
                       else { $hdninput.val($hdninput.val() + $(this).attr("type") + ":" + $(this).attr("code") + ";"); }
                   }

               });
               if (boolflag) {
                   $("#showSearch").append("<div type='" + txtcode.split(':')[0] + "' code='" + txtcode.split(':')[1] + "' onclick='divonclick(this)'  style='margin-left: 5px;float:left;cursor: pointer;border: 1px solid gray;padding: 5px;'><a style='color:gray'>" + txtcname.split(':')[0] + "</a><a>:" + txtcname.split(':')[1] + "</a> <i class='icon-remove-sign'></i></div>");
                   $hdninput.val($hdninput.val() + txtcode + ";");
                   $iframe.attr("src", "View/Customers/CustomerList.aspx?id=" + $hdninput.val()); 
               }
               
           }
          
       }
       function divonclick(e) {
           $(e).remove();
           var $a = $("#showSearch").find("div"); 
           var $iframe = $("#showIframe"); 
           var $hdninput = $("#hdnsearchvalue");
           $hdninput.val("");
           $a.each(function () { 
               $hdninput.val($hdninput.val() + $(this).attr("type") + ":" + $(this).attr("code") + ";");
           }); 
           $iframe.attr("src", "View/Customers/CustomerList.aspx?id=" + $hdninput.val());
       }
       function removediv(obj) { 
           $(obj).parent().parent("div.control-group").remove();
       }
       function onrefresh() {
           $("#txtGroupName").val("");
           $("#target fieldset").find("div.component").each(function () {
               if ($(this).attr("id") !== "legend")
                   $(this).remove();
           });
           getlength = 0;
       }

       function onsaveGroup() {
           if ($("#txtGroupName").val() == "") {
               alert("请输入分组名.");
               return;
           } 
           $.ajax({
               url: "Ajax.aspx",
               type: "post",
               data: "type=saveGroup&" + $("#target").serialize(),
               success: function (msg) {
                   if (msg.indexOf("fail:") == -1) { 
                       alert("保存成功!");
                       window.location.reload();
                   }
                   else
                       alert(msg.split(':')[1]);
               }
           });
       }

       
   </script>
       
   
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

	<script src="media/js/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>

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

	<script src="media/js/jquery.uniform.min.js" type="text/javascript" ></script>

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

	<script src="media/js/daterangepicker.js" type="text/javascript"></script>     

	<script src="media/js/jquery.gritter.js" type="text/javascript"></script>

	<script src="media/js/fullcalendar.min.js" type="text/javascript"></script>

	<script src="media/js/jquery.easy-pie-chart.js" type="text/javascript"></script>

	<script src="media/js/jquery.sparkline.min.js" type="text/javascript"></script>  

	<!-- END PAGE LEVEL PLUGINS -->

	<!-- BEGIN PAGE LEVEL SCRIPTS -->

	<script src="media/js/app.js" type="text/javascript"></script>

	<script src="media/js/index.js" type="text/javascript"></script>        
      
         <link href="easyui/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <script src="easyui/js/jquery.easyui.min.js" type="text/javascript"></script>
        <script src="easyui/locale/easyui-lang-zh_CN.js"></script> 
	<!-- END PAGE LEVEL SCRIPTS -->   
	<script>
	    jQuery(document).ready(function () {
	        $(".submit").click(function () {
	            var $iframe = $("#showIframe");
	            var $hdninput = $("#hdnsearchvalue");
	            $iframe.attr("src", "View/Customers/CustomerList.aspx?id=" + $hdninput.val()+"&strSearch="+$("#txtSearch").val());
	        });
	        //$("#build").click(function () { 
	        //   $.parser.parse('.component'); 
	        //});
	        $("#btnSaveDate").click(function () {
	            if ($("#txtStartDate").datebox('getValue') == "" || $("#txtEndDate").datebox('getValue') == "")
	            { alert("请输入日期."); return;}
	            var $iframe = $("#showIframe");
	            var $hdninput = $("#hdnsearchvalue");
	            $iframe.attr("src", "View/Customers/CustomerList.aspx?id=" + $hdninput.val() + "&strSearch=" + $("#txtSearch").val()) + "&StartDate=" + $("#txtStartDate").datebox('getValue') + "&EndDate=" + $("#txtEndDate").datebox('getValue');
	            $("#WinDate").window("close");
	        });
	        
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

<script type="text/javascript">    var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-37564768-1']); _gaq.push(['_setDomainName', 'keenthemes.com']); _gaq.push(['_setAllowLinker', true]); _gaq.push(['_trackPageview']); (function () { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script> 

<!-- END BODY -->
</body>
</html>
