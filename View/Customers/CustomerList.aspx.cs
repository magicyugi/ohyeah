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
    public partial class CustomerList : BasePage
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

        protected void btnExcel_Click(object sender, EventArgs e)
        {
            string headstr = hdntitle.Value;
            string colstr = hdnfiles.Value;
            string txtleft = "", txtwhere = "";
            if(hdncategory.Value!="")
            {
                txtleft = "LEFT JOIN (select top 1 * from CustomerLevel order BY ID desc) cl ON c.Code=cl.Customer_Code ";
                txtwhere = " and (cl.Category='" + hdncategory.Value.Split('-')[1] + "' and cl.Level_Code='" + hdncategory.Value.Split('-')[0] + "')";
            }
            if (hdntxtid.Value != "")
            {
                SqlQuery q = new Select().From<TxTSql>().Where("StatusFlag").IsEqualTo(1).And("ID").IsEqualTo(hdntxtid.Value);
                DataTable sqldt = q.ExecuteDataSet().Tables[0];
                txtwhere += sqldt.Rows[0]["sql"].ToString();
            }
            //查询条件  客户页面
            if (hdnid.Value != "")
            {
                SqlQuery q = new Select().From<TxTSql>().Where("StatusFlag").IsEqualTo(1);
                DataTable sqldt = q.ExecuteDataSet().Tables[0];
                string[] strCode = hdnid.Value.Split(';');
                string countrysql = "", citysql = "";
                for (int i = 0; i < strCode.Length - 1; i++)
                {
                    string[] strPcodeAndCode = strCode[i].Split(':');
                    if (strPcodeAndCode[0] == "10")
                    {
                        string[] countrytype = strPcodeAndCode[1].Split('_');
                        if (countrysql == "")
                        {
                            if (countrytype[0] != "City")
                                countrysql += " and c." + countrytype[0] + "='" + countrytype[1] + "'";
                            else
                                citysql += " and ( c." + countrytype[0] + "='" + countrytype[1] + "'";
                        }
                        else
                        {
                            if (countrytype[0] != "City")
                                countrysql += " and c." + countrytype[0] + "='" + countrytype[1] + "'";
                            else
                                citysql += " or c." + countrytype[0] + "='" + countrytype[1] + "'";
                        }

                    }
                    else
                    {
                        txtwhere += Common.ReplaceSQL(sqldt.Select("id=" + strPcodeAndCode[1])[0]["Sql"].ToString());
                    }

                }
                if (citysql != "") citysql += ")";
                txtwhere += countrysql + citysql;
            }
            string txtsql = @"select * from (select ROW_NUMBER() OVER ( ORDER BY c.ID) AS Row, c.ID, c.Code, c.Cname, c.Guide_Code as GuideCode, (CASE when isnull(Guide,'')='' THEN '' ELSE Guide end) as GuideName, c.Company, c.VisitTime, (select cname from syscode where code=c.CustomerLevel and category='CustomerLevel' and WareHouse_Code='" + Common.currentMaster + @"' and statusflag=1) as CreditLevel
                                    , CONVERT(varchar(100), c.RegDate, 20) as RegDate,CONVERT(varchar(100), c.DealDate, 20) as DealDate,CONVERT(varchar(100), c.VisitDate, 20) as VisitDate,CONVERT(varchar(100), c.AlertDate1, 20) as AlertDate1,c.CustomerMoney
                                    ,c.Address,Creater,c.Sex,c.Mobile,c.Tel,c.IntroduceName,c.IntroduceMobile,c.Description,c.CustomerLevel
                                    ,IntentionFlag,(case when IntentionFlag=0 then '意向' when IntentionFlag=1 then '成交' else '放弃' end) as IntentionFlagName,c.ClientSource_Code as ClientSourceCode,c.ClientSource,ct.Price
                              from Customer c left join SysUser su on c.Guide_Code=su.Code left join (select sum(Price) as price,Customer_Code FROM Contract group by customer_code) ct on c.code=ct.Customer_Code " + txtleft + " where (c.guide='" + Common.currentUser + "' or c.guide='' or c.guide IS NULL or su.UserLevelPoint<" + Common.currentLevel + @") " + txtwhere;
            if(hdndate.Value!="")
                txtsql += " and month(c." + hdndate.Value + ")=month(getdate()) ";
            txtsql += " and (c.Cname like '%" + txtSCname.Value + "%' or c.Mobile like '%" + txtSPhone.Value + "%')";// or c.Creater like '%" + txtSearch.Value + "%' or c.guide like '%" + txtSearch.Value + "%'
            if (Request["intentionflag"] != "" && Request["intentionflag"] != null)
            {
                txtsql += " and c.intentionflag=" + Request["intentionflag"];
            }
            txtsql += " and (c.guide_code='" + Common.currentUserCode + "' or c.WareHouse_Code in (" + Common.currentGroup + "))) a";
            Response.ClearContent();
            Response.AddHeader("content-disposition", "attachment; filename=MyExcelFile.xls");
            Response.ContentType = "application/excel";
            QueryCommand cmd = new QueryCommand(txtsql);
            DataTable dt = DataService.GetDataSet(cmd).Tables[0];
            Response.Write(Common.GetGridAllTableHtml(dt, headstr, colstr));
            Response.End(); 
        } 
    }
}