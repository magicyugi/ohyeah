using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic; 
using System.Data;

namespace AppBox.ProductTypeManage
{
    public partial class Ajax : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["key"] != null && Request["key"].ToString() != "")
            {
                if (Request["key"].ToString() == "LoadGrid")
                {
                //    DataTable dt = new Select().From(ProductType.Schema).Where(ProductType.StatusFlagColumn).IsEqualTo(1).OrderAsc("Code").ExecuteDataSet().Tables[0];
                //    Response.Write(Utils.GetTreeJsonByTB(dt, "Code", "Cname", "PCode", "VCode,PCode,LevelValue,Remark1", "父类"));
                    SetAjaxGrid();
                }
                if (Request["key"].ToString() == "update")
                {
                    ProductType producttype = new ProductType("Code",Request["txtCode"].ToString());
                    producttype.Cname = Request["txtCname"].ToString();
                    producttype.Remark1 = Request["txtRemark1"].ToString();
                    producttype.Save();
                    Response.Write("success");
                }
                if (Request["key"].ToString() == "insert")
                {
                    SqlQuery sqlquery = new Select().From(ProductType.Schema).Where(ProductType.WareHouseCodeColumn).IsEqualTo(Common.currentWareHouse)
                         .And(ProductType.StatusFlagColumn).IsEqualTo(1).And(ProductType.VCodeColumn).IsEqualTo(Request["txtNewVCode"].ToString());
                    int count = sqlquery.GetRecordCount();
                    if (count > 0) { Response.Write("编号重复，请重新选择！"); return; }
                    string code = SqlDal.GetSelectCode("ProductType", "Code","", Common.currentWareHouse);
                    Insert q = new Insert().Into(ProductType.Schema, "Code", "VCode", "Cname", "WareHouse_Code", "Pcode", "CodeList", "LevelValue", "Remark1", "StatusFlag")
                        .Values(
                        code,
                        Request["txtNewVCode"].ToString(),
                        Request["txtNewCname"].ToString(),
                        Common.currentWareHouse,
                        (Request["txtCode"].ToString()=="0"?"":Request["txtCode"].ToString()),
                        (Request["txtCodeList"].ToString() == "" ? code : Request["txtCodeList"].ToString() + "-" + code),
                        (Request["txtLevelValue"].ToString() == "" ? 1 : int.Parse(Request["txtLevelValue"].ToString()) + 1),
                        Request["txtRemark1"].ToString(),
                        1
                        );
                    if (q.Execute() > 0)
                        Response.Write("success");
                    else
                        Response.Write("faild");
                }
                if (Request["key"].ToString() == "del")
                {
                    string sql = "delete ProductType where CodeList like '" + Request["id"].ToString() + "%'";
                    SqlDal.RunSql(sql);
                    SetAjaxGrid();

                }
            }

        }

        void SetAjaxGrid()
        {
            DataTable dt = new Select().From(ProductType.Schema).Where(ProductType.StatusFlagColumn).IsEqualTo(1).OrderAsc("Code").ExecuteDataSet().Tables[0];
            Response.Write(Utils.GetTreeJsonByTB(dt, "Code", "Cname", "PCode", "VCode,LevelValue,CodeList,Remark1", "父类"));
        }
    }
}