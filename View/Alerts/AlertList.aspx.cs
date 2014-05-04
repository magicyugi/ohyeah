using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox.View.Alerts
{
    public partial class AlertList :  BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string define = "";
            SqlQuery q = new Select().From<CustomerDetail>().Where("CTextCount").IsNotNull().And(CustomerDetail.WareHouseCodeColumn).IsEqualTo(Common.currentMaster);
            DataTable dt = q.ExecuteDataSet().Tables[0];
            if(dt.Rows.Count!=0)
            for (int i = 1; i < int.Parse(dt.Rows[0]["CTextCount"].ToString()) + 1; i++)
            {
                define += "<li  class='normalli'> <label for='txtCText" + i + "'  >" + dt.Rows[0]["CText" + i].ToString() + ":</label><input type='text' name='CText" + i + "' id='txtCText" + i + "' class='fieldItem' field='CText" + i + "' disabled='disabled'  /></li>";
            }
            customerDefine.InnerHtml = define;
        }
    }
}