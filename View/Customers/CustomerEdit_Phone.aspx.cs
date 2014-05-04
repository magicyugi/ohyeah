using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox.View.Customers
{
    public partial class CustomerEdit_Phone : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string define = "";
            string warehouse = "";
            DataTable dt1 = new Select(WareHouse.PCodeColumn).From<WareHouse>().Where("Code").IsEqualTo(Request["WarehouseCode"]).ExecuteDataSet().Tables[0];
            if (dt1.Rows.Count > 0)
            {
                warehouse = dt1.Rows[0]["PCode"].ToString();
            }
            //addr.Value= Request["addr"].ToString();
            SqlQuery q = new Select().From<CustomerDetail>().Where("CTextCount").IsNotNull().And(CustomerDetail.WareHouseCodeColumn).IsEqualTo(warehouse);
            DataTable dt=q.ExecuteDataSet().Tables[0];
            int starindex = 4, tabindex=0;
            if (dt.Rows.Count!=0)
                for (int i=1;i< int.Parse( dt.Rows[0]["CTextCount"].ToString())+1;i++) {
                    tabindex = (starindex + i - 1);
                    define += @"<div class='control-group'>
                                   <label class='control-label'>" + dt.Rows[0]["CText" + i].ToString() + @":</label>
                                   <div class='controls'> 
									    <input type='text' class='span6 m-wrap fieldItem' name='CText" + i + @"'  id='txtCText" + i + @"'   field='CText" + i + @"'>  
								   </div>
                               </div>";
                   // define += "<li  class='normalli'> <label for='txtCText" + i + "'  >" + dt.Rows[0]["CText" + i].ToString() + ":</label><input type='text' tabindex='"+tabindex+"' name='CText" + i + "' id='txtCText" + i + "' class='fieldItem' field='CText" + i + "'  /></li>";
                }
            tab2.InnerHtml = define;
//            define += @"<li class='metrouicss' style='width:80%'  >
//                        <div   style='float:left;width:100%; font-size:20px;text-align:center;'> 
//                             <input  type='button' id='btnlast'  name='btnlast'  value='上一页'  tabindex='" + (tabindex + 2) + @"'  onclick='btnclick(divtabs,0,customerul)'   class='fg-color-white bg-color-blue'/>
//                             <input  type='button' id='btnnext1'  name='btnnext1'  value='下一页'  tabindex='" + (tabindex + 1) + @"'  onclick='btnclick(divtabs,2,basicul)'   class='fg-color-white bg-color-blue' />
//                        </div>
//                    </li>";
//            customerDefine.InnerHtml = define;
        }
    }
}