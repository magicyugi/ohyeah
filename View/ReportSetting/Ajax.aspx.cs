using System;
using System.Collections.Generic; 
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox.View.ReportSetting
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
                Customer.Delete("id", id);
                renderData("success");
            }  
            else if (Request["type"] == "edit")
            {
                int id = int.Parse(Request["id"]);
                Customer cust = new Customer("ID", id);
                cust.Code = Request["Code"];
                cust.Cname = Request["Cname"];
                cust.GuideCode = Request["GuideCode"];
                cust.Save();
                renderData("success");
            }
            else if (Request["type"] == "add")
            {
                string guid = Guid.NewGuid().ToString(); 
                Customer cust = new Customer();
                cust.WareHouseCode=currentWareHouse ;
                cust.Code = guid;
                cust.VIPNumber = Request["VIPNumber"];
                cust.Cname = Request["Cname"];
                cust.GuideCode = Request["GuideCode"];
                cust.Guide = Request["Guide"];
                cust.Mobile = Request["Mobile"];
                cust.Tel = Request["Tel"];
                cust.Address = Request["Address"];
                cust.Sex = Request["Sex"];
                cust.IntroduceName = Request["IntroduceName"];
                cust.IntroduceCode = Request["IntroduceCode"];
                cust.IntroduceMobile = Request["IntroduceMobile"];
                cust.ClientSourceCode = Request["ClientSourceCode"];
                cust.ClientSource = Request["ClientSource"]; 
                SqlQuery q = new Select().From<CustomerDetail>().Where("CTextCount").IsNotNull();
                DataTable dt = q.ExecuteDataSet().Tables[0];
                string sql = "insert into CustomerDetail ";
                string keys = "(";
                string values = "(";
                for (int i = 1; i < int.Parse(dt.Rows[0]["CTextCount"].ToString()) + 1; i++)
                {
                    keys += "CText" + i + ",";
                    values += "'" + Request["CText" + i] + "',";
                }
                keys += " Customer_Code,CustomerName)";
                values += "'" + guid + "','"+Request["Cname"]+"')";
                sql += keys + " values " + values;
                QueryCommand cmd = new QueryCommand(sql);
                if (DataService.ExecuteQuery(cmd) > 0)
                {
                    Alert al = new Alert();
                    al.WareHouseCode = currentWareHouse;
                    al.Code = guid;
                    al.CustomerName = cust.Cname;
                    al.Mobile = cust.Mobile;
                    al.Tel = cust.Tel;
                    al.StartDate =DateTime.Parse( Request["AlertDate"] );
                    al.AlertContent = Request["AlertContent"]; 
                    al.Hour = int.Parse(Request["HM"].Split(':')[0]);
                    al.Minute = int.Parse(Request["HM"].Split(':')[1]);
                    al.Save();
                    cust.Save();
                    renderData("success");
                }
                else
                    renderData("fail");
            }
            else if (Request["type"] == "dropdown")
            {
                string[] tableCollection = { "Guide","SysCode" };
                string[] whereCollection = { "", " where Category='ClientSource' " };
                renderData(getDrop(tableCollection, whereCollection));
            }
        }

        public DataTable getList(out int totalcount) {
            int row = int.Parse(Request["rows"]);
            int page = int.Parse(Request["page"].ToString());
            string[] selectItem = { "Customer.Id" , "Customer.Code", "Customer.Cname", "Customer.Guide_Code as GuideCode", "Guide.Cname as GuideName" };
            SqlQuery q = new Select(selectItem).From(Customer.Schema).LeftOuterJoin(Guide.CodeColumn, Customer.GuideCodeColumn);
            totalcount = q.GetRecordCount();
            return q.Paged(page, row).ExecuteDataSet().Tables[0];
        }

        public void gridbind() { 
            int totalcount = 0;
            DataTable newList = getList(out totalcount);
            renderData("{\"rows\":" + JSON.Encode(newList) + ",\"total\":" + totalcount + "}");
        }
    }
}