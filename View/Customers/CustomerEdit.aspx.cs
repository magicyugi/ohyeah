using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox.View.Customers
{
    public partial class CustomerEdit : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string define = "";
            SqlQuery q = new Select().From<CustomerDetail>().Where("CTextCount").IsNotNull().And(CustomerDetail.WareHouseCodeColumn).IsEqualTo(Common.currentMaster);
            DataTable dt=q.ExecuteDataSet().Tables[0];
            int starindex = 4, tabindex=0;
            if (dt.Rows.Count!=0)
                for (int i=1;i< int.Parse( dt.Rows[0]["CTextCount"].ToString())+1;i++) {
                    tabindex = (starindex + i - 1);
                    define += "<li  class='normalli'> <label for='txtCText" + i + "'  >" + dt.Rows[0]["CText" + i].ToString() + ":</label><input type='text' tabindex='"+tabindex+"' name='CText" + i + "' id='txtCText" + i + "' class='fieldItem' field='CText" + i + "'  /></li>";
                }

            define += @"<li class='metrouicss' style='width:80%'  >
                        <div   style='float:left;width:100%; font-size:20px;text-align:center;'> 
                             <input  type='button' id='btnlast'  name='btnlast'  value='上一页'  tabindex='" + (tabindex + 2) + @"'  onclick='btnclick(divtabs,0,customerul)'   class='fg-color-white bg-color-blue'/>
                             <input  type='button' id='btnnext1'  name='btnnext1'  value='下一页'  tabindex='" + (tabindex + 1) + @"'  onclick='btnclick(divtabs,2,basicul)'   class='fg-color-white bg-color-blue' />
                        </div>
                    </li>";
            customerDefine.InnerHtml = define;
        }
    }
}