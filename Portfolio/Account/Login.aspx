<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Portfolio.Account.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign In | UniPortfolio</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <!-- Custom Theme CSS -->
    <link href="~/CSS/site.css" rel="stylesheet" type="text/css" runat="server" />
    <link href="~/CSS/Login.css" rel="stylesheet" type="text/css" runat="server" />
</head>
<body class="platform-body d-flex align-items-center min-vh-100 py-5">
    <form id="form1" runat="server" class="w-100">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-5 col-lg-4 animate-fade-in-up">
                    <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                        <div class="card-body p-4 p-sm-5 bg-white">
                            <div class="text-center mb-4">
                                <div class="brand-icon-box mx-auto mb-3 text-white rounded-circle d-flex align-items-center justify-content-center">
                                    <i class="fa-solid fa-graduation-cap fs-3"></i>
                                </div>
                                <h4 class="fw-bold text-dark mb-1">Welcome Back</h4>
                                <p class="text-muted small">Sign in to your UniPortfolio account</p>
                            </div>

                            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show rounded-3 small mb-3" role="alert">
                                <asp:Label ID="lblAlertMessage" runat="server" />
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </asp:Panel>

                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-secondary">Username or Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-user"></i></span>
                                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control bg-light border-start-0 py-2" Placeholder="Enter your username or email" required="required" />
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-secondary">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-lock"></i></span>
                                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control bg-light border-start-0 py-2" Placeholder="Enter your password" required="required" />
                                </div>
                            </div>

                            <!-- Initial Trigger Button -->
                            <button type="button" class="btn btn-dark w-100 rounded-pill py-2 fw-semibold shadow-sm mb-3" onclick="showLoginConfirmation()">
                                Sign In
                            </button>

                            <div class="text-center border-top pt-3">
                                <span class="text-muted small">Don't have an account? </span>
                                <asp:HyperLink runat="server" NavigateUrl="Register.aspx" CssClass="fw-semibold text-primary text-decoration-none small">Create an Account</asp:HyperLink>
                            </div>
                            <div class="text-center mt-2">
                                <asp:HyperLink runat="server" NavigateUrl="../Default.aspx" CssClass="text-secondary small text-decoration-none"><i class="fa-solid fa-arrow-left me-1"></i>Return to Feed</asp:HyperLink>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Confirmation Modal -->
        <div class="modal fade" id="confirmLoginModal" tabindex="-1" aria-labelledby="confirmLoginModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow rounded-4">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-dark" id="confirmLoginModalLabel">
                            <i class="fa-solid fa-circle-question text-primary me-2"></i>Confirm Sign In
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-secondary py-3">
                        Are you sure you want to proceed with signing in using these credentials?
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-semibold small" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnLogin" runat="server" Text="Yes, Proceed" CssClass="btn btn-dark rounded-pill px-4 fw-semibold small shadow-sm" OnClick="btnLogin_Click" UseSubmitBehavior="false" />
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Bootstrap & Global site.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src='<%= ResolveUrl("~/Script/site.js") %>'></script>
    
    <script>
document.addEventListener('DOMContentLoaded', function () {
    var txtUser = document.getElementById('<%= txtUsername.ClientID %>');
            var txtPass = document.getElementById('<%= txtPassword.ClientID %>');

            function handleEnterKey(e) {
                if (e.key === 'Enter' || e.keyCode === 13) {
                    e.preventDefault();
                    showLoginConfirmation();
                }
            }

            if (txtUser) txtUser.addEventListener('keydown', handleEnterKey);
            if (txtPass) txtPass.addEventListener('keydown', handleEnterKey);
        });

        function showLoginConfirmation() {
            var form = document.getElementById('form1');
            if (form.checkValidity()) {
                var confirmModal = new bootstrap.Modal(document.getElementById('confirmLoginModal'));
                confirmModal.show();
            } else {
                form.reportValidity();
            }
        }
    </script>
</body>
</html>