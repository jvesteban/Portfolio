using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Portfolio.Student
{
    public partial class StudentProfile : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["UniPortfolioDBConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("../Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentProfile();
                LoadEducationHistory();
            }
        }

        #region Helper: Dynamic Profile Picture
        private string GetProfilePicture(object imageUrlObj, object firstNameObj, object surnameObj)
        {
            string imageUrl = imageUrlObj?.ToString();
            string firstName = firstNameObj?.ToString();
            string surname = surnameObj?.ToString();

            if (!string.IsNullOrWhiteSpace(imageUrl))
            {
                return ResolveUrl(imageUrl);
            }

            string fullName = $"{firstName} {surname}".Trim();
            if (string.IsNullOrWhiteSpace(fullName))
            {
                fullName = "User";
            }

            return $"https://ui-avatars.com/api/?name={Server.UrlEncode(fullName)}&background=0D6EFD&color=fff&bold=true&size=128";
        }
        #endregion

        #region Load Student Profile & Education Data
        private void LoadStudentProfile()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT FirstName, Surname, Email, ContactNumber, Headline, 
                                        Skills, Hobbies, Bio, ImageUrl, PortfolioUrl 
                                 FROM Users WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtFirstName.Text = reader["FirstName"].ToString();
                            txtSurname.Text = reader["Surname"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                            txtContact.Text = reader["ContactNumber"].ToString();
                            txtHeadline.Text = reader["Headline"].ToString();
                            txtPortfolioUrl.Text = reader["PortfolioUrl"]?.ToString();
                            txtSkills.Text = reader["Skills"]?.ToString();
                            txtHobbies.Text = reader["Hobbies"]?.ToString();
                            txtBio.Text = reader["Bio"]?.ToString();

                            lblFullName.Text = $"{reader["FirstName"]} {reader["Surname"]}";
                            lblHeadline.Text = reader["Headline"].ToString();

                            imgAvatar.Src = GetProfilePicture(reader["ImageUrl"], reader["FirstName"], reader["Surname"]);
                        }
                    }
                }
            }
        }

        private void LoadEducationHistory()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // 1. College Records
                using (SqlCommand cmd = new SqlCommand("SELECT EducationId, SchoolLevel, SchoolName, CourseOrStrand, YearOrGradeLevel, SchoolYearRange, HonorsOrNotes FROM EducationHistory WHERE UserId = @UserId AND SchoolLevel = 'College' ORDER BY EducationId DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptCollege.DataSource = dt;
                        rptCollege.DataBind();
                        lblNoCollege.Visible = (dt.Rows.Count == 0);
                    }
                }

                // 2. Senior High School Records
                using (SqlCommand cmd = new SqlCommand("SELECT EducationId, SchoolLevel, SchoolName, CourseOrStrand, YearOrGradeLevel, SchoolYearRange, HonorsOrNotes FROM EducationHistory WHERE UserId = @UserId AND SchoolLevel = 'Senior High School' ORDER BY EducationId DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptSeniorHigh.DataSource = dt;
                        rptSeniorHigh.DataBind();
                        lblNoSeniorHigh.Visible = (dt.Rows.Count == 0);
                    }
                }

                // 3. Junior High School Records
                using (SqlCommand cmd = new SqlCommand("SELECT EducationId, SchoolLevel, SchoolName, CourseOrStrand, YearOrGradeLevel, SchoolYearRange, HonorsOrNotes FROM EducationHistory WHERE UserId = @UserId AND SchoolLevel = 'Junior High School' ORDER BY EducationId DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptJuniorHigh.DataSource = dt;
                        rptJuniorHigh.DataBind();
                        lblNoJuniorHigh.Visible = (dt.Rows.Count == 0);
                    }
                }

                // 4. Elementary Records
                using (SqlCommand cmd = new SqlCommand("SELECT EducationId, SchoolLevel, SchoolName, CourseOrStrand, YearOrGradeLevel, SchoolYearRange, HonorsOrNotes FROM EducationHistory WHERE UserId = @UserId AND SchoolLevel = 'Elementary' ORDER BY EducationId DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptElementary.DataSource = dt;
                        rptElementary.DataBind();
                        lblNoElementary.Visible = (dt.Rows.Count == 0);
                    }
                }
            }
        }
        #endregion

        #region Add and Delete Education Event Handlers
        protected void btnAddEducation_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string level = ddlSchoolLevel.SelectedValue;
            string schoolName = txtModalSchoolName.Text.Trim();
            string courseStrand = txtModalCourseOrStrand.Text.Trim();
            string yearOrGrade = txtModalYearOrGrade.Text.Trim();
            string yearRange = txtModalSchoolYear.Text.Trim();
            string honors = txtModalHonors.Text.Trim();

            if (!string.IsNullOrEmpty(schoolName) && !string.IsNullOrEmpty(yearRange))
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "INSERT INTO EducationHistory (UserId, SchoolLevel, SchoolName, CourseOrStrand, YearOrGradeLevel, SchoolYearRange, HonorsOrNotes) VALUES (@UserId, @Level, @SchoolName, @CourseStrand, @YearOrGrade, @YearRange, @Honors)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@Level", level);
                        cmd.Parameters.AddWithValue("@SchoolName", schoolName);
                        cmd.Parameters.AddWithValue("@CourseStrand", string.IsNullOrEmpty(courseStrand) ? (object)DBNull.Value : courseStrand);
                        cmd.Parameters.AddWithValue("@YearOrGrade", string.IsNullOrEmpty(yearOrGrade) ? (object)DBNull.Value : yearOrGrade);
                        cmd.Parameters.AddWithValue("@YearRange", yearRange);
                        cmd.Parameters.AddWithValue("@Honors", string.IsNullOrEmpty(honors) ? (object)DBNull.Value : honors);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Clear modal text boxes
                txtModalSchoolName.Text = "";
                txtModalCourseOrStrand.Text = "";
                txtModalYearOrGrade.Text = "";
                txtModalSchoolYear.Text = "";
                txtModalHonors.Text = "";

                LoadEducationHistory();
            }
        }

        protected void rptEducation_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteEdu")
            {
                int eduId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "DELETE FROM EducationHistory WHERE EducationId = @EducationId";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EducationId", eduId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                LoadEducationHistory();
            }
        }
        #endregion

        #region Save Profile Updates Event
        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string newImagePath = null;

            if (fuStudentImage.HasFile)
            {
                string ext = Path.GetExtension(fuStudentImage.FileName).ToLower();
                if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif")
                {
                    string uploadFolder = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    string fileName = $"user_{userId}_{DateTime.Now:yyyyMMddHHmmss}{ext}";
                    string filePath = Path.Combine(uploadFolder, fileName);
                    fuStudentImage.SaveAs(filePath);
                    newImagePath = $"~/Uploads/{fileName}";
                }
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"UPDATE Users SET 
                                 FirstName = @FirstName,
                                 Surname = @Surname,
                                 Email = @Email,
                                 ContactNumber = @ContactNumber,
                                 Headline = @Headline,
                                 PortfolioUrl = @PortfolioUrl,
                                 Skills = @Skills,
                                 Hobbies = @Hobbies,
                                 Bio = @Bio"
                                 + (newImagePath != null ? ", ImageUrl = @ImageUrl " : " ") +
                                 "WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Surname", txtSurname.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@ContactNumber", txtContact.Text.Trim());
                    cmd.Parameters.AddWithValue("@Headline", txtHeadline.Text.Trim());
                    cmd.Parameters.AddWithValue("@PortfolioUrl", txtPortfolioUrl.Text.Trim());
                    cmd.Parameters.AddWithValue("@Skills", txtSkills.Text.Trim());
                    cmd.Parameters.AddWithValue("@Hobbies", txtHobbies.Text.Trim());
                    cmd.Parameters.AddWithValue("@Bio", txtBio.Text.Trim());
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    if (newImagePath != null)
                    {
                        cmd.Parameters.AddWithValue("@ImageUrl", newImagePath);
                    }

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Session["FullName"] = $"{txtFirstName.Text.Trim()} {txtSurname.Text.Trim()}";
            LoadStudentProfile();
            LoadEducationHistory();

            pnlAlert.Visible = true;
            pnlAlert.CssClass = "alert alert-success alert-dismissible fade show rounded-4 mb-4 animate-fade-in-up";
            lblAlertMessage.Text = "Your student profile has been updated successfully!";
        }
        #endregion

        #region Log Out Event
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("../Default.aspx");
        }
        #endregion
    }
}