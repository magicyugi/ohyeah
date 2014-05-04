using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic; 
using System.Data;

namespace AppBox.View.WareHouseManage
{
    public partial class Ajax : Common
    {
        int sflag = 4;//warehouse -StoreFlag设置
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["key"] != null && Request["key"].ToString() != "")
            {
                if (Request["key"].ToString() == "LoadGrid")
                {
                    gridBind();
                }
                if (Request["key"] == "Role")
                {
                    renderData(Common.btnRole("", Request["RoleCode"]));
                }
                else if (Request["key"].ToString() == "del")
                {
                    string id = Request["id"].ToString();  
                    WareHouseController tt = new WareHouseController(); 
                    tt.Delete(id);
                    gridBind();
                }
                else if (Request["key"].ToString() == "insert")
                { 
                        SqlQuery Rq = new Select().From(WareHouse.Schema).Where(WareHouse.CnameColumn).IsEqualTo(Request["txtCname"]);
                        DataTable dt = Rq.ExecuteDataSet().Tables[0];
                        if (dt.Rows.Count != 0) { renderData("fail:名称已有重复项!"); }
                        else
                        {
                            LoginUser user = new LoginUser();
                            string code = currentMaster+SqlDal.GetSelectCode("Warehouse", "", Common.currentMaster);
                            int q = new Insert().Into(WareHouse.Schema,
                           "Code", "VCode", "Cname", "CodeList", "LevelValue", "PCode", "Tel", "Fax",
                           "Address", "Province_Code", "City_Code",
                           "Area_Code", "Credit", "Discount1", "Account", "Overdraft", "PayType",
                           "StoreFlag", "StatusFlag", "UserNum").
                           Values(
                            code,
                            code,
                            Request["txtCname"].ToString(),
                            currentWareHouse + "-" + code,
                            currentLevel + 1,
                            currentMaster,
                            Request["txtTel"].ToString(),
                            Request["txtFax"].ToString(),
                            Request["txtAddress"].ToString(),
                            Request["txtProvince_Code"].ToString(),
                            Request["txtCity_Code"].ToString(),
                            Request["txtArea_Code"].ToString(),
                            (Request["txtCredit"].ToString() != "" ? decimal.Parse(Request["txtCredit"].ToString()) : 0),
                            (Request["txtDiscount1"].ToString() != "" ? decimal.Parse(Request["txtDiscount1"].ToString()) : 0),
                            (Request["txtAccount"].ToString() != "" ? decimal.Parse(Request["txtAccount"].ToString()) : 0),
                            (Request["txtOverdraft"].ToString() != "" ? decimal.Parse(Request["txtOverdraft"].ToString()) : 0),
                            (Request["txtPayType"].ToString() != "" ? int.Parse(Request["txtPayType"].ToString()) : 0),
                            sflag.ToString(),
                           int.Parse(Request["txtStatusFlag"].ToString()), 0
                           ).Execute();
                            renderData("保存成功!");
                        }
                }
                else if (Request["key"].ToString() == "update")
                {
                    try
                    {
                        SqlQuery Rq = new Select().From(WareHouse.Schema).Where(WareHouse.CnameColumn).IsEqualTo(Request["txtCname"]).And(WareHouse.CodeColumn).IsNotEqualTo(Request["txtCode"].ToString());
                        DataTable dt = Rq.ExecuteDataSet().Tables[0];
                        if (dt.Rows.Count != 0) { renderData("fail:名称已有重复项!"); }
                        else
                        {
                            WareHouse model = new WareHouse("Code", Request["txtCode"].ToString());
                            model.VCode = Request["txtCode"].ToString();
                            model.Cname = Request["txtCname"].ToString();
                            model.Tel = Request["txtTel"].ToString();
                            model.Fax = Request["txtFax"].ToString();
                            model.Address = Request["txtAddress"].ToString();
                            model.ProvinceCode = Request["txtProvince_Code"].ToString();
                            model.CityCode = Request["txtCity_Code"].ToString();
                            model.AreaCode = Request["txtArea_Code"].ToString();
                            model.Credit = Request["txtCredit"].ToString() != "" ? decimal.Parse(Request["txtCredit"].ToString()) : 0;
                            model.Discount1 = Request["txtDiscount1"].ToString() != "" ? decimal.Parse(Request["txtDiscount1"].ToString()) : 0;
                            model.Account = Request["txtAccount"].ToString() != "" ? decimal.Parse(Request["txtAccount"].ToString()) : 0;
                            model.Overdraft = Request["txtOverdraft"].ToString() != "" ? decimal.Parse(Request["txtOverdraft"].ToString()) : 0;
                            model.PayType = Request["txtPayType"].ToString() != "" ? int.Parse(Request["txtPayType"].ToString()) : 0;
                            model.StoreFlag = sflag;
                            model.StatusFlag = Request["txtStatusFlag"].ToString() != "" ? int.Parse(Request["txtStatusFlag"].ToString()) : 0;
                            model.Save();
                            Response.Write("保存成功!");
                        }
                    }
                    catch (Exception exc)
                    {
                        Response.Write(exc.Message);
                    }
                }
                else if (Request["key"].ToString() == "City" && Request["Pcode"] != null)
                {
                    string[] css = { "Code", "CityName", "Pcode" };
                    DataTable clist = new Select(css).From(City.Schema).Where(City.PCodeColumn).IsEqualTo(Request["Pcode"].ToString()).ExecuteDataSet().Tables[0];
                    Response.Write(JSON.Encode(clist));

                }
                else if (Request["key"].ToString() == "Area" && Request["Pcode"] != null)
                {
                    string[] ass = { "Code", "AreaName", "Pcode" };
                    DataTable alist = new Select(ass).From(Area.Schema).Where(Area.PcodeColumn).IsEqualTo(Request["Pcode"].ToString()).ExecuteDataSet().Tables[0];
                    Response.Write(JSON.Encode(alist));
                }
                // else if (Request["key"] != null && Request["key"].ToString() == "search")
                //{

                //}
            }

        }

        void gridBind()
        {
            int pagenumber = int.Parse(Request["page"].ToString());
            int pagesize = int.Parse(Request["rows"].ToString());
            string[] ss = { "WareHouse.ID","WareHouse.Code","WareHouse.VCode","WareHouse.Cname","WareHouse.Tel","WareHouse.Fax",
                              "WareHouse.Province_Code","WareHouse.City_Code","WareHouse.Area_Code","WareHouse.Credit","WareHouse.Address","WareHouse.Discount1",
                              "WareHouse.Account","WareHouse.Overdraft","(select cname from syscode where code=WareHouse.PayType and category='PayType' and statusflag=1) as PayType","(case when WareHouse.StoreFlag=1 then '总代' when WareHouse.StoreFlag=2 then '门店' when WareHouse.StoreFlag=3 then '仓库' else '经销商' end) as StoreFlag",
                              "(case when WareHouse.StatusFlag=1 then '启用' else '停用' end) as StatusFlag","Province.ProvinceName", "City.CityName", "Area.AreaName","UserNum" };
            SqlQuery q = new Select(ss).From("Warehouse")
                .LeftOuterJoin(Province.CodeColumn, WareHouse.ProvinceCodeColumn)
                .LeftOuterJoin(City.CodeColumn,WareHouse.CityCodeColumn).LeftOuterJoin(Area.CodeColumn,WareHouse.AreaCodeColumn).Where("PCode").IsEqualTo(currentMaster);
            //string wheresql = "";
            if (Request["ddpProvince"] != null && Request["ddpProvince"].ToString() != "")
            {
                q.And(WareHouse.Columns.ProvinceCode).IsEqualTo(Request["ddpProvince"].ToString());
                //if (wheresql != "")
                //    wheresql += " and ";
                //wheresql += " Province_Code='" + Request["ddpProvince"].ToString() + "'";
            }
            if (Request["ddpCity"] != null && Request["ddpCity"].ToString() != "")
            {
                q.And(WareHouse.Columns.CityCode).IsEqualTo(Request["ddpCity"].ToString());
                //if (wheresql != "")
                //    wheresql += " and ";
                //wheresql += " City_Code='" + Request["ddpProvince"].ToString() + "'";
            }
            if (Request["ddpArea"] != null && Request["ddpArea"].ToString() != "")
            {
                q.And(WareHouse.Columns.AreaCode).IsEqualTo(Request["ddpArea"].ToString());
                //if (wheresql != "")
                //    wheresql += " and ";
                //wheresql += " Area_Code='" + Request["ddpArea"].ToString() + "'";
            }
            if (Request["txtSearch"] != null && Request["txtSearch"].ToString() != "")
            {
                q.AndExpression(WareHouse.Columns.VCode).Like("%" + Request["txtSearch"].ToString() + "%")
                    .Or(WareHouse.Columns.Cname).Like("%" + Request["txtSearch"].ToString() + "%")
                    .Or(WareHouse.Columns.Linkman).Like("%" + Request["txtSearch"].ToString() + "%")
                    .Or(WareHouse.Columns.Tel).Like("%" + Request["txtSearch"].ToString() + "%");
                //if (wheresql != "")
                //    wheresql += " and ";
                //wheresql += " (VCode like '%" + Request["txtSearch"].ToString() + "%' or Cname like '%" + Request["txtSearch"].ToString()
                //    + "%' or Linkman like'" + Request["txtSearch"].ToString() + "' or Tel='" + Request["txtSearch"].ToString() + ")' ";
            }
            
         
            int count = q.GetRecordCount();
            DataTable dt = q.Paged(pagenumber, pagesize).ExecuteDataSet().Tables[0];
            Response.Write("{\"rows\":" + JSON.Encode(dt) + ",\"total\":" + count.ToString() + "}");
        }
    }
}   