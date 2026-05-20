<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineStore - Crear cuenta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div id="stars-container"></div>
<div class="planet"></div>
<div class="container d-flex justify-content-center align-items-center min-vh-100 py-5">
    <div class="card shadow-lg border-0 overflow-hidden w-100 custom-modal" style="max-width: 1000px; border-radius: 20px; min-height: 550px;">

        <div class="row g-0 h-100" style="min-height: inherit;">

            <div class="col-md-6 d-none d-md-flex flex-column justify-content-center align-items-center p-5 position-relative" style="background-color: #141414; border-right: 1px solid rgba(255,255,255,0.05);">
                <div class="brand text-center">
                    <img src="../img/logo-cinestore.svg" alt="CineStore" style="width: 120px; height: 120px; object-fit: contain; margin-bottom: 1rem;">
                    <h1 class="fw-bold m-0 text-white" style="font-size: 3rem; letter-spacing: 1px;">CINE<span style="color: var(--accent-color);">STORE</span></h1>
                    <p class="text-white-50 mt-3" style="font-size: 1.1rem;">Tu tienda visual de películas digitales</p>
                </div>
            </div>

            <div class="col-md-6 p-4 p-lg-5 d-flex flex-column justify-content-center bg-white position-relative" data-bs-theme="light">
                <button id="theme-toggle" class="btn btn-outline-secondary btn-sm position-absolute top-0 end-0 m-3" title="Cambiar tema" aria-label="Cambiar tema">
                    <i class="bi bi-moon-stars" id="theme-icon"></i>
                </button>

                <div class="d-flex justify-content-start mb-3">
                    <button class="btn btn-outline-secondary rounded-pill btn-sm px-3 fw-bold text-dark" data-action="go-back" data-fallback="../index.jsp">
                        <i class="bi bi-arrow-left me-1"></i>Volver
                    </button>
                </div>

                <div class="text-start mb-4">
                    <h2 class="fw-bold m-0 text-dark">Crear cuenta</h2>
                    <p class="text-muted small">Ingresa tus datos para registrarte</p>
                </div>

                <div class="mb-4 text-center">
                    <p class="text-muted small mb-3 fw-bold text-uppercase" style="letter-spacing: 1px;">Selecciona tu Avatar</p>

                    <div class="avatar-main-container position-relative mb-3">
                        <div class="avatar-main-preview shadow-lg">
                            <img src="" alt="Avatar Seleccionado" id="avatarImage">
                        </div>
                        <div class="avatar-checked-badge" id="avatarBadge">
                            <i class="fas fa-check"></i>
                        </div>
                    </div>

                    <div class="avatar-options-wrapper">
                        <div class="avatar-options-container d-flex justify-content-center gap-3 py-2" id="avatarOptionsContainer">
                        </div>

                        <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill mt-2 px-3 style-btn" id="refreshAvatarBtn">
                            <i class="fas fa-random me-1"></i> Cambiar opciones
                        </button>
                    </div>

                    <input type="hidden" name="avatarUrl" id="avatarUrl">
                </div>

                <%-- Alerta de error si el registro falla (Opcional, manejado por el Servlet) --%>
                <% if(request.getParameter("error") != null) { %>
                <div class="alert alert-danger py-2 small" role="alert">
                    Error al crear la cuenta. Revisa los datos e intenta nuevamente.
                </div>
                <% } %>

                <form id="signup-form" action="${pageContext.request.contextPath}/RegistroServlet" method="POST">

                    <input type="hidden" id="avatarUrl" name="avatarUrl">

                    <div class="mb-4">
                        <label for="signupName" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Nombre completo</label>
                        <div class="input-group border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-person text-muted fs-5"></i></span>
                            <input type="text" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" id="signupName" name="nombre" placeholder="Tu nombre" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="signupCedula" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Cédula</label>
                        <div class="input-group border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-card-heading text-muted fs-5"></i></span>
                            <input type="text" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" id="signupCedula" name="cedula" placeholder="Tu número de cédula" required>
                            <span id="cedulaProvince" class="input-group-text bg-transparent border-0 py-2 text-muted small cedula-province">Provincia</span>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="signupEmail" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Correo</label>
                        <div class="input-group border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-envelope text-muted fs-5"></i></span>
                            <input type="email" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" id="signupEmail" name="correo" placeholder="tu@email.com" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="estado_civil" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Estado Civil</label>
                        <div class="input-group border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-people text-muted fs-5"></i></span>
                            <select id="estado_civil" name="id_est" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" required>
                                <option value="" disabled selected>Seleccione su estado civil</option>
                                <option value="1">Soltero/a</option>
                                <option value="2">Casado/a</option>
                                <option value="3">Divorciado/a</option>
                                <option value="4">Viudo/a</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="signupPassword" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Contraseña</label>
                        <div class="input-group border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-lock text-muted fs-5"></i></span>
                            <input type="password" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" id="signupPassword" name="clave" placeholder="Crea una contraseña" minlength="6" required>
                        </div>
                    </div>

                    <div class="form-check mb-4 mt-2">
                        <input class="form-check-input border-secondary" type="checkbox" value="1" id="signupTerms" required>
                        <label class="form-check-label text-muted small" for="signupTerms">
                            Acepto los términos y condiciones
                        </label>
                    </div>

                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-signup text-white rounded-pill py-3 fw-bold shadow-sm" style="font-size: 1rem; background-color: var(--accent-color, #0d6efd);">CREAR CUENTA</button>
                    </div>

                    <div class="text-center mt-3 mb-2">
                        <span class="text-muted small d-block mb-1">¿Ya tienes cuenta?</span>
                        <a href="login.jsp" class="btn border-secondary rounded-pill px-4 py-2 mt-2 w-100 fw-bold d-block text-decoration-none text-center d-flex justify-content-center align-items-center text-dark">Volver a iniciar sesión</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/script.js"></script>
<script type="module">
    import { initAvatarGenerator } from '../js/utils/avatar.js';
    import { initSignupValidation } from '../js/utils/signup.js';

    document.addEventListener('DOMContentLoaded', () => {
        initAvatarGenerator();
        initSignupValidation();
    });
</script>
<script>
    // Script para alternar tema claro/oscuro
    document.addEventListener('DOMContentLoaded', function() {
        const html = document.documentElement;
        const btn = document.getElementById('theme-toggle');
        const icon = document.getElementById('theme-icon');
        // Cargar preferencia guardada
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            html.setAttribute('data-bs-theme', savedTheme);
            icon.className = savedTheme === 'light' ? 'bi bi-brightness-high' : 'bi bi-moon-stars';
        }
        btn.addEventListener('click', function() {
            const current = html.getAttribute('data-bs-theme') === 'light' ? 'dark' : 'light';
            html.setAttribute('data-bs-theme', current);
            localStorage.setItem('theme', current);
            icon.className = current === 'light' ? 'bi bi-brightness-high' : 'bi bi-moon-stars';
        });
    });
</script>
</body>
</html>