using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Portfolio.Account
{
    public partial class Admin : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["UniPortfolioDBConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("../Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAdminDashboardStats();
            }
        }

        private void LoadAdminDashboardStats()
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Isinama na rito ang PortfolioUrl, Education, Skills, at Hobbies
                string query = "SELECT UserId, FirstName + ' ' + Surname AS FullName, Username, Email, ContactNumber, Role, Headline, PortfolioUrl, Education, Skills, Hobbies FROM Users";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            int totalUsers = dt.Rows.Count;
            int totalStudents = 0;
            int totalAdmins = 0;

            foreach (DataRow row in dt.Rows)
            {
                string role = row["Role"].ToString();
                if (role == "Student") totalStudents++;
                else if (role == "Admin") totalAdmins++;
            }

            lblTotalUsers.Text = totalUsers.ToString();
            lblTotalStudents.Text = totalStudents.ToString();
            lblTotalAdmins.Text = totalAdmins.ToString();

            gvUsers.DataSource = dt;
            gvUsers.DataBind();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("../Default.aspx");
        }
    }
}