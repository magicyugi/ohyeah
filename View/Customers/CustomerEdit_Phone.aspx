<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerEdit_Phone.aspx.cs" Inherits="AppBox.View.Customers.CustomerEdit_Phone" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server"> 

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
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
        
        .datagrid-cell,
.datagrid-cell-group,
.datagrid-header-rownumber,
.datagrid-cell-rownumber {
  margin: 0;
  padding: 0 4px;
  white-space: nowrap;
  word-wrap: normal;
  overflow: hidden;
  height: 24px;
  line-height: 24px;
  font-weight: normal;
   font-size: 20px;
}
.datagrid-header .datagrid-cell span {
   font-size: 20px;
}
    </style>
    <script src="../../common/js/jquery.hotkeys-0.7.9.min.js" type="text/javascript"></script>
    <link href="../Visit/src/jquery.percentageloader-0.1.css" rel="stylesheet" type="text/css" />
    <script src="../Visit/src/jquery.percentageloader-0.1.js" type="text/javascript" charset="gbk"></script>   
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />	
    <meta content="" name="description" />	
    <meta content="" name="author" />    
    <script type="text/javascript">
        var url = "Ajax.aspx";
        var namecode = "Customer";
        var g5value = 0;
        var g5;
        var $topLoader;
        $(function () { 
            $topLoader = $("#topLoader").percentageLoader({ width: 200, height: 200, progress: 0, onProgressUpdate: function (val) {

            }
            });
            appendHM(30);
            if (request("ProcessFlag") == "1") {
                $("#txtTitle").html("售前<small>客户编辑</small>");
                $(".alertli").hide();
            }
            else if (request("ProcessFlag") == "2") {
                $("#txtTitle").html("售中<small>客户编辑</small>");
                $(".alertli").hide();
            }
            else if (request("ProcessFlag") == "3") {
                $("#txtTitle").html("售后<small>编辑</small>");
                $(".alertli").hide();
            }

            $("#txtCname").focus();

            $(".fieldItem").bind('keydown', 'return', function () {
                var txttabindex = parseInt($(this).attr('tabindex')) + 1;
                $("#divtabs").find("input[tabindex=" + txttabindex + "]").focus();
            }).bind('keydown', 'tab', function () {
                return false;
            });

            $.ajax({
                url: url,
                data: "type=dropdown",
                success: function (msg) {
                    $('#txtClientSourceCode').combobox({
                        data: eval(msg)[1].item1,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    $('#txtthirdCode').combobox({
                        data: eval(msg)[3].item3,
                        valueField: 'Code',
                        textField: 'Cname'
                    });
                    LoadData(url, request("code"));
                }
            });
            
            $(".back-button").click(function () {
                var backtype = "";
                if (request("type") == null || request("type") == "") backtype = "?ProcessFlag=" + request("ProcessFlag");
                if ($.trim($("#txtTitle").text()) == "意向登记") window.history.go(-1);
                else
                    window.location.href = "CustomerList.aspx" + backtype;
            });
            $('#txtClientSourceCode').combobox({
                onChange: function (newValue, oldValue) {
                    if (newValue == 0) {
                        $("#hidli").css("display", "block"); $("#hidli1").css("display", "block");
                        $("#hidli2").css("display", "none");
                        $("#txtIntroduceName").select();

                    }
                    else if (newValue == 1) {
                        $("#hidli2").css("display", "block");
                        $("#hidli").css("display", "none"); $("#hidli1").css("display", "none");
                    }
                    else
                    { $("#hidli").css("display", "none"); $("#hidli1").css("display", "none"); $("#hidli2").css("display", "none"); }
                }
            }); 
            var today = new Date();
            var date = AddDays(today, 7);
            var day = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
            $('#txtAlertDate').datebox('setValue', day);
            if (request('addr') != "") { $("#txtAddress").val(request('addr')); }
            
        })
        
        var topLoaderRunning = false;
        function getScore(oldvalue, newvalue) {
            //g5.refresh(txtscore);
            if (topLoaderRunning) {
                return;
            }
            topLoaderRunning = true;
            $topLoader.setProgress(0);
            $topLoader.setValue('');
            var kb = oldvalue;
            var total = 100;
            var animateFunc = function () {
                if (kb < newvalue) {
                    kb += 1;
                    $topLoader.setProgress(kb / total);
                    //$topLoader.setValue(kb.toString() + '分'); 
                    if (kb < total) {
                        setTimeout(animateFunc, 5);
                    } else {
                        topLoaderRunning = false;
                    }

                }
                else if (kb > newvalue) {
                    kb -= 1;
                    $topLoader.setProgress(kb / total);
                    //$topLoader.setValue(kb.toString() + '分'); 
                    if (kb < total) {
                        setTimeout(animateFunc, 5);
                    } else {
                        topLoaderRunning = false;
                    }
                }
                else { $topLoader.setProgress(kb / total); topLoaderRunning = false; }

            }

            setTimeout(animateFunc, 5);  ;
        }
        function allckonclick(pcode, obj) {
            var rows = $('#Pgrid').datagrid('getRows');
            var $obj = $(obj);
            var chks = $("input[name='ckId']");
            var txtck = $("a[name='txtck']");
            if ($obj.prop("checked")) {
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].Pcode == pcode) {
                        $(chks[i]).prop("checked", 'true');
                        $(txtck[i]).text('完成');
                    }
                }
            } else {
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].Pcode == pcode) {
                        $(chks[i]).prop("checked", '');
                        $(txtck[i]).text('未完成');
                    }
                }
            }
            forck();

        }
        //循环取值
        function forck(type) {
            var oldvalue = g5value;
            g5value = 0;
            var txtvalue = "";
            var count = -1;
            var chks = $("input[name='ckId']");
            var txtck = $("a[name='txtck']");
            var rows = $('#Pgrid').datagrid('getRows');
            for (var i = 0; i < chks.length; i++) {
                if ($(chks[i]).prop("checked")) {
                    txtvalue += rows[i].Pcode + "-" + rows[i].Pname + "-" + rows[i].Code + "-" + rows[i].Cname + ",";
                    count++;
                    g5value += parseFloat(rows[i].score);
                }
            } 
            if (count != -1&&type!=1) {
                if (rows[count].Remark2 != null && rows[count].Remark2 != "") {
                    var myDate = new Date();
                    var txtdate = parseInt(myDate.getDate()) + parseInt(rows[count].Remark2);
                    myDate.setDate(txtdate);
                    $("#txtAlertDate").datebox("setValue", myDate.getFullYear() + '-' + (myDate.getMonth() + 1) + '-' + myDate.getDate());
                }
                else {
                    $("#txtAlertDate").datebox("setValue", "");
                }
            }
            g5value = Math.round(g5value); 
            $("#txtValue").val(txtvalue);
            getScore(oldvalue, g5value);
            $("#txtScore").val(g5value);
            var txtprocess = request("processflag");
            if (txtprocess != "") txtprocess = parseInt(request("processflag")) - 1;
            $("#txtCustomerLevel").val(txtprocess); 
        }
        function ckonclick(index, obj) {
            //            var txtvalue = "";
            //            var chks = $("input[name='ckId']"); 
            var txtck = $("a[name='txtck']");
            //            var rows = $('#Pgrid').datagrid('getRows');
            if ($(obj).prop("checked")) {
                $(txtck[index]).text('完成');
            }
            else {
                $(txtck[index]).text('未完成');
            }
            forck();
        }
    </script>
    	<!-- BEGIN GLOBAL MANDATORY STYLES -->	<link href="../../media/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>	<link href="../../media/css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css"/>	<link href="../../media/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>	<link href="../../media/css/style-metro.css" rel="stylesheet" type="text/css"/>	<link href="../../media/css/style.css" rel="stylesheet" type="text/css"/>	<link href="../../media/css/style-responsive.css" rel="stylesheet" type="text/css"/>	<link href="../../media/css/default.css" rel="stylesheet" type="text/css" id="style_color"/>	<link href="../../media/css/uniform.default.css" rel="stylesheet" type="text/css"/>	<!-- END GLOBAL MANDATORY STYLES -->	<!-- BEGIN PAGE LEVEL STYLES -->	<link rel="stylesheet" type="text/css" href="../../media/css/select2_metro.css" />	<link rel="stylesheet" type="text/css" href="../../media/css/chosen.css" />	<!-- END PAGE LEVEL STYLES -->	<link rel="shortcut icon" href="../../media/image/favicon.ico" />
        <script src="../SysCodeManage/datagrid-groupview.js" type="text/javascript"></script>  
