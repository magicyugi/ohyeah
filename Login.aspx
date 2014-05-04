<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="UI.Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>OHYEAH</title>
    <link href="res/login.css" rel="stylesheet" type="text/css" />
    <script src="common/js/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="common/js/Common.js" type="text/javascript"></script>
    <meta http-equiv="X-UA-Compatible" content="chrome=27">
    <script>
        window.onload = function () {
            checkbrowse();
        }

        function checkbrowse() {
            var client = function () {
                //呈现引擎  
                var engine = {
                    ie: 0,
                    gecko: 0,
                    webkit: 0,
                    khtml: 0,
                    opera: 0,
                    ver: null
                };
                //浏览器  
                var browser = {
                    //主要浏览器  
                    ie: 0,
                    firefox: 0,
                    konq: 0,
                    opera: 0,
                    chrome: 0,
                    safari: 0,
                    //版本号  
                    ver: null
                };

                var system = {
                    win: false,
                    mac: false,
                    x11: false,
                    //移动设备  
                    iphone: false,
                    ipod: false,
                    nokiaN: false,
                    winMobile: false,
                    macMobile: false,
                    //游戏系统  
                    wii: false,
                    ps: false
                };


                //检测呈现引擎和浏览器  
                var ua = navigator.userAgent;
                if (window.opera) {
                    engine.ver = browser.ver = window.opera.version();
                    engine.opera = browser.opera = parseFloat(engine.ver);
                } else if (/AppleWebKit\/(\S+)/.test(ua)) {
                    engine.ver = RegExp["$1"];
                    engine.webkit = parseFloat(engine.ver);

                    if (/Chrome\/(\S+)/.test(ua)) {
                        browser.ver = RegExp["$1"];
                        browser.chrome = parseFloat(browser.ver);
                    } else if (/Version\/(\S+)/.test(ua)) {
                        browser.ver = RegExp["$1"];
                        browser.safari = parseFloat(browser.ver);
                    } else {
                        var safariVersion = 1;
                        if (engine.webkit < 100) {
                            safariVersion = 1;
                        } else if (engine.webkit < 312) {
                            safariVersion = 1.2;
                        } else if (engine.webkit < 412) {
                            safariVersion = 1.3;
                        } else {
                            safariVersion = 2;
                        }
                        browser.safari = browser.ver = safariVersion;
                    }
                } else if (/KHTML\/(\S+)/.test(ua) || /Konqueror\/([^;]+)/.test(ua)) {
                    engine.ver = browser.ver = RegExp["$1"];
                    engine.khtml = parseFloat(engine.ver);
                } else if (/rv:([^\)]+)\) Gecko\/\d{8}/.test(ua)) {
                    engine.ver = browser.ver = RegExp["$1"];
                    engine.gecko = parseFloat(engine.ver);

                    //  
                    if (/Firefox\/(\S+)/.test(ua)) {
                        browser.ver = RegExp["$1"];
                        browser.firefox = parseFloat(browser.ver);
                    }
                } else if (/MSIE ([^;]+)/.test(ua)) {
                    engine.ver = browser.ver = RegExp["$1"];
                    engine.ie = browser.ie = parseFloat(browser.ver);
                }

                browser.ie = engine.ie;
                browser.opera = engine.opera;

                //检测平台        
                var p = navigator.platform;
                system.win = p.indexOf("Win") == 0;
                system.mac = p.indexOf("Mac") == 0;
                system.x11 = (p == "x11") || (p.indexOf("Linux") == 0);

                //检测windows平台  
                if (system.win) {
                    if (/Win(?:dows )?([^do]{2})\s?(\d+\.\d+)?/.test(ua)) {
                        if (RegExp["$1"] == "NT") {
                            switch (RegExp["$2"]) {
                                case "5.0":
                                    system.win = "2000";
                                    break;
                                case "5.1":
                                    system.win = "XP";
                                    break;
                                case "6.0":
                                    system.win = "Vista";
                                    break;
                                default:
                                    system.win = "NT";
                                    break;
                            }
                        } else if (RegExp["$1"] == "9x") {
                            system.win = "ME";
                        } else {
                            system.win = RegExp["$1"];
                        }
                    }
                }

                system.iphone = ua.indexOf("iPhone") > -1;
                system.ipod = ua.indexOf("iPod") > -1;
                system.nokiaN = ua.indexOf("nokiaN") > -1;
                system.winMobile = (system.win == "CE");
                system.macMobile = (system.iphone || system.ipod);

                system.wii = ua.indexOf("Wii") > -1;
                system.ps = /playstation/i.test(ua);

                return {
                    engine: engine,
                    browser: browser,
                    system: system
                };
            } ();
            //            if (client.browser.ie > 0) {
            //                alert("请安装最新的谷歌浏览器以达到最好的显示效果");
            //                window.location.href = "http://www.google.cn/intl/zh-CN/chrome/browser/";
            //            }
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $("#txtUserName").focus();
            $("#txtUserName").keyup(function () {
                if (event.which == 13)
                    $("#txtPassword").focus();
            });
            $("#txtPassword").keyup(function () {
                if (event.which == 13) {
                    $("#btnLogin").click();
                }
            });
            $("#btnLogin").click(function () { 
                $("#btnLogin").text("正在登录...");
                $(this).attr("disabled", "disabled");
                $.ajax({
                    url: "Ajax.aspx",
                    datatype: "json",
                    type: "post",
                    data: "type=login&username=" + $("#txtUserName").val() + "&password=" + $("#txtPassword").val(),
                    success: function (msg) {
                        if (msg == "fail") {
                            alert("用户名或密码错误，请重新输入");
                            $("#txtPassword").val("");
                            $("#txtUserName").focus();
                            $("#btnLogin").text("登录");
                        }
                        else {
                            if (msg == "1")
                                window.location.href = "CustomerTilePanel.aspx";
                            else
                                window.location.href = "CustomerTilePanel.aspx";
                        }
                    },
                    error: function () {
                        alert("网络连接异常");
                        $("#txtPassword").val("");
                        $("#txtUserName").focus();
                        $("#btnLogin").text("登录");
                    }
                });
            });
        });
        function connectQQ() {
            window.open("http://wpa.qq.com/msgrd?v=3&uin=779371121&site=qq&menu=yes");
        }
    </script>
</head>
<body>
<div id="main">
    <div id="loginForm">
    <div style="   position:absolute; left:200px;   width:140px;height:200px" ></div> 
        <div id="divUser" style="padding-top: 290px; float: left; padding-left: 360px;">
            <input id="txtUserName" name="Cname"   style="font-size: 20px;width:340px;height:26px" />
        </div>
        <div id="divPassword" style="padding-top: 44px; float: left; padding-left: 360px;">
            <input type="password" id="txtPassword" name="Password"  style="font-size: 20px;width:340px;height:26px" />
        </div>
        <div id="divBtn" style="padding-top: 40px; float: left; padding-left: 400px;">
            <input id="btnLogin" type="button"    tabindex="3" />
            <input id="btnconnect"  type="button"  onclick="connectQQ()"   tabindex="3" />
        </div>
    </div>
</div>
</body>
</html>
