using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Portfolio
{
    public partial class Default : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["UniPortfolioDBConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RefreshUIState();
                LoadCards();
            }
        }

        #region Helper: Dynamic Profile Picture / Initials Avatar
        public string GetProfilePicture(object imageUrlObj, object firstNameObj, object surnameObj)
        {
            string imageUrl = imageUrlObj?.ToString();
            string firstName = firstNameObj?.ToString();
            string surname = surnameObj?.ToString();

            if (!string.IsNullOrWhiteSpace(imageUrl) && !imageUrl.Contains("placeholder"))
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

        #region UI and State Setup
        private void RefreshUIState()
        {
            if (Session["UserId"] != null)
            {
                if (phGuestNav != null) phGuestNav.Visible = false;
                if (phUserNav != null) phUserNav.Visible = true;

                if (lblNavUser != null)
                    lblNavUser.InnerText = Session["FullName"] != null ? Session["FullName"].ToString() : "User";

                if (lblSidebarName != null)
                    lblSidebarName.Text = Session["FullName"] != null ? Session["FullName"].ToString() : "User";

                string role = Session["Role"] != null ? Session["Role"].ToString() : "Student";
                if (lblSidebarRole != null)
                    lblSidebarRole.Text = role + " Account";

                if (btnGoToDashboard != null)
                {
                    btnGoToDashboard.Visible = true;
                    if (role == "Admin")
                    {
                        btnGoToDashboard.Text = "Admin Dashboard";
                        btnGoToDashboard.CssClass = "btn btn-sm btn-danger w-100 rounded-pill fw-semibold py-2 shadow-sm";
                    }
                    else
                    {
                        btnGoToDashboard.Text = "Student Portal";
                        btnGoToDashboard.CssClass = "btn btn-sm btn-primary w-100 rounded-pill fw-semibold py-2 shadow-sm";
                    }
                }

                LoadSidebarAvatar(Convert.ToInt32(Session["UserId"]));
            }
            else
            {
                if (phGuestNav != null) phGuestNav.Visible = true;
                if (phUserNav != null) phUserNav.Visible = false;

                if (lblSidebarName != null)
                    lblSidebarName.Text = "Guest Visitor";

                if (lblSidebarRole != null)
                    lblSidebarRole.Text = "Sign in to unlock full features";

                if (btnGoToDashboard != null)
                    btnGoToDashboard.Visible = false;

                if (imgNavAvatar != null)
                    imgNavAvatar.Src = GetProfilePicture(null, "Guest", "Visitor");
            }
        }

        private void LoadSidebarAvatar(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT FirstName, Surname, ImageUrl FROM Users WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            imgNavAvatar.Src = GetProfilePicture(reader["ImageUrl"], reader["FirstName"], reader["Surname"]);
                        }
                    }
                }
            }
        }

        protected void btnGoToDashboard_Click(object sender, EventArgs e)
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            if (role == "Admin")
            {
                Response.Redirect("Account/Admin.aspx");
            }
            else if (role == "Student")
            {
                Response.Redirect("Student/StudentProfile.aspx");
            }
        }

        private void ShowAlert(string message, string alertType = "danger")
        {
            if (pnlAlert != null && lblAlertMessage != null)
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = $"alert alert-{alertType} alert-dismissible fade show shadow-sm border-0 rounded-4 mb-4";
                lblAlertMessage.Text = message;
            }
        }
        #endregion

        #region Card Loading & Management Logic
        private void LoadCards()
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT UserId, Role, Surname, FirstName, Email, ContactNumber, Headline, Bio, ImageUrl, PortfolioUrl FROM Users WHERE Role = 'Student'";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            dt.Columns.Add("FullName", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                row["FullName"] = $"{row["FirstName"]} {row["Surname"]}";
            }

            if (rptPortfolios != null)
            {
                rptPortfolios.DataSource = dt;
                rptPortfolios.DataBind();
            }
        }

        protected void rptPortfolios_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                Button btnDeleteCard = (Button)e.Item.FindControl("btnDeleteCard");

                if (Session["UserId"] != null)
                {
                    string userRole = Session["Role"] != null ? Session["Role"].ToString() : "Student";

                    if (userRole == "Admin")
                    {
                        if (btnDeleteCard != null) btnDeleteCard.Visible = true;
                    }
                }
            }
        }

        protected void rptPortfolios_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int targetUserId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ViewCard")
            {
                OpenViewModal(targetUserId);
            }
            else if (e.CommandName == "DeleteCard")
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "DELETE FROM Users WHERE UserId = @UserId";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", targetUserId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                LoadCards();
                ShowAlert("User profile successfully deleted from database.", "warning");
            }
        }

        private void OpenViewModal(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT FirstName, Surname, Email, ContactNumber, Headline, Bio, ImageUrl, PortfolioUrl, Skills, Hobbies FROM Users WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblViewFullName.Text = $"{reader["FirstName"]} {reader["Surname"]}";
                            lblViewHeadline.Text = reader["Headline"].ToString();
                            lblViewEmail.Text = reader["Email"].ToString();
                            lblViewContact.Text = reader["ContactNumber"].ToString();

                            imgViewAvatar.Src = GetProfilePicture(reader["ImageUrl"], reader["FirstName"], reader["Surname"]);

                            string portfolioUrl = reader["PortfolioUrl"]?.ToString();
                            if (!string.IsNullOrWhiteSpace(portfolioUrl))
                            {
                                divPortfolioLink.Visible = true;
                                if (!portfolioUrl.StartsWith("http://") && !portfolioUrl.StartsWith("https://"))
                                {
                                    portfolioUrl = "https://" + portfolioUrl;
                                }
                                lnkExternalPortfolio.NavigateUrl = portfolioUrl;
                            }
                            else
                            {
                                divPortfolioLink.Visible = false;
                            }

                            string skills = reader["Skills"]?.ToString();
                            lblViewSkills.Text = string.IsNullOrWhiteSpace(skills) ? "Not specified" : skills;

                            string hobbies = reader["Hobbies"]?.ToString();
                            lblViewHobbies.Text = string.IsNullOrWhiteSpace(hobbies) ? "Not specified" : hobbies;

                            string bio = reader["Bio"]?.ToString();
                            lblViewBio.Text = string.IsNullOrWhiteSpace(bio) ? "Not specified" : bio;
                        }
                    }
                }

                // Hiwalay na pag-load at pag-render para sa bawat Education Level division sa View Modal
                string eduQuery = "SELECT SchoolLevel, SchoolName, CourseOrStrand, YearOrGradeLevel, SchoolYearRange, HonorsOrNotes FROM EducationHistory WHERE UserId = @UserId ORDER BY EducationId DESC";
                using (SqlCommand cmdEdu = new SqlCommand(eduQuery, conn))
                {
                    cmdEdu.Parameters.AddWithValue("@UserId", userId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmdEdu))
                    {
                        DataTable dtEdu = new DataTable();
                        da.Fill(dtEdu);

                        string collegeHtml = "";
                        string shsHtml = "";
                        string jhsHtml = "";
                        string elemHtml = "";

                        foreach (DataRow row in dtEdu.Rows)
                        {
                            string level = row["SchoolLevel"].ToString();
                            string school = row["SchoolName"].ToString();
                            string course = row["CourseOrStrand"]?.ToString();
                            string yearGrade = row["YearOrGradeLevel"]?.ToString();
                            string yearRange = row["SchoolYearRange"].ToString();
                            string honors = row["HonorsOrNotes"]?.ToString();

                            string itemHtml = "<div class='p-3 mb-2 rounded-3 border bg-light shadow-sm text-start'>";
                            itemHtml += $"<div class='d-flex justify-content-between align-items-center mb-1'>";
                            itemHtml += $"<span class='badge bg-info bg-opacity-10 text-info border border-info border-opacity-25 px-2 py-1 rounded-pill small fw-bold'>{yearGrade ?? "N/A"}</span>";
                            if (!string.IsNullOrEmpty(yearRange))
                            {
                                itemHtml += $"<span class='text-muted small'><i class='fa-regular fa-calendar me-1'></i>{yearRange}</span>";
                            }
                            itemHtml += "</div>";

                            itemHtml += $"<h6 class='fw-bold text-dark mb-1'>{school}</h6>";

                            if (!string.IsNullOrEmpty(course))
                            {
                                itemHtml += $"<div class='text-secondary small mb-1'><i class='fa-solid fa-book-open-reader text-primary me-1'></i><strong>Course/Strand:</strong> {course}</div>";
                            }

                            if (!string.IsNullOrEmpty(honors))
                            {
                                itemHtml += $"<div class='small text-success fw-semibold mt-1'><i class='fa-solid fa-award text-warning me-1'></i>{honors}</div>";
                            }

                            itemHtml += "</div>";

                            // Pangkatin sa kaukulang division
                            if (level == "College")
                            {
                                collegeHtml += itemHtml;
                            }
                            else if (level == "Senior High School")
                            {
                                shsHtml += itemHtml;
                            }
                            else if (level == "Junior High School")
                            {
                                jhsHtml += itemHtml;
                            }
                            else if (level == "Elementary")
                            {
                                elemHtml += itemHtml;
                            }
                        }

                        lblViewCollege.Text = string.IsNullOrEmpty(collegeHtml) ? "<span class='text-muted small fst-italic'>No college records added.</span>" : collegeHtml;
                        lblViewSeniorHigh.Text = string.IsNullOrEmpty(shsHtml) ? "<span class='text-muted small fst-italic'>No senior high records added.</span>" : shsHtml;
                        lblViewJuniorHigh.Text = string.IsNullOrEmpty(jhsHtml) ? "<span class='text-muted small fst-italic'>No junior high records added.</span>" : jhsHtml;
                        lblViewElementary.Text = string.IsNullOrEmpty(elemHtml) ? "<span class='text-muted small fst-italic'>No elementary records added.</span>" : elemHtml;
                    }
                }

                if (pnlViewModal != null) pnlViewModal.Visible = true;
            }
        }

        protected void btnCloseViewModal_Click(object sender, EventArgs e)
        {
            if (pnlViewModal != null) pnlViewModal.Visible = false;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            RefreshUIState();
            LoadCards();
            ShowAlert("You have been logged out successfully.", "info");
        }
        #endregion
    }
}