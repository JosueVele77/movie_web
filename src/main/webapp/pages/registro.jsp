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

            <!-- MITAD IZQUIERDA: LOGO -->
            <div class="col-md-6 d-none d-md-flex flex-column justify-content-center align-items-center p-5 position-relative" style="background-color: #141414; border-right: 1px solid rgba(255,255,255,0.05);">
                <div class="brand text-center">
                    <img src="../img/logo-cinestore.svg" alt="CineStore" style="width: 120px; height: 120px; object-fit: contain; margin-bottom: 1rem;">
                    <h1 class="fw-bold m-0 text-white" style="font-size: 3rem; letter-spacing: 1px;">CINE<span style="color: var(--accent-color);">STORE</span></h1>
                    <p class="text-white-50 mt-3" style="font-size: 1.1rem;">Tu tienda visual de películas digitales</p>
                </div>
            </div>

            <!-- MITAD DERECHA: FORMULARIO -->
            <div class="col-md-6 p-4 p-lg-5 d-flex flex-column justify-content-center bg-white position-relative" data-bs-theme="light">
                <!-- Botón de cambio de tema -->
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

                <form id="signup-form" action="#" method="POST" novalidate>
                    <div class="mb-4">
                        <label for="signupName" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Nombre completo</label>
                        <div class="input-group has-validation border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-person text-muted fs-5"></i></span>
                            <input type="text" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" id="signupName" name="name" placeholder="Tu nombre" autocomplete="name" required>
                            <div class="invalid-feedback">Ingresa tu nombre.</div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="signupEmail" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Correo</label>
                        <div class="input-group has-validation border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-envelope text-muted fs-5"></i></span>
                            <input type="email" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" id="signupEmail" name="email" placeholder="tu@email.com" autocomplete="email" required>
                            <div class="invalid-feedback">Ingresa un correo válido.</div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="signupUsername" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Usuario</label>
                        <div class="input-group has-validation border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-at text-muted fs-5"></i></span>
                            <input type="text" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" id="signupUsername" name="username" placeholder="Elige un usuario" autocomplete="username" required>
                            <div class="invalid-feedback">El usuario es obligatorio.</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="signupPassword" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Contraseña</label>
                        <div class="input-group has-validation border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-lock text-muted fs-5"></i></span>
                            <input type="password" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" id="signupPassword" name="password" placeholder="Crea una contraseña" autocomplete="new-password" minlength="6" required>
                            <div class="invalid-feedback">La contraseña debe tener al menos 6 caracteres.</div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="signupPasswordConfirm" class="form-label text-muted small fw-bold" style="font-size: 0.75rem; letter-spacing: 1px; text-transform: uppercase;">Confirmar contraseña</label>
                        <div class="input-group has-validation border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-shield-lock text-muted fs-5"></i></span>
                            <input type="password" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" id="signupPasswordConfirm" name="passwordConfirm" placeholder="Repite tu contraseña" autocomplete="new-password" minlength="6" required>
                            <div class="invalid-feedback">Las contraseñas no coinciden.</div>
                        </div>
                    </div>
                    <div class="form-check mb-4">
                        <input class="form-check-input border-secondary" type="checkbox" value="1" id="signupTerms" required>
                        <label class="form-check-label text-muted small" for="signupTerms">
                            Acepto los términos y condiciones
                        </label>
                        <div class="invalid-feedback">Debes aceptar los términos para continuar.</div>
                    </div>
                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-signup text-white rounded-pill py-3 fw-bold shadow-sm" style="font-size: 1rem;">CREAR CUENTA</button>
                    </div>
                    <div id="signupSuccess" class="alert alert-success py-2 small d-none" role="alert">
                        Cuenta creada (demo). Redirigiendo a Iniciar sesión...
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

