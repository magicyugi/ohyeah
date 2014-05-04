using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox.View.SysRoles
{
    public partial class SysRoleEdit : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string roleCode = "";
                string roleCname = "";
                string levelPoint = "";
                if (Request.QueryString["Code"] != null)
                {
                    roleCode = Request.QueryString["Code"].ToString();
                    SysRole sr = new SysRole("ID", Request.QueryString["id"].ToString());
                    txtCode.Value = roleCode; 
                    txtCode.Disabled = true;
                    txtCname.Value = sr.Cname;
                    txtLevelPoint.Value = sr.LevelPoint.ToString();
                }
                DataTable dt = new DataTable();
                string sql = @" select (case when   b.code=mincode  then  a.code else '' end) as pcode,
                        (case when b.code=mincode then a.cname else '' end) as pname,b.code,b.cname,
                        rolekey,(case when rolekey=-1 then 0 else 1 end ) as ViewStatus,maxcode,mincode,'新增,修改' as ActionLookUp from (select code,cname from sysMenu where pcode='' ) a inner join
                        (select code,cname,pcode, isnull(rolekey,-1) as rolekey from sysMenu a left join 
                        (select menu_code,rolekey from sysrolemenu where role_code='" + roleCode + @"' and org_code='" + Common.currentMaster + @"' ) b on 
                        a.code=b.menu_code  where pcode<>'' and isAdminMenuFlag<2 and statusflag=1 ) b on a.code=b.pcode left join 
                        (select pcode,min(code) as mincode,max(code) as maxcode from sysMenu where pcode<>'' and statusflag=1 group by pcode) c 
                            on a.code=c.pcode  order by a.Code,b.code";
                QueryCommand cmd = new QueryCommand(sql);
                DataSet ds = DataService.GetDataSet(cmd);
                dt = ds.Tables[0];
                pivotGrids.DataSource = dt;
                pivotGrids.DataBind();

                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    string txtmenusql = @" select distinct  b.Code,b.menu_code,a.AllRoleKey,b.RoleKey,b.Cname, a.AllRoleKey&b.RoleKey as checked from  (select  Code,RoleKey,Menu_Code,Cname from [SysAction]) b left join (select Menu_Code,RoleKey as AllRoleKey from [SysRoleMenu] 
         	        where  Role_Code='" + roleCode + "' and org_code='"+Common.currentMaster+"') a   on a.Menu_Code=b.Menu_Code where b.menu_code='" + dt.Rows[j]["Code"].ToString() + "' order by b.Code";
                    QueryCommand menucmd = new QueryCommand(txtmenusql);
                    DataSet menuds = DataService.GetDataSet(menucmd);

                    #region checkBos
                    System.Web.UI.WebControls.CheckBox lbss = pivotGrids.Items[j].FindControl("chbRole") as System.Web.UI.WebControls.CheckBox;

                    #endregion

                    System.Web.UI.WebControls.CheckBoxList lb = pivotGrids.Items[j].FindControl("cblRoleLists") as System.Web.UI.WebControls.CheckBoxList;
                    System.Web.UI.WebControls.HiddenField hdn = (System.Web.UI.WebControls.HiddenField)pivotGrids.Items[j].FindControl("hdnActionValue");
                    lb.Items.Clear();
                    for (int i = 0; i < menuds.Tables[0].Rows.Count; i++)
                    {
                        System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem();
                        li.Text = menuds.Tables[0].Rows[i]["Cname"].ToString();
                        li.Value = menuds.Tables[0].Rows[i]["RoleKey"].ToString();
                        lb.Items.Add(li);
                    }
                    lbss.Checked = dt.Rows[j]["ViewStatus"].ToString() == "1" ? true : false;
                    lb.Attributes.Add("onclick", "ActionChecked('" + lb.ClientID.ToString() + "','" + lb.Items.Count + "', '" + hdn.ClientID.ToString() + "' )");
                    foreach (System.Web.UI.WebControls.ListItem cb in lb.Items)
                    {
                        if (menuds.Tables[0].Rows[lb.Items.IndexOf(cb)]["checked"].ToString() == menuds.Tables[0].Rows[lb.Items.IndexOf(cb)]["RoleKey"].ToString())
                            cb.Selected = true;
                        if (Session["SelectAll"] != null)
                        {
                            cb.Selected = true;
                        }
                        if (Session["UnSelectAll"] != null)
                        {
                            cb.Selected = false;
                        }
                    }
                }
                //LoadData();
            }
        }

        protected void btn_Save_Click(object sender, EventArgs e)
        { 
            if (txtCname.Value == "")
            {
                Response.Write("<script>alert('请输入角色名称!');window.location.href = window.location.href;</script>");
                return;
            }
            if (txtLevelPoint.Value == "")
            {
                Response.Write("<script>alert('请输入角色等级!');window.location.href = window.location.href;</script>");
                return;
            }
            string roleID = "";
            string editType = "";
            if (Request.QueryString["ID"] != null)
            {
                roleID = Request.QueryString["ID"].ToString();
            }
            if (Request.QueryString["EditType"] != null)
            {
                editType = Request.QueryString["EditType"].ToString();
                QueryCommand cmd = new QueryCommand("select * from sysrole where ID<>" + roleID + " and Cname='" + txtCname.Value + "' and org_code='"+Common.currentMaster+"' ");
                DataSet ds = DataService.GetDataSet(cmd);
                if (ds.Tables[0].Rows.Count != 0) { Response.Write("<script>alert('角色名有重复项!');window.location.href =window.location.href; </script>"); return; }
                SysRole sysRole = new SysRole("ID", int.Parse(roleID));
                sysRole.Code = txtCode.Value;
                sysRole.OrgCode = Common.currentMaster; 
                sysRole.Cname = txtCname.Value;
                sysRole.LevelPoint = int.Parse(txtLevelPoint.Value == "" ? "1" : txtLevelPoint.Value);
                sysRole.Description = ""; 
                sysRole.StatusFlag = 1;
                sysRole.Save();
            }
            else
            {
                QueryCommand cmd = new QueryCommand("select * from sysrole where Code='" + txtCode.Value + "'  or Cname='" + txtCname.Value + "' and org_code='" + Common.currentMaster + "' ");
                DataSet ds = DataService.GetDataSet(cmd);
                if (ds.Tables[0].Rows.Count != 0) { Response.Write("<script>alert('代码或角色名有重复项!');window.location.href =window.location.href;</script>"); return; }
                SysRole sysRole = new SysRole();
                sysRole.OrgCode = Common.currentMaster;
                txtCode.Value = SqlDal.GetSelectCode("SysCode", "", Common.currentMaster);
                sysRole.Code = txtCode.Value;
                sysRole.Cname = txtCname.Value; 
                sysRole.LevelPoint = int.Parse(txtLevelPoint.Value == "" ? "1" : txtLevelPoint.Value);
                sysRole.Description = "";
                sysRole.StatusFlag = 1;
                sysRole.Save();
            }
            string roleCode = ""; 
            roleCode =txtCode.Value;
            DBUtil.Execute("delete from sysrolemenu where role_code='" + roleCode + "' and org_code='" + Common.currentMaster + "'");
           
             for (int i = 0; i < pivotGrids.Items.Count; i++)
            {
                System.Web.UI.WebControls.CheckBoxList lb = pivotGrids.Items[i].FindControl("cblRoleLists") as System.Web.UI.WebControls.CheckBoxList;
                System.Web.UI.WebControls.HiddenField hdn = (System.Web.UI.WebControls.HiddenField)pivotGrids.Items[i].FindControl("hdnActionValue");
                System.Web.UI.WebControls.CheckBox cbView = (System.Web.UI.WebControls.CheckBox)pivotGrids.Items[i].FindControl("chbRole");


                //********************2012.8.24 lsp ********************
                double cnt = 0;
                for (int j = 0; j < lb.Items.Count; j++)
                {
                    if (lb.Items[j].Selected)
                    {
                        cnt = cnt + Math.Pow(2, j);
                    }
                    hdn.Value = cnt.ToString();
                }
                //********************2012.8.24 lsp ********************
                if (lb.Items.Count == 0)
                {
                    if (cbView.Checked == true)
                        hdn.Value = "0";
                    else
                        hdn.Value = "-1";
                }
                int roleKey = 0;
                roleKey = int.Parse(hdn.Value);

                if ((cbView.Checked == true && roleKey <= 0) || roleKey > 0)
                {
                    SysRoleMenu sysrolemenu = new SysRoleMenu();
                    sysrolemenu.OrgCode = Common.currentMaster;
                    System.Web.UI.WebControls.Label lable = pivotGrids.Items[i].FindControl("Label1") as System.Web.UI.WebControls.Label;
                    sysrolemenu.MenuCode = lable.Text;
                    sysrolemenu.RoleCode = roleCode;
                    sysrolemenu.RoleKey = roleKey <= 0 ? 0 : roleKey;
                    sysrolemenu.Save(); 
                }
            }
            Response.Write("<script>alert('保存成功!');window.location.href = 'SysRoleList.aspx';</script>");
        }
    }
}