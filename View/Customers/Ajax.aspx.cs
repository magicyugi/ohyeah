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
    public partial class Ajax : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int setnumber = 15;
            if (Request["type"] == "list")
            { 
                gridbind("");
            }
            if (Request["type"] == "menulist")
            {
                menugridbind("");
            }
            if (Request["type"] == "paymentlist")
            {
                gridbind2("");
            }
            if (Request["type"] == "Role")
            {
                renderData(Common.btnRole("", Request["RoleCode"]));
            }
            else if (Request["type"] == "del")
            {
                int id = int.Parse(Request["id"]);
                Customer cut = new Customer("id", id);
                Alert.Delete("code",cut.Code);
                Customer.Delete("id", id);
                renderData("success");
            }
            else if (Request["type"] == "Level")
            {
                string sql = "";
                SqlQuery q = new Select("CustomerLevel.ID,Level_Code,LevelName,Customer_Code,CustomerLevel.CustomerName,CustomerLevel.Code,CustomerLevel.Cname,Category,CONVERT(varchar(100), Alert.CreateDate, 20) as CreateDate").From<CustomerLevel>()
                    .LeftOuterJoin(Alert.CodeColumn,CustomerLevel.CustomerCodeColumn ).Where("Customer_Code").IsEqualTo(Request["Code"]);
                int totalcount = q.GetRecordCount();
                DataTable cd = q.ExecuteDataSet().Tables[0];
                renderData("{\"rows\":" + JSON.Encode(cd) + ",\"total\":" + totalcount + "}");
            }
            else if (Request["type"] == "edit")
            {
                string code = Request["code"];
                Customer cust = new Customer("Code", code);
                SaveCustomer(cust, code); 
            }
            else if (Request["type"] == "add")
            {
                string guid = Guid.NewGuid().ToString(); 
                Customer cust = new Customer();
                cust.RegDate = DateTime.Now;
                cust.ContractMoney = 0;
                cust.VisitTime = 1;
                cust.Creater = currentUser;
                cust.CreateTime = DateTime.Now;
                cust.ProcessFlag = 1; 
                VisitLog vl = new VisitLog();
                vl.WareHouseCode = Common.currentWareHouse;
               // vl.Code = guid;
                vl.Cname = Request["Cname"];
                vl.Address = Request["Address"];
                vl.CustomerName = Request["Cname"];
                vl.Mobile = Request["Mobile"];
                vl.CustomerLevel = 0;
                vl.VisitProcessCode = "1";
                vl.VisitTypeCode = "";
                vl.VisitProcess = "";
                vl.VisitType = "";
                vl.VisitName = Common.currentUser;
                vl.VisitTitle = "首次回访";
                vl.VisitContent = Request["Description"];
                vl.VisitDate = DateTime.Now;
                vl.VisitContent = Request["Description"];
                vl.StatusFlag = 1;
                vl.Save();  
                SaveCustomer(cust, guid);
            }
            else if (Request["type"] == "addcustomer")
            {
                string guid = Guid.NewGuid().ToString();
                Customer cust = new Customer();
                cust.Code = Request["Code"];
                cust.RegDate = DateTime.Now;
                cust.ContractMoney = 0;
                cust.VisitTime = 1;
                cust.Creater = currentUser;
                cust.CreateTime = DateTime.Now;
                cust.Email = Request["Email"];
                cust.Province = Request["ddpProvince"];
                cust.Country = Request["ddpCountry"];
                cust.City = Request["ddpCity"];
                cust.ProcessFlag = 1;
                DataTable haveTable =
                    SqlDal.RunSqlExecuteDT("select ec.* from ExistCountry ec where ec.warehouse_code='" + currentMaster +
                                           "' and ec.Vcode='" + cust.Country + "' and ec.PName='" + cust.Province +
                                           "' and ec.Code='" + cust.City + "'");
                if (haveTable.Rows.Count == 0)
                {
                    ExistCountry ec = new ExistCountry();
                    Country ct = new Country("code", cust.Country);
                    City2 ct2 = new City2("id", cust.City);
                    ec.WareHouseCode = currentMaster;
                    ec.VCode = cust.Country;
                    ec.VName = ct.NameCn;
                    ec.PName = cust.Province;
                    ec.Code = cust.City;
                    ec.CName =ct2.District;
                    ec.TotalCount = 1;
                    ec.StatusFlag = 1;
                    ec.Save();
                }
                else
                {
                    ExistCountry ec = new ExistCountry("id", haveTable.Rows[0]["id"].ToString());
                    ec.TotalCount = ec.TotalCount + 1;

                }
                SaveCustomer(cust, guid);
            }
            else if (Request["type"] == "addvisit")
            {
                string code = Request["Code"];
                VisitLog vl = new VisitLog();
                vl.WareHouseCode = Common.currentWareHouse;
                // vl.Code = guid;
                vl.Code = code;
                vl.Cname = Request["Cname"];
                vl.Address = Request["Address"];
                vl.CustomerName = Request["Cname"];
                vl.Mobile = Request["Mobile"];
                vl.CustomerLevel = 0;
                vl.VisitProcessCode = "1";
                vl.VisitTypeCode = "";
                vl.VisitProcess = "";
                vl.VisitType = "";
                vl.VisitName = Common.currentUser;
                vl.VisitTitle = Request["VisitTitle"];
                vl.VisitContent = Request["VisitContent"];
                vl.VisitDate = DateTime.Now; 
                vl.StatusFlag = 1;
                vl.Save(); 
                Alert.Delete("code", code);
                Alert al = new Alert();
                al.WareHouseCode = currentWareHouse;
                al.Code = Request["Code"];
                al.CustomerName = Request["Cname"];
                al.CreateDate = DateTime.Now;
                al.Creater = Common.currentUser;
                al.MsgFlag = int.Parse(Request["MsgFlag"] == "on" ? "1" : "0");
                al.Mobile = Request["Mobile"];
                al.StartDate = DateTime.Parse(Request["NextVisitDate"]);
                al.Cname = Request["NextVisitContent"];
                al.AlertContent = Request["NextVisitContent"];
                al.Hour = int.Parse(Request["HM"].Split(':')[0]);
                al.Minute = int.Parse(Request["HM"].Split(':')[1]); 
                // CustomerLevel.Delete("Customer_Code", Request["Code"]);

                Customer customer = new Customer("code", Request["Code"]);
                customer.VisitDate = DateTime.Now;  
                customer.AlertDate1 = DateTime.Parse(Request["NextVisitDate"]).AddHours(int.Parse(Request["HM"].Split(':')[0])).AddMinutes(int.Parse(Request["HM"].Split(':')[1]));
                if (customer.VisitTime == null || customer.VisitTime.ToString() == "")
                    customer.VisitTime = 1;
                else
                    customer.VisitTime = customer.VisitTime + 1;
                customer.Save();
                al.Save();
                renderData("success");
            }
            else if (Request["type"] == "getstock")
            {
                SqlQuery q = new Select().From<SaleBillDetail>().Where("SaleBill_Code").IsEqualTo(Request["salebill_code"]);
                if (Request["getstock"] != null) q.And("StatusFlag").IsEqualTo(1);
                DataTable dt = q.ExecuteDataSet().Tables[0];
                renderData(JSON.Encode(dt));
            }
            else if (Request["type"] == "setstock")
            {
                string sql = @"update SaleBillDetail set statusflag=0 where salebill_code='" + Request["SaleBill_Code"] + "' and product_code in (" + Request["Product_Code"] + ");";
                DBUtil.Execute(sql);
                SqlQuery q = new Select().From<SaleBillDetail>().Where("SaleBill_Code").IsEqualTo(Request["salebill_code"]).And("StatusFlag").IsEqualTo(1);
                DataTable dt = q.ExecuteDataSet().Tables[0];
                Contract ct = new Contract("Salebill_Code", Request["SaleBill_Code"]);
                if (dt.Rows.Count == 0)
                {
                    ct.SendFlag = 3;
                    ct.Save();
                    //sql = "update [contract] set SendFlag=3 where  salebill_code='" + Request["SaleBill_Code"] + "';";
                    //DBUtil.Execute(sql);
                }
                else
                {
                    ct.SendFlag = 2;
                    ct.Save();
                    //sql = "update [contract] set SendFlag=2 where  salebill_code='" + Request["SaleBill_Code"] + "';";
                    //DBUtil.Execute(sql);
                }

                SetCustomerLevel(ct.CustomerCode, "StockUp");

                renderData("备货成功!");
            }
            else if (Request["type"] == "getSendDate")
            {
                SqlQuery q = new Select().From<SysCode>().Where("WareHouse_Code").IsEqualTo(currentMaster).And("Category").IsEqualTo("SendDate");
                DataTable dt = q.ExecuteDataSet().Tables[0];
                renderData(JSON.Encode(dt));
            }
            else if (Request["type"] == "setSendDate")
            {
                QueryCommand syscmd = new QueryCommand("select * from syscode where category='SendDate' and warehouse_code='" + currentMaster + "'");
                DataTable sysdt = DataService.GetDataSet(syscmd).Tables[0];
                if (sysdt.Rows.Count == 0)
                {
                    string[] txtp = { "备货提醒日期", "发货提醒日期" };
                    for (int i = 0; i < 2; i++)
                    {
                        SysCode sc = new SysCode();
                        sc.Code = "00000" + (i + 1).ToString();
                        sc.Cname = Request["SendDate" + (i + 1).ToString()];
                        sc.Category = "SendDate";
                        sc.WareHouseCode = currentMaster;
                        sc.VCode = sc.Code;
                        sc.CategoryName = txtp[i];
                        sc.StatusFlag = 1;
                        sc.IsAdminCode = 0;
                        sc.StepFlag = 0;
                        sc.Save();
                    }
                }
                else
                {
                    string sql = "";
                    for (int i = 0; i < 2; i++)
                    {
                        sql += @"update syscode set Cname='" + Request["SendDate" + (i + 1).ToString()] + "' where code='00000" + (i + 1).ToString() + "' and category='SendDate' and warehouse_code='" + currentMaster + "';";
                    }
                    DBUtil.Execute(sql);
                }
                renderData("设置成功!");
            }
            else if (Request["type"] == "setfix")
            {
                string txtvalue = Request["value"].Substring(0, Request["value"].Length - 1);
                string[] txtsplit = txtvalue.Split(',');
                string sql = @"";
                for (int i = 0; i < txtsplit.Length; i++)
                {
                    sql += "update SaleBillDetail set fixflag=" + txtsplit[i].Split('-')[1] + " where id=" + txtsplit[i].Split('-')[0] + ";";
                }
                DBUtil.Execute(sql);

                renderData("维修标记成功!");
            }
            else if (Request["type"] == "setflag")
            {
                string sql = @"";
                Contract ct = new Contract("id", Request["id"]);
                ct.StatusFlag = 2;
                ct.SendFlag = 3;
                ct.Save();
                sql = "update [SaleBillDetail] set statusflag=2 where SaleBill_Code='" + ct.SaleBillCode + "';";

                SetCustomerLevel(ct.CustomerCode, "Deliver");

                DBUtil.Execute(sql);
                renderData("发货标记成功!");
            }
            else if (Request["type"] == "dropdown")
            {
                string[] tableCollection = { "SysUser", "SysCode", "SysCode", "Partner", "WareHouse" };
                string[] whereCollection = { " where WareHouse_Code in (" + Common.currentGroup + ") and UserLevelPoint<=" + currentLevel + "", " where Category='ClientSource' and statusflag=1 and warehouse_code='" + currentMaster + "' ", " where Category='CustomerLevel' and statusflag=1 and warehouse_code='" + currentMaster + "' ", " where warehouse_code in (" + currentGroup + ")", " where Pcode='" + currentMaster + "' or code='" + currentMaster + "' " };
                renderData(getDrop(tableCollection, whereCollection));
            }
            else if (Request["type"] == "dropdown2")
            {
                string[] tableCollection = { "SysCode" };
                string[] whereCollection = { " where Category='PayType' and statusflag=1 and warehouse_code='" + currentMaster + "'  " };
                renderData(getDrop(tableCollection, whereCollection));
            }
                //************************新付款记录
            else if (Request["type"] == "gridPayment")
            {
                int row = int.Parse(Request["rows"]);
                int page = int.Parse(Request["page"].ToString());
                SqlQuery q = new Select().From<SaleBill>().Where("BuyerCode").IsEqualTo(Request["Code"]);
                int totalcount = q.GetRecordCount();
                DataTable cd = q.Paged(page, row).ExecuteDataSet().Tables[0];
                renderData("{\"rows\":" + JSON.Encode(cd) + ",\"total\":" + totalcount + "}");
            }
            else if (Request["type"] == "gridPaymentDetail")
            { 
                SqlQuery q = new Select().From<SaleBillDetail>().Where("Bill_Code").IsEqualTo(Request["Code"]);
                int totalcount = q.GetRecordCount();
                DataTable cd = q.ExecuteDataSet().Tables[0];
                renderData("{\"rows\":" + JSON.Encode(cd) + ",\"total\":" + totalcount + "}");
            }
                //***************************end

            else if (Request["type"] == "paymentdetail")
            {
                int row = int.Parse(Request["rows"]);
                int page = int.Parse(Request["page"].ToString());
                SqlQuery q = new Select().From<ContractDetail>().Where("Bill_Code").IsEqualTo(Request["Code"]);
                int totalcount = q.GetRecordCount();
                DataTable cd = q.Paged(page, row).ExecuteDataSet().Tables[0];
                renderData("{\"rows\":" + JSON.Encode(cd) + ",\"total\":" + totalcount + "}");
            }
            else if (Request["type"] == "pay")
            {
                ContractDetail cd = new ContractDetail();
                cd.BillCode = Request["Code"];
                cd.PayType = Request["PaymentType"];
                if (Request["PayMoney"] == null) cd.Price = 0;
                else
                    cd.Price = decimal.Parse(Request["PayMoney"] == "" ? "0" : Request["PayMoney"]);
                cd.PayDate = DateTime.Now;
                cd.CreateTime = DateTime.Now;
                cd.Creater = Common.currentUser;
                Contract ct = new Contract("SaleBill_Code", cd.BillCode);
                if (Request["paymentflag"] != null) { ct.StatusFlag = 3; }
                else
                {
                    ct.PayMoney = ct.PayMoney + cd.Price;
                    ct.LeftMoney = ct.Price - ct.PayMoney;
                    if (ct.LeftMoney <= 0) ct.PayMentFlag = 3;//判断完成收款
                    else if (ct.LeftMoney >= 0 && ct.LeftMoney <= ct.Price) ct.PayMentFlag = 2;
                    else if (ct.LeftMoney == ct.Price) ct.PayMentFlag = 1;
                    ct.StatusFlag = 1;
                    cd.Save();
                }
                ct.Save();
                if (ct.LeftMoney <= 0)
                {
                    SetCustomerLevel(ct.CustomerCode, "Detail");
                }
                if (ct.PayMentFlag == 2 || ct.StatusFlag == 3)
                { Customer cu = new Customer("code", ct.CustomerCode); cu.ProcessFlag = 3; cu.Save(); }
                renderData("success");
            }
            else if (Request["type"] == "CheckCustomer")
            {
                string code = Request["code"], cname = Request["cname"], mobile = Request["mobile"], address = Request["address"];
                int icount = 0;
                DataTable dt = new DataTable();
                if (code == "")
                {
                    SqlQuery q = new Select().From<Customer>().Where("Mobile").IsEqualTo(mobile).OrExpression("Address").IsEqualTo(address).And("Address").IsNotEqualTo("");
                    icount = q.GetRecordCount();
                    dt = q.ExecuteDataSet().Tables[0];
                    if (icount > 0) { renderData("fail:客户手机或者地址不能与'" + dt.Rows[0]["Cname"].ToString() + "-" + dt.Rows[0]["Mobile"].ToString() + "-" + dt.Rows[0]["Address"].ToString() + "'重复.\n请联系跟单业务员   " + dt.Rows[0]["Guide_Code"].ToString() + "-" + dt.Rows[0]["Guide"].ToString()); }
                }
                else
                {

                    if (Request["type"] == "edit")
                    {
                        dt = SqlDal.RunSqlExecuteDT(@"select * from customer where (Mobile='" + mobile + @"' or
                    (address='" + Request["Address"] + @"' and Address<>'')) AND  Code<>'" + code + "'");
                        icount = dt.Rows.Count;
                    }
                    if (Request["type"] == "add")
                    {
                        dt = SqlDal.RunSqlExecuteDT(@"select * from customer where (Mobile='" + mobile + @"' or
                      (address='" + address + @"' and Address<>'')) ");
                        icount = dt.Rows.Count;
                    }
                    if (icount > 0) { renderData("fail:客户手机或者地址不能与'" + dt.Rows[0]["Cname"].ToString() + "-" + dt.Rows[0]["Mobile"].ToString() + "-" + dt.Rows[0]["Address"].ToString() + "'重复.\n请联系跟单业务员   " + dt.Rows[0]["Guide_Code"].ToString() + "-" + dt.Rows[0]["Guide"].ToString()); }
                }
                renderData("");
            }
            else if (Request["type"] == "search")
            {
                gridbind(Request["value"]);
            }
            else if (Request["type"] == "paysearch")
            {
                gridbind2(Request["value"]);
            }
            else if (Request["type"] == "ChangeCustomer")
            {
                DataTable dt = SqlDal.RunSqlExecuteDT("select * from customer where guide_code='"+currentUserCode+"'"); 
                Customer c = new Customer("Code",Request["code"]);
                if (Request["value"] == "跟进") 
                {
                    if (dt.Rows.Count > setnumber) { renderData("fail:私海人数已经到达上限:" + setnumber + "人."); return; }
                    c.GuideCode = currentUserCode;
                    c.Guide = currentUser; 
                }
                else if (Request["value"] == "放弃")
                {
                    c.GuideCode = "";
                    c.Guide = ""; 
                } 
                c.Save();
                renderData("success");
            }

            else if (Request["type"] == "printVisit")
            {
                SqlQuery q = new Select("CONVERT(varchar(100), VisitDate, 20) as VisitDate ", "VisitName", "VisitTitle", "VisitContent").From(VisitLog.Schema).Where(VisitLog.CodeColumn).IsEqualTo(Request["code"]);

                DataTable dt = q.ExecuteDataSet().Tables[0];
                renderData(JSON.Encode(dt));
            }
            else if (Request["type"] == "printContract")
            {
                string txtsql = "select * from contract where Customer_Code='" + Request["code"] + "' order by price desc";
                QueryCommand cmd = new QueryCommand(txtsql);
                DataTable dt = DataService.GetDataSet(cmd).Tables[0];
                renderData(JSON.Encode(dt));
            }
            else if (Request["type"] == "Alert")
            {

                if (Request["flag"] == "0")
                {
                    SqlQuery q = new Select().From(Alert.Schema).Where(Alert.CodeColumn).IsEqualTo(Request["CustomerCode"]);
                    q.And(Alert.CnameColumn).IsEqualTo("催款提醒");
                    DataTable detail = q.ExecuteDataSet().Tables[0];
                    if (detail.Rows.Count != 0)
                    { renderData("fail:该客户已经设置过催款提醒,是否重新设置?"); return; }
                    else
                    { renderData("success"); }
                }
                else
                {
                    if (Request["AlertDate"] == null || Request["AlertDate"] == "")
                    {
                        renderData("fail:请输入提醒时间!"); return;
                    }
                    Customer cust = new Customer("Code", Request["CustomerCode"]);
                    DBUtil.Execute("delete from alert where code='" + cust.Code + "' and cname='催款提醒'");
                    Alert al = new Alert();
                    al.WareHouseCode = currentWareHouse;
                    al.Code = cust.Code;
                    al.Cname = "催款提醒";
                    al.CustomerName = cust.Cname;
                    al.Mobile = cust.Mobile;
                    al.Tel = cust.Tel;
                    al.CreateDate = DateTime.Now;
                    al.Creater = currentUser;
                    al.StartDate = DateTime.Parse(Request["AlertDate"]);
                    al.AlertContent = "催款提醒";
                    al.Hour = int.Parse(Request["HM"].Split(':')[0]);
                    al.Minute = int.Parse(Request["HM"].Split(':')[1]);
                    al.StatusFlag = 1;
                    al.Save();
                    renderData("success");
                }
            }
            else if (Request["type"] == "detail")
            {
                SqlQuery q = new Select("Customer.*,Customer.ClientSource_Code as ClientSourceCode,Customer.Guide_Code as GuideCode,(select top 1 Cname  from sysCode where Category='CustomerLevel' and Code=Customer.CustomerLevel and warehouse_code='" + currentMaster + "')  as  CustomerLevelCname,Customer.Introduce_Code as IntroduceCode,CustomerDetail.*,Alert.*,(cast(Alert.Hour as VARCHAR)+':'+cast(Alert.Minute as VARCHAR)) as HM,CONVERT(varchar(100), Customer.AlertDate1, 23) as AlertDate").From(Customer.Schema)
                    .LeftOuterJoin(CustomerDetail.CustomerCodeColumn, Customer.CodeColumn).LeftOuterJoin(Alert.CodeColumn, Customer.CodeColumn).Where(Customer.CodeColumn).IsEqualTo(Request["Code"]).OrderDesc("Alert.ID");
                DataTable detail = q.ExecuteDataSet().Tables[0];
                renderData(JSON.Encode(detail));
            }

            else if (Request["type"] == "CustomerDetail")
            {
                SqlQuery q = new Select().From<CustomerDetail>().Where("CTextCount").IsNotNull().And(CustomerDetail.WareHouseCodeColumn).IsEqualTo(Request["WareHouse"]);
                DataTable detail = q.ExecuteDataSet().Tables[0];
                renderData(JSON.Encode(detail));
            }
            else if (Request["type"] == "SaveDetail")
            {
                CustomerDetail.Delete("WareHouse_Code", currentMaster);
                string txtinsert = "insert  into CustomerDetail (WareHouse_Code,CTextCount";
                string lastinsert = "values('" + currentMaster + "',#count#";
                int notnullcount = 1;
                for (int i = 1; i <= 20; i++)
                {
                    if (Request[Request.Params.AllKeys[i].ToString()] != "")
                    {
                        txtinsert += ",CText" + notnullcount;
                        lastinsert += ",'" + Request[Request.Params.AllKeys[i].ToString()] + "'";
                        notnullcount++;
                    }
                }
                string txtsql = txtinsert + ") " + lastinsert + ")";
                txtsql = txtsql.Replace("#count#", (notnullcount - 1).ToString());
                DBUtil.Execute(txtsql);
                renderData("success");
            }
            else if (Request["type"] == "SupSearch")
            {
                gridbind("");
            }
            else if (Request["type"] == "Guide")
            {
                string txtid = Request["id"];
                Customer cust = new Customer("ID", txtid);
                cust.Guide = Request["guidename"];
                cust.GuideCode = Request["GuideCode1"];
                cust.Save();
                renderData("success");
            }
            else if (Request["type"] == "Country")
            { 
                DataTable clist = new Select().From(Country.Schema).ExecuteDataSet().Tables[0];
                Response.Write(JSON.Encode(clist));

            }
            else if (Request["type"] == "Province")
            {
                string sql = "select District from city2 where CountryCode='"+Request["Pcode"]+"' GROUP BY District ";
                QueryCommand cmd = new QueryCommand(sql);
                DataTable dt = DataService.GetDataSet(cmd).Tables[0];
                Response.Write(JSON.Encode(dt));

            }
            else if (Request["type"] == "City")
            {
                DataTable clist = new Select().From(City2.Schema).Where("District").IsEqualTo(Request["Pcode"]).ExecuteDataSet().Tables[0];
                Response.Write(JSON.Encode(clist));
                

            }
        }

        public void SaveCustomer(Customer cust,string code) {
            int icount = 0;
            DataTable dt1 = new DataTable();
            if (code == "")
            {
                SqlQuery q1 = new Select().From<Customer>().Where("Mobile").IsEqualTo(Request["Mobile"]).OrExpression("Address").IsEqualTo(Request["Address"]).And("Address").IsNotEqualTo("");
                icount = q1.GetRecordCount();
                dt1 = q1.ExecuteDataSet().Tables[0];
                if (icount > 0) { renderData("fail:客户手机或者地址不能与'" + dt1.Rows[0]["Cname"].ToString() + "-" + dt1.Rows[0]["Mobile"].ToString() + "-" + dt1.Rows[0]["Address"].ToString() + "'重复.\n请联系跟单业务员   " + dt1.Rows[0]["Guide_Code"].ToString() + "-" + dt1.Rows[0]["Guide"].ToString()); }
            }
            else
            {

                if (Request["type"] == "edit")
                {
                    dt1 = SqlDal.RunSqlExecuteDT(@"select * from customer where (Mobile='" + Request["Mobile"] + @"' or
                    (address='" + Request["Address"] + @"' and Address<>'')) AND  Code<>'" + code + "'");
                    icount = dt1.Rows.Count;
                }
                if (Request["type"] == "add")
                {
                    dt1 = SqlDal.RunSqlExecuteDT(@"select * from customer where (Mobile='" + Request["Mobile"] + @"' or
                      (address='" + Request["Address"] + @"' and Address<>'')) ");
                    icount = dt1.Rows.Count;
                }
                if (icount > 0) { renderData("fail:客户手机或者地址不能与'" + dt1.Rows[0]["Cname"].ToString() + "-" + dt1.Rows[0]["Mobile"].ToString() + "-" + dt1.Rows[0]["Address"].ToString() + "'重复.\n请联系跟单业务员   " + dt1.Rows[0]["Guide_Code"].ToString() + "-" + dt1.Rows[0]["Guide"].ToString()); }
            }
            //if (Request["CreditLevel"] == null || Request["CreditLevel"] == "") { renderData("fail:请选择客户评级!"); }
            if (Request["ClientSourceCode"] == null || Request["ClientSourceCode"] == "") { renderData("fail:请选择客户来源!"); }
            cust.WareHouseCode = currentWareHouse; 
            cust.Code = code;
            cust.VIPNumber = Request["VIPNumber"];
            cust.Cname = Request["Cname"]; 
            //cust.GuideCode = currentUserCode;// Request["GuideCode"] == "" ? currentUserCode : Request["GuideCode"];
            //cust.Guide = currentUser; //Request["GuideCode"] == "" ? currentUser : Request["Guide"];
            cust.Mobile = Request["Mobile"];
            cust.Tel = Request["Tel"];
            cust.Address = Request["Address"];
            cust.Sex = Request["Sex"];
            cust.ClientSourceCode = Request["ClientSourceCode"];
            if (cust.ClientSourceCode == "1")
            {
                cust.IntroduceCode = Request["ClientSourceCode1"];
                cust.IntroduceName = Request["ClientSource1"];
                SqlQuery partnerq = new Select().From<Partner>().Where("Code").IsEqualTo(cust.IntroduceCode);
                cust.IntroduceMobile = partnerq.ExecuteDataSet().Tables[0].Rows[0]["Mobile"].ToString();
            }
            else if (cust.ClientSourceCode == "0")
            {
                cust.IntroduceName = Request["IntroduceName"];
                cust.IntroduceCode = Request["IntroduceCode"];
                cust.IntroduceMobile = Request["IntroduceMobile"];
            } 
            cust.Description = Request["Description"];
            
            string txtgetcategory="";
            if (Request["txtCustomerLevel"] != null && Request["txtCustomerLevel"] != "0") txtgetcategory = Request["txtCustomerLevel"];
             
            
            //cust.CreditLevel = int.Parse(Request["Score"]);
            cust.ClientSource = Request["ClientSource"];
            cust.GuideCode = Common.currentUserCode;
            cust.Guide = Common.currentUser;
            cust.VisitDate = DateTime.Now;
            if ((Request["ProcessFlag"] == "" || Request["ProcessFlag"] == null) & cust.IntentionFlag != 1) 
               cust.IntentionFlag = 0;
            cust.StatusFlag = 1;
            if (Request["HM"] != null) 
               cust.AlertDate1 = DateTime.Parse(Request["AlertDate"]).AddHours(int.Parse(Request["HM"].Split(':')[0])).AddMinutes(int.Parse(Request["HM"].Split(':')[1]));       
            SqlQuery q = new Select().From<CustomerDetail>().Where("CTextCount").IsNotNull().And("warehouse_code").IsEqualTo(Common.currentMaster);
            DataTable dt = q.ExecuteDataSet().Tables[0];
            string sql = "delete from CustomerDetail where Customer_Code='"+code+"'; insert into CustomerDetail ";
            string keys = "(";
            string values = "(";
            int notnullcount = 0;
                for (int i = 1; i < int.Parse(dt.Rows[0]["CTextCount"].ToString()) + 1; i++)
                {
                    if (Request["CText" + i] != "") { notnullcount++; }
                    keys += "CText" + i + ",";
                    values += "'" + Request["CText" + i] + "',";
                }
                keys += " Customer_Code,CustomerName,CTextCount)";
                values += "'" + code + "','" + Request["Cname"] + "'," + notnullcount + ")";
                sql += keys + " values " + values;
                QueryCommand cmd = new QueryCommand(sql); 
            if (DataService.ExecuteQuery(cmd) > 0)
            {
                if (Request["type"] == "add")
                {
                    Alert al = new Alert();
                    al.WareHouseCode = currentWareHouse;
                    al.Code = code;
                    al.Cname = Request["AlertContent"];
                    al.CustomerName = cust.Cname;
                    al.Mobile = cust.Mobile;
                    al.Tel = cust.Tel;
                    al.CreateDate = DateTime.Now;
                    al.Creater = currentUser;
                    al.StartDate = DateTime.Parse(Request["AlertDate"]);
                    al.AlertContent = Request["AlertContent"];
                    al.Hour = int.Parse(Request["HM"].Split(':')[0]);
                    al.Minute = int.Parse(Request["HM"].Split(':')[1]);
                    al.StatusFlag = 1;
                    al.Save();
                }
                cust.Save(); 
                renderData("success");
            }
            else
                renderData("fail"); 
        }
        public DataTable getList(out int totalcount, string txtSearch)
        {
            int row=0;
            int page=0;
            if (Request["rows"] != null && Request["page"] != null)
            {
                row = int.Parse(Request["rows"]);
                page = int.Parse(Request["page"].ToString());
            }
            string txtsort = Request["sort"];
            string txtorder = Request["order"];
            string txtleft = "",txtwhere="";
            //if (txtsort != "Price") txtsort = "a." + txtsort;
            if (Request["Category"] != "")
            {
                txtleft = @"LEFT JOIN (select * from CustomerLevel where id in (select max(ID) AS MAXID 
from CustomerLevel GROUP BY CUSTOMER_CODE) ) cl ON c.Code=cl.Customer_Code ";
                txtwhere = " and (cl.Category='" + Request["Category"].Split('-')[1] + "' and cl.Level_Code='" + Request["Category"].Split('-')[0] + "')";
            }
            //自定义分组  客户页面
            if (Request["txtid"] != null && Request["txtid"] != "")
            {
                SqlQuery q = new Select().From<TxTSql>().Where("StatusFlag").IsEqualTo(1).And("ID").IsEqualTo(Request["txtid"]);
                DataTable sqldt = q.ExecuteDataSet().Tables[0];
                txtwhere += sqldt.Rows[0]["sql"].ToString();
            }
            //查询条件  客户页面
            if (Request["id"] != null && Request["id"] != "")
            {
                SqlQuery q = new Select().From<TxTSql>().Where("StatusFlag").IsEqualTo(1);
                DataTable sqldt = q.ExecuteDataSet().Tables[0];
                string[] strCode = Request["id"].ToString().Split(';');
                string countrysql = "",citysql="";
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
                        txtwhere += ReplaceSQL(sqldt.Select("id=" + strPcodeAndCode[1])[0]["Sql"].ToString());
                    }

                }
                if (citysql != "") citysql += ")";
                txtwhere+=countrysql+citysql;
            }

            //if (sqldt.Rows.Count != 0) txtwhere += ReplaceSQL(sqldt.Rows[0]["Sql"].ToString());

            // (select cname from syscode where code=c.CustomerLevel and category='CustomerLevel' and WareHouse_Code='" + currentMaster + @"' and statusflag=1) as 
            string txtsql = @"select * from (select ROW_NUMBER() OVER ( ORDER BY c.CreditLevel desc) AS Row, c.ID, c.Code, c.Cname, c.Guide_Code as GuideCode, (CASE when isnull(Guide,'')='' THEN '' ELSE Guide end) as GuideName, c.Company, c.VisitTime,isnull(CreditLevel,0) as CreditLevel
                                    , CONVERT(varchar(100), c.RegDate, 20) as RegDate,CONVERT(varchar(100), c.DealDate, 20) as DealDate,CONVERT(varchar(100), c.VisitDate, 20) as VisitDate,CONVERT(varchar(100), c.AlertDate1, 20) as AlertDate1,c.ProcessFlag,c.CustomerMoney
                                    ,c.Address,Creater,c.Sex,c.Mobile,c.Tel,c.IntroduceName,c.IntroduceMobile,c.Description,c.CustomerLevel
                                    ,IntentionFlag,(case when IntentionFlag=0 then '意向' when IntentionFlag=1 then '成交' else '放弃' end) as IntentionFlagName,
                                    (case when isnull(c.guide_code,'')='' then '公海' else '私海' end) as CustomerType,(case when isnull(c.guide_code,'')='' then '公海' else '私海' end) as CustomerType1,
                                    c.ClientSource_Code as ClientSourceCode,c.ClientSource,ct.Price,ct2.SaleBill_Code,co.Name_CN AS Country,c.Province,ci.Name as City,c.Email
                                from Customer c left join (select  customer_code,max(salebill_code) as salebill_code from contract group BY customer_code  
                                ) ct2 on c.code=ct2.customer_code 
                                left join Country co on co.code=c.country
                                left join city2 ci on ci.ID=c.City
                                left join SysUser su on c.Guide_Code=su.Code 
                                left join (select sum(Price) as price,Customer_Code FROM Contract group by customer_code) ct 
                                on c.code=ct.Customer_Code " + txtleft +
                                @" where  1=1 " + txtwhere;
