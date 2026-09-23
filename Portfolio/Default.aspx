<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Portfolio.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UniPortfolio | Enterprise Student & Professional Network</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <!-- Custom Enterprise Theme CSS -->
    <link href="~/CSS/site.css" rel="stylesheet" type="text/css" runat="server" />
</head>
<body class="platform-body">
    <!-- Form configuration for file uploading -->
    <form id="form1" runat="server" enctype="multipart/form-data">
        <!-- Top Enterprise Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark-custom sticky-top py-3 shadow-sm border-bottom border-secondary border-opacity-10">
            <div class="container">
                <a class="navbar-brand brand-logo d-flex align-items-center text-white text-decoration-none" href="Default.aspx">
                    <div class="brand-icon-box me-2 shadow-sm">
                        <i class="fa-solid fa-graduation-cap text-white"></i>
                    </div>
                    <span class="fw-bold tracking-tight fs-5">Uni<span class="text-accent">Portfolio</span></span>
                </a>
                <div class="d-flex align-items-center gap-3">
                    <asp:PlaceHolder ID="phGuestNav" runat="server">
                        <asp:HyperLink runat="server" NavigateUrl="~/Account/Login.aspx" CssClass="btn btn-outline-light btn-sm rounded-pill px-4 fw-semibold transition-all">Sign In</asp:HyperLink>
                        <asp:HyperLink runat="server" NavigateUrl="~/Account/Register.aspx" CssClass="btn btn-accent btn-sm rounded-pill px-4 fw-semibold shadow-sm transition-all">Get Started</asp:HyperLink>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="phUserNav" runat="server" Visible="false">
                        <div class="d-flex align-items-center bg-white bg-opacity-10 px-3 py-1 rounded-pill border border-light border-opacity-10 me-2">
                            <i class="fa-solid fa-circle-user text-accent me-2"></i>
                            <span class="text-light small">Welcome, <strong class="text-white" runat="server" id="lblNavUser">User</strong></span>
                        </div>
                        <!-- 🔘 Log Out Trigger Button -->
                        <button type="button" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-semibold" data-bs-toggle="modal" data-bs-target="#confirmLogoutModal">
                            <i class="fa-solid fa-right-from-bracket me-1"></i> Log Out
                        </button>
                    </asp:PlaceHolder>
                </div>
            </div>
        </nav>

        <!-- Professional Hero Banner Section -->
        <div class="hero-section text-white py-5 mb-5 position-relative overflow-hidden shadow-sm">
            <div class="container text-center py-5 position-relative z-1">
                <span class="badge bg-white bg-opacity-10 text-light px-3 py-2 rounded-pill mb-3 border border-light border-opacity-10 backdrop-blur">
                    <i class="fa-solid fa-award me-1 text-warning"></i> Premier Academic & Talent Network
                </span>
                <h1 class="fw-bold display-5 mb-3 tracking-tight">Showcase Your Skills, Connect & Grow</h1>
                <p class="lead text-light text-opacity-75 mx-auto" style="max-width: 680px; font-weight: 400;">
                    Explore verified professional portfolios created by students and faculty members. Manage your digital footprint and accelerate your career path.
                </p>
            </div>
        </div>

        <!-- Main Content Layout -->
        <div class="container mb-5">
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show shadow-sm border-0 rounded-4 mb-4" role="alert">
                <asp:Label ID="lblAlertMessage" runat="server" />
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

            <div class="row">
                <!-- Left Sidebar: Profile Summary Card -->
                <div class="col-lg-3 mb-4">
                    <div class="card card-profile text-center shadow-sm border-0 overflow-hidden rounded-4">
                        <div class="card-bg-banner"></div>
                        <div class="card-body pt-0 bg-white px-4 pb-4">
                            <img src="https://via.placeholder.com/150" runat="server" id="imgNavAvatar" class="profile-img-avatar mb-3 shadow" alt="Avatar" />
                            <h5 class="mb-1 fw-bold text-dark"><asp:Label ID="lblSidebarName" runat="server" Text="Guest Visitor" /></h5>
                            <p class="text-muted small mb-3"><asp:Label ID="lblSidebarRole" runat="server" Text="Sign in to unlock full features" /></p>
                            <hr class="text-muted opacity-25 my-3" />
                            
                            <asp:Button ID="btnGoToDashboard" runat="server" Text="Go to Dashboard" CssClass="btn btn-sm btn-primary w-100 rounded-pill fw-semibold py-2 shadow-sm" Visible="false" OnClick="btnGoToDashboard_Click" />
                        </div>
                    </div>
                </div>

                <!-- Right Area: Live Portfolio Feed -->
                <div class="col-lg-9">
                    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-3 px-4 rounded-4 shadow-sm border border-opacity-10">
                        <h5 class="fw-bold mb-0 text-dark d-flex align-items-center">
                            <i class="fa-solid fa-address-card text-primary me-2"></i>Community Portfolios
                        </h5>
                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-3 py-2 rounded-pill fw-semibold">
                            <i class="fa-solid fa-bolt me-1"></i> Live Stream
                        </span>
                    </div>

                    <div class="row">
                        <asp:Repeater ID="rptPortfolios" runat="server" OnItemDataBound="rptPortfolios_ItemDataBound" OnItemCommand="rptPortfolios_ItemCommand">
                            <ItemTemplate>
                                <div class="col-md-6 col-lg-4 mb-4">
                                    <div class="card card-profile h-100 shadow-sm border-0 rounded-4 overflow-hidden">
                                        <div class="card-bg-banner"></div>
                                        <div class="card-body text-center d-flex flex-column pt-0 bg-white px-3 pb-3">
                                            
                                            <!-- Dynamic Profile Avatar -->
                                            <img src='<%# GetProfilePicture(Eval("ImageUrl"), Eval("FirstName"), Eval("Surname")) %>' class="profile-img-avatar mx-auto mb-3 shadow-sm" alt="Profile" />
                                            
                                            <span class='<%# Eval("Role").ToString() == "Admin" ? "badge badge-role-admin mx-auto mb-2 px-3 py-1 rounded-pill shadow-sm" : "badge badge-role-student mx-auto mb-2 px-3 py-1 rounded-pill shadow-sm" %>'>
                                                <%# Eval("Role") %>
                                            </span>
                                            <h6 class="fw-bold mb-1 text-dark"><%# Eval("FullName") %></h6>
                                            <p class="text-muted small mb-2 fw-medium"><%# Eval("Headline") %></p>
                                            
                                            <div class="bg-light p-2 rounded-3 mb-3 small text-secondary text-start border border-opacity-10">
                                                <div class="text-truncate mb-1"><i class="fa-solid fa-envelope text-primary me-2"></i><%# Eval("Email") %></div>
                                                <div class="text-truncate"><i class="fa-solid fa-phone text-success me-2"></i><%# Eval("ContactNumber") %></div>
                                            </div>

                                            <p class="card-text small text-secondary mb-4 flex-grow-1 px-1"><%# Eval("Bio") %></p>
                                            
                                            <div class="mt-auto pt-3 border-top border-light">
                                                <asp:Button ID="btnViewCard" runat="server" CommandName="ViewCard" CommandArgument='<%# Eval("UserId") %>' Text="View Profile" CssClass="btn btn-outline-primary btn-sm rounded-pill w-100 mb-2 fw-semibold" />
                                                <asp:Button ID="btnDeleteCard" runat="server" CommandName="DeleteCard" CommandArgument='<%# Eval("UserId") %>' Text="Delete Profile" CssClass="btn btn-outline-danger btn-sm rounded-pill w-100 fw-semibold" Visible="false" OnClientClick="return confirm('Are you sure you want to delete this profile?');" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enterprise View Profile Modal -->
        <asp:Panel ID="pnlViewModal" runat="server" CssClass="modal fade show d-block bg-dark bg-opacity-75 backdrop-blur-sm" Visible="false">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                    <div class="modal-header bg-dark text-white py-3 px-4">
                        <h5 class="modal-title fw-bold"><i class="fa-solid fa-address-card text-accent me-2"></i>Student Professional Profile</h5>
                        <asp:Button ID="btnCloseViewModal" runat="server" CssClass="btn-close btn-close-white" OnClick="btnCloseViewModal_Click" CausesValidation="false" />
                    </div>
                    <div class="modal-body px-4 py-4 bg-white text-center">
                        <div class="card-bg-banner rounded-3 mb-4" style="height: 100px;"></div>
                        <img runat="server" id="imgViewAvatar" class="profile-img-avatar mx-auto mb-3 shadow" alt="Profile Avatar" style="width: 100px; height: 100px; margin-top: -70px; border: 4px solid #fff;" />
                        
                        <span class="badge badge-role-student mb-2 px-3 py-1 rounded-pill shadow-sm">Verified Student</span>
                        <h3 class="fw-bold text-dark mb-1"><asp:Label ID="lblViewFullName" runat="server" /></h3>
                        <p class="text-primary fw-medium mb-3"><asp:Label ID="lblViewHeadline" runat="server" /></p>

                        <!-- External Live Portfolio Link Button -->
                        <div class="mb-4" id="divPortfolioLink" runat="server" visible="false">
                            <asp:HyperLink ID="lnkExternalPortfolio" runat="server" Target="_blank" CssClass="btn btn-success rounded-pill px-4 py-2 fw-semibold shadow-sm">
                                <i class="fa-solid fa-globe me-2"></i>Visit Live Portfolio / Personal Website
                            </asp:HyperLink>
                        </div>

                        <!-- Contact Details -->
                        <div class="row text-start bg-light p-3 rounded-4 mb-3 border border-opacity-10">
                            <div class="col-md-6 mb-2 mb-md-0">
                                <i class="fa-solid fa-envelope text-primary me-2"></i><strong>Email:</strong> <asp:Label ID="lblViewEmail" runat="server" />
                            </div>
                            <div class="col-md-6">
                                <i class="fa-solid fa-phone text-success me-2"></i><strong>Contact:</strong> <asp:Label ID="lblViewContact" runat="server" />
                            </div>
                        </div>

                        <!-- Educational Attainment Section (Naka-group per School Level divisions na) -->
                        <div class="text-start bg-light border border-opacity-10 p-3 rounded-4 shadow-sm mb-3">
                            <h6 class="fw-bold text-primary mb-3"><i class="fa-solid fa-user-graduate me-2"></i>Educational Attainment History</h6>
                            
                            <!-- 1. College Division -->
                            <div class="card border-0 shadow-sm rounded-3 p-3 mb-2 bg-white">
                                <h6 class="fw-bold text-primary border-bottom pb-2 mb-2 fs-6"><i class="fa-solid fa-graduation-cap me-2"></i>College Level</h6>
                                <asp:Literal ID="lblViewCollege" runat="server" />
                            </div>

                            <!-- 2. Senior High School Division -->
                            <div class="card border-0 shadow-sm rounded-3 p-3 mb-2 bg-white">
                                <h6 class="fw-bold text-success border-bottom pb-2 mb-2 fs-6"><i class="fa-solid fa-school me-2"></i>Senior High School (SHS)</h6>
                                <asp:Literal ID="lblViewSeniorHigh" runat="server" />
                            </div>

                            <!-- 3. Junior High School Division -->
                            <div class="card border-0 shadow-sm rounded-3 p-3 mb-2 bg-white">
                                <h6 class="fw-bold text-warning-emphasis border-bottom pb-2 mb-2 fs-6"><i class="fa-solid fa-book me-2"></i>Junior High School (JHS)</h6>
                                <asp:Literal ID="lblViewJuniorHigh" runat="server" />
                            </div>

                            <!-- 4. Elementary Division -->
                            <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                <h6 class="fw-bold text-secondary border-bottom pb-2 mb-2 fs-6"><i class="fa-solid fa-child me-2"></i>Elementary</h6>
                                <asp:Literal ID="lblViewElementary" runat="server" />
                            </div>
                        </div>

                        <!-- Skills Section -->
                        <div class="text-start bg-white border border-opacity-10 p-3 rounded-4 shadow-sm mb-3">
                            <h6 class="fw-bold text-dark mb-2"><i class="fa-solid fa-gears text-warning me-2"></i>Skills & Expertise</h6>
                            <p class="text-secondary small mb-0"><asp:Label ID="lblViewSkills" runat="server" Text="Not specified" /></p>
                        </div>

                        <!-- Hobbies Section -->
                        <div class="text-start bg-white border border-opacity-10 p-3 rounded-4 shadow-sm mb-3">
                            <h6 class="fw-bold text-dark mb-2"><i class="fa-solid fa-gamepad text-danger me-2"></i>Hobbies & Interests</h6>
                            <p class="text-secondary small mb-0"><asp:Label ID="lblViewHobbies" runat="server" Text="Not specified" /></p>
                        </div>

                        <!-- About / Short Bio Section -->
                        <div class="text-start bg-white border border-opacity-10 p-3 rounded-4 shadow-sm">
                            <h6 class="fw-bold text-dark mb-2"><i class="fa-solid fa-book-open text-secondary me-2"></i>About / Short Bio</h6>
                            <p class="text-secondary small mb-0"><asp:Label ID="lblViewBio" runat="server" Text="Not specified" /></p>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pb-4 px-4 bg-white justify-content-center">
                        <asp:Button ID="btnCloseModalFooter" runat="server" Text="Close" CssClass="btn btn-outline-dark rounded-pill px-5 py-2 fw-semibold" OnClick="btnCloseViewModal_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </asp:Panel>

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
                    <div class="modal-body text-secondary py-3 text-start">
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

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src='<%= ResolveUrl("~/Script/site.js") %>'></script>
</body>
</html>