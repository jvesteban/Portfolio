/**
 * site.js - Global Client-side Utilities & Validations
 */
document.addEventListener("DOMContentLoaded", function () {
    initApp();
});

// Support for ASP.NET AJAX UpdatePanel Partial PostBacks
if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        initApp();
    });
}

function initApp() {
    initAlerts();
    initCardEffects();
    initRealtimeValidation();
    initPasswordToggle();
    initSubmitButtonLoading();
    initExternalLinks();
}

/* 1. Auto-hide Alert Messages */
function initAlerts() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alertPanel => {
        if (alertPanel && !alertPanel.dataset.hasTimeout) {
            alertPanel.dataset.hasTimeout = "true";
            setTimeout(function () {
                alertPanel.classList.remove("show");
                setTimeout(() => {
                    alertPanel.style.display = "none";
                }, 300);
            }, 4000);
        }
    });
}

/* 2. Smooth Card Hover Animation */
function initCardEffects() {
    const cards = document.querySelectorAll('.card-profile, .card');
    cards.forEach(card => {
        card.addEventListener('mouseenter', function () {
            this.style.transform = 'translateY(-4px)';
            this.style.transition = 'all 0.25s ease-in-out';
            this.style.boxShadow = '0 0.5rem 1rem rgba(0, 0, 0, 0.15)';
        });
        card.addEventListener('mouseleave', function () {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '';
        });
    });
}

/* 3. Real-Time Form & Input Validation (On typing or on blur) */
function initRealtimeValidation() {
    const inputs = document.querySelectorAll('.form-control, input[type="text"], input[type="email"], input[type="password"], textarea');

    inputs.forEach(input => {
        // Prevent attaching duplicate listeners
        if (input.dataset.hasValidation) return;
        input.dataset.hasValidation = "true";

        // Validate on input and blur
        input.addEventListener('input', function () {
            validateField(this);
        });

        input.addEventListener('blur', function () {
            validateField(this);
        });
    });
}

function validateField(input) {
    // Skip if optional and empty
    if (!input.hasAttribute('required') && input.value.trim() === '') {
        clearValidationState(input);
        return;
    }

    let isValid = true;
    let errorMessage = '';

    // Check 1: Required Field
    if (input.hasAttribute('required') && input.value.trim() === '') {
        isValid = false;
        errorMessage = 'This field is required.';
    }
    // Check 2: Email Format Check
    else if (input.type === 'email' || input.id.toLowerCase().includes('email')) {
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (input.value.trim() !== '' && !emailPattern.test(input.value.trim())) {
            isValid = false;
            errorMessage = 'Please enter a valid email address (e.g., name@domain.com).';
        }
    }
    // Check 3: Phone/Contact Number Check
    else if (input.id.toLowerCase().includes('contact') || input.id.toLowerCase().includes('phone')) {
        const phonePattern = /^[0-9+\s-]{7,15}$/;
        if (input.value.trim() !== '' && !phonePattern.test(input.value.trim())) {
            isValid = false;
            errorMessage = 'Please enter a valid contact number.';
        }
    }

    // UI Feedback
    if (!isValid) {
        input.classList.add('is-invalid');
        input.classList.remove('is-valid');
        showFieldError(input, errorMessage);
    } else if (input.value.trim() !== '') {
        input.classList.remove('is-invalid');
        input.classList.add('is-valid');
        removeFieldError(input);
    } else {
        clearValidationState(input);
    }
}

function showFieldError(input, message) {
    let errorFeed = input.nextElementSibling;
    if (!errorFeed || !errorFeed.classList.contains('invalid-feedback')) {
        errorFeed = document.createElement('div');
        errorFeed.className = 'invalid-feedback small text-danger mt-1';
        input.parentNode.insertBefore(errorFeed, input.nextSibling);
    }
    errorFeed.innerText = message;
}

function removeFieldError(input) {
    const errorFeed = input.nextElementSibling;
    if (errorFeed && errorFeed.classList.contains('invalid-feedback')) {
        errorFeed.remove();
    }
}

function clearValidationState(input) {
    input.classList.remove('is-invalid', 'is-valid');
    removeFieldError(input);
}

/* 4. Password Show/Hide Toggle Button */
function initPasswordToggle() {
    const passwordInputs = document.querySelectorAll('input[type="password"]');
    passwordInputs.forEach(input => {
        if (input.dataset.hasToggle) return;
        input.dataset.hasToggle = "true";

        const parent = input.parentElement;
        if (parent && parent.classList.contains('input-group')) {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'btn btn-outline-secondary';
            btn.innerHTML = '👁️';
            btn.title = 'Show/Hide Password';

            btn.addEventListener('click', function () {
                if (input.type === 'password') {
                    input.type = 'text';
                    btn.innerHTML = '🙈';
                } else {
                    input.type = 'password';
                    btn.innerHTML = '👁️';
                }
            });

            parent.appendChild(btn);
        }
    });
}

/* 5. Button Loading State (Prevent Double Submit) */
function initSubmitButtonLoading() {
    const submitBtns = document.querySelectorAll('form input[type="submit"], form button[type="submit"]');
    submitBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            const form = this.closest('form');

            // Do not alter button state if the form is invalid
            if (form && form.checkValidity && !form.checkValidity()) {
                return;
            }

            // Short delay to allow ASP.NET PostBack to trigger first
            setTimeout(() => {
                this.disabled = true;
                if (this.tagName === 'INPUT') {
                    this.value = 'Processing...';
                } else {
                    this.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status"></span>Processing...';
                }
            }, 50);
        });
    });
}

/* 6. Security Hardening for External Links */
function initExternalLinks() {
    const links = document.querySelectorAll('a[target="_blank"]');
    links.forEach(link => {
        link.setAttribute('rel', 'noopener noreferrer');
    });
}