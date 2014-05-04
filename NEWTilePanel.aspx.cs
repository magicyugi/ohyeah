using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox
{
    public partial class NewTilePanel :  Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lbUserName.InnerText = Common.currentUser;
            //lbTime.InnerText = Common.currentWareHouseName;
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
) and statusflag=2");
            DataTable dt = DataService.GetDataSet(cmd).Tables[0]; 
            SqlQuery q = new Select().From<SysMenu>();
            SqlQuery Sysq = new Select().From<SysCode>().Where("WareHouse_Code").IsEqualTo(Common.currentMaster).And("StatusFlag").IsEqualTo("1").And("KeyFlag").IsEqualTo("1");
            DataTable menudt=q.ExecuteDataSet().Tables[0];
            DataTable sysdt = Sysq.ExecuteDataSet().Tables[0];
            DataRow[] titlerow = menudt.Select(" statusflag=2 and Pcode=''");
            string group = @"<ul class='page-sidebar-menu'> 
				 
                                   ";
            string txttitle="",txtKeytitle=""; 
             
            foreach(var item in titlerow)
            { 
                //if (dt.Seli class=''>lect(" code='" + item["Code"] + "'").Length != 0) continue; 
                group += @"<li>

					<a href='javascript:;'>

					<i class='"+item["Icon"]+@"'></i> 

					<span class='title'>"+item["Cname"]+ @"</span>

					<span class='arrow '></span>

					</a> 
                    <ul class='sub-menu'>";
                DataRow[] showrow = menudt.Select(" statusflag=1 and Pcode='" + item["Code"] + "'");
                
                foreach (var showitem in showrow)
                {
                     
                    if (dt.Select(" code='" + showitem["Code"] + "'").Length != 0) continue;
                    string direction = "", txtUrl = "" ;
                    if (item["Direction"].ToString() != "") direction = "-" + item["Direction"];
                    if (item["NumSql"].ToString() != "") txtUrl += "?" + item["NumSql"];
                    if (item["Cname"].ToString() == "按国家地区")
                    { 
                        txttitle += CountryMenu();

                    }
                    else
                    {
                        txttitle += @"<li>
                            <div class='badge'  id='menu" + showitem["Code"] + @"' style='width:0px' getcount='" + showitem["NumSql"] + @"' ></div>
						<a  href=""JavaScript:MenuOnClick('" + showitem["Url"] + @"','" + showitem["Cname"] + @"')""> 
							" + showitem["Cname"] + @"</a>

						   </li>";
                    }
                }
                group +=txttitle + txtKeytitle + "</ul></li>";
                txtKeytitle = ""; txttitle = "";
            }
            group += @" </ul>";
                         
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
        private string CountryMenu() 
        {
            string strreturn = "";
            string Countrysql = "SELECT  count(*) as totalcount,VCode,VName from ExistCountry where WareHouse_Code='" + Common.currentMaster + "' group BY VCode,VName";
            DataTable Countrydt = SqlDal.RunSqlExecuteDT(Countrysql);
            //QueryCommand Countrycmd = new QueryCommand(@"SELECT VCode,VName,Pname,code,cname from ExistCountry where WareHouse_Code='" + Common.currentMaster + "' order BY VCode,VName,Pname");
            //DataTable Countrydt = DataService.GetDataSet(Countrycmd).Tables[0];
            for (int Ci = 0; Ci < Countrydt.Rows.Count; Ci++)
            {
                DataRow dr = Countrydt.Rows[Ci];
                strreturn += @"<li> 
                                 <a href='javascript:;'>

					            <i class='icon-exchange'></i> 

					            <span class='title'>" + dr["VName"] + @"(" + dr["totalcount"] + @")</span>

					            <span class='arrow '></span></a>";

                                //<a  href=""JavaScript:MenuOnClick('','" + dr["VName"] + @"')""> 
                                //    " + dr["VName"] + @"(" + dr["totalcount"] + @")</a>";
                string Areasql = "SELECT  count(*) as totalcount,Pname from ExistCountry where WareHouse_Code='" + Common.currentMaster + "' and VCode='" + dr["VCode"] + "' group BY Pname";
                DataTable Areadt = SqlDal.RunSqlExecuteDT(Areasql);
                if (Areadt.Rows.Count != 0)
                {
                    strreturn += "<ul class='sub-menu'>";
                    for (int Ai = 0; Ai < Areadt.Rows.Count; Ai++)
                    {
                        DataRow Adr = Areadt.Rows[Ai];
                        strreturn += @"<li> 
                                <a href='javascript:;'>

					            <i class='icon-exchange'></i> 

					            <span class='title'>" + Adr["Pname"] + "(" + Adr["totalcount"] + @")</span>

					            <span class='arrow '></span></a>";
                                //<a  href=""JavaScript:MenuOnClick('','" + Adr["Pname"] + @"')""> 
                                //    " + Adr["Pname"] + @"(" + Adr["totalcount"] + @")</a>";
                        string Citysql = "SELECT  count(*) as totalcount,Code,Cname from ExistCountry where WareHouse_Code='" + Common.currentMaster + "' and VCode='" + dr["VCode"] + "' and Pname='" + Adr["Pname"] + "' group BY Code,Cname";
                        DataTable Citydt = SqlDal.RunSqlExecuteDT(Citysql);
                        if (Citydt.Rows.Count != 0)
                        {
                            strreturn += "<ul class='sub-menu'><li>";
                            for (int CTi = 0; CTi < Citydt.Rows.Count; CTi++)
                            {
                                DataRow CTdr = Citydt.Rows[CTi];
//                                strreturn += @"<li> 
//						        <a  href=""JavaScript:MenuOnClick('','" + CTdr["Cname"] + @"')""> 
//							        " + CTdr["Cname"] + @"(" + CTdr["totalcount"] + @")</a></li>";
                                strreturn += @"<span onclick='javascript:;' style='margin-left: 5px;cursor:pointer;' class='label label-success label-mini'> " + CTdr["Cname"] + @"(" + CTdr["totalcount"] + @")</span>";
                                //strreturn += @"<a href='javascript:;' role='button' class='btn' data-toggle='modal'>" + CTdr["Cname"] + @"(" + CTdr["totalcount"] + @")</a>";
                            }
                            strreturn += "</li></ul>";
                        }
                        strreturn += "</li>";
                    }
                    strreturn += "</ul>";
                }
				strreturn+="</li>";
            }
            return strreturn;
        }
    }
}