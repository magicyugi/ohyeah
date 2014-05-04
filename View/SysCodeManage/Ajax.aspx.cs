using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic; 
using System.Data;
using System.Collections;

namespace AppBox.View.SysCodeManage
{
    public partial class Ajax : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["type"] == "Role")
            {
                renderData(Common.btnRole("", Request["RoleCode"]));
            }
            else if (Request["type"] == "dropdown")
            {
                string category = (int.Parse(Request["category"]) - 1) <= 0 ? "" : (int.Parse(Request["category"]) - 1).ToString();
                string[] tableCollection = { "SysCode" };
                string[] whereCollection = { " where category='CustomerLevel" + category + "' and statusflag=1 and warehouse_code='" + currentMaster + "' " };
                renderData(getDrop(tableCollection, whereCollection));
            }
            else if (Request["type"] == "deletegrid")
            {
                string txtsql = "";
                if (Request["isPcode"] == "P")
                    txtsql = @"delete from customerlevel where Level_Code='" + Request["pcode"] + "' and warehouse_code in(" + currentGroup + ") ;delete from syscode where id=" + Request["txtid"] + " or (pcode='" + Request["pcode"] + "' and warehouse_code='" + currentMaster + "');";

                else
                    txtsql = "delete from customerlevel where Code=(select Code from syscode where id=" + Request["txtid"] + ") and level_code=(select PCode from syscode where id=" + Request["txtid"] + ") and warehouse_code in(" + currentGroup + ");delete from syscode where id=" + Request["txtid"];
                       
                DBUtil.Execute(txtsql);
                renderData("删除成功!");
            }
            else if (Request["type"] == "precent")
            {
                string[] txtid = Request["txtid"].Split(',');
                string[] txtvalue = Request["txtvalue"].Split(',');
                for (int i = 0; i < txtid.Length-1; i++) {
                    SysCode model = new SysCode("ID", txtid[i]);
                    model.Remark2 = txtvalue[i];
                    model.Save();
                }
                renderData("success");
            }
            else if (Request["type"] == "LevelGrid")
            {
                ArrayList dt = DBUtil.Select(@"select a.ID,b.id as pid,a.Code,a.VCode,a.Cname,a.StatusFlag,b.Cname as Pname,b.code as Pcode,b.Remark1 as PRemark1,a.Remark1,a.Remark2,b.Remark2 as precent,a.BindModule from SysCode a
left JOIN (select id,cname,Code,Remark1,Remark2
 from SysCode where Category='CustomerLevel" + Request["category"] + @"' and WareHouse_Code='" + currentMaster + @"') b
on a.Pcode=b.Code
where a.Category='CustomerLevelSon" + Request["category"] + @"' 
AND a.WareHouse_Code='" + currentMaster + @"' and a.StatusFlag=1  ORDER BY b.Remark1,a.Remark1");
                Response.Write("{\"rows\":" + JSON.Encode(dt) + "}");
            }
            else if (Request["type"] == "getLevel")
            {
                string txtsql = @"select * from (select top 1 ID,Code,VCode,Cname,StatusFlag,'' as pname,'' as Pcode,KeyFlag as PRemark1,
Remark1,Remark2,BindModule from SysCode where Category='CustomerLevel" + Request["level"] + @"' and code='" + Request["pcode"] + @"' AND WareHouse_Code='" + currentMaster + @"'
order by Remark1 desc) as sys
UNION all
select * from (select a.ID,a.Code,a.VCode,a.Cname,a.StatusFlag,b.Cname as Pname,b.code as Pcode,b.Remark1 as PRemark1,
a.Remark1,Remark2,BindModule from SysCode a
left JOIN (select cname,Code,Remark1
 from SysCode where Category='CustomerLevel" + Request["level"] + @"' and WareHouse_Code='" + currentMaster + @"') b
on a.Pcode=b.Code
where a.Category='CustomerLevelSon" + Request["level"] + @"'  AND a.Pcode='" + Request["pcode"] + @"'
AND a.WareHouse_Code='" +currentMaster+@"' and a.StatusFlag=1 ) as b
 ORDER BY PRemark1,Remark1";
               ArrayList dt = DBUtil.Select(txtsql);
               Response.Write(JSON.Encode(dt));
            }
            else if (Request["type"] == "getPLevel")
            {
                ArrayList dt = DBUtil.Select("select * from syscode where category='CustomerLevel" + Request["level"] + @"' and warehouse_code='" + currentMaster + @"'");
                Response.Write(JSON.Encode(dt));
            }
            else if (Request["type"] == "savelevel")
            {

                if (Request["txtpname"] == "") { renderData("fail:请输入名称!"); }
                string txtsql = "";
                string pcode = "";
                if (Request["hdnid"] != "")
                {
                    SysCode sc = new SysCode("ID", Request["hdnid"]);
                    pcode = sc.Code;
                    sc.Cname = Request["txtpname"];
                    sc.Remark1 = Request["txtpRemark1"];
                    sc.KeyFlag = int.Parse(Request["txtpFlag"]);
                    sc.StatusFlag = int.Parse(Request["txtpStatusFlag"]);
                    sc.Save();
                }
                else
                {
                    pcode = SqlDal.GetSelectCode("SysCode", "", Common.currentMaster);
                    int q = new Insert().Into(SysCode.Schema, "WareHouse_Code",
                    "Code", "VCode", "Cname", "Category", "Pcode", "CategoryName", "IsAdminCode", "StatusFlag", "BindModule", "Remark1", "Remark2", "KeyFlag", "stepflag").
                    Values(
                    currentMaster,
                    pcode,
                    pcode,
                    Request["txtpname"].ToString(),
                    "CustomerLevel" + Request["level"].ToString(),
                    "",
                    Request["levelname"].ToString(),
                     0,
                     int.Parse(Request["txtpStatusFlag"].ToString()),
                     "",
                     Request["txtpRemark1"].ToString(),
                     "",
                     int.Parse(Request["txtpFlag"]),
                     0
                    ).Execute();
                }
                txtsql += "delete from syscode where Pcode='" + pcode + "' and warehouse_code='" + currentMaster + "' and category='CustomerLevelSon" + Request["level"].ToString() + "';";
                for (int i = 1; i < 11; i++)
                {
                    if (Request["txtCname_" + i] != "")
                    {
                        string code = SqlDal.GetSelectCode("SysCode", "", Common.currentMaster);
                        txtsql += @"insert into SysCode (WareHouse_Code,Code, VCode, Cname, Category, Pcode, CategoryName, IsAdminCode, StatusFlag, BindModule, Remark1, Remark2, KeyFlag,stepflag)
                                   values ('" + currentMaster + "','" + code + "','" + code + "','" + Request["txtCname_" + i] + "','CustomerLevelSon" + Request["level"].ToString() + "','" + pcode + "','" + Request["levelname"].ToString() + "子级',0," + Request["txtStatusFlag_" + i] + ",'" + Request["txtBind_" + i] + "','" + Request["Remark1_" + i] + "','" + Request["Remark2_" + i] + "',0,0)";
                    }
                }
                if (!txtsql.Contains("insert")) {
                    string code = SqlDal.GetSelectCode("SysCode", "", Common.currentMaster);
                    txtsql += @"insert into SysCode (WareHouse_Code,Code, VCode, Cname, Category, Pcode, CategoryName, IsAdminCode, StatusFlag, BindModule, Remark1, Remark2, KeyFlag,stepflag)
                                   values ('" + currentMaster + "','" + code + "','" + code + "','" + Request["txtpname"].ToString() + "','CustomerLevelSon" + Request["level"].ToString() + "','" + pcode + "','" + Request["levelname"].ToString() + "子级',0,1,'','1','',0,0)";
                }
                DBUtil.Execute(txtsql);
                renderData("保存成功!");
            }
            if(Request["key"]!=null)
                if (Request["key"].ToString() == "LoadGrid")
                {
                    SetAjaxGrid();
                }
            
            else if (Request["key"] != null && Request["id"] != null && Request["key"].ToString() == "DGrid" && Request["id"] != "")
            {
                SetAjaxDGrid(Request["id"].ToString());
            }
            else if (Request["key"] != null && Request["id"] != null && Request["key"].ToString() == "PGrid" && Request["id"] != "")
            {
                SetAjaxPGrid(Request["category"]);
            }
            else if (Request["key"] != null && Request["id"] != null && Request["pid"] != null
                && Request["key"].ToString() == "del" && Request["id"] != "" && Request["pid"] != "")
            {
                string id = Request["id"].ToString();
                SysCode.Delete("ID",id);
                if (Request["type"]!=null)
                    SetAjaxPGrid(Request["category"]);
                else
                    SetAjaxDGrid(Request["pid"].ToString());
            } 
            else if (Request["key"].ToString() == "insert")
            {
                if (Request["txtCname"] == null || Request["txtCname"] == "")
                { renderData("fail:请输入名称!"); }
                int iCount = new Select().From(SysCode.Schema).Where(SysCode.CnameColumn).IsEqualTo(Request["txtCname"]).And(SysCode.CategoryColumn).IsEqualTo(Request["txtCategory"]).And(SysCode.WareHouseCodeColumn).IsEqualTo(currentMaster).GetRecordCount();
                if (iCount != 0) { renderData("fail:该名称已有重复!"); return; }
                if (Request["SType"] != "")
                { if (Request["hdnRemark1"] == "") { renderData("fail:请选择步骤!"); return; } }
                if (Request["txtModule"] != "") { iCount = DBUtil.Select("select * FROM SysCode where BindModule='" + Request["txtModule"] + "' AND WareHouse_Code='" + currentMaster + "'").Count; if (iCount != 0) { renderData("fail:该模块已有绑定!"); return; } }
                try
                {
                string code = SqlDal.GetSelectCode("SysCode", "", currentMaster),
                       pcode = Request["Pcode"],
                       txtremark1 = "",
                       txtremark2 = "",
                       txtkeyflag="",
                       txtmodul="";
                if (Request["hdnRemark2"] != "")
                    txtremark2 = Request["hdnRemark2"];
                if (Request["hdnRemark1"] != "")
                    txtremark1 = Request["hdnRemark1"];
                if (Request["txtFlag"] != "")
                    txtkeyflag = Request["txtFlag"];
                if (Request["txtModule"] != "")
                    txtmodul = Request["txtModule"];
                if (Request["SType"] == "")
                    pcode = code;
                //string txtcategory = (int.Parse(Request["SType"]) - 1) <= 0 ? "" : (int.Parse(Request["SType"]) - 1).ToString();
                int q = new Insert().Into(SysCode.Schema,"WareHouse_Code",
                    "Code", "VCode", "Cname", "Category", "Pcode", "CategoryName", "IsAdminCode", "StatusFlag", "BindModule", "Remark1", "Remark2", "KeyFlag", "stepflag").
                    Values(
                    currentMaster,
                    code,
                    (Request["txtVCode"] == null ? code : Request["txtVCode"].ToString()),
                    Request["txtCname"].ToString(),
                    Request["txtCategory"].ToString(),
                    pcode,
                     Request["txtCategoryName"].ToString(),
                     0,
                     int.Parse( Request["txtStatusFlag"].ToString()),
                     txtmodul,
                     txtremark1,
                     txtremark2,
                     txtkeyflag,
                     0
                    ).Execute();
                Response.Write("success");
                }
                catch (Exception exc)
                {
                    Response.Write(exc.Message);
                }
            }
            else if (Request["key"].ToString() == "update")
            {
                if (Request["txtCname"] == null || Request["txtCname"] == "")
                { renderData("fail:请输入名称!"); }
                if (Request["SType"] != "")
                { if (Request["hdnRemark1"] == "") { renderData("fail:请选择步骤!"); return; } }
                int iCount = new Select().From(SysCode.Schema).Where(SysCode.CnameColumn).IsEqualTo(Request["txtCname"]).And(SysCode.CodeColumn).IsNotEqualTo(Request["txtCode"]).And(SysCode.CategoryColumn).IsEqualTo(Request["txtCategory"]).And(SysCode.WareHouseCodeColumn).IsEqualTo(currentMaster).GetRecordCount();
                if (iCount != 0) { renderData("fail:该名称已有重复!"); return; }
                if (Request["txtModule"] != "") { iCount = DBUtil.Select("select * FROM SysCode where BindModule='" + Request["txtModule"] + "' AND WareHouse_Code='" + currentMaster + "' and Code<>'" + Request["txtCode"] + "'").Count; if (iCount != 0) { renderData("fail:该模块已有绑定!"); return; } }
                try
                {
                    SysCode model = new SysCode("ID", Request["txtID"].ToString());
                    //model.VCode = (Request["txtVCode"] == null ? "" : Request["txtVCode"].ToString());
                    model.Cname = Request["txtCname"].ToString();
                    model.StatusFlag = int.Parse(Request["txtStatusFlag"].ToString());
                    if (Request["SType"] != "")
                        model.Pcode = Request["Pcode"];
                    if (Request["hdnRemark1"] != "")
                        model.Remark1 = Request["hdnRemark1"]; 
                    if (Request["hdnRemark2"]!="")
                        model.Remark2 = Request["hdnRemark2"];
                    if (Request["txtFlag"] != "")
                        model.KeyFlag = int.Parse(Request["txtFlag"].ToString());
                    if (Request["txtModule"] != "")
                        model.BindModule = Request["txtModule"];
                    model.Save();
                    Response.Write("success");
                }
                catch (Exception exc)
                {
                    Response.Write(exc.Message);
                }
            }
        }

        void SetAjaxGrid()
        {
            Query q = new Query("SysCode");
          ///  SqlQuery q= new Select().From("SysCode").Where("").IsEqualTo("").And("").IsEqualTo("");
            DataTable dt = q.AddWhere("Category", "system").AddWhere("StatusFlag", "1").AddWhere("StepFlag", "0")
              .ExecuteDataSet().Tables[0];
            Response.Write("{\"rows\":" + JSON.Encode(dt) + "}");
        }

        void SetAjaxDGrid(string pcode)
        {
            //Query q = new Query("SysCode");
            //DataTable dt = q.AddWhere("Category", pcode).WHERE("StatusFlag<>0").AddWhere("WareHouse_Code", currentMaster).WHERE("Code>0")
            //  .ExecuteDataSet().Tables[0];
            string txtsql = @"select * from syscode where Category='" + pcode + "' and statusflag<>0  and warehouse_code='" + currentMaster + "'";
            if (pcode == "CustomerLevel" || pcode == "CustomerLevel1" || pcode == "CustomerLevel2")
                txtsql += " ORDER BY Remark1";
            ArrayList dt = DBUtil.Select(txtsql); 
            Response.Write("{\"rows\":" + JSON.Encode(dt) + "}");
         }
        void SetAjaxPGrid(string category)
        {
            category = (int.Parse(category) - 1) <= 0 ? "" : (int.Parse(category) - 1).ToString();
            ArrayList dt = DBUtil.Select(@"select a.ID,a.Code,a.VCode,a.Cname,a.StatusFlag,b.Cname as Pname,b.code as Pcode,b.Remark1 as PRemark1,a.Remark1,Remark2 from SysCode a
left JOIN (select cname,Code,Remark1
 from SysCode where Category='CustomerLevel" + category + @"' and WareHouse_Code='" + currentMaster + @"') b
on a.Pcode=b.Code
where a.Category='CustomerLevelSon" + category + @"' 
AND a.WareHouse_Code='" + currentMaster + @"' and a.StatusFlag=1  ORDER BY b.Remark1,a.Remark1"); 
            Response.Write("{\"rows\":" + JSON.Encode(dt) + "}");
        }
    }
}