using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox
{
    public partial class HorzontalTilePanel : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lbUserName.InnerText = Common.currentUser;
            lbTime.InnerText = Common.currentWareHouseName;
            if (Common.currentUser == "") Response.Redirect("Login.aspx");
            if (Common.currentUserCode == "system") Response.Redirect("View/Users/QuickUser.aspx");
            string[] pcode = { "03", "02", "01" };
            TileMenu(pcode);
        }

        private void TileMenu(string[] pcode)
        {
            string[] RoleArry = Common.currentRole.Split(',');
            string txtRole = "";
            for (int i = 0; i < RoleArry.Length; i++)
            {
                txtRole += RoleArry[i] + ",";
            } 
            QueryCommand cmd = new QueryCommand(@"select Code from SysMenu 
WHERE  Code NOT IN (SELECT Menu_Code FROM SysRoleMenu where Org_Code='"+Common.currentMaster+@"' AND 
Role_Code IN (" + txtRole.Substring(0, txtRole.Length-1) + @") 
)");
            DataTable dt = DataService.GetDataSet(cmd).Tables[0]; 
            SqlQuery q = new Select().From<SysMenu>();
            SqlQuery Sysq = new Select().From<SysCode>().Where("WareHouse_Code").IsEqualTo(Common.currentMaster).And("StatusFlag").IsEqualTo("1").And("KeyFlag").IsEqualTo("1");
            DataTable menudt=q.ExecuteDataSet().Tables[0];
            DataTable sysdt = Sysq.ExecuteDataSet().Tables[0];
            DataRow[] titlerow = menudt.Select(" statusflag=1 and Pcode=''");
            string group = @" 
                <li class='active '>

                        <a href='TilePanel.aspx'>

                        <i class='icon-home'></i>  主页

                        </a>

                </li>     ";
            string txttitle="",txtKeytitle=""; 
             
            foreach(var item in titlerow)
            {
                bool isflag = false;
                string txtcategory = ""; 
                //if (dt.Seli class=''>lect(" code='" + item["Code"] + "'").Length != 0) continue; 
                group += @"<li> 
                            <a data-toggle='dropdown' class='dropdown-toggle' href='javascript:;'>
                                <i class='" + item["Icon"] + @"'></i> 
								<span class='title'>" + item["Cname"] + @"</span>

								<span class='arrow'></span>     

							</a> 
                            <ul class='dropdown-menu'>";
                DataRow[] showrow = menudt.Select(" statusflag=1 and Pcode='" + item["Code"] + "'");
                DataRow[] sysrow = sysdt.Select("");
                
                if (item["Cname"].ToString() == "售前")
                { txtcategory = "CustomerLevel"; sysrow = sysdt.Select("Category='CustomerLevel'"); if (sysrow.Length != 0)isflag = true; }
                else if (item["Cname"].ToString() == "售中")
                { txtcategory = "CustomerLevel1"; sysrow = sysdt.Select("Category='CustomerLevel1'"); if (sysrow.Length != 0)isflag = true; }
                else if (item["Cname"].ToString() == "售后")
                { txtcategory = "CustomerLevel2"; sysrow = sysdt.Select("Category='CustomerLevel2'"); if (sysrow.Length != 0)isflag = true; }
                foreach (var showitem in showrow)
                {
                    if (isflag) 
                    {
                        foreach (var keyitem in sysrow)
                        {
                            txtKeytitle += @"<li>

							<a  href=""JavaScript:MenuOnClick('View/Customers/CustomerList.aspx?Category=" + keyitem["Code"] + "-" + txtcategory + @"','" + keyitem["Cname"] + @"客户')"">

							" + keyitem["Cname"] + @"客户</a>

						   </li>";  
                        }
                        isflag = false;
                    }
                    if (dt.Select(" code='" + showitem["Code"] + "'").Length != 0) continue;
                    string direction = "", txtUrl = "" ;
                    if (item["Direction"].ToString() != "") direction = "-" + item["Direction"];
                    if (item["NumSql"].ToString() != "") txtUrl += "?" + item["NumSql"];
                    txttitle += @"<li>
                            <div class='badge'  id='menu" + showitem["Code"] + @"' style='width:0px' getcount='" + showitem["NumSql"] + @"' ></div>
						<a  href=""JavaScript:MenuOnClick('" + showitem["Url"] + @"','" + showitem["Cname"] + @"')""> 
							" + showitem["Cname"] + @"</a>

						   </li>"; 
                }
                group +=txttitle + txtKeytitle + "</ul></li>";
                txtKeytitle = ""; txttitle = "";
            }
            //group += @" </ul>";
                         
//            foreach(var item in q.ExecuteTypedList<SysMenu>()) {
//                if (dt.Select(" code='" + item.Code + "'").Length != 0) continue;
//                string direction=""; 
//                if (item.Direction != "") direction = "-" + item.Direction;
//                string tile = @"<div class='tile bg-color-" + item.BgColor + " " + item.TileNum +  direction + @" icon'  url='"+item.Url+@"'>
//                        <div class='tile-content'> 
//                        <i class=' icon " +item.Icon+@"'></i>
//                        </div>
//                        <div class='brand'>
//                                <div class='badge'  id='menu" + item.Code + @"' style='font-size:40px' getcount='" + item.NumSql + "' ></div><div class='name' style='font-size:14px; font-weight:bolder' >"
//                                 +item.Cname
//                                 +@"</div> 
//                        </div>
//                    </div>";
//                 group += tile;
//            } 
            Menudiv.InnerHtml = group;
        }
    }
}