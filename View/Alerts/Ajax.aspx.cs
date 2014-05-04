using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Linq;
using System.Data;

namespace AppBox.View.Alerts
{
    public partial class Ajax : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["type"] == "list")
            { 
                gridbind();
            }  
            else if (Request["type"] == "del")
            {
                int id = int.Parse(Request["id"]);
                Invest.Delete("id", id);
                renderData("success");
            }  
            else  if (Request["type"] == "visit")
            {
                string result =  "";
                string process = "";
                string month = "";
                string statusflag = string.IsNullOrEmpty(Request["statusflag"] == "null" ? "" : Request["statusflag"]) ? "1" : Request["statusflag"];
                if (statusflag == "null") statusflag = "1";
                DataTable vlog = new Select().From<VisitLog>().Where("Code").IsEqualTo(Request["customer"]).And("StatusFlag").IsEqualTo(statusflag).OrderDesc("VisitDate").ExecuteDataSet().Tables[0];
                for (int i = 0; i < vlog.Rows.Count; i++)
                {
                    DataRow dr=  vlog.Rows[i];
                    DateTime date=  DateTime.Parse(dr["VisitDate"].ToString());
                    process = dr["VisitProcess"].ToString();
                    if (month=="")
                    {
                        month= date.Year + "."+date.Month;
                        result += @"<div class='history-date'><ul>	<h2> <a>" + month + @"           </a></h2>";
                    }
                    else if (month != date.Year + "." + date.Month)
                    {
                        month = date.Year + "." + date.Month;
                        result += @"</ul> </div><div class='history-date'><ul><h2>
                        <a >" + month + @"</a></h2>";
                    } 
                    result += @"<li class='green bounceInDown'  >
                        <h3>" + date.Month+"."+date.Day + "<span>" + date.Hour + ":" + date.Minute + @"</span></h3>
                        <dl>
                        <dt  >"
                        + "<span style='font-size:14px;cursor:pointer; '  class='alertTitle'>" + dr["VisitTitle"].ToString() + "   ▼"
                       //<dt>【" + dr["CustomerName"].ToString() + "】" + dr["VisitTitle"].ToString()
                        //+ "<div class='metrouicss'><button class='bg-color-white fg-color-red'><i class='icon-clock' style='font-size:24px'></i>设置提醒</button><button class='bg-color-white fg-color-blue'><i class='icon-phone' style='font-size:24px'></i>回访登记</button></div>
                        +"</span>"
                        +"<div style='word-warp:break-word;word-break:break-all;font-size:12px; width:200px;display:none;' >"+ dr["VisitContent"].ToString()
                        + "</div></dt>  </dl> </li> ";
                    if (i == vlog.Rows.Count - 1) result += "</ul> </div>";
                }
              
                //result1 += result1 + result1; 
                renderData(result);
            }
            else if (Request["type"] == "message")
            { 
                string mess = "";
                SqlQuery q = new Select().From<Alert>().Where("WareHouse_Code").In(currentGroups).And("Creater").IsEqualTo(currentUser);
                q = q.And("AlertTime").IsLessThan(DateTime.Now.AddMinutes(15)).And("AlertTime").IsGreaterThan(DateTime.Now.AddMinutes(-15));
                List<Alert> newList= q.Paged(1, 10).ExecuteTypedList<Alert>();
                string txturl = Request.Url.AbsolutePath.Split('/')[0];
                foreach (Alert item in newList) { 
                    mess += "<a href='" + txturl + "/View/Visit/NewVisit.aspx?Code=" + item.Code + "'>客户：" + item.CustomerName + "联系计划：" + item.Cname + item.AlertContent + "</a>|";
 
                }
                if (mess != "") mess = mess.Substring(0, mess.Length - 1);
                renderData(mess);
            }  
        }


        public List<Alert> getList(out int totalcount)
        {
            string daytype = Request["daytype"];
            int row = int.Parse(Request["rows"]);
            int page = int.Parse(Request["page"].ToString());
            SqlQuery q = new Select().From<Alert>().Where("WareHouse_Code").In(currentGroups).And("Creater").IsEqualTo(currentUser).OrderAsc("alertTime"); 
            if (daytype == "today")
                q = q.And("StartDate").IsEqualTo(DateTime.Today.ToShortDateString());
            else if (daytype == "week")
                q = q.And("StartDate").IsGreaterThanOrEqualTo(DateTime.Today.ToShortDateString()).And("StartDate").IsLessThanOrEqualTo(DateTime.Today.AddDays(7));
            else
                q = q.And("StartDate").IsLessThan(DateTime.Today.ToShortDateString());
            string processFlag = "1";
            if (Request["ProcessFlag"] != "") processFlag = Request["ProcessFlag"];
            SqlQuery cq = new Select(Customer.CodeColumn).From<Customer>().Where(Customer.ProcessFlagColumn).IsEqualTo(processFlag);
            q = q.And("Code").In(cq);
            totalcount = q.GetRecordCount();
            List<Alert> alertList = q.Paged(page, row).ExecuteTypedList<Alert>(); 
            return alertList;
        }

        public void gridbind() { 
            int totalcount = 0;
            List<Alert> newList = getList(out totalcount);
            renderData("{\"rows\":" + JSON.Encode(newList) + ",\"total\":" + totalcount + "}");
        }

    }
}