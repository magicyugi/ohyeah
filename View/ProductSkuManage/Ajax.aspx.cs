using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using DB;
using System.Data;

namespace UI.Module.ProductSkuManage
{
    public partial class Ajax : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["key"] != null && Request["key"].ToString() != "")
            {
                if (Request["key"].ToString() == "LoadGrid")
                {
                    SetAjaxGrid();
                }
                else if (Request["key"].ToString() == "LoadDGrid")
                {

                    SetAjaxDGrid(Request["id"].ToString());
                }
                else if (Request["key"].ToString() == "LoadKGrid")
                {
                    SetAjaxKGrid();
                }
                else if (Request["key"].ToString() == "LoadSGrid")
                {
                    SetAjaxSGrid();
                }
                else if (Request["key"].ToString() == "insert"
                    && Request["pid"] != null && Request["pid"].ToString()!=""
                    && Request["kid"] != null && Request["kid"].ToString()!=""
                    && Request["sid"] != null && Request["sid"].ToString()!="")
                {
                    string sql = "Insert into ProductSku (Code,Product_Code,ProductKey_Code,StatusFlag) values (";
                    sql += "'" + Request["sid"].ToString() + "',";
                    sql += "'" + Request["pid"].ToString() + "',";
                    sql += "'" + Request["kid"].ToString() + "',1);";
                    sql += " EXEC UpdateProductSku '" + Request["pid"].ToString() + "','" + Request["kid"].ToString() + "','" + Request["sid"].ToString() + "'";
                    if (SqlDal.RunSql(sql) > 0)
                        Response.Write("success");
                    else
                        Response.Write("faild");
                }

                else if (Request["key"].ToString() == "del"
                   && Request["pid"] != null && Request["pid"].ToString() != ""      //商品编号
                   && Request["kid"] != null && Request["kid"].ToString() != ""     //商品KEY2值
                   && Request["sid"] != null && Request["sid"].ToString() != "")    //商品KEY3值
                {

                    //ProductSkuController tt = new ProductSkuController();
                    SqlDal.RunSql("Delete ProductSku where Code='" + Request["sid"].ToString() + "' and Product_Code='" + Request["pid"].ToString()
                        + "' and ProductKey_Code='" + Request["kid"].ToString() + "'");
                    //tt.Delete( Request["sid"].ToString(),Request["pid"].ToString(), Request["kid"].ToString());
                    SetAjaxDGrid(Request["pid"].ToString());
                }
            }

        }

        void SetAjaxGrid()
        {
            int pagenumber = int.Parse(Request["page"].ToString());
            int pagesize = int.Parse(Request["rows"].ToString());
            SqlQuery q = new Select().From("Product").Where("StatusFlag").IsEqualTo("1").OrderDesc("Code");
            int count = q.GetRecordCount();
            DataTable dt = q.ExecuteDataSet().Tables[0];
            Response.Write("{\"rows\":" + JSON.Encode(dt) + ",\"total\":" + count.ToString() + "}");
        }

        void SetAjaxDGrid(string productCode)
        {
            if (productCode != "")
            {
                DataTable tblist = new Select().From<ProductKey>().Where(ProductKey.ProductCodeColumn).IsEqualTo(Request["id"].ToString()).ExecuteDataSet().Tables[0];
                Response.Write("{\"rows\":" + JSON.Encode(tblist) + "}");
            }
        }
        void SetAjaxKGrid()
        {
            if (Request["pid"] != null && Request["pid"].ToString() != "" && Request["kid"] != null && Request["kid"].ToString() != "")
            {
                DataTable tblist = new Select().From<ProductSku>().Where(ProductSku.ProductCodeColumn).IsEqualTo(Request["pid"].ToString())
                    .And(ProductSku.ProductKeyCodeColumn).IsEqualTo(Request["kid"].ToString()).ExecuteDataSet().Tables[0];
                Response.Write("{\"rows\":" + JSON.Encode(tblist) + "}");
            }
        }

        void SetAjaxSGrid()
        {
            if (Request["pid"] != null && Request["pid"].ToString() != "" && Request["kid"] != null && Request["kid"].ToString() != "")
            {
                List<SysCode> list = new Select().From<SysCode>().Where(SysCode.CodeColumn)
                    .NotIn(new Select(ProductSku.CodeColumn).From<ProductSku>().Where(ProductSku.ProductCodeColumn).IsEqualTo(Request["pid"].ToString())
                    .And(ProductSku.ProductKeyCodeColumn).IsEqualTo(Request["kid"].ToString()))
                   .And(SysCode.CategoryColumn).IsEqualTo("Key3").ExecuteTypedList<SysCode>();
                Response.Write("{\"rows\":" + JSON.Encode(list) + "}");
            }
        }
    }
}