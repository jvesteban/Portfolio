<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Portfolio.Account.Admin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard | UniPortfolio</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Custom Theme CSS -->
    <link href="~/CSS/site.css" rel="stylesheet" type="text/css" runat="server" />
    <link href="~/CSS/Admin.css" rel="stylesheet" type="text/css" runat="server" />
</head>
<body class="platform-body">
    <form id="form1" runat="server">
        <!-- Top Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark-custom sticky-top py-3 shadow-sm border-bottom border-secondary border-opacity-10">
            <div class="container">
                <a class="navbar-brand brand-logo d-flex align-items-center text-white text-decoration-none" href="../Default.aspx">
                    <div class="brand-icon-box me-2 shadow-sm">
                        <i class="fa-solid fa-graduation-cap text-white"></i>
                    </div>
                    <span class="fw-bold tracking-tight fs-5">Uni<span class="text-accent">Portfolio</span> <span class="badge bg-danger ms-2 fs-6">Admin Portal</span></span>
                </a>
                <div class="d-flex align-items-center gap-3">
                    <asp:HyperLink runat="server" NavigateUrl="../Default.aspx" CssClass="btn btn-outline-light btn-sm rounded-pill px-3 fw-semibold">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back to Feed
                    </asp:HyperLink>
                    <asp:Button ID="btnLogout" runat="server" Text="Log Out" CssClass="btn btn-outline-danger btn-sm rounded-pill px-3 fw-semibold" OnClick="btnLogout_Click" />
                </div>
            </div>
        </nav>

        <!-- Dashboard Content Area -->
        <div class="container py-5">
            <!-- Header Banner with Fade-In Animation -->
            <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-4 rounded-4 shadow-sm border border-opacity-10 animate-fade-in-up">
                <div>
                    <h3 class="fw-bold text-dark mb-1"><i class="fa-solid fa-chart-line text-primary me-2"></i>Executive Analytics Dashboard</h3>
                    <p class="text-muted small mb-0">Real-time system insights, platform statistics, and registered user reports.</p>
                </div>
                <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-2 rounded-pill fw-semibold">
                    <i class="fa-solid fa-circle text-success small me-1 status-pulse"></i> System Online & Secure
                </span>
            </div>

            <!-- Statistics Summary Cards with Staggered Animations -->
            <div class="row g-4 mb-5">
                <div class="col-md-4 animate-fade-in-up animate-delay-1">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white border-start border-4 border-primary">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p class="text-uppercase text-muted fw-semibold small mb-1">Total Registered Users</p>
                                <h3 class="fw-bold text-dark mb-0"><asp:Label ID="lblTotalUsers" runat="server" Text="0" /></h3>
                            </div>
                            <div class="bg-primary bg-opacity-10 p-3 rounded-circle text-primary fs-4">
                                <i class="fa-solid fa-users"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 animate-fade-in-up animate-delay-2">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white border-start border-4 border-success">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p class="text-uppercase text-muted fw-semibold small mb-1">Student Accounts</p>
                                <h3 class="fw-bold text-dark mb-0"><asp:Label ID="lblTotalStudents" runat="server" Text="0" /></h3>
                            </div>
                            <div class="bg-success bg-opacity-10 p-3 rounded-circle text-success fs-4">
                                <i class="fa-solid fa-user-graduate"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 animate-fade-in-up animate-delay-3">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white border-start border-4 border-danger">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p class="text-uppercase text-muted fw-semibold small mb-1">Administrator Accounts</p>
                                <h3 class="fw-bold text-dark mb-0"><asp:Label ID="lblTotalAdmins" runat="server" Text="0" /></h3>
                            </div>
                            <div class="bg-danger bg-opacity-10 p-3 rounded-circle text-danger fs-4">
                                <i class="fa-solid fa-shield-halved"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Graphs Section -->
            <div class="row g-4 mb-5">
                <div class="col-lg-6 animate-fade-in-up animate-delay-2">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-chart-pie text-primary me-2"></i>Account Role Distribution</h5>
                        <div class="position-relative" style="height: 280px;">
                            <canvas id="roleChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 animate-fade-in-up animate-delay-3">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-chart-column text-success me-2"></i>Platform Engagement Metrics</h5>
                        <div class="position-relative" style="height: 280px;">
                            <canvas id="growthChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Registered Users Table Directory -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white animate-fade-in-up animate-delay-3">
                <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-table-list text-primary me-2"></i>System Users Directory</h5>
                <div class="table-responsive">
                    <asp:GridView ID="gvUsers" runat="server" CssClass="table table-hover align-middle mb-0" AutoGenerateColumns="false" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="UserId" HeaderText="ID" />
                            <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                            <asp:BoundField DataField="Username" HeaderText="Username" />
                            <asp:BoundField DataField="Email" HeaderText="Email Address" />
                            <asp:BoundField DataField="ContactNumber" HeaderText="Contact Number" />
                            <asp:TemplateField HeaderText="Role">
                                <ItemTemplate>
                                    <span class='<%# Eval("Role").ToString() == "Admin" ? "badge bg-danger" : "badge bg-primary" %>'>
                                        <%# Eval("Role") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Headline" HeaderText="Headline" />
                            <asp:TemplateField HeaderText="Portfolio Website">
                                <ItemTemplate>
                                    <%# string.IsNullOrEmpty(Eval("PortfolioUrl")?.ToString()) ? "<span class='text-muted small'>N/A</span>" : $"<a href='{(Eval("PortfolioUrl").ToString().StartsWith("http") ? Eval("PortfolioUrl") : "https://" + Eval("PortfolioUrl"))}' target='_blank' class='btn btn-sm btn-outline-success rounded-pill'><i class='fa-solid fa-globe me-1'></i>Visit</a>" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Education" HeaderText="Educational Attainment" NullDisplayText="N/A" />
                            <asp:BoundField DataField="Skills" HeaderText="Skills" NullDisplayText="N/A" />
                            <asp:BoundField DataField="Hobbies" HeaderText="Hobbies" NullDisplayText="N/A" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>

    <!-- Chart.js Render Script -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const studentCount = parseInt('<%= lblTotalStudents.Text %>') || 0;
            const adminCount = parseInt('<%= lblTotalAdmins.Text %>') || 0;

            const ctxRole = document.getElementById('roleChart').getContext('2d');
            new Chart(ctxRole, {
                type: 'doughnut',
                data: {
                    labels: ['Students / Professionals', 'Administrators'],
                    datasets: [{
                        data: [studentCount, adminCount],
                        backgroundColor: ['#6366f1', '#ef4444'],
                        borderWidth: 0,
                        hoverOffset: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'bottom' } }
                }
            });

            const ctxGrowth = document.getElementById('growthChart').getContext('2d');
            new Chart(ctxGrowth, {
                type: 'bar',
                data: {
                    labels: ['Total Portfolios', 'Verified Contacts', 'Active Sessions'],
                    datasets: [{
                        label: 'Metrics',
                        data: [studentCount + adminCount, studentCount + adminCount, studentCount],
                        backgroundColor: ['#3b82f6', '#10b981', '#f59e0b'],
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
                }
            });
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>