<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VisitList.aspx.cs" Inherits="AppBox.View.Visit.VisitList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>  
<title></title>   
    <link href="../../metro/css/modern.css" rel="stylesheet" type="text/css" />
    <link href="../../common/history/css/history.css" rel="stylesheet" type="text/css" />
    <script src="../../common/js/jquery-2.0.0.min.js" type="text/javascript"></script>
    <script src="../../common/history/js/history.js" type="text/javascript"></script>
    <script src="../../common/js/common.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            loadHistory("", "", "");

            $("#btnSearch").click(function () {
                loadHistory("", "", $("#txtSearch").val());
            })
        });

    </script>
    <style>
       .inputcss
       {
           border:1px solid gray; 
           font-size:18px;
           margin:0; 
           margin-top:-10px;
           line-height:normal;
           height:30px; 
           padding:3px 
       }
    </style>
</head>
<body>

<div class="metrouicss">
  <div class="page secondary">
        <div class="page-header">
            <div class="page-header-content" >
                <h1  >回访<small >记录 </small>&nbsp;<small><input id="txtSearch"  type="text" style="width:500px; " placeholder="请输入客户名、手机或地址查询"   /><input id="btnSearch" type="button" name="btnSearch"   class=" bg-color-grayLight fg-color-blackLight" value="查询" /> </small>  
                </h1>   
                <a class="back-button big page-back"  ></a>
            </div>
        </div> 
    </div>   
</div>
<div class="head-warp">
  <div class="head" style="display:none">
        <div class="nav-box">
          <ul>
              <li class="cur" style="text-align:center; font-size:62px; font-family:'微软雅黑', '宋体';">回访记录</li>
          </ul>
        </div>
  </div>
</div>
<div class="main"> 
  <div class="history">
  </div>
</div>
  
</body>
</html>