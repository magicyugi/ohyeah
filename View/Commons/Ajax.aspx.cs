using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox.View.Commons
{
    public partial class Ajax : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["type"] == "excel")
            {
                if (Request["rpt"] == "Customer")
                {
                    DataTable dt = new Select().From<Customer>().ExecuteDataSet().Tables[0];
                    string[] selectItem = { "Customer.ID", "Customer.Code", "Customer.Cname", "Customer.Guide_Code as GuideCode", "SysUser.Cname as GuideName", "Customer.Company", "Customer.VisitTime", "(select cname from syscode where code=Customer.CreditLevel and category='CustomerLevel' and WareHouse_Code='"+currentMaster+"' and statusflag=1) as CreditLevel"
                                    ," CONVERT(varchar(100), Customer.RegDate, 20) as RegDate","CONVERT(varchar(100), Customer.DealDate, 20) as DealDate","CONVERT(varchar(100), Customer.VisitDate, 20) as VisitDate","CONVERT(varchar(100), Customer.AlertDate1, 20) as AlertDate1","Customer.CustomerMoney"
                                    ,"Customer.Address","Customer.Sex","Customer.Mobile","Customer.Tel","Customer.IntroduceName","Customer.IntroduceMobile","Customer.Description"
                                    ,"IntentionFlag","(case when IntentionFlag=0 then '意向' when IntentionFlag=1 then '成交' else '放弃' end) as IntentionFlagName","Customer.ClientSource_Code as ClientSourceCode","Customer.ClientSource","(select sum(Price) FROM Contract where [Customer_Code]=[dbo].[Customer].[Code]) as Price"};
                    SqlQuery q = new Select(selectItem).From(Customer.Schema).LeftOuterJoin(SysUser.CodeColumn, Customer.GuideCodeColumn).Where("1").IsEqualTo("1");
                    renderExcel(dt, "Cname,Mobile", "客户名,电话");
                }
            }
        }
    }
}