//(c.guide_code='" + currentUserCode + "' or isnull(c.guide_code,'')='' or su.UserLevelPoint<" + currentLevel + @") " + txtwhere; 
            if (Request["strSearch"] != null && Request["strSearch"] != "")
            {
                string[] searchsplit = Request["strSearch"].Split(';');
                txtsql += " and (c.Cname like '%" + searchsplit[1] + "%' or c.Mobile like '%" + searchsplit[2] + "%' or c.cname like '%" + searchsplit[0] + "%')";
            }
            if (Request["Date"] != "")
            {
                if (Request["type"] != "SupSearch" && Request["Date"]!="LaterVisit")
                txtsql += " and month(c." + Request["Date"] + ")=month(getdate()) ";
                 
            }
            if (Request["StartDate"] != "" && Request["EndDate"] != "")
            {

                txtsql += " and c.VisitDate>='" + Request["StartDate"] + "' and c.VisitDate<'" + DateTime.Parse(Request["EndDate"]).AddDays(1).ToShortDateString() + "'";

            } 
            if (Request["type"] == "SupSearch")
            {
                if (Request["txtWareHouse_Code"] != "")
                {
                    string[] splitwarehouse=Request["txtWareHouse_Code"].Split(',');
                    string stringwarehouse = "";
                    for (int i = 0; i < splitwarehouse.Length; i++) 
                    {
                        stringwarehouse += "'" + splitwarehouse[i]+"',";
                    }
                    stringwarehouse = stringwarehouse.Substring(0, stringwarehouse.Length - 1);
                    txtsql += " and c.warehouse_code in (" + stringwarehouse + ")";
                }
                if (Request["RegDate"] != "")
                    txtsql += " and c.regdate>='" + Request["RegDate"]+"' "; 
                if(Request["RegDate1"] != "")
                    txtsql += " and c.regdate<='" + DateTime.Parse(Request["RegDate1"]).AddDays(1) + "' "; 
                if (Request["ContractDate"] != "")
                    txtsql += " and c.DealDate>='" + Request["ContractDate"] + "' "; 
                if (Request["ContractDate1"] != "")
                    txtsql += " and c.DealDate<='" + DateTime.Parse(Request["ContractDate1"]).AddDays(1) + "' "; 
                if (Request["CustomerMoney"] != "")
                    txtsql += " and c.ContractMoney>='" + Request["CustomerMoney"] + "' "; 
                if (Request["CustomerMoney1"] != "")
                    txtsql += " and c.ContractMoney<='" + Request["CustomerMoney1"] + "' "; 
                if (Request["VisitDate"] != "")
                    txtsql += " and c.VisitDate>='" + Request["VisitDate"] + "' "; 
                if (Request["VisitDate1"] != "")
                    txtsql += " and c.VisitDate>='" + DateTime.Parse(Request["VisitDate1"]).AddDays(1) + "' ";
                if (Request["txtCreditLevel"] != "")
                    txtsql += " and c.CreditLevel>=" + Request["txtCreditLevel"];
                if (Request["txtCreditLevel1"] != "")
                    txtsql += " and c.CreditLevel<=" + Request["txtCreditLevel1"]; 
                if (Request["GuideCode1"] != "")
                    txtsql += " and c.Guide_Code='" + Request["GuideCode1"]+"'";
                if (!string.IsNullOrEmpty(Request["friendflag"]))
                    txtsql += " and c.ClientSource_Code='0'";
                
            }
            if (!string.IsNullOrEmpty(Request["giveup"]))
                txtsql += " and c.IntentionFlag=2";
            else
                txtsql += " and c.IntentionFlag<>2";
            if (txtSearch != "")
                txtsql += " and (c.Cname like '%" + txtSearch + "%' or c.Mobile like '%" + txtSearch + "%' or c.Creater like '%" + txtSearch + "%' or c.guide like '%" + txtSearch + "%')";
            if (Request["ProcessFlag"] != "" && Request["ProcessFlag"] != null && Request["Date"] != "RegDate")
            {
                if (Request["ProcessFlag"] == "2" && Request["Date"] == "DealDate")
                    txtsql += " and c.ProcessFlag in (2,3)";
                else if (Request["ProcessFlag"] == "1" && Request["Date"] == "LaterVisit")
                    txtsql += " and c.VisitDate<getdate()-7  and c.ProcessFlag=1 "; 
                else
                txtsql += " and c.ProcessFlag=" + Request["ProcessFlag"]; 
            }
            if (!string.IsNullOrEmpty(Request["intentionflag"])) { txtsql += " and c.IntentionFlag=" + Request["intentionflag"]; }
            txtsql += " and (c.guide_code='" + currentUserCode + "' or c.WareHouse_Code in (" + currentGroup + "))) a";
            QueryCommand cmd = new QueryCommand(txtsql);
            DataTable dt = DataService.GetDataSet(cmd).Tables[0];
            totalcount = dt.Rows.Count; 
            txtsql += "  WHERE  Row >= " + ((row * page) - (row - 1)) + " AND Row <= " + (row * page);

            if (txtorder == "desc" && txtorder != null)
                txtsql += " order by " + txtsort + " desc";
            else
                txtsql += " order by " + txtsort; 
            cmd = new QueryCommand(txtsql);
            dt = DataService.GetDataSet(cmd).Tables[0]; 
            return dt;
        }
        public DataTable getList2(out int totalcount,out string Price,out string PayMoney,out string LeftMoney, string txtSearch)
        {
            int row = int.Parse(Request["rows"]);
            int page = int.Parse(Request["page"].ToString());
            string txtsort = Request["sort"];
            string txtorder = Request["order"]; 
            //SqlQuery q = new Select().From(Contract.Schema).Where("WareHouse_Code").In(currentGroups)
            //    .AndExpression("Code").Like("%" + txtSearch + "%")
            //    .Or("CustomerName").Like("%" + txtSearch + "%").Or("UserName").Like("%" + txtSearch + "%")
            //    .OrderDesc("leftMoney").OrderAsc("CreateTime");
            string txtCreateTime = "";
            if ((Request["txtStartDate"] == null || Request["txtStartDate"] == "") && Request["CreateTime"] != "") txtCreateTime = " and Month(c.CreateTime)=Month(getdate())";
            else
            {

                if (!string.IsNullOrEmpty(Request["txtStartDate"])) txtCreateTime += "and c.CreateTime>='" + Request["txtStartDate"] + "'";
                if (!string.IsNullOrEmpty(Request["txtEndDate"])) txtCreateTime += "and c.CreateTime<'" + DateTime.Parse(Request["txtEndDate"]).AddDays(1).ToShortDateString() + "'";
    
            }
            if (!string.IsNullOrEmpty(Request["txtStatusFlag"])) txtCreateTime += " and c.statusflag in (" + Request["txtStatusFlag"] + ") ";
            if (!string.IsNullOrEmpty(Request["txtPayMentFlag"])) txtCreateTime += " and c.PayMentFlag in (" + Request["txtPayMentFlag"] + ") ";
            if (!string.IsNullOrEmpty(Request["txtSendFlag"])) txtCreateTime += " and c.SendFlag in (" + Request["txtSendFlag"] + ") ";
            if (Request["code"] != null) txtCreateTime += " and Customer_Code='" + Request["code"] + "' ";
            if (!string.IsNullOrEmpty(Request["SendFlag"])) {
                string getNum = "7";
                QueryCommand syscmd = new QueryCommand("select * from syscode where category='SendDate' and warehouse_code='"+currentMaster+"'");
                DataTable sysdt = DataService.GetDataSet(syscmd).Tables[0];
                if (sysdt.Rows.Count != 0)
                {
                    if (Request["SendFlag"] == "1")
                    {
                        getNum = sysdt.Rows[0]["Cname"].ToString() + " and c.Statusflag=4";
                    }
                    else
                    {
                        getNum = sysdt.Rows[1]["Cname"].ToString() + " and c.Statusflag=2";
                    }
                }
                else
                {
                    if (Request["SendFlag"] == "1")
                    {
                        getNum = "7 and c.Statusflag=4";
                    }
                    else
                    {
                        getNum = "2 and c.Statusflag=2";
                    }
                }
                txtCreateTime += " and datediff(day,c.SendDate,getdate())<=" + getNum;
            }
            string txtsql = @"   select * from (select ROW_NUMBER() OVER ( ORDER BY c." + txtsort + " " + txtorder + @") AS Row,c.*,CONVERT(varchar(100),c.CreateTime, 20) as ContractDate,(case when datediff(day,c.SendDate,getdate())<=0 then 0 else 1 end) as colorflag,st.Cname as  StylistName,hp.Cname as HelperName from Contract 
                               c left join (select * from SysCode where Category='Stylist' and WareHouse_Code='"+Common.currentMaster+@"' and statusflag=1) st on c.stylist= st.Code
                                 left join (select * from SysCode where Category='Helper' and WareHouse_Code='" + Common.currentMaster + @"' and statusflag=1) hp on c.helper= hp.Code
                                left join SysUser su on c.User_Code=su.Code where  c.WareHouse_Code in (" + currentGroup + @") and (c.Code like '%" + txtSearch + @"%' or c.UserName like '%" + txtSearch + @"%'
                              or c.CustomerName like '%" + txtSearch + @"%')" + txtCreateTime + @" and (su.UserLevelPoint<" + currentLevel + @" or su.code='"+currentUserCode+@"') )
                              a WHERE  Row >= " + ((row * page) - (row - 1)) + " AND Row <= " + (row * page) + @" order by " + txtsort + " " + txtorder + @",CreateTime Asc;
                                 select count(*) as icount,sum(c.Price) as Price,sum(c.PayMoney) as PayMoney,sum(c.LeftMoney) as LeftMoney  from Contract c left join SysUser su on c.User_Code=su.Code
                              where  c.WareHouse_Code in (" + currentGroup + @") and (c.Code like '%" + txtSearch + @"%' or c.UserName like '%" + txtSearch + @"%'  
                              or c.CustomerName like '%" + txtSearch + @"%')" + txtCreateTime + @" and (su.UserLevelPoint<" + currentLevel+" or su.code='"+currentUserCode+"')" ;
             
            QueryCommand cmd = new QueryCommand(txtsql);
            DataTable dt = DataService.GetDataSet(cmd).Tables[0];
            DataTable dt1 = DataService.GetDataSet(cmd).Tables[1];
            totalcount =int.Parse(dt1.Rows[0]["icount"].ToString());
            Price = dt1.Rows[0]["Price"].ToString();
            PayMoney = dt1.Rows[0]["PayMoney"].ToString();
            LeftMoney = dt1.Rows[0]["LeftMoney"].ToString();
            return dt;// q.Paged(page, row).ExecuteDataSet().Tables[0];
        }

        public DataTable getList3(out int totalcount, string txtSearch)
        {
            int row = int.Parse(Request["rows"]);
            int page = int.Parse(Request["page"].ToString());
            SqlQuery q = new Select().From(Partner.Schema).Where("WareHouse_Code").In(currentGroups).AndExpression("CustomerName").Like("%" + txtSearch + "%").Or("Mobile").Like("%"+txtSearch+"%").Or("UserName").Like("%" + txtSearch + "%").OrderDesc("CreateTime");
            totalcount = q.GetRecordCount();
            return q.Paged(page, row).ExecuteDataSet().Tables[0];
        }

        public void gridbind(string txtSearch) { 
            int totalcount = 0;
            DataTable newList = getList(out totalcount, txtSearch);
            renderData("{\"rows\":" + JSON.Encode(newList) + ",\"total\":" + totalcount + "}");
        }
        public void menugridbind(string txtSearch)
        { 
            int totalcount = 0;
            DataTable newList = getList(out totalcount, txtSearch);
            renderData("{\"rows\":" + JSON.Encode(newList) + ",\"total\":" + totalcount + "}");
        }

        public void gridbind2(string txtSearch)
        {
            int totalcount = 0;
            string totlaPrice = "", totlaPayMoney = "", totlaLeftMoney = "";
            DataTable newList = getList2(out totalcount, out totlaPrice, out totlaPayMoney,out totlaLeftMoney, txtSearch);

            string txtfooter = "[{\"ContractContent\":\"合计:\",\"Price\":\"￥" + totlaPrice + "\",\"PayMoney\":\"￥" + totlaPayMoney + "\",\"LeftMoney\":\"￥" + totlaLeftMoney + "\"}]";
            renderData("{\"rows\":" + JSON.Encode(newList) + ",\"total\":" + totalcount + ",\"footer\":" + txtfooter + "}");
        }
        public void gridbind3(string txtSearch)
        {
            int totalcount = 0;
            DataTable newList = getList3(out totalcount, txtSearch);
            renderData("{\"rows\":" + JSON.Encode(newList) + ",\"total\":" + totalcount + "}");
        }
        public string doValidate() {
            return "";
        }
         
         
    }
}