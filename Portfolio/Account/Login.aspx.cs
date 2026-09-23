using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Portfolio.Account
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["UniPortfolioDBConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserId"] != null)
            {
                RedirectByUserRole(Session["Role"]?.ToString());
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string inputUser = txtUsername.Text.Trim();
            string inputPass = txtPassword.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT UserId, FirstName, Surname, Role FROM Users WHERE (Username = @Input OR Email = @Input) AND Password = @Password";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Input", inputUser);
                    cmd.Parameters.AddWithValue("@Password", inputPass);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            Session["UserId"] = reader["UserId"].ToString();
                            Session["FullName"] = $"{reader["FirstName"]} {reader["Surname"]}";
                            Session["Role"] = reader["Role"].ToString();

                            RedirectByUserRole(reader["Role"].ToString());
                        }
                        else
                        {
                            pnlAlert.Visible = true;
                            lblAlertMessage.Text = "Invalid Username/Email or Password. Please try again.";
                        }
                    }
                }
            }
        }

        private void RedirectByUserRole(string role)
        {
            if (role == "Admin")
            {
                Response.Redirect("Admin.aspx");
            }
            else
            {
                Response.Redirect("../Default.aspx");
            }
        }
    }
}