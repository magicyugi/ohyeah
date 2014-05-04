using System;
using System.Collections.Generic; 
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;
using System.Text;

namespace AppBox.View.Customers
{
    public partial class CustomerPrint :System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string define = "",txtrequest=Request["code"];
            SqlQuery q = new Select().From<CustomerDetail>().Where("CTextCount").IsNotNull().And(CustomerDetail.WareHouseCodeColumn).IsEqualTo(Common.currentMaster);
            SqlQuery cq = new Select().From<CustomerDetail>().Where(CustomerDetail.CustomerCodeColumn).IsEqualTo(txtrequest);
            SqlQuery Customerq = new Select().From<Customer>().Where(Customer.CodeColumn).IsEqualTo(txtrequest);
            DataTable dt = q.ExecuteDataSet().Tables[0];
            DataTable cqdt = cq.ExecuteDataSet().Tables[0];
            DataRow[] Customerdt = Customerq.ExecuteDataSet().Tables[0].Select("1=1");
            string txtintentionflag = Customerdt[0]["IntentionFlag"].ToString();
            if (txtintentionflag == "0") txtintentionflag = "意向";
            else if (txtintentionflag == "1") txtintentionflag = "成交";
            else if (txtintentionflag == "2") txtintentionflag = "放弃";
            txtname.InnerText = Customerdt[0]["Cname"].ToString();
            txtphone.InnerText = Customerdt[0]["Mobile"].ToString();
            txtaddress.InnerText = Customerdt[0]["Address"].ToString();
            txtlevel.InnerText = Customerdt[0]["CreditLevel"].ToString();
            txtflag.InnerText = txtintentionflag;
            txtguide.InnerText = Customerdt[0]["Guide"].ToString();
            txtcreater.InnerText = Customerdt[0]["CreateTime"].ToString();
            if (dt.Rows.Count != 0)
                for (int i = 1; i < int.Parse(dt.Rows[0]["CTextCount"].ToString()) + 1; i++)
                {
                    define += "<li  class='basicli'> <label for='txtCText" + i + "'  >" + dt.Rows[0]["CText" + i].ToString() + ":</label>" + cqdt.Rows[0]["CText" + i].ToString() + "</li>";
                }
            customerDefine.InnerHtml = define; 
        }
 
    }
}