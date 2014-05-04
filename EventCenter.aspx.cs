using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using System.Data;

namespace AppBox
{
    public partial class EventCenter : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lbUserName.InnerText = Common.currentUser;
            //lbTime.InnerText = Common.currentWareHouseName;
            if (Common.currentUser == "") Response.Redirect("Login.aspx");
             
        }

       
    }
}