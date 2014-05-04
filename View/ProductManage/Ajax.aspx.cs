using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;  
using SubSonic; 
using System.Data;

namespace AppBox.ProductManage
{
    public partial class Ajax : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        { 
            if (Request["key"] != null && Request["key"].ToString() != "")
            {
                if (Request["key"].ToString() == "download")
                { 
                }
                else if (Request["key"].ToString() == "LoadGrid")
                {
                    SetAjaxGrid();
                }
                else if (Request["key"].ToString() == "del")
                {
                    string id = Request["id"].ToString();
                    ProductController tt = new ProductController();
                    tt.Delete(id);
                    SetAjaxGrid();
                }
                else if (Request["key"].ToString() == "insert")
                {
                    int count = new Select().From(Product.Schema).Where(Product.VCodeColumn).IsEqualTo(Request["txtVCode"].ToString()).GetRecordCount();
                    if (count > 0)
                    {
                        Response.Write("该产品编号已经存在！");
                    }
                    else
                    {
                        string code = SqlDal.GetSelectCode("Product", "Key1", "",Common.currentMaster );
                        Insert q = new Insert().Into(Product.Schema, "Key1", "VCode", "Cname", "Price", "WareHouse_Code",
                            "CType_Code", "Brand_Code", "MainStuff", "SalePoint", "WeakPoint", "StatusFlag")
                            .Values(
                            code,
                            Request["txtVCode"].ToString() != "" ? Request["txtVCode"].ToString() : code,
                            Request["txtCname"].ToString(),
                            Request["txtPrice"].ToString() != "" ? decimal.Parse(Request["txtPrice"].ToString()) : 0,
                            Common.currentMaster,
                            Request["txtCTypeCode"].ToString(),
                            Request["txtBrandCode"].ToString(),
                            Request["txtMainStuff"].ToString(),
                            Request["txtSalePoint"].ToString(),
                            Request["txtWeakPoint"].ToString(),
                            1
                            );
                        if (q.Execute() > 0)
                            Response.Write("success");
                        else
                            Response.Write("faild");
                    }
                }
                else if (Request["key"].ToString() == "update")
                {
                    Product product = new Product("Code", Request["txtCode"].ToString());
                    product.VCode = Request["txtVCode"].ToString();
                    product.Cname = Request["txtCname"].ToString();
                    product.Price = decimal.Parse(Request["txtPrice"].ToString());
                    product.CTypeCode = Request["txtCTypeCode"].ToString();
                    product.BrandCode = Request["txtBrandCode"].ToString();
                    product.MainStuff = Request["txtMainStuff"].ToString();
                    product.SalePoint = Request["txtSalePoint"].ToString();
                    product.WeakPoint = Request["txtWeakPoint"].ToString();
                   // product.UnitCode = Request["txtUnitCode"].ToString();
                    product.Save();
                    Response.Write("success");
                }
                else if (Request["key"].ToString() == "TreeLoad")
                {
                    TreeLoad(true);
                }
                else if (Request["key"].ToString() == "EditTreeLoad")
                {
                    TreeLoad(false);
                }
                else if (Request["key"].ToString() == "Search")
                {
                    SetAjaxGrid();
                 }
                else if (Request["key"].ToString() == "Brand")
                {
                    DataTable dt = new Select().From(SysCode.Schema).Where("Category").IsEqualTo("Brand").And(SysCode.StatusFlagColumn)
                        .IsEqualTo(1).And(SysCode.WareHouseCodeColumn).IsEqualTo(Common.currentMaster).ExecuteDataSet().Tables[0];
                    Response.Write(JSON.Encode(dt));

                }
             
            }
           
        }


        string GetProductType(List<ProductType> typelist, ProductType type,int level)
        {
            string tree = "{";
            tree += "\"id\":\"" + type.Code + "\",";
            tree += "\"text\":\"" + type.Cname + "\",";
            tree += "\"state\":\"open\",";
            List<ProductType> list = new List<ProductType>();
            list = typelist.Where(c => c.Pcode == type.Code).ToList();
            if (list.Count > 0)
            {
                tree += "\"children\":[";
                for (int i = 0; i < list.Count; i++)
                {
                    tree += GetProductType(typelist, list[i],level+1);
                    tree += ",";
                }
                tree = tree.TrimEnd(',');
                tree += "]";
            }
            else
            {
                tree = tree.TrimEnd(',');
            }
            return tree + "}";
        }

        void SetAjaxGrid()
        {

            int pagenumber = int.Parse(Request["page"].ToString());
            int pagesize = int.Parse(Request["rows"].ToString());
            string where="";
            if (Request["type"] != null && Request["type"].ToString() != ""&&Request["type"].ToString()!="0")
            {
                where += " p.[CType_Code] IN (select code from productType where code='" + Request["type"].ToString() + "' or pcode='" + Request["type"].ToString() + "')";
            }

            StoredProcedure spd = new StoredProcedure("GetProduct");
            spd.Command.AddParameter("@beginrow", ((pagenumber - 1) * pagesize + 1).ToString());
            spd.Command.AddParameter("@endrow", (pagenumber * pagesize).ToString());
            spd.Command.AddParameter("@WareHouse_Code", Common.currentMaster);
            spd.Command.AddParameter("@where", where);
            int count = int.Parse(spd.GetDataSet().Tables[0].Rows[0][0].ToString());
            DataTable resultTbl = spd.GetDataSet().Tables[1];
            Response.Write("{\"rows\":" + JSON.Encode(resultTbl) + ",\"total\":" + count.ToString() + "}");

        }

        public void TreeLoad(bool topflag)
        {
            List<ProductType> typelist = new Select().From(ProductType.Schema).Where(ProductType.StatusFlagColumn).IsEqualTo(1).ExecuteTypedList<ProductType>();
            string tree = "[";
            if (topflag)
            {
                tree += "{";
                tree += "\"id\":\"0\",";
                tree += "\"text\":\"所有\",";
                tree += "\"iconCls\":\"icon-house\",";
                tree += "\"state\":\"open\"";
                tree += "},";
            }
            List<ProductType> list = typelist.Where(c => c.LevelValue == 1).ToList();
            for (int i = 0; i < list.Count; i++)
            {
                tree += GetProductType(typelist, list[i], 1);
                tree += ",";
            }
            tree = tree.TrimEnd(',');
            tree += "]";
            Response.Write(tree);
        }

    }
}