</head>
<body id="showbody" style="  background-color:White " >
 
     <div id="tablediv" style="position:absolute;top: -1000px;left: 10px;">
            <table id="Pgrid" class="easyui-datagrid"  style="width:600px;height:300px"
                data-options=" 
                    singleSelect: true,
                    rownumbers:true, 
                    view:groupview,
                    url: '../Visit/Ajax.aspx?type=PGrid&code=' + request('code'),
                    onLoadSuccess: function (data) { 
                            forck();
                    },
                    groupField:'Pname', 
                    groupFormatter:function(value,rows){
                        return '<a style=color:gray>'+value +'</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type=\'checkbox\' onclick=\'allckonclick(&quot;'+rows[0].Pcode+'&quot;,this);\' />该项全选';
                    }
                ">
            <thead>
                <tr>
                    <th data-options="field:'ID',hidden:true,width:120">ID</th>
                    <th data-options="field:'Pname',hidden:true,width:120">父级</th>
                    <th data-options="field:'Pcode',hidden:true,width:120">父级编号</th>
                    <th data-options="field:'Code',hidden:true,width:120">编号</th>
                    <th data-options="field:'VCode',width:120,hidden:true">编号</th>
                    <th data-options="field:'Cname',width:120">名称</th> 
                    <th data-options="field:'Remark2',width:120,hidden:true">Remark2</th>
                    <th data-options="field:'score',width:120,hidden:true">Score</th>
                    <th data-options="field:'clCode',width:120,formatter: function(value,row,index){  var txtsp;var txtreturn='<input type=\'checkbox\'  name=\'ckId\' onclick=\'ckonclick('+index+',this);\' />&nbsp;&nbsp;<a name=\'txtck\'>未完成</a>';if(value!=null){txtsp=value;if(row.Code==txtsp){txtreturn='<input type=\'checkbox\'  checked=\'checked\' name=\'ckId\'  onclick=\'ckonclick('+index+',this);\' />&nbsp;&nbsp;<a name=\'txtck\'>完成</a>';}} return txtreturn;}">是否完成</th>
                </tr>
            </thead>
        </table>      
       
     </div>          
    <div  id="nipic_search" class="tipSwitch" style="top:112px;left:990px; z-index:100;"></div> 
    <div class="row-fluid"> 
	<div class="span12"> 
		<div class="portlet box blue" id="form_wizard_1"> 
    <div class="portlet-body form">

	    <form class="form-horizontal " id="submit_form" novalidate="novalidate" >

		    <div class="form-wizard">

			    <div class="navbar steps">

				    <div class="navbar-inner">

					    <ul class="row-fluid nav nav-pills">

						    <li class="span3 active">

							    <a href="#tab1" data-toggle="tab" class="step active">

							    <span class="number">1</span>

							    <span class="desc"><i class="icon-ok"></i> 基本资料</span>   

							    </a>

						    </li>

						    <li class="span3">

							    <a href="#tab2" data-toggle="tab" class="step">

							    <span class="number">2</span>

							    <span class="desc"><i class="icon-ok"></i> 扩展信息</span>   

							    </a>

						    </li>

						    <li class="span3">

							    <a href="#tab3" data-toggle="tab" class="step">

							    <span class="number">3</span>

							    <span class="desc"><i class="icon-ok"></i>客户进度</span>   

							    </a>

						    </li>

						    <li class="span3">

							    <a href="#tab4" data-toggle="tab" class="step">

							    <span class="number">4</span>

							    <span class="desc"><i class="icon-ok"></i> 联系提醒</span>   

							    </a> 

						    </li>

					    </ul>

				    </div>

			    </div>

			    <div id="bar" class="progress progress-success progress-striped">

				    <div class="bar" style="width: 25%;"></div>

			    </div>

			    <div class="tab-content">

				    <div class="alert alert-error hide">

					    <button class="close" data-dismiss="alert"></button>

					    请根据以下提示修改错误!

				    </div>

				    <div class="alert alert-success hide">

					    <button class="close" data-dismiss="alert"></button>

					    保存成功!

				    </div>

				    <div class="tab-pane active" id="tab1">  
					    <div class="control-group">

						    <label class="control-label">客户名称:<span class="required">*</span></label>

						    <div class="controls">

							    <input type="text" class="span6 m-wrap fieldItem" field="Cname"  name="Cname">

							    <span class="help-inline">请填写客户名称.</span>

						    </div>

					    </div>

					    <div class="control-group">

						    <label class="control-label">手机号:<span class="required">*</span></label>

						    <div class="controls">

							    <input type="text" class="span6 m-wrap fieldItem" name="Mobile"  field="Mobile" maxlength="11"  id="submit_form_phone">

							    <span class="help-inline">请填写客户手机号.</span>

						    </div>

					    </div>

					    <div class="control-group">

						    <label class="control-label">地址:<span class="required">*</span></label>

						    <div class="controls">

							    <input id="txtAddress" type="text" class="span6 m-wrap fieldItem" field="Address" name="Address">

							    <span class="help-inline">请填写客户地址.</span>

						    </div>

					    </div> 
				    </div>

				    <div class="tab-pane" id="tab2" runat="server">  
                    <%--读取自定义模块--%>

				    </div>

				    <div class="tab-pane" id="tab3">  
					    <div class="control-group" style="height:320px">
                          <input type="hidden" id="txtValue" name="txtValue"  class="fieldItem"   />
                          <input type="hidden" id="txtScore" name="Score" value="0" class="fieldItem"   />
                          <input type="hidden" name="txtCustomerLevel"  class="fieldItem"  id="txtCustomerLevel" value="CustomerLevel"/>  
					    </div> 
				    </div>

				    <div class="tab-pane" id="tab4">
                                             
					    <div class="control-group">

						    <label class="control-label">客户来源:</label>

						    <div class="controls">
                                <input type="hidden"  id="txtClientSource" name="ClientSource" class="fieldItem" field="ClientSource" />
                                <input type="combo" tabindex="50" id="txtClientSourceCode" name="ClientSourceCode" class="easyui-combobox fieldItem"
                                    field="ClientSourceCode" /> 
						    </div> 
					    </div>
                        <div class="control-group"  style="display:none;" id="hidli"> 
                            <label class="control-label">介绍人:</label> 
                            <div class="controls">
                                 <input type="text" id="txtIntroduceName"  name="IntroduceName" tabindex="50" class="fieldItem" field="IntroduceName" />
                            </div> 
                        </div> 
                        <div class="control-group"  style="display:none;" id="hidli1"> 
                            <label class="control-label">介绍人电话:</label> 
                            <div class="controls">
                                 <input type="text" onkeydown="if(event.keyCode==13) $('#txtDescription').focus();" id="txtIntroduceMobile" name="IntroduceMobile" tabindex="51" class="fieldItem" field="IntroduceMobile" />
                            </div> 
                        </div> 
                        <div class="control-group"  style="display:none;" id="hidli2"> 
                            <label class="control-label">第三方:</label> 
                            <div class="controls">
                                  <input type="hidden"  id="txtthird" name="ClientSource1" class="fieldItem" field="ClientSource1" />
                                  <input type="combo" tabindex="50" id="txtthirdCode" name="ClientSourceCode1" class="easyui-combobox fieldItem"
                                        field="ClientSourceCode1" />
                            </div> 
                        </div>   
					    <div class="control-group">

						    <label class="control-label">交流情况:</label>

						    <div class="controls">

							     <textarea tabindex="52" cols="4" rows="4" name="Description" id="txtDescription" class="fieldItem"
                                field="Description" style="width:400px"  ></textarea> 

						    </div>

					    </div> 

					    <div class="control-group">

						    <label class="control-label">下次回访时间:</label>

						    <div class="controls">

							    <input   type="text"  tabindex="52" name="AlertDate" id="txtAlertDate" style="width:147px"     field="AlertDate" 
                                field="AlertDate"  class="easyui-datebox fieldItem" required="required" />  
                           <select name="HM" id="txtHM"  tabindex="53" class="fieldItem hm" field="HM" style="width: 100px;"></select>  
						     <span class="help-inline">请填写下次回访时间.</span>
                            </div>

					    </div>

					    <div class="control-group">

						    <label class="control-label">联系计划:</label>

						    <div class="controls">

							   <input type="text" tabindex="55" name="AlertContent" id="txtAlertContent" class="fieldItem"
                                field="AlertContent" />
                                <span class="help-inline">请填写联系计划.</span>
						    </div>

					    </div>

												 

				    </div>

			    </div>

			    <div class="form-actions clearfix">

				    <a href="javascript:;" class="btn button-previous" style="display: none;">

				    <i class="m-icon-swapleft"></i> 上一页 

				    </a>

				    <a href="javascript:;" class="btn blue button-next">

				    下一页 <i class="m-icon-swapright m-icon-white"></i>

				    </a>

				    <a href="javascript:;" class="btn green button-submit" style="display: none;">

				    保存 <i class="m-icon-swapright m-icon-white"></i>

				    </a>

			    </div>

		    </div>

	    </form>

    </div>
    	</div>					</div>	</div>
    <!-- END FOOTER -->	<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->	<!-- BEGIN CORE PLUGINS -->
     	<script src="../../media/js/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>	<!-- IMPORTANT! Load jquery-ui-1.10.1.custom.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->	<script src="../../media/js/jquery-ui-1.10.1.custom.min.js" type="text/javascript"></script>      	<script src="../../media/js/bootstrap.min.js" type="text/javascript"></script>	<!--[if lt IE 9]>	<script src="media/js/excanvas.min.js"></script>	<script src="media/js/respond.min.js"></script>  	<![endif]-->   	<script src="../../media/js/jquery.slimscroll.min.js" type="text/javascript"></script>	<script src="../../media/js/jquery.blockui.min.js" type="text/javascript"></script>  	<script src="../../media/js/jquery.cookie.min.js" type="text/javascript"></script>	<script src="../../media/js/jquery.uniform.min.js" type="text/javascript" ></script>	<!-- END CORE PLUGINS -->	<!-- BEGIN PAGE LEVEL PLUGINS -->	<script type="text/javascript" src="../../media/js/jquery.validate.min.js"></script>	<script type="text/javascript" src="../../media/js/additional-methods.min.js"></script>	<script type="text/javascript" src="../../media/js/jquery.bootstrap.wizard.min.js"></script>	<script type="text/javascript" src="../../media/js/chosen.jquery.min.js"></script>	<script type="text/javascript" src="../../media/js/select2.min.js"></script>	<!-- END PAGE LEVEL PLUGINS -->	<!-- BEGIN PAGE LEVEL SCRIPTS -->	<script src="../../media/js/app.js"></script>	<script src="../../media/js/form-wizard.js"></script>     	<!-- END PAGE LEVEL SCRIPTS -->	<script>
	    jQuery(document).ready(function () {
	        // initiate layout and plugins
	        App.init();
	        FormWizard.init();
	    });	</script>	<!-- END JAVASCRIPTS -->   <script type="text/javascript">    var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-37564768-1']); _gaq.push(['_setDomainName', 'keenthemes.com']); _gaq.push(['_setAllowLinker', true]); _gaq.push(['_trackPageview']); (function () { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script>
        </body><!-- END BODY -->
</html>
