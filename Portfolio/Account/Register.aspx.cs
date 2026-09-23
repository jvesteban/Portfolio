using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Portfolio.Account
{
    public partial class Register : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["UniPortfolioDBConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Check if username/email already exists
                string checkQuery = "SELECT COUNT(*) FROM Users WHERE Username = @Username OR Email = @Email";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@Username", username);
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (count > 0)
                    {
                        pnlAlert.Visible = true;
                        lblAlertMessage.Text = "Username or Email address is already registered.";
                        return;
                    }
                }

                // 💡 Updated Insert Query (Isinama ang PortfolioUrl at ginawang NULL ang ImageUrl sa simula)
                string insertQuery = @"INSERT INTO Users (FirstName, Surname, Username, Email, ContactNumber, Password, Role, Headline, Bio, ImageUrl, PortfolioUrl, Education, Skills, Hobbies)
                                       VALUES (@FirstName, @Surname, @Username, @Email, @ContactNumber, @Password, 'Student', @Headline, @Bio, @ImageUrl, @PortfolioUrl, '', '', '')";

                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Surname", txtSurname.Text.Trim());
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@ContactNumber", txtContact.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());
                    cmd.Parameters.AddWithValue("@Headline", "Student at UniCollege");
                    cmd.Parameters.AddWithValue("@Bio", "Welcome to my student portfolio!");

                    // 🖼️ DBNull.Value para awtomatikong lumabas ang "JD" Initials Avatar
                    cmd.Parameters.AddWithValue("@ImageUrl", DBNull.Value);
                    cmd.Parameters.AddWithValue("@PortfolioUrl", DBNull.Value);

                    cmd.ExecuteNonQuery();
                }
            }

            Response.Redirect("Login.aspx?registered=true");
        }
    }
}