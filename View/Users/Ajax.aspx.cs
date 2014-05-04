using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox.View.Users
{
    public partial class Ajax : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["type"] == "list")
            { 
                gridbind("");
            }
            if (Request["type"] == "Role")
            {
                renderData(Common.btnRole("", Request["RoleCode"]));
            }
            else if (Request["type"] == "del")
            {
                int id = int.Parse(Request["id"]);
                SysUser su = new SysUser("ID", id);
                DBUtil.Execute("update Warehouse set usernum=usernum-1 where code='" + su .WareHouseCode+ "'");
                SysUser.Delete("ID", id); 
                renderData("success"); 
            }

            else if (Request["type"] == "add")
            {
                int iCount = new Select().From(SysUser.Schema).Where(SysUser.CodeColumn).IsEqualTo(Request["Code"]).Or(SysUser.CnameColumn).IsEqualTo(Request["Cname"]).GetRecordCount();
                if (iCount > 0)
                {
                    renderData("fail:用户名和姓名不能重复!");  
                } 
                SysUser sysu = new SysUser();
                sysu.Code = Request["Code"]; 
                saveUser(sysu);
            }
            else if (Request["type"] == "quick")
            {
                int iCount = 0;
                iCount = new Select().From(SysUser.Schema).Where(SysUser.CodeColumn).IsEqualTo(Request["Code"]).GetRecordCount();
                if (iCount > 0) 
                    renderData("fail:用户名和姓名不能重复!"); 
                iCount = new Select().From(WareHouse.Schema).Where(WareHouse.CnameColumn).IsEqualTo(Request["Cname"]).GetRecordCount();
                if (iCount > 0)
                    renderData("fail:总代理名称重复!");
                QuickSave();
            }
            else if (Request["type"] == "edit")
            {  
                int id = int.Parse(Request["id"]); 
                SysUser sysu = new SysUser("ID", id);
                
                //sysu.Code = Request["Code"];
                saveUser(sysu);
            }
            else if (Request["type"] == "combox")
            {
                gridbind("Comb");
            } 
            else if (Request["type"] == "search")
            {
                gridbind(Request["value"]);
            }
            else if (Request["type"] == "getcomb")
            {
                string txtid = "";
                SqlQuery q = new Select().From(SysUser.Schema).Where(SysUser.IdColumn).IsEqualTo(int.Parse(Request["id"].ToString()));
                DataTable userdt = q.ExecuteDataSet().Tables[0];
                q = new Select().From(SysUserGroup.Schema).Where(SysUserGroup.UserCodeColumn).IsEqualTo(userdt.Rows[0]["Code"].ToString());
                DataTable userGroupdt = q.ExecuteDataSet().Tables[0];
                for (int i = 0; i < userGroupdt.Rows.Count; i++)
                {
                    txtid += userGroupdt.Rows[i]["Group_Code"].ToString() + ";";
                }
                txtid += "|";
                q = new Select().From(SysUserRole.Schema).Where(SysUserRole.UserCodeColumn).IsEqualTo(userdt.Rows[0]["Code"].ToString());
                DataTable userRoledt = q.ExecuteDataSet().Tables[0];
                for (int i = 0; i < userRoledt.Rows.Count; i++)
                {
                    txtid += userRoledt.Rows[i]["Role_Code"].ToString() + ";";
                }
                txtid += "|";
                txtid += userdt.Rows[0]["WareHouse_Code"].ToString();  
                renderData(txtid); 
            }
        }
        public void QuickSave() 
        {
            WareHouse wh = new WareHouse();
            wh.Code = Request["Code"];
            wh.Cname = Request["Cname"];
            wh.VCode = Request["Code"];
            wh.CodeList = "-" + Request["Code"];
            wh.Tel = Request["Mobile"];
            wh.LevelValue = 1;
            wh.PCode = "";
            wh.UserNum = 1;
            wh.AllowUserNum = 1;
            wh.CreateTime = DateTime.Now;
            wh.StatusFlag = 1;
            wh.StoreFlag = 4;

            WareHouse whshop = new WareHouse();
            whshop.Code = Request["Code"] + "01";
            whshop.Cname = Request["Cname"] + "1店";
            whshop.VCode = Request["Code"] + "01";
            whshop.CodeList = Request["Code"] + "-" + Request["Code"] + "01";
            whshop.Tel = Request["Mobile"];
            whshop.LevelValue = 2;
            whshop.PCode = wh.Code;
            whshop.UserNum = 1;
            whshop.AllowUserNum = 1;
            whshop.CreateTime = DateTime.Now;
            whshop.StatusFlag = 1;
            whshop.StoreFlag = 4;
            
            SysUser sys = new SysUser();
            sys.Code = Request["Code"] ;
            sys.WareHouseCode = whshop.Code;
            sys.Cname = Request["Name"];
            sys.Password = EncryptionUtil.StringToMD5Hash(Request["Password"]);
            sys.UserLevel = "4"; sys.UserLevelPoint = 4;
            sys.Mobile = Request["Mobile"];
            sys.Discount = 0;
            sys.DeleteFlag = 0;
            sys.StatusFlag = 1;

            SysRole role = new SysRole();
            role.Code = "admin";
            role.Cname = "管理员";
            role.LevelPoint = 4;
            role.OrgCode = wh.Code;
            role.StatusFlag = 1; 

            SysUserGroup userGroup = new SysUserGroup();
            userGroup.WareHouseCode = wh.Code;
            userGroup.GroupCode = whshop.Code;
            userGroup.UserCode = sys.Code;
            
            SysUserRole UserRole = new SysUserRole();
            UserRole.WareHouseCode = wh.Code;
            UserRole.RoleCode = "admin";
            UserRole.UserCode = sys.Code;

            DBUtil.Execute("insert into sysrolemenu (org_code,role_code,menu_code,rolekey) select '"+wh.Code+"','admin',menu_code,rolekey from sysrolemenu where org_code='system' and role_code='admin'");
           
            //***************Save*********************
            wh.Save();
            whshop.Save();
            sys.Save();
            role.Save();
            UserRole.Save();
            userGroup.Save();
            renderData("success");
        }
        //保存用户
        public void saveUser(SysUser sysu){
                string warehouse = Request["WareHouse"] == null ? currentWareHouse : Request["WareHouse"];
                sysu.Cname = Request["Cname"];
                sysu.Mobile = Request["Mobile"];
                sysu.Tel = Request["Tel"];
                if (sysu.Password != Request["Password"])
                sysu.Password = EncryptionUtil.StringToMD5Hash( Request["Password"]);
                sysu.WareHouseCode = warehouse;
                sysu.PostCode = "";
                sysu.Discount =0;
                sysu.JobCode = "";
                sysu.DeleteFlag = 1;
                sysu.StatusFlag = 1;
                sysu.MenuFlag =Request["txtMenuFlag"]==""?0: int.Parse(Request["txtMenuFlag"]);
                if (Request["UserPoint"] == null) sysu.UserLevelPoint = 1;
                else
                {
                    sysu.UserLevelPoint = int.Parse(Request["UserPoint"] == "" ? "1" : Request["UserPoint"]);
                }
                SysUserGroup.Delete("User_Code", sysu.Code);
                SysUserRole.Delete("User_Code", sysu.Code);
                if (Request["OrgName"] != null)
                {
                    string[] txtwarehouse = Request["OrgName"].ToString().Split(',');
                    if (Request["OrgName"].Contains(Request["WareHouse"]))
                        for (int i = 0; i < txtwarehouse.Length; i++)
                        {
                            SysUserGroup userGroup = new SysUserGroup();
                            userGroup.WareHouseCode = Common.currentMaster;
                            userGroup.GroupCode = txtwarehouse[i];
                            userGroup.UserCode = sysu.Code;
                            userGroup.Save();
                        }
                }
                else
                {
                    SysUserGroup userGroup = new SysUserGroup();
                    userGroup.WareHouseCode = Common.currentMaster;
                    userGroup.GroupCode = currentWareHouse;
                    userGroup.UserCode = sysu.Code;
                    userGroup.Save();
                }
                if (Request["UserCode"] != null)
                {
                    string[] txtUserCode = Request["UserCode"].ToString().Split(',');
                    for (int i = 0; i < txtUserCode.Length; i++)
                    {
                        SysUserRole UserRole = new SysUserRole();
                        UserRole.WareHouseCode = Common.currentMaster;
                        UserRole.RoleCode = txtUserCode[i];
                        UserRole.UserCode = sysu.Code;
                        UserRole.Save();
                    }
                }
                else
                {
                    SysUserRole UserRole = new SysUserRole();
                    UserRole.WareHouseCode = Common.currentMaster;
                    UserRole.RoleCode ="0";
                    UserRole.UserCode = sysu.Code;
                    UserRole.Save();
                }
                sysu.Save();
                DBUtil.Execute(@"update warehouse set usernum =sys.usernum from warehouse wh,
                                        (select warehouse_code,count(*) as usernum from sysuser group by warehouse_code) sys
                                        where wh.code=sys.warehouse_code ");
                if (Request["type"] == "edit"&&Request["UserPoint"] != null)
                {
                    if (Request["UserPoint"]!=sysu.UserLevelPoint.ToString())
                    DBUtil.Select(@"update sysuser set userlevelpoint = s.levelpoint from sysuser su, 
                    (select sr.user_code ,max(isnull(levelpoint,1)) as  levelpoint  from sysuserrole sr 
                    left join sysrole r on  role_code= r.code where user_code<>''  group by sr.user_code) s 
                    where su.code =s.user_code and warehouse_code in (" + currentGroup + @")
                    ");
                }
                renderData("success");
        }
       
        public DataTable getList(out int totalcount, string txtSearch)
        {
            int row = int.Parse(Request["rows"]);
            int page = int.Parse(Request["page"].ToString());
            string[] selectItem = { "ID", "Code", "Cname", "(select Cname from warehouse where code=WareHouse_Code ) as OrgName", "Password", "Mobile","Tel", "Email", "Post_Code", "StatusFlag", "Discount","UserLevelPoint", "MenuFlag",
                              "UserRoleName=stuff((select ';'+ Cname  from (select distinct User_Code,Role_Code,Cname from SysRole b left join sysUserRole a on a.Role_Code=b.Code and b.Org_code=a.WareHouse_Code) c where c.User_Code=Code for xml path('')),1,1,'') ", 
                              "UserGroupName=stuff((select ';'+Cname from (select distinct Cname,b.User_Code as User_Code  from WareHouse a left join SysUserGroup b on a.Code=b.Group_Code where (a.Pcode='"+currentMaster+"' or a.code='"+currentMaster+"')) e where e.User_Code=Code for xml path('')),1,1,'')","DeleteFlag" };
            SqlQuery q = new Select(selectItem).From(SysUser.Schema).Where(SysUser.StatusFlagColumn).IsEqualTo(1).And(SysUser.WareHouseCodeColumn).In(Common.currentGroups);
            if (txtSearch != "") q.AndExpression("Cname").Like("%" + txtSearch + "%").Or(SysUser.MobileColumn).Like("%" + txtSearch + "%").Or(SysUser.CodeColumn).Like("%" + txtSearch + "%");
            totalcount = q.GetRecordCount();
            return q.Paged(page, row).ExecuteDataSet().Tables[0];
        }
        public DataTable getWarehouseList(out int totalcount, string txtSearch)
        { 

            SqlQuery q ;
            if (Request["table"] == "Warehouse")
                q = new Select().From(WareHouse.Schema).Where(WareHouse.PCodeColumn).IsEqualTo(Common.currentMaster).And(WareHouse.StatusFlagColumn).IsEqualTo("1");
            else
                q = new Select().From(SysRole.Schema).Where(SysRole.OrgCodeColumn).IsEqualTo(Common.currentMaster).OrderAsc("LevelPoint"); 
             
            totalcount = q.GetRecordCount(); 
            return q.ExecuteDataSet().Tables[0];
        }
        public void gridbind(string txtSearch)
        { 
            int totalcount = 0;

            DataTable newList=new DataTable ();
            if (txtSearch == "Comb")
            {
                newList = getWarehouseList(out totalcount, Request["type"]);
                renderData("{\"rows\":" + JSON.Encode(newList) + ",\"total\":" + totalcount + "}");
            }
            else
            {
                newList = getList(out totalcount, txtSearch);
                renderData("{\"rows\":" + JSON.Encode(newList) + ",\"total\":" + totalcount + "}");
            }
        }
    }
}