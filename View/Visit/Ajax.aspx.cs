using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;
using System.Collections;

namespace AppBox.View.Visit
{
    public partial class Ajax :Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //回访记录
            if (Request["type"] == "visit")
            {
                string result =  "";
                string process = ""; 
                string month = "";
                
                SqlQuery q;
                 DataTable vlog= null;
                if(Request["customer"]=="")
                    q=new Select().From<VisitLog>().OrderAsc("VisitProcess");
                   // vlog = new Select().From<VisitLog>().OrderAsc("VisitProcess").ExecuteDataSet().Tables[0];
                else
                    q = new Select().From<VisitLog>().Where("Code").IsEqualTo(Request["customer"]).OrderDesc("VisitDate");
                   // vlog = new Select().From<VisitLog>().Where("Code").IsEqualTo(Request["customer"]).OrderAsc("VisitProcess").ExecuteDataSet().Tables[0];
                if (Request["value"] != null)
                {
                    q.And(VisitLog.CnameColumn).Like("%" + Request["value"] + "%").Or(VisitLog.MobileColumn).Like("%" + Request["value"] + "%").Or(VisitLog.AddressColumn).Like("%" + Request["value"] + "%");
                }
                if (!string.IsNullOrEmpty(Request["statusflag"])) 
                {
                    q.And(VisitLog.StatusFlagColumn).IsEqualTo(Request["statusflag"]);
                }
                vlog = q.ExecuteDataSet().Tables[0];
                for (int i = 0; i < vlog.Rows.Count; i++)
                {
                    
                    string desc = "";
                    string txtdesc = "";
                    string id = "";
                    DataRow dr = vlog.Rows[i];
                    DateTime date = DateTime.Parse(dr["VisitDate"].ToString());
                    id = dr["ID"].ToString();
                    string txtjs = " &nbsp;&nbsp;&nbsp;&nbsp <input type='button' value='添加批注' style='float:left;margin-left:20px;font-size:12px;padding:3px;color:red' id='" + id + "'  class='alertdesc' />";
                    txtdesc = dr["VisitDesc"].ToString();
                    
                     
                    if (txtdesc!="")
                    {
                        string dd = dr["VisitDescDate"].ToString().Substring(2, 9);
                        txtjs = "&nbsp&nbsp&nbsp&nbsp<label style='color:red'>(已批注)</label>";
                        desc = "<br/><label style='color:red'>" + dd + "</label><br/><label style='color:red'>批注：" + txtdesc + "</label>";
                    }
                    
                    process = dr["VisitProcess"].ToString();
                    if (month == "")
                    {
                        month = date.Year + "." + date.Month;
                        result += @"<div class='history-date'><ul>	<h2> <a>" + month + @"           </a></h2>";
                    }
                    else if (month != date.Year + "." + date.Month)
                    {
                        month = date.Year + "." + date.Month;
                        result += @"</ul> </div><div class='history-date'><ul><h2>
                        <a >" + month + @"</a></h2>";
                    }
                    result += @"<li class='green bounceInDown'  >
                        <h3>" + date.Month + "." + date.Day + "<span>" + date.Hour + ":" + date.Minute + @"</span></h3>
                        <dl>
                        <dt  >"
                        + "<div style='font-size:14px;cursor:pointer;width:200px;'  > <span  class='alertTitle' style='float:left' > " + dr["VisitTitle"].ToString() + "  ▼  " + "</span>" + txtjs
                        //<dt>【" + dr["CustomerName"].ToString() + "】" + dr["VisitTitle"].ToString()
                        //+ "<div class='metrouicss'><button class='bg-color-white fg-color-red'><i class='icon-clock' style='font-size:24px'></i>设置提醒</button><button class='bg-color-white fg-color-blue'><i class='icon-phone' style='font-size:24px'></i>回访登记</button></div>
                        + "</div>"
                        + "<div style='word-warp:break-word;word-break:break-all;font-size:12px; float:left; width:200px;display:none;' >" + dr["VisitContent"].ToString()
                        + desc
                        +"</div></dt>  </dl> </li> ";
                    if (i == vlog.Rows.Count - 1) result += "</ul> </div>";
                } 
                renderData(result);
            }
            if (Request["type"] == "Role")
            {
                renderData(Common.btnRole("", Request["RoleCode"]));
            }
                //售前,售中,售后
            else if (Request["type"] == "PGrid")
            {
                string ProcessFlag="1";
                if (Request["Code"] != "")
                {
                    DataTable flagdt = SqlDal.RunSqlExecuteDT("select ProcessFlag from customer where code='" + Request["Code"] + "'");
                    ProcessFlag = flagdt.Rows[0]["ProcessFlag"].ToString(); 
                }
                    string txtcategory = "";
                if (ProcessFlag == "2") txtcategory = "1";
                else if (ProcessFlag == "3") txtcategory = "2";
                string txtcustomer = "", txtselect = "";
                if (Request["txtcategory"] != null) txtcategory = Request["txtcategory"];//给定判断值
                if (Request["Code"] != "")
                {
                    txtselect += ",cl.Code as clCode";
                    txtcustomer += " left join (select * from CustomerLevel where category='CustomerLevel"+txtcategory+"' and Customer_Code='" + Request["Code"] + @"') cl ON a.Code=cl.Code ";
                    
                }
                ArrayList dt = DBUtil.Select(@"select a.ID,a.Code,a.VCode,a.Cname,a.StatusFlag,b.Cname as Pname,b.code as Pcode,b.Remark1,cast(isnull(b.Remark2,1)/isnull(c.txtcount,0) AS DECIMAL(18,2)) as score,a.Remark2" + txtselect + @" from SysCode a
                left JOIN (select cname,Code,Remark1,(case when remark2='' then 1 else cast(isnull(Remark2,1) AS DECIMAL(18,2)) END ) as Remark2
                    from SysCode where Category='CustomerLevel" + txtcategory + "' and WareHouse_Code='" + currentMaster + @"') b
                on a.Pcode=b.Code left join (SELECT Count(*) as txtcount,Pcode from SysCode where Category='CustomerLevelSon" +txtcategory+@"' 
                and WareHouse_Code='"+currentMaster+@"'
                group by Pcode) c
                ON a.Pcode=c.Pcode" + txtcustomer + @"
                where a.Category='CustomerLevelSon" +txtcategory+@"' 
                AND a.WareHouse_Code='" + currentMaster + @"' and a.StatusFlag=1 ORDER BY b.Remark1");
                Response.Write("{\"rows\":" + JSON.Encode(dt) + "}");
            }
            
            //下拉菜单获取
            else if (Request["type"] == "dropdown")
            {
                string[] tableCollection = { "SysCode", "SysCode", "SysCode", "SysCode", "SysCode", "SysCode"  };
                string[] whereCollection = { " where Category='VisitType' and Warehouse_Code='" + Common.currentMaster + "'  and statusflag=1 ", " where Category='Process' and Warehouse_Code='" + Common.currentMaster + "'  and statusflag=1 ", " where Category='CustomerLevel' and Warehouse_Code='" + Common.currentMaster + "'  and statusflag=1 ", " where Category='Stylist' and Warehouse_Code='" + Common.currentMaster + "'  and statusflag=1", " where Category='Helper' and Warehouse_Code='" + Common.currentMaster + "'  and statusflag=1", " where category='IntentionLevel'  and warehouse_code='" + Common.currentMaster + "' " };
                renderData(getDrop(tableCollection, whereCollection));
            }
            //放弃客户的原因保存
            else if (Request["type"] == "reason")
            {
                addVisitLog();
                string code =  Request["Code"] ;
                Customer cust = new Customer("code", code);
                cust.DropReason = Request["reason"];
                cust.VisitDate = DateTime.Now;
                cust.Guide = "";
                cust.GuideCode = "";
                cust.VisitTime = cust.VisitTime + 1;
                cust.IntentionFlag = 2;
                cust.Save();
                Alert.Delete("code", code);
                renderData("success");
            }
            //转为售后客户
            else if (Request["type"] == "setstatusflag")
            { 
                string code = Request["Code"];
                Customer cust = new Customer("code", code);
                cust.ProcessFlag = 3;
                cust.Save();
                DataTable dt = SqlDal.RunSqlExecuteDT("select * from syscode where category='CustomerLevel2' and warehouse_code='"+currentMaster+"' and remark1='1'");
                if (dt.Rows.Count != 0)
                {
                    DBUtil.Execute("insert into CustomerLevel values('','" + currentWareHouse + "','" + dt.Rows[0]["Code"].ToString() + "','" + dt.Rows[0]["Cname"].ToString() + "','" + cust.Code + "','" + cust.Cname + "','0','售后未联系客户',0,1,'CustomerLevel2')");
                }
                renderData("success");
            }
            //获取客户明细
            else if (Request["type"] == "detail")
            {
                string txtsql=@"select c.*,a.cname as VisitTitle,ct.PayMoney,su.cname as CustomerLevelName  from customer c left join alert a on c.code=a.code LEFT JOIN (SELECT * FROM Contract where ID in (SELECT max(ID) as ID 
                from Contract group BY Customer_Code)) ct ON c.Code=ct.Customer_Code  left join  syscode su on c.customerlevel=su.code and su.category='IntentionLevel'  and su.warehouse_code='" + Common.currentMaster + "' where c.code='" + Request["Code"] + "'";
                //DataTable detail = new Select().From<Customer>().Where("Code").IsEqualTo(Request["Code"]).ExecuteDataSet().Tables[0];
                QueryCommand cmd = new QueryCommand(txtsql);
                DataTable dt = DataService.GetDataSet(cmd).Tables[0];
                renderData(JSON.Encode(dt));
            }
            //添加新回访记录
            else if (Request["type"] == "add")
            {
                if (Request["txtValue"] == "") renderData("fail:请选择客户评级！");
                addVisitLog(); 
                string[] txtsplit=Request["txtValue"].Split(',');
                string code = Request["Code"];
                Alert.Delete("code", code);
                Alert al = new Alert();
                al.WareHouseCode = currentWareHouse;
                al.Code = Request["Code"];
                al.CustomerName = Request["Cname"];
                al.CreateDate = DateTime.Now;
                al.Creater = Common.currentUser;
                al.MsgFlag = int.Parse(Request["MsgFlag"]=="on"?"1":"0");
                al.Mobile = Request["Mobile"];
                al.StartDate = DateTime.Parse(Request["NextVisitDate"]);
                al.Cname = Request["NextVisitContent"];
                al.AlertContent = Request["NextVisitContent"];
                al.Hour = int.Parse(Request["HM"].Split(':')[0]);
                al.Minute = int.Parse(Request["HM"].Split(':')[1]);
                al.CustomerLevel = txtsplit[txtsplit.Length - 2].Split('-')[0];
               // CustomerLevel.Delete("Customer_Code", Request["Code"]);
                
                Customer customer = new Customer("code", Request["Code"]);
                customer.VisitDate = DateTime.Now;
                string txtcategory = "CustomerLevel";
                if (customer.ProcessFlag == 2) txtcategory = "CustomerLevel1";
                else if (customer.ProcessFlag == 3) txtcategory = "CustomerLevel2";
                //customer.CreditLevel = int.Parse(Request["CustomerLevel"] == "" ? "0" : Request["CustomerLevel"]);
                //删除 
                DBUtil.Execute("delete from CustomerLevel where Customer_Code='" + Request["Code"] + "' and category='" + txtcategory + "'");
                if (Request["CustomerLevel"] != "")
                {
                    customer.CustomerLevel = Request["CustomerLevel"];
                    //for (int i = 0; i < txtsplit.Length - 1; i++)
                    //{ 
                    //    string[] txtrows = txtsplit[i].Split('-');
                    //    CustomerLevel cl = new CustomerLevel();
                    //    cl.WareHouseCode = currentWareHouse;
                    //    cl.LevelCode = txtrows[0];
                    //    cl.LevelName = txtrows[1];
                    //    cl.Code = txtrows[2];
                    //    cl.Cname = txtrows[3];
                    //    cl.CustomerCode = customer.Code;
                    //    cl.CustomerName = customer.Cname; 
                    //    cl.Category = txtcategory;
                    //    cl.StatusFlag = 1;
                    //    cl.Save();
                    //}
                }
                customer.CreditLevel = int.Parse(Request["Score"]);
                customer.AlertDate1 = DateTime.Parse(Request["NextVisitDate"]).AddHours(int.Parse(Request["HM"].Split(':')[0])).AddMinutes(int.Parse(Request["HM"].Split(':')[1]));
                if (customer.VisitTime == null || customer.VisitTime.ToString() == "")
                    customer.VisitTime = 1;
                else
                    customer.VisitTime = customer.VisitTime + 1; 
                customer.Save(); 
                al.Save(); 
                renderData("success");
            }
            else if (Request["type"] == "getsalebill")
            {
                string salebillcode = Request["SaleBill_Code"], code = Request["code"];
                string txtvalue = "";
                Contract ct = new Contract("SaleBill_Code", salebillcode);
                Alert al = new Alert("Code",ct.CustomerCode);
                VisitLog vl = new VisitLog("Code", ct.CustomerCode);
                txtvalue += ct.Code + "|" + vl.VisitTypeCode + "|" + ct.SendDate + "|" + al.StartDate + "|" + al.UseTime + "|" + al.Cname + "|" + ct.ContractContent + "|" + ct.ContractUrl + "|" + ct.Helper + "|" + ct.Stylist+"|"+ct.PayMoney+"|"+ct.Price;
                renderData(txtvalue);
            }
            //添加新成交记录
            else if (Request["type"] == "contract")
            {
                string code = Request["Code"];
                //Alert.Delete("code", code);
                //if (string.IsNullOrEmpty(Request["SaleBill_Code"]))
                //{
                //    addVisitLog();
                //}
                //Alert al = new Alert();
                //al.WareHouseCode = currentWareHouse;
                //al.Code = Request["Code"];
                //al.CustomerName = Request["Cname"];
                //al.CreateDate = DateTime.Now;
                //al.Creater = Common.currentUser;
                //al.Mobile = Request["Mobile"];
                //al.StartDate = DateTime.Parse(Request["NextVisitDate"]);
                //al.Cname = Request["NextVisitContent"];
                //al.AlertContent = Request["NextVisitContent"];
                //al.Hour = int.Parse(Request["HM"].Split(':')[0]);
                //al.Minute = int.Parse(Request["HM"].Split(':')[1]);
                //al.Save();
                ContractDetail cd = new ContractDetail();
                Contract ct = new Contract();

                if (!string.IsNullOrEmpty(Request["SaleBill_Code"]) && Request["SaleBill_Code"]!="null"&&Request["SaleBill_Code"]!="undefined")
                {
                    string salebillcode = Request["SaleBill_Code"];
                    ct = new Contract("SaleBill_Code", salebillcode);
                    if (!string.IsNullOrEmpty(Request["ckpay"]))
                    {
                        cd.PayType = "现金";
                        cd.Price = decimal.Parse(Request["Price"] == "" ? "0" : Request["Price"]) - decimal.Parse(Request["PayMoney"] == "" ? "0" : Request["PayMoney"]);
                        cd.PayDate = DateTime.Now;
                        cd.CreateTime = DateTime.Now;
                        cd.Creater = Common.currentUser;
                        cd.Save();
                    }
                   
                }
                else
                {
                    if (Request["salebill"] != null) { 
                        ct.SaleBillCode = Request["salebill"];
                        cd.BillCode = Request["salebill"]; 
                    } 
                    cd.PayType = "现金"; 
                    cd.Price = decimal.Parse(Request["PayMoney"] == "" ? "0" : Request["PayMoney"]);
                    cd.PayDate = DateTime.Now;
                    cd.CreateTime = DateTime.Now;
                    cd.Creater = Common.currentUser;
                    cd.Save();
                    ct.WareHouseCode = currentWareHouse;
                    ct.PayMoney = cd.Price;
                }
                    ct.Helper = Request["helper"];
                    ct.Stylist = Request["stylist"];
                    ct.Code = Request["ContractCode"];
                    ct.ContractContent = Request["ContractContent"];
                    ct.Price = decimal.Parse(Request["Price"]==""?"0":Request["Price"]);
                    ct.CreateTime = DateTime.Now;
                    ct.Creater = Common.currentUser;
                    ct.UserCode = Common.currentUserCode;
                    ct.UserName = Common.currentUser;
                    ct.Mobile = Request["Mobile"];
                    ct.CustomerCode = Request["Code"];
                    ct.CustomerName = Request["Cname"];
                    ct.Creater = Common.currentUser;
                    ct.StatusFlag = 1;
                    ct.CreateTime = DateTime.Now;
                    if (!string.IsNullOrEmpty(Request["SendDate"])) ct.SendDate = DateTime.Parse(Request["SendDate"]);
                    ct.LeftMoney = ct.Price - ct.PayMoney;
                    if (ct.LeftMoney <= 0) ct.PayMentFlag = 3;//判断完成收款
                    else if (ct.LeftMoney >= 0 && ct.LeftMoney <= ct.Price) ct.PayMentFlag = 2;
                    else if (ct.LeftMoney == ct.Price) ct.PayMentFlag = 1;
                    ct.SendFlag = 1;
                    ct.Save();


                    SetCustomerLevel(ct.CustomerCode, "Contract");
                  
                decimal ContractPrice = new Select(Aggregate.Sum("Price")).From(Contract.Schema).Where("Customer_Code").IsEqualTo(Request["code"]).ExecuteScalar<decimal>();
                Customer customer = new Customer("code", Request["Code"]);
                customer.VisitDate = DateTime.Now;
                customer.DealDate = DateTime.Now;
                if (customer.ProcessFlag != 2)
                    customer.CreditLevel = 0;
                //customer.AlertDate1 = DateTime.Parse(Request["NextVisitDate"]);
                //customer.VisitTime = customer.VisitTime + 1;
                customer.ContractMoney = ContractPrice;
                customer.IntentionFlag = 1;
                customer.ProcessFlag = 2;
                if (!string.IsNullOrEmpty(Request["ckdeal"]))
                {

                    customer.ProcessFlag = 3; 
                    DataTable dt = SqlDal.RunSqlExecuteDT("select * from syscode where category='CustomerLevel2' and warehouse_code='" + currentMaster + "' and remark1='1'");
                    if (dt.Rows.Count != 0)
                    {
                        DBUtil.Execute("insert into CustomerLevel values('','" + currentWareHouse + "','" + dt.Rows[0]["Code"].ToString() + "','" + dt.Rows[0]["Cname"].ToString() + "','" + customer.Code + "','" + customer.Cname + "','0','售后未联系客户',0,1,'CustomerLevel2')");
                    }
                }
                else
                {
                    DataTable dt = SqlDal.RunSqlExecuteDT("select * from syscode where category='CustomerLevel1' and warehouse_code='" + currentMaster + "' and remark1='1'");
                    if (dt.Rows.Count != 0)
                    {
                        DBUtil.Execute("insert into CustomerLevel values('','" + currentWareHouse + "','" + dt.Rows[0]["Code"].ToString() + "','" + dt.Rows[0]["Cname"].ToString() + "','" + customer.Code + "','" + customer.Cname + "','0','售中未联系客户',0,1,'CustomerLevel1')");
                    }
                }
                customer.Save();
                if (Request["fileNameList"] != "")
                {
                    string[] fileNames = Request["fileNameList"].Substring(0, Request["fileNameList"].Length - 1).Split(',');
                    foreach (string filename in fileNames)
                    {
                        FileUpload fu = new FileUpload();
                        fu.Code = ct.Code;
                        fu.FileName = filename.Split('.')[0];
                        fu.Url = "../MutiUpload/" + filename;
                        fu.Creater = Common.currentUser;
                        fu.CreateTime = DateTime.Now;
                        fu.ModuleName = "合同附件";
                        fu.Save();
                    }
                }
              
                renderData("success");
            }
        }
        protected void addVisitLog()
        {
            //if (Request["VisitTypeCode"] == "" && Request["type"] != "reason") renderData("fail:请选择本次沟通方式！");
            if (Request["ContractCode"] != "")
            {
                SqlQuery q = new Select().From(Contract.Schema).Where(Contract.CodeColumn).IsEqualTo(Request["ContractCode"]);
                     
                //DataTable dt = q.ExecuteDataSet().Tables[0];
                //if (dt.Rows.Count != 0) { renderData("fail:合同号不能重复!"); return; }
            }
            else{ renderData("fail:请输入合同号！");return;}
            VisitLog vl = new VisitLog();
            vl.WareHouseCode = Common.currentWareHouse;
            vl.Code = Request["Code"];
            vl.Cname = Request["Cname"];
            vl.Address = Request["Address"];
            vl.CustomerName = Request["Cname"];
            vl.Mobile = Request["Mobile"];
            
            vl.CustomerLevel = int.Parse(Request["CustomerLevel"] == null ? "3" : (Request["CustomerLevel"] == "" ? "3" : Request["CustomerLevel"]));
            vl.VisitProcessCode = Request["VisitProcessCode"];
            vl.VisitTypeCode = Request["VisitTypeCode"];
            vl.VisitProcess = Request["VisitProcess"];
            vl.VisitType = Request["VisitType"];
            //vl.VisitCode = currentUserCode;
            vl.VisitName = Common.currentUser;
            vl.VisitTitle = Request["VisitTitle"];
            vl.VisitDate = DateTime.Now;
            if (Request["type"] == "reason")
            {
                vl.VisitTitle = "放弃客户";
                vl.VisitContent = Request["VisitContent"] + "处理结果：放弃客户，原因：" + Request["Reason"];
            }
            else if (Request["type"] == "contract")
                vl.VisitContent = "合同内容:" + Request["ContractContent"];
            else
                vl.VisitContent = Request["VisitContent"];
            vl.StatusFlag = 1;
            vl.Save();  
        }
        public List<Invest> getList(out int totalcount)
        {
            int row = int.Parse(Request["rows"]);
            int page = int.Parse(Request["page"].ToString());
            SqlQuery q = new Select().From<Invest>();
            totalcount = q.GetRecordCount();
            List<Invest> customerList = q.Paged(page, row).ExecuteTypedList<Invest>();
            List<SysCode> syscodeList = new Select().From<SysCode>().ExecuteTypedList<SysCode>();
            List<Invest> newList = new List<Invest>();
            foreach (Invest customer in customerList)
            {
                Invest cs = customer.Clone();
                cs.IndustryTypeCode = syscodeList.Find(c => c.Code == customer.IndustryTypeCode && c.Category == "IndustryType"&&c.StatusFlag==1&&c.WareHouseCode==currentMaster).Cname;
                cs.InvestTypeCode = syscodeList.Find(c => c.Code == customer.InvestTypeCode && c.Category == "InvestType" && c.StatusFlag == 1 && c.WareHouseCode == currentMaster).Cname;
                newList.Add(cs);
            }
            return newList;
        }
    }
}