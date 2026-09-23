<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentProfile.aspx.cs" Inherits="Portfolio.Student.StudentProfile" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Dashboard | UniPortfolio</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <!-- Custom Theme CSS -->
    <link href="~/CSS/site.css" rel="stylesheet" type="text/css" runat="server" />
    <link href="~/CSS/StudentProfile.css" rel="stylesheet" type="text/css" runat="server" />
</head>
<body class="platform-body">
    <form id="form1" runat="server" enctype="multipart/form-data">
        <!-- Top Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark-custom sticky-top py-3 shadow-sm border-bottom border-secondary border-opacity-10">
            <div class="container">
                <a class="navbar-brand brand-logo d-flex align-items-center text-white text-decoration-none" href="../Default.aspx">
                    <div class="brand-icon-box me-2 shadow-sm">
                        <i class="fa-solid fa-graduation-cap text-white"></i>
                    </div>
                    <span class="fw-bold tracking-tight fs-5">Uni<span class="text-accent">Portfolio</span> <span class="badge bg-primary ms-2 fs-6">Student Portal</span></span>
                </a>
                <div class="d-flex align-items-center gap-3">
                    <asp:HyperLink runat="server" NavigateUrl="../Default.aspx" CssClass="btn btn-outline-light btn-sm rounded-pill px-3 fw-semibold">
                        <i class="fa-solid fa-arrow-left me-1"></i> Return to Feed
                    </asp:HyperLink>
                    <button type="button" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-semibold" onclick="showLogoutConfirmation();">
                        <i class="fa-solid fa-right-from-bracket me-1"></i> Log Out
                    </button>
                </div>
            </div>
        </nav>

        <div class="container py-5">
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show rounded-4 mb-4 animate-fade-in-up" role="alert">
                <asp:Label ID="lblAlertMessage" runat="server" />
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

            <div class="row">
                <!-- Left Column: Avatar & Basic Info Card -->
                <div class="col-lg-4 mb-4 animate-fade-in-up animate-delay-1">
                    <div class="card card-profile text-center shadow-sm border-0 overflow-hidden rounded-4">
                        <div class="card-bg-banner"></div>
                        <div class="card-body pt-0 bg-white px-4 pb-4">
                            <img runat="server" id="imgAvatar" class="profile-img-avatar mx-auto mb-3 shadow" alt="Profile Picture" />
                            <h4 class="fw-bold text-dark mb-1"><asp:Label ID="lblFullName" runat="server" /></h4>
                            <p class="text-primary fw-medium small mb-3"><asp:Label ID="lblHeadline" runat="server" /></p>
                            <span class="badge badge-role-student px-3 py-2 rounded-pill shadow-sm">Verified Student Account</span>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Full Profile Information Editor -->
                <div class="col-lg-8 animate-fade-in-up animate-delay-2">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                        <h5 class="fw-bold text-dark mb-4 border-bottom pb-3">
                            <i class="fa-solid fa-user-pen text-primary me-2"></i>Update Professional Profile
                        </h5>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold small text-secondary">First Name</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control bg-light py-2" required="required" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold small text-secondary">Surname</label>
                                <asp:TextBox ID="txtSurname" runat="server" CssClass="form-control bg-light py-2" required="required" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold small text-secondary">Email Address</label>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control bg-light py-2" required="required" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold small text-secondary">Cellphone Number</label>
                                <asp:TextBox ID="txtContact" runat="server" MaxLength="11" CssClass="form-control bg-light py-2" required="required" onkeypress="return event.charCode >= 48 && event.charCode <= 57" />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-secondary">Headline / Professional Title</label>
                            <asp:TextBox ID="txtHeadline" runat="server" CssClass="form-control bg-light py-2" Placeholder="e.g. 3rd Year BSIT Student | Front-End Developer" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-secondary"><i class="fa-solid fa-image text-primary me-1"></i>Upload Profile Image</label>
                            <asp:FileUpload ID="fuStudentImage" runat="server" CssClass="form-control bg-light py-2" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-secondary"><i class="fa-solid fa-globe text-success me-1"></i>External Portfolio Website URL</label>
                            <asp:TextBox ID="txtPortfolioUrl" runat="server" TextMode="Url" CssClass="form-control bg-light py-2" Placeholder="https://github.com/username" />
                        </div>

                        <!-- ================= EDUCATIONAL ATTAINMENT SECTION ================= -->
                        <div class="card border border-primary border-opacity-25 bg-light p-3 rounded-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="fw-bold text-primary mb-0"><i class="fa-solid fa-user-graduate me-2"></i>Educational Background History</h6>
                                <button type="button" class="btn btn-sm btn-primary rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#addEducationModal">
                                    <i class="fa-solid fa-plus me-1"></i> Add Education
                                </button>
                            </div>

                            <!-- 1. COLLEGE DIVISION -->
                            <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                <h6 class="fw-bold text-primary border-bottom pb-2 mb-3"><i class="fa-solid fa-graduation-cap me-2"></i>College Level</h6>
                                <asp:Repeater ID="rptCollege" runat="server" OnItemCommand="rptEducation_ItemCommand">
                                    <ItemTemplate>
                                        <div class="p-3 mb-2 border rounded-3 bg-light shadow-sm text-start position-relative">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-25 px-2 py-1 rounded-pill small fw-bold">
                                                    <%# string.IsNullOrEmpty(Eval("YearOrGradeLevel")?.ToString()) ? "N/A" : Eval("YearOrGradeLevel") %>
                                                </span>
                                                <span class="text-muted small"><i class='fa-regular fa-calendar me-1'></i><%# Eval("SchoolYearRange") %></span>
                                            </div>
                                            <h6 class="fw-bold text-dark mb-1"><%# Eval("SchoolName") %></h6>
                                            <%# string.IsNullOrEmpty(Eval("CourseOrStrand")?.ToString()) ? "" : "<div class='text-secondary small mb-1'><i class='fa-solid fa-book-open-reader text-primary me-1'></i><strong>Course:</strong> " + Eval("CourseOrStrand") + "</div>" %>
                                            <%# string.IsNullOrEmpty(Eval("HonorsOrNotes")?.ToString()) ? "" : "<div class='small text-success fw-semibold mt-1'><i class='fa-solid fa-award text-warning me-1'></i>" + Eval("HonorsOrNotes") + "</div>" %>
                                            <div class="text-end mt-2">
                                                <asp:Button ID="btnDeleteEdu" runat="server" CommandName="DeleteEdu" CommandArgument='<%# Eval("EducationId") %>' Text="Remove" CssClass="btn btn-outline-danger btn-sm py-0 px-2 small" CausesValidation="false" OnClientClick="return confirm('Remove this record?');" />
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Label ID="lblNoCollege" runat="server" Text="No college records added yet." CssClass="text-muted small fst-italic d-block text-center py-1" />
                            </div>

                            <!-- 2. SENIOR HIGH SCHOOL DIVISION -->
                            <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                <h6 class="fw-bold text-success border-bottom pb-2 mb-3"><i class="fa-solid fa-school me-2"></i>Senior High School (SHS)</h6>
                                <asp:Repeater ID="rptSeniorHigh" runat="server" OnItemCommand="rptEducation_ItemCommand">
                                    <ItemTemplate>
                                        <div class="p-3 mb-2 border rounded-3 bg-light shadow-sm text-start position-relative">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1 rounded-pill small fw-bold">
                                                    <%# string.IsNullOrEmpty(Eval("YearOrGradeLevel")?.ToString()) ? "N/A" : Eval("YearOrGradeLevel") %>
                                                </span>
                                                <span class="text-muted small"><i class='fa-regular fa-calendar me-1'></i><%# Eval("SchoolYearRange") %></span>
                                            </div>
                                            <h6 class="fw-bold text-dark mb-1"><%# Eval("SchoolName") %></h6>
                                            <%# string.IsNullOrEmpty(Eval("CourseOrStrand")?.ToString()) ? "" : "<div class='text-secondary small mb-1'><i class='fa-solid fa-book-open-reader text-success me-1'></i><strong>Strand:</strong> " + Eval("CourseOrStrand") + "</div>" %>
                                            <%# string.IsNullOrEmpty(Eval("HonorsOrNotes")?.ToString()) ? "" : "<div class='small text-success fw-semibold mt-1'><i class='fa-solid fa-award text-warning me-1'></i>" + Eval("HonorsOrNotes") + "</div>" %>
                                            <div class="text-end mt-2">
                                                <asp:Button ID="btnDeleteEdu" runat="server" CommandName="DeleteEdu" CommandArgument='<%# Eval("EducationId") %>' Text="Remove" CssClass="btn btn-outline-danger btn-sm py-0 px-2 small" CausesValidation="false" OnClientClick="return confirm('Remove this record?');" />
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Label ID="lblNoSeniorHigh" runat="server" Text="No senior high school records added yet." CssClass="text-muted small fst-italic d-block text-center py-1" />
                            </div>

                            <!-- 3. JUNIOR HIGH SCHOOL DIVISION -->
                            <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                <h6 class="fw-bold text-warning-emphasis border-bottom pb-2 mb-3"><i class="fa-solid fa-book me-2"></i>Junior High School (JHS)</h6>
                                <asp:Repeater ID="rptJuniorHigh" runat="server" OnItemCommand="rptEducation_ItemCommand">
                                    <ItemTemplate>
                                        <div class="p-3 mb-2 border rounded-3 bg-light shadow-sm text-start position-relative">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="badge bg-warning bg-opacity-10 text-warning-emphasis border border-warning border-opacity-25 px-2 py-1 rounded-pill small fw-bold">
                                                    <%# string.IsNullOrEmpty(Eval("YearOrGradeLevel")?.ToString()) ? "N/A" : Eval("YearOrGradeLevel") %>
                                                </span>
                                                <span class="text-muted small"><i class='fa-regular fa-calendar me-1'></i><%# Eval("SchoolYearRange") %></span>
                                            </div>
                                            <h6 class="fw-bold text-dark mb-1"><%# Eval("SchoolName") %></h6>
                                            <%# string.IsNullOrEmpty(Eval("HonorsOrNotes")?.ToString()) ? "" : "<div class='small text-success fw-semibold mt-1'><i class='fa-solid fa-award text-warning me-1'></i>" + Eval("HonorsOrNotes") + "</div>" %>
                                            <div class="text-end mt-2">
                                                <asp:Button ID="btnDeleteEdu" runat="server" CommandName="DeleteEdu" CommandArgument='<%# Eval("EducationId") %>' Text="Remove" CssClass="btn btn-outline-danger btn-sm py-0 px-2 small" CausesValidation="false" OnClientClick="return confirm('Remove this record?');" />
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Label ID="lblNoJuniorHigh" runat="server" Text="No junior high school records added yet." CssClass="text-muted small fst-italic d-block text-center py-1" />
                            </div>

                            <!-- 4. ELEMENTARY DIVISION -->
                            <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3"><i class="fa-solid fa-child me-2"></i>Elementary</h6>
                                <asp:Repeater ID="rptElementary" runat="server" OnItemCommand="rptEducation_ItemCommand">
                                    <ItemTemplate>
                                        <div class="p-3 mb-2 border rounded-3 bg-light shadow-sm text-start position-relative">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1 rounded-pill small fw-bold">
                                                    <%# string.IsNullOrEmpty(Eval("YearOrGradeLevel")?.ToString()) ? "N/A" : Eval("YearOrGradeLevel") %>
                                                </span>
                                                <span class="text-muted small"><i class='fa-regular fa-calendar me-1'></i><%# Eval("SchoolYearRange") %></span>
                                            </div>
                                            <h6 class="fw-bold text-dark mb-1"><%# Eval("SchoolName") %></h6>
                                            <%# string.IsNullOrEmpty(Eval("HonorsOrNotes")?.ToString()) ? "" : "<div class='small text-success fw-semibold mt-1'><i class='fa-solid fa-award text-warning me-1'></i>" + Eval("HonorsOrNotes") + "</div>" %>
                                            <div class="text-end mt-2">
                                                <asp:Button ID="btnDeleteEdu" runat="server" CommandName="DeleteEdu" CommandArgument='<%# Eval("EducationId") %>' Text="Remove" CssClass="btn btn-outline-danger btn-sm py-0 px-2 small" CausesValidation="false" OnClientClick="return confirm('Remove this record?');" />
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Label ID="lblNoElementary" runat="server" Text="No elementary records added yet." CssClass="text-muted small fst-italic d-block text-center py-1" />
                            </div>
                        </div>
                        <!-- ================= END OF EDUCATIONAL SECTION ================= -->

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-secondary"><i class="fa-solid fa-gears text-warning me-1"></i>Skills & Technical Expertise</label>
                            <asp:TextBox ID="txtSkills" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control bg-light rounded-3" Placeholder="e.g. C#, ASP.NET, SQL Server" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-secondary"><i class="fa-solid fa-gamepad text-danger me-1"></i>Hobbies & Personal Interests</label>
                            <asp:TextBox ID="txtHobbies" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control bg-light rounded-3" Placeholder="e.g. Coding, Gaming" />
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-secondary"><i class="fa-solid fa-book-open text-secondary me-1"></i>About / Short Bio</label>
                            <asp:TextBox ID="txtBio" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control bg-light rounded-3" Placeholder="Write a brief intro about yourself..." />
                        </div>

                        <button type="button" class="btn btn-primary rounded-pill px-5 py-2 fw-semibold shadow-sm" onclick="showSaveConfirmation();">
                            Save Profile Updates
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Education Modal with Dynamic Fields -->
        <div class="modal fade" id="addEducationModal" tabindex="-1" aria-labelledby="addEducationModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow rounded-4">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-dark" id="addEducationModalLabel">
                            <i class="fa-solid fa-graduation-cap text-primary me-2"></i>Add Educational Attainment
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-secondary py-3">
                        <div class="mb-3 text-start">
                            <label class="form-label fw-semibold small">School Level</label>
                            <asp:DropDownList ID="ddlSchoolLevel" runat="server" CssClass="form-select bg-light" onchange="toggleEducationalFields();">
                                <asp:ListItem Text="College" Value="College" />
                                <asp:ListItem Text="Senior High School (SHS)" Value="Senior High School" />
                                <asp:ListItem Text="Junior High School (JHS)" Value="Junior High School" />
                                <asp:ListItem Text="Elementary" Value="Elementary" />
                            </asp:DropDownList>
                        </div>

                        <div class="mb-3 text-start">
                            <label class="form-label fw-semibold small">School / Institution Name</label>
                            <asp:TextBox ID="txtModalSchoolName" runat="server" CssClass="form-control bg-light" Placeholder="e.g. University of the Philippines" />
                        </div>

                        <!-- Dynamic Field for Course / Strand -->
                        <div class="mb-3 text-start" id="divCourseStrand">
                            <label class="form-label fw-semibold small" id="lblCourseStrandTitle">Course / Degree Program</label>
                            <asp:TextBox ID="txtModalCourseOrStrand" runat="server" CssClass="form-control bg-light" Placeholder="e.g. BS Information Technology" />
                        </div>

                        <!-- Field para sa Year o Grade Level -->
                        <div class="mb-3 text-start">
                            <label class="form-label fw-semibold small" id="lblYearGradeTitle">Year Level / Grade Level</label>
                            <asp:TextBox ID="txtModalYearOrGrade" runat="server" CssClass="form-control bg-light" Placeholder="e.g. 3rd Year / Grade 12" />
                        </div>

                        <div class="mb-3 text-start">
                            <label class="form-label fw-semibold small">School Year Range</label>
                            <asp:TextBox ID="txtModalSchoolYear" runat="server" CssClass="form-control bg-light" Placeholder="e.g. 2022 - 2026" />
                        </div>

                        <div class="mb-3 text-start">
                            <label class="form-label fw-semibold small">Honors / Awards / Notes (Optional)</label>
                            <asp:TextBox ID="txtModalHonors" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control bg-light" Placeholder="e.g. Dean's Lister, Cum Laude" />
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-semibold small" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnAddEducation" runat="server" Text="Add Record" CssClass="btn btn-primary rounded-pill px-4 fw-semibold small shadow-sm" OnClick="btnAddEducation_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Save Profile Confirmation Modal -->
        <div class="modal fade" id="confirmSaveModal" tabindex="-1" aria-labelledby="confirmSaveModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow rounded-4">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-dark" id="confirmSaveModalLabel">
                            <i class="fa-solid fa-circle-check text-primary me-2"></i>Confirm Profile Update
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-secondary py-3">
                        Are you sure you want to save these profile changes?
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-semibold small" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnSaveProfile" runat="server" Text="Yes, Save Changes" CssClass="btn btn-dark rounded-pill px-4 fw-semibold small shadow-sm" OnClick="btnSaveProfile_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Log Out Confirmation Modal -->
        <div class="modal fade" id="confirmLogoutModal" tabindex="-1" aria-labelledby="confirmLogoutModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow rounded-4">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-dark" id="confirmLogoutModalLabel">
                            <i class="fa-solid fa-right-from-bracket text-danger me-2"></i>Confirm Log Out
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-secondary py-3">
                        Are you sure you want to end your current session and log out of UniPortfolio?
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-semibold small" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnLogout" runat="server" Text="Yes, Log Out" CssClass="btn btn-danger rounded-pill px-4 fw-semibold small shadow-sm" OnClick="btnLogout_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Bootstrap & Global Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src='<%= ResolveUrl("~/Script/site.js") %>'></script>
    
    <script>
        function toggleEducationalFields() {
            var ddl = document.getElementById('<%= ddlSchoolLevel.ClientID %>');
            var titleLabel = document.getElementById('lblCourseStrandTitle');
            var container = document.getElementById('divCourseStrand');
            var yearGradeLabel = document.getElementById('lblYearGradeTitle');

            if (!ddl) return;
            var val = ddl.value;

            if (val === 'College') {
                container.style.display = 'block';
                titleLabel.innerText = 'Course / Degree Program';
                yearGradeLabel.innerText = 'Year Level (e.g. 3rd Year)';
            } else if (val === 'Senior High School') {
                container.style.display = 'block';
                titleLabel.innerText = 'Track & Strand (e.g. STEM, HUMSS)';
                yearGradeLabel.innerText = 'Grade Level (e.g. Grade 11 or 12)';
            } else if (val === 'Junior High School') {
                container.style.display = 'none';
                yearGradeLabel.innerText = 'Grade Level (e.g. Grade 10)';
            } else if (val === 'Elementary') {
                container.style.display = 'none';
                yearGradeLabel.innerText = 'Grade Level (e.g. Grade 6)';
            }
        }

        window.onload = function () {
            toggleEducationalFields();
        };

        function showSaveConfirmation() {
            var form = document.getElementById('form1');
            if (form.checkValidity && !form.checkValidity()) {
                form.reportValidity();
                return;
            }
            var modalEl = document.getElementById('confirmSaveModal');
            if (modalEl) {
                var confirmModal = bootstrap.Modal.getOrCreateInstance(modalEl);
                confirmModal.show();
            }
        }

        function showLogoutConfirmation() {
            var modalEl = document.getElementById('confirmLogoutModal');
            if (modalEl) {
                var logoutModal = bootstrap.Modal.getOrCreateInstance(modalEl);
                logoutModal.show();
            }
        }
    </script>
</body>
</html>