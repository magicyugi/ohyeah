using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Collections;
using System.Web.Security;
using System.Data;

namespace AppBox
{
    public partial class Ajax : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["type"] == "login") {
                if (Request["UserName"] != "" && Request["Password"] != "")
                {
                    string username = Request["UserName"].Replace("'", "").Replace(" ", "");
                    string password = Request["Password"].Replace("'", "").Replace(" ", "");  
                    string password1 = EncryptionUtil.StringToMD5Hash(password);
                    IList<SysUser> userList= new Select().From<SysUser>().Where("Code").IsEqualTo(username).And("Password").IsEqualTo(password1).ExecuteTypedList<SysUser>();
                   if (userList.Count > 0)
                    { 
                        WareHouse wh = new Select().From<WareHouse>().Where("Code").IsEqualTo(userList[0].WareHouseCode).ExecuteTypedList<WareHouse>()[0];
                        IList<WareHouse> wareHouseList = new Select().From<WareHouse>().Where("Code").In(new Select("Group_Code").From<SysUserGroup>().Where("User_Code").IsEqualTo(userList[0].Code).And("WareHouse_Code").IsEqualTo(wh.PCode)).And(WareHouse.PCodeColumn).IsEqualTo(wh.PCode).ExecuteTypedList<WareHouse>();
                        #region 获取数据权限
                        string wareHouseCodes = "";
                        if (wareHouseList.Count != 0)
                        { 
                            for (int i = 0; i < wareHouseList.Count; i++)
                            {
                                if (i == wareHouseList.Count - 1)
                                    wareHouseCodes += "'" + wareHouseList[i].Code + "'";
                                else
                                    wareHouseCodes += "'" + wareHouseList[i].Code + "',";
                            }
                        }
                        #endregion

                        string UserRoles = ""; 
                        IList<SysUserRole> urList = new Select().From<SysUserRole>().Where("User_Code").IsEqualTo(username).ExecuteTypedList<SysUserRole>();
                        if (urList.Count != 0)
                        {

                            for (int i = 0; i < urList.Count; i++)
                            {
                                if (i == urList.Count - 1)
                                    UserRoles += "'" + urList[i].RoleCode + "'";
                                else
                                    UserRoles += "'" + urList[i].RoleCode + "',";
                            }
                        }
                        FormsAuthenticationTicket authTicket = new
                        FormsAuthenticationTicket(
                        1,								// 版本
                        "CrmUser",
                        DateTime.Now,					// 创建名称
                        DateTime.Now.AddHours(50),	    // Cookie持续时间
                        false,				            // 是否持久   
                        //用户名 | 用户姓名 | 用户所属店 | 店名 | 父代码 | 用户数据权限 | 用户角色 | 用户等级
                        userList[0].Code + "|" + userList[0].Cname + "|" + userList[0].WareHouseCode + "|" + wh.Cname + "|"+ wh.PCode + "|"  + wareHouseCodes + "|" + UserRoles + "|" + userList[0].UserLevelPoint			// 用户名称
                        );
                        string encryptedTicket = FormsAuthentication.Encrypt(authTicket); //加密
                        HttpCookie authCookie = new HttpCookie("CrmUser", encryptedTicket);
                        Response.Cookies.Add(authCookie);  　


                        #region 初始化检测数据 
                        int iCount = new Select().From(SysCode.Schema).Where("WareHouse_Code").IsEqualTo(wh.PCode).And("Category").IsEqualTo("ClientSource").And("Code").IsEqualTo("0").GetRecordCount();
                        if (iCount == 0)
                        {
                            try
                            {
                                int q = new Insert().Into(SysCode.Schema, "WareHouse_Code",
                                    "Code", "VCode", "Cname", "Category", "Pcode", "CategoryName", "IsAdminCode", "StatusFlag").
                                    Values(
                                    wh.PCode,
                                    "0",
                                    "0",
                                    "朋友介绍",
                                    "ClientSource",
                                     "0",
                                     "客户来源",
                                     0,
                                     1
                                    ).Execute();
                                int q1 = new Insert().Into(SysCode.Schema, "WareHouse_Code",
                                    "Code", "VCode", "Cname", "Category", "Pcode", "CategoryName", "IsAdminCode", "StatusFlag").
                                    Values(
                                    wh.PCode,
                                    "1",
                                    "1",
                                    "第三方介绍",
                                    "ClientSource",
                                     "0",
                                     "客户来源",
                                     0,
                                     1
                                    ).Execute();
                            }
                            catch (Exception exc)
                            {

                            }
                        }
                        iCount = new Select().From(SysRole.Schema).Where("Org_Code").IsEqualTo(wh.PCode).And("Code").IsEqualTo("0").GetRecordCount();
                        if (iCount == 0)
                        {
                            try
                            {
                                int q = new Insert().Into(SysRole.Schema, "Org_Code",
                                    "Code", "Cname", "Description", "LevelPoint","StatusFlag").
                                    Values(
                                    wh.PCode,
                                    "0",
                                    "业务员",
                                    "系统默认生成的最低权限",
                                    "1",
                                    1
                                    ).Execute();
                            }
                            catch (Exception exc)
                            {

                            }
                        }
                        #endregion
                        Response.Write(userList[0].MenuFlag);
                    }
                    else
                    { 
                        Response.Write("fail");
                    }
                }
                else
                    Response.Write("fail");
            }
            else if (Request["type"] == "Contract")
            {
                int result = 0;
                string txtsql = "select * from contract where warehouse_code in ("+currentGroup+") ";
                if (!string.IsNullOrEmpty(Request["SendFlag"]))
                {
                    QueryCommand syscmd = new QueryCommand("select * from syscode where category='SendDate' and warehouse_code='" + currentMaster + "'");
                    DataTable sysdt = DataService.GetDataSet(syscmd).Tables[0];
                    if (sysdt.Rows.Count != 0)
                    {
                        if (Request["SendFlag"] == "1")
                        {
                            txtsql += " and datediff(day,SendDate,getdate())<=" + sysdt.Rows[0]["Cname"].ToString() + " and Statusflag=4";
                        }
                        else
                        {
                            txtsql += " and datediff(day,SendDate,getdate())<=" + sysdt.Rows[1]["Cname"].ToString() + " and Statusflag=2";
                        }
                    }
                    else
                    {
                        if (Request["SendFlag"] == "1")
                        {
                            txtsql += " and datediff(day,SendDate,getdate())<=7 and Statusflag=4";
                        }
                        else
                        {
                            txtsql += " and datediff(day,SendDate,getdate())<=2 and Statusflag=2";
                        }
                    }
                }
                QueryCommand cmd = new QueryCommand(txtsql);
                DataTable dt = DataService.GetDataSet(cmd).Tables[0];
                result = dt.Rows.Count;
                Response.Write(result);
            }
            else if (Request["type"] == "Customer")
            {
                int result = 0;
                string txtsql = @"select * from customer c left join sysuser s on s.code=c.guide_code 
                                  where (c.guide_code='" + currentUserCode + "' or c.warehouse_code in (" + currentGroup + ")) and (guide_code='" + currentUserCode + @"'
                                  or isnull(guide_code,'')='' or s.UserLevelPoint<" + currentLevel + ") ";
                if (Request["ProcessFlag"] != null && Request["Date"] != "RegDate")
                {
                    txtsql += " and ProcessFlag=" + Request["ProcessFlag"];
                }
                if (Request["Date"] != null)
                {
                    txtsql += " and month(" + Request["Date"] + ")=month(getdate())";
                }
                
                QueryCommand cmd = new QueryCommand(txtsql);
                DataTable dt = DataService.GetDataSet(cmd).Tables[0];
                result = dt.Rows.Count;
                Response.Write(result);
            }
            else if (Request["type"] == "Alert")
            {
                int result = 0;
                string txtsql = @"select * from alert a left join customer c on a.Code=c.Code where a.creater='" + currentUser + "' and a.StartDate='" + DateTime.Today + "'";
                if (Request["ProcessFlag"] != null) txtsql += " and c.ProcessFlag=" + Request["ProcessFlag"];
                QueryCommand cmd = new QueryCommand(txtsql);
                DataTable dt = DataService.GetDataSet(cmd).Tables[0];
                result = dt.Rows.Count;
                Response.Write(result);
            }
            else if (Request["type"] == "HM")
            {
                int result = 0;
                string txtsql = @"select * from alert a left join customer c on a.Code=c.Code where a.creater='" + currentUser + "' and a.StartDate='" + DateTime.Today + "'";
                if (Request["ProcessFlag"] != null) txtsql += " and c.ProcessFlag=" + Request["ProcessFlag"];
                QueryCommand cmd = new QueryCommand(txtsql);
                DataTable dt = DataService.GetDataSet(cmd).Tables[0];
                result = dt.Rows.Count;
                Response.Write(result);
            }
            else if (Request["type"] == "Adverse")
            {
                int result = 0;
                SqlQuery q = new Select().From<Adverse>();
                result = q.GetRecordCount();
                Random rd = new Random(DateTime.Now.Millisecond);
                int random = rd.Next(0, result - 1);
                Response.Write(q.ExecuteTypedList<Adverse>()[random].AdverseX);
            }
            else if (Request["type"] == "password")
            {
                SysUser sysu = new SysUser("Code", currentUserCode);
                if (sysu.Password != EncryptionUtil.StringToMD5Hash(Request["Password"]))
                    renderData("fail:原始密码输入错误!");
                if (Request["New"] != Request["New1"])
                    renderData("fail:两次输入密码不相同!");
                sysu.Password = EncryptionUtil.StringToMD5Hash(Request["New"]);
                sysu.Save();
                renderData("success");
            }
            else if (Request["type"] == "saveGroup")
            {
                string url = Request.Form.ToString();
                string sql = "";
                string[] urlsplit = url.Split('&');
                TxTSql tq = new TxTSql();
                tq.Cname = Server.UrlDecode(urlsplit[1].Split('=')[1]);
                for (int i = 2; i < urlsplit.Length; i++)
                {
                    string[] columnsplit = urlsplit[i].Split('=');
                    string[] columncname = columnsplit[0].Split('_');
                    bool getequal=false;
                    if (columncname[1] != "Type")
                    {
                        for (int j = 2; j < urlsplit.Length; j++)
                        {
                            string[] columnsplitC = urlsplit[j].Split('=');
                            string[] columncnameC = columnsplitC[0].Split('_');
                            if ((columncname[0] + "_Type_" + columncname[columncname.Length - 1]) == columnsplitC[0])
                            {
                                string txturldecode=Server.UrlDecode(columnsplitC[1]);
                                if (txturldecode != "like")
                                    sql += " and c." + Server.UrlDecode(columncname[0]) + txturldecode+ "'" + Server.UrlDecode(columnsplit[1]) + "'";
                                else
                                    sql += " and c." + Server.UrlDecode(columncname[0]) + " like '%" + Server.UrlDecode(columnsplit[1]) + "%'";
 
                                getequal = true;
                                break;
                            }
                        }
                        if (!getequal)
                        {
                            sql += " and c." + columncname[0] + " like '%" + columnsplit[1] + "%'";
                        }
                    }
                   
                }
                tq.Sql = sql;
                tq.WarehouseCode = currentMaster;
                tq.IsAdmin = 0;
                tq.StatusFlag = 1;
                tq.Save();
                renderData("success");
            }
        }
    }
}