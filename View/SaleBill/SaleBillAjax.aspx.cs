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
    public partial class SaleBillAjax : Common
    {
        int sflag = 4;//warehouse -StoreFlag设置
        protected void Page_Load(object sender, EventArgs e)
        { 
            if (Request["key"] != null && Request["key"].ToString() != "")
            {
                if (Request["key"].ToString() == "LoadGrid")
                {
                    SetAjaxGrid();
                }
                else if (Request["key"].ToString() == "LoadEditGrid")
                {
                    SetAjaxDGrid();
                }
                else if (Request["key"].ToString() == "LoadDGrid")
                {
                    SetAjaxDGrid();
                }
                else if (Request["key"].ToString() == "LoadSGrid")
                {         
                    string[] ss = { "WareHouse.Code","WareHouse.VCode","WareHouse.Cname","WareHouse.Tel","WareHouse.Fax",
                              "WareHouse.Province_Code","WareHouse.City_Code","WareHouse.Area_Code","WareHouse.Discount1",
                              "WareHouse.Account","WareHouse.Overdraft","WareHouse.PayType","WareHouse.StoreFlag",
                              "WareHouse.StatusFlag","Province.ProvinceName", "City.CityName", "Area.AreaName" };
                    SqlQuery q = new Select(ss).From("Warehouse")
                        .LeftOuterJoin(Province.CodeColumn, WareHouse.ProvinceCodeColumn)
                        .LeftOuterJoin(City.CodeColumn, WareHouse.CityCodeColumn).LeftOuterJoin(Area.CodeColumn, WareHouse.AreaCodeColumn)
                        .Where(WareHouse.StoreFlagColumn).IsEqualTo(sflag).And(WareHouse.PCodeColumn).IsEqualTo(Common.currentWareHouse).And(WareHouse.StatusFlagColumn).IsEqualTo(1);
                    DataTable dt = q.ExecuteDataSet().Tables[0];
                    Response.Write("{\"rows\":" + JSON.Encode(dt) + "}");
                }
                else if (Request["key"].ToString() == "Allot"
                   &&Request["id"]!=null&& Request["id"].ToString() != ""
                  && Request["sid"] != null && Request["sid"].ToString() != "") 
                {
                    //SaleBill salebill = new SaleBill("Code", Request["id"].ToString());
                    StoredProcedure spd = new StoredProcedure("SaleBillToAllotBill");
                    spd.Command.AddParameter("@SaleBillCode", Request["id"].ToString());
                    spd.Command.AddParameter("@FromWCode", Common.currentWareHouse);
                    spd.Command.AddParameter("@WareHouseCode", Request["sid"].ToString());
                    spd.Command.AddParameter("@Alloter", Common.currentUserCode);
                    spd.Command.AddParameter("@level",Common.currentLevel);
                    spd.Execute();
                    Response.Write("SUCCESS");

                }
                else if (Request["key"].ToString() == "ReCheck"
                  && Request["id"] != null && Request["id"].ToString() != "")
                {
                    string sql="Delete SaleBill Where Code='"+Request["id"].ToString()+"'; Delete SaleBill Where Bill_Code='"
                        +Request["id"].ToString()+"'; Update TbTrade Set n_shenh=0 where SaleBill_Code='"+Request["id"].ToString()+"'";
                    SqlDal.RunSql(sql);
                }
                else if (Request["key"].ToString() == "HangUp"
                 && Request["id"] != null && Request["id"].ToString() != "")
                {
                    SaleBill salebill = new SaleBill(Request["id"].ToString());
                    salebill.StatusFlag = 3;
                    salebill.Save();
                }

                else if (Request["key"].ToString() == "EditCommit")
                {
                    SaleBillDetail salebilldetail = new SaleBillDetail(Request["ID"].ToString());
                    salebilldetail.TotalCount =decimal.Parse( Request["TotalCount"]);
                    salebilldetail.Save();
                    renderData("SUCCESS");
                }
                else if (Request["key"].ToString() == "AskDiscountCommit")
                {
                    AskDiscount ad = new AskDiscount();
                    ad.BillCode = Request["Code"];
                    ad.OldAmount = decimal.Parse(Request["OldAmount"]);
                    ad.OldFreight = decimal.Parse(Request["OldFreight"]);
                    ad.ApplyAmount = decimal.Parse(Request["ApplyAmount"]);
                    ad.ApplyFreight = decimal.Parse(Request["ApplyFreight"]);
                    ad.ApplyMemo = Request["ApplyMemo"];
                    ad.Applyer = Common.currentUser;
                    ad.ApplyDate = DateTime.Now;
                    ad.Save();
                    renderData("SUCCESS");
                }
                else if (Request["key"].ToString() == "CommitDiscountCommit")
                {
                    AskDiscount ad = new AskDiscount("ID", Request["ID"]);  
                    ad.NewAmount = decimal.Parse(Request["NewAmount"]);
                    ad.NewFreight = decimal.Parse(Request["NewFreight"]);
                    ad.CommitMemo = Request["CommitMemo"];
                    ad.Commiter = Common.currentUser;
                    ad.CommitDate = DateTime.Now;
                    ad.Save();
                    SaleBill sb = new SaleBill("Code", Request["Code"]);
                    sb.BillAmount = ad.NewAmount;
                    sb.Freight = ad.NewFreight;
                    renderData("SUCCESS");
                }

                else if (Request["key"].ToString() == "GetApply")
                {
                    QueryCommand qc = new QueryCommand("select top 1 * from AskDiscount where statusflag=1 and Bill_Code='"+Request["Code"]+"' order by applydate desc");
                    DataTable dt = DataService.GetDataSet(qc).Tables[0]; 
                    renderData(JSON.Encode(dt));
                }
                else if (Request["key"].ToString() == "LevelUp")
                {
                    SaleBill sb = new SaleBill("ID", Request["ID"]);
                    if(sb.BillLevel!=5)
                     sb.BillLevel = sb.BillLevel==null?1:sb.BillLevel + 1;
                    sb.Save();
                    renderData("SUCCESS");
                }
                
            }
        }

        void SetAjaxGrid()
        {
            /*参数:
             * BC=BillCode  订单编号
             * CS=CustomerSname 客户昵称
             * CE =CustomerEmail 客户邮箱
             * CL =CustomerLevel 客户等级
             * CN =CustomerName 客户姓名
             * BF =BillFrom  订单来源
             * BT =BillType  订单类型
             * BS =BillStatus 订单状态  
             * SD =StartDate 订单开始日期
             * ED =EndDate 订单开始日期
             */
            /*订单状态
             * <option value="1">正常单</option>
                <option value="2">已改单</option>
                <option value="3">优惠申请</option>
                <option value="4">已提交</option>
                <option value="5">已付款</option>
                <option value="6">已发货</option>
                <option value="7">已收货</option>
             */
             
            int pagenumber = int.Parse(Request["page"].ToString());
            int pagesize = int.Parse(Request["rows"].ToString());
            SqlQuery q = new Select("SaleBill.ID", "SaleBill.BillLevel", "SaleBill.Code", "SaleBill.Bill_Code", "SaleBill.BillFromName", "SaleBill.BuyerCode", "SaleBill.BuyerName",
                 "SaleBill.TotalCount", "SaleBill.Weight", "SaleBill.BillAmount", "SaleBill.Freight"
                , "SaleBill.TotalAmount", "SaleBill.BillDate", "SaleBill.PayDate", "SaleBill.ReceiverName",
                "SaleBill.ReceiverZip", "SaleBill.ReceiverEmail"  , "SaleBill.ReceiverMobile",
                "SaleBill.ReceiverPhone", "SaleBill.ReceiverCountry", "SaleBill.ReceiverState", "SaleBill.ReceiverCity"
                , "SaleBill.ReceiverDistrict", "SaleBill.Address").From(SaleBill.Schema)
                .LeftOuterJoin(Customer.CodeColumn,SaleBill.BillToCodeColumn)
                .Where(SaleBill.StatusFlagColumn).IsEqualTo(1).AndExpression("Warehouse_Code").IsEqualTo(Common.currentWareHouse);
           if(!string.IsNullOrEmpty(Request["BC"])) q= q.AndExpression("SaleBill.Code").Like("'%"+Request["BC"]+"%'");
           if(!string.IsNullOrEmpty(Request["CS"])) q= q.AndExpression("SaleBill.BuyerCode").Like("'%"+Request["BC"]+"%'");
           if (!string.IsNullOrEmpty(Request["CL"])) q = q.AndExpression("Customer.CustomerLevel").IsEqualTo(Request["CL"]);
           if (!string.IsNullOrEmpty(Request["CN"])) q = q.AndExpression("Customer.ReceiverName").Like("'%" + Request["BC"] + "%'");
           if(!string.IsNullOrEmpty(Request["BF"])) q= q.AndExpression("SaleBill.BillFromName").Like("'%"+Request["BF"]+"%'");
           if (!string.IsNullOrEmpty(Request["BT"])) q = q.AndExpression("SaleBill.BillType").IsEqualTo( Request["BT"] );
           if (!string.IsNullOrEmpty(Request["BS"])) q = q.AndExpression("SaleBill.StatusFlag").IsEqualTo(Request["BS"]);
           if (!string.IsNullOrEmpty(Request["SD"])) q = q.AndExpression("SaleBill.BillDate").IsGreaterThan(Request["SD"]);
           if (!string.IsNullOrEmpty(Request["ED"])) q = q.AndExpression("SaleBill.BillDate").IsLessThan(Request["ED"]);
          
            int count = q.GetRecordCount();
            DataTable dt = q.Paged(pagenumber, pagesize).ExecuteDataSet().Tables[0];
            Response.Write("{\"rows\":" + JSON.Encode(dt) + ",\"total\":" + count.ToString() + "}");
        }

        void SetAjaxDGrid()
        {
            SqlQuery q = new Select().From(SaleBillDetail.Schema).Where(SaleBillDetail.BillCodeColumn).IsEqualTo(Request["Code"].ToString());
            DataTable dt = q.ExecuteDataSet().Tables[0];
            Response.Write("{\"rows\":" + JSON.Encode(dt) + "}");
        }
    }
}