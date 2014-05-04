using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls; 
using SubSonic; 
using System.Data; 


namespace AppBox.SaleBillManage
{
    public partial class Ajax : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["key"] != null && Request["key"].ToString() != "")
            {
                 if (Request["key"].ToString() == "LoadGrid")
                {
                    SetAjaxGrid();
                } 
                else if (Request["key"].ToString() == "Guide")
                {
                    DataTable dt = new Select("Code","Cname").From(Guide.Schema).Where(Guide.Columns.WareHouseCode).IsEqualTo(user.UserWCode).And(Guide.StatusFlagColumn).IsEqualTo(1).ExecuteDataSet().Tables[0];
                    Response.Write(JSON.Encode(dt));
                }
                else if (Request["key"].ToString() == "Check")
                {

                    StoredProcedure spd = new StoredProcedure("TradeToSaleBill");
                    spd.Command.AddParameter("@Tid", Request["id"].ToString());
                    spd.Command.AddParameter("@WarehouseCode", Common.currentWareHouse);
                    spd.Command.AddParameter("@GuideCode", Request["ddpGuid"].ToString());
                    spd.Command.AddParameter("@UserCode", Common.currentUserCode);
                    spd.Command.AddParameter("@Cheat", Request["cheat"].ToString() == "true" ? 1 : 0);
                    DataTable resultTbl = spd.GetDataSet().Tables[0];
                    string sku = "";
                    for (int i = 0; i < resultTbl.Rows.Count; i++)
                    {
                        if (resultTbl.Rows[i][0].ToString() == "TRADE_TO_SALEBILL_SUCCESS")
                        {
                            sku = "SUCCESS"; break;
                        }
                        else
                            sku += resultTbl.Rows[i][0].ToString() + ",";
                    }
                    sku = sku.TrimEnd(',');
                    Response.Write(sku);

                }
            }
        }

        void  SetAjaxGrid()
        {
            int pagenumber = int.Parse(Request["page"].ToString());
            int pagesize = int.Parse(Request["rows"].ToString());
            SqlQuery q = new Select().From<TbTrade>();
            int count = q.GetRecordCount();
            List<TbTrade> tblist = q.Paged(pagenumber, pagesize).ExecuteTypedList<TbTrade>();
            Response.Write("{\"rows\":" + JSON.Encode(tblist) + ",\"total\":" + count.ToString() + "}");   
        }
    }
}