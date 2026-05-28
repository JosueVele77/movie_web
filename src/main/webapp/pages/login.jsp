<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<% if ("credenciales".equals(request.getParameter("error"))) { %>
<div class="alert alert-danger small py-2 text-center" role="alert">
    <i class="fas fa-exclamation-circle me-1"></i> Correo o contraseña incorrectos. Inténtalo de nuevo.
</div>
<% } else if ("1".equals(request.getParameter("error"))) { %>
<div class="alert alert-warning small py-2 text-center" role="alert">
    <i class="fas fa-exclamation-triangle me-1"></i> Por favor, llena todos los campos.
</div>
<% } %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineStore - Iniciar Sesión</title>
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
                    <h2 class="fw-bold m-0 text-dark">¡Hola de nuevo!</h2>
                    <p class="text-muted small">Ingresa tus datos para continuar</p>
                </div>

                <%-- Alertas Dinámicas del Servlet (Éxito o Error) --%>
                <% if(request.getParameter("success") != null) { %>
                <div class="alert alert-success py-2 small" role="alert">
                    <i class="bi bi-check-circle me-1"></i> ¡Registro exitoso! Ya puedes iniciar sesión.
                </div>
                <% } %>
                <% if(request.getParameter("error") != null) { %>
                <div class="alert alert-danger py-2 small" role="alert">
                    <i class="bi bi-exclamation-triangle me-1"></i> Correo o contraseña incorrectos.
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-uppercase text-secondary mb-1" style="font-size: 0.75rem; letter-spacing: 1px;">Correo Electrónico</label>
                        <div class="input-group border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-envelope text-muted fs-5"></i></span>
                            <input type="email" name="correo" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" placeholder="tu@email.com" required>
                        </div>
                    </div>

                    <div class="mb-2">
                        <label class="form-label small fw-bold text-uppercase text-secondary mb-1" style="font-size: 0.75rem; letter-spacing: 1px;">Contraseña</label>
                        <div class="input-group border-bottom border-2">
                            <span class="input-group-text bg-transparent border-0 ps-0 py-2"><i class="bi bi-lock text-muted fs-5"></i></span>
                            <input type="password" name="clave" class="form-control bg-transparent border-0 shadow-none py-2 fs-6 text-dark" placeholder="Tu contraseña" required>
                        </div>
                    </div>

                    <div class="text-end mb-4">
                        <a href="#" class="text-decoration-none fw-bold text-primary" style="font-size: 0.8rem;">¿Olvidaste tu contraseña?</a>
                    </div>

                    <button type="submit" class="btn btn-login w-100 py-3 rounded-pill fw-bold shadow-sm mb-4 text-white" style="font-size: 1rem; background-color: var(--accent-color, #0d6efd);">
                        INICIAR SESIÓN
                    </button>

                    <div class="position-relative mb-4 text-center text-muted" style="font-size: 0.85rem;">
                        <hr class="position-absolute w-100" style="top: 50%; transform: translateY(-50%); margin: 0; z-index: 1; border-color: rgba(0,0,0,0.1);">
                        <span class="px-3 position-relative text-muted custom-modal-divider bg-white" style="z-index: 2;">O continúa con</span>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mb-4">
                        <button type="button" class="btn btn-outline-secondary rounded-circle btn-social text-dark border-secondary"><i class="bi bi-google"></i></button>
                        <button type="button" class="btn btn-outline-secondary rounded-circle btn-social text-dark border-secondary"><i class="bi bi-facebook"></i></button>
                        <button type="button" class="btn btn-outline-secondary rounded-circle btn-social text-dark border-secondary"><i class="bi bi-twitter-x"></i></button>
                    </div>

                    <p class="text-center m-0 text-muted" style="font-size: 0.9rem;">
                        ¿No tienes cuenta? <a href="registro.jsp" class="text-primary fw-bold text-decoration-none">Regístrate</a>
                    </p>
                </form>
            </div>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/script.js"></script>
<script>
    // Limpiar datos temporales del UI
    document.addEventListener('DOMContentLoaded', function() {
        localStorage.removeItem('comesFrom3dSection');

        // Script para alternar tema claro/oscuro
        const html = document.documentElement;
        const btn = document.getElementById('theme-toggle');
        const icon = document.getElementById('theme-icon');
        // Cargar preferencia guardada (mantener tema)
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