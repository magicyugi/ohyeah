using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox.View.Visit
{
    public partial class NewVisit : BasePage
    {
        protected string txtflag = "";
        protected void Page_Load(object sender, EventArgs e)
        {

            DataTable flagdt = SqlDal.RunSqlExecuteDT("select ProcessFlag from customer where code='" + Request["Code"] + "'");
            if (flagdt.Rows.Count == 0)
            {
                Alert.Delete("code", Request["Code"]);
                Response.Write("<script>alert('该客户已被删除,将删除该客户所有提醒信息!');window.location.href='../Alerts/AlertList.aspx?ProcessFlag=" + Request["ProcessFlag"] + "';</script>");
            }
            else
                txtflag = Request["ProcessFlag"];
        }
    }
}