<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineStore - Página Fuera de Órbita</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../css/styles.css">
    <script>
        // Sincronizar modo claro/oscuro instantáneamente para evitar parpadeos visuales
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        }
    </script>
</head>
<body class="d-flex align-items-center min-vh-100 position-relative overflow-hidden">
<div id="stars-container"></div>

<div class="container text-center position-relative" style="z-index: 10;">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">

            <div class="error-icon-container mb-4">
                <i class="bi bi-film display-1 error-cinema-icon"></i>
                <i class="bi bi-exclamation-triangle-fill error-badge-icon"></i>
            </div>

            <h1 class="display-1 error-404-title mb-2">404</h1>

            <h2 class="h4 fw-bold text-uppercase mb-4" style="color: var(--accent-color); letter-spacing: 0.3em;">
                Página Fuera de Órbita
            </h2>

            <p class="fs-5 text-muted mb-5 px-3">
                Lo sentimos, la película, función o sección que estás buscando no se encuentra disponible en cartelera o ha sido removida del espacio sideral.
            </p>

            <a href="../index.jsp" class="btn btn-login rounded-pill px-5 py-3 fw-bold shadow-lg transition-all">
                <i class="bi bi-camera-reel-fill me-2"></i>Volver al Catálogo
            </a>
        </div>
    </div>
</div>

<script src="../js/script.js"></script>
</body>
</html>