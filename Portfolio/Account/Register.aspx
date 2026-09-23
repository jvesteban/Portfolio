<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Portfolio.Account.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Account | UniPortfolio</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <!-- Custom Theme CSS -->
    <link href="~/CSS/site.css" rel="stylesheet" type="text/css" runat="server" />
    <link href="~/CSS/Register.css" rel="stylesheet" type="text/css" runat="server" />
</head>
<body class="platform-body d-flex align-items-center min-vh-100 py-5">
    <form id="form1" runat="server" class="w-100">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-7 col-lg-6 animate-fade-in-up">
                    <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                        <div class="card-body p-4 p-sm-5 bg-white">
                            <div class="text-center mb-4">
                                <div class="brand-icon-box mx-auto mb-3 text-white rounded-circle d-flex align-items-center justify-content-center">
                                    <i class="fa-solid fa-graduation-cap fs-3"></i>
                                </div>
                                <h4 class="fw-bold text-dark mb-1">Create Student Account</h4>
                                <p class="text-muted small">Join UniPortfolio to build and showcase your digital portfolio</p>
                            </div>

                            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show rounded-3 small mb-3" role="alert">
                                <asp:Label ID="lblAlertMessage" runat="server" />
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </asp:Panel>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold small text-secondary">First Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-id-card"></i></span>
                                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control bg-light border-start-0 py-2" Placeholder="Enter first name" required="required" />
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold small text-secondary">Surname</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-user"></i></span>
                                        <asp:TextBox ID="txtSurname" runat="server" CssClass="form-control bg-light border-start-0 py-2" Placeholder="Enter surname" required="required" />
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-secondary">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-at"></i></span>
                                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control bg-light border-start-0 py-2" Placeholder="Choose a unique username" required="required" />
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold small text-secondary">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-envelope"></i></span>
                                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control bg-light border-start-0 py-2" Placeholder="name@domain.com" required="required" />
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold small text-secondary">Contact Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-phone"></i></span>
                                        <asp:TextBox ID="txtContact" runat="server" MaxLength="11" CssClass="form-control bg-light border-start-0 py-2" Placeholder="09123456789" required="required" onkeypress="return event.charCode >= 48 && event.charCode <= 57" />
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-secondary">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-lock"></i></span>
                                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control bg-light border-start-0 py-2" Placeholder="Create a strong password" required="required" />
                                </div>
                            </div>

                            <!-- Initial Trigger Button -->
                            <button type="button" class="btn btn-dark w-100 rounded-pill py-2 fw-semibold shadow-sm mb-3" onclick="showRegisterConfirmation()">
                                Create Account
                            </button>

                            <div class="text-center border-top pt-3">
                                <span class="text-muted small">Already registered? </span>
                                <asp:HyperLink runat="server" NavigateUrl="Login.aspx" CssClass="fw-semibold text-primary text-decoration-none small">Sign In</asp:HyperLink>
                            </div>
                            <div class="text-center mt-2">
                                <asp:HyperLink runat="server" NavigateUrl="../Default.aspx" CssClass="text-secondary small text-decoration-none"><i class="fa-solid fa-arrow-left me-1"></i>Return to Feed</asp:HyperLink>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Registration Confirmation Modal -->
        <div class="modal fade" id="confirmRegisterModal" tabindex="-1" aria-labelledby="confirmRegisterModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow rounded-4">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-dark" id="confirmRegisterModalLabel">
                            <i class="fa-solid fa-user-plus text-primary me-2"></i>Confirm Registration
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-secondary py-3">
                        Are you sure you want to create your UniPortfolio account with the provided details?
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-semibold small" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnRegister" runat="server" Text="Yes, Create Account" CssClass="btn btn-dark rounded-pill px-4 fw-semibold small shadow-sm" OnClick="btnRegister_Click" UseSubmitBehavior="false" />
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
    var inputs = document.querySelectorAll('#form1 input[type="text"], #form1 input[type="email"], #form1 input[type="password"]');

    function handleEnterKey(e) {
        if (e.key === 'Enter' || e.keyCode === 13) {
            e.preventDefault();
            showRegisterConfirmation();
        }
    }

    inputs.forEach(function (input) {
        input.addEventListener('keydown', handleEnterKey);
    });
});

function showRegisterConfirmation() {
    var form = document.getElementById('form1');
    if (form.checkValidity()) {
        var confirmModal = new bootstrap.Modal(document.getElementById('confirmRegisterModal'));
        confirmModal.show();
    } else {
        form.reportValidity();
    }
}
</script>
</body>
</html>