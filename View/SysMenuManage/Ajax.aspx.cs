using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using DB;
using System.Data;

namespace UI.Module.SysMenuManage
{
    public partial class Ajax : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
             GetUser();//验证登陆
             if (Request["key"] != null && Request["key"].ToString() != "")
             {
                 if (Request["key"].ToString() == "LoadGrid")
                 {
                     SetAjaxGrid();
                 }
                 else if (Request["key"].ToString() == "del")
                 {
                     string id = Request["id"].ToString();
                     SysMenu sysmenu = new SysMenu("Code",id);
                     if (sysmenu.IsAdminMenuFlag != 1)
                     {
                         SysMenuController tt = new SysMenuController();
                         tt.Delete(id);
                         SetAjaxGrid();
                     }
                 }
                 else if (Request["key"].ToString() == "insert")
                 {
                     //try
                     //{
                     string code = SqlDal.GetSelectCode("SysMenu", "", user.UserWCode);
                     int q = new Insert().Into(SysMenu.Schema,
                    "Code", "Cname", "Url", "DescCode", "Pcode", "Icon", "Description",
                      "StatusFlag").
                    Values(
                    code,
                   
                    Request["txtCname"].ToString(),
                    Request["txtUrl"].ToString(),
                   (Request["txtDescCode"].ToString() == "" ? 0 : int.Parse(Request["txtDescCode"].ToString())),
                    Request["txtPCode"].ToString(),
                    Request["txtIcon"].ToString(),
                    Request["txtDescription"].ToString(),
                     Request["txtStatusFlag"].ToString()
                    ).Execute();
                     Response.Write("success");
                     //}
                     //catch (Exception exc)
                     //{
                     //    Response.Write(exc.Message);
                     //}
                 }
                 else if (Request["key"].ToString() == "update")
                 {
                     //try
                     //{

                     SysMenu model = new SysMenu("Code", Request["txtCode"].ToString());
                     model.Cname = Request["txtCname"].ToString();
                     model.Url = Request["txtUrl"].ToString();
                     model.DescCode = int.Parse(Request["txtDescCode"].ToString());
                     model.Pcode = Request["txtPCode"].ToString();
                     model.Icon = Request["txtIcon"].ToString();
                     model.Description = Request["txtDescription"].ToString();
                     
                     model.Save();
                     Response.Write("success");
                     //}
                     //catch (Exception exc)
                     //{
                     //    Response.Write(exc.Message);
                     //}
                 }

             }
        }

        void SetAjaxGrid()
        {
           
            SqlQuery q = new Select().From(SysMenu.Schema).Where(SysMenu.StatusFlagColumn).IsEqualTo(1).OrderAsc("TypeFlag,DescCode");
            DataTable dt = q.ExecuteDataSet().Tables[0];
            Response.Write(Utils.GetTreeJsonByTB(dt, "Code", "Cname", "PCode", "Url,TypeFlag,DescCode,Icon,Description,IsAdminMenuFlag,StatusFlag", ""));
        }
    }
}