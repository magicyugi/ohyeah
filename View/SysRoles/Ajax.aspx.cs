using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox.View.SysRoles
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
                SysRole sys = new SysRole("id", id); 
                DBUtil.Execute("delete from sysrolemenu where role_code='" + Request["RoleCode"] + "' and org_code='" + Common.currentMaster + "'"); 
                SysRole.Delete("id", id); 
                renderData("success"); 
            } 
            else if (Request["type"] == "dropdown")
            {
                string[] tableCollection={"Warehouse","SysCode","SysCode"};
                string[] whereCollection = { " where Pcode='" + Common.currentMaster + "' ", " where category='Degree' and Warehouse_Code='" + Common.currentWareHouse + "'' and statusflag=1", " where category='Post' and Warehouse_Code='" + Common.currentWareHouse + "'' and statusflag=1" };
                getDrop(tableCollection, whereCollection);
            }
            else if (Request["type"] == "search")
            {
                gridbind(Request["value"]);
            }
        }

        private void getDrop(string[] tableCollection, string[] whereCollection)
        {
            string sql = "";
            int i=0;
            List<Select> sList = new List<Select>();
            foreach (var table in tableCollection)
            { 
                sql += "select * from " + table +whereCollection[i] +"\r\n";
                i++;  
            } 
            QueryCommand cmd = new QueryCommand(sql);
            cmd.Parameters.Add("@Cname","测试1");
            DataSet ds = DataService.GetDataSet(cmd);
            string liststr = "";
            foreach (DataTable tb in ds.Tables)
            {
                List<DropDown> dd = new List<DropDown>();
                foreach (DataRow dr in tb.Rows)
                {
                    DropDown dditem = new DropDown();
                    dditem.DropType = ds.Tables.IndexOf(tb).ToString();
                    dditem.Code = dr["Code"].ToString();
                    dditem.Cname = dr["Cname"].ToString(); 
                    dd.Add(dditem);
                }
                liststr += "{\"item" + ds.Tables.IndexOf(tb).ToString() + "\":" + JSON.Encode(dd) + "},";
            }
            renderData("[" + liststr.Substring(0, liststr.Length - 1) + "]");  
        }
        public DataTable getList(out int totalcount, string txtSearch)
        {
            int row = int.Parse(Request["rows"]);
            int page = int.Parse(Request["page"].ToString());
            SqlQuery q = new Select().From(SysRole.Schema).And(SysRole.OrgCodeColumn).IsEqualTo(Common.currentMaster);
            totalcount = q.GetRecordCount();
            return q.Paged(page, row).ExecuteDataSet().Tables[0];
        }

        public void gridbind(string txtSearch)
        { 
            int totalcount = 0;
            DataTable newList = getList(out totalcount, txtSearch);
            renderData("{\"rows\":" + JSON.Encode(newList) + ",\"total\":" + totalcount + "}");
        }
    }
}