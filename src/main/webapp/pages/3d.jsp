<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineStore - Experiencia 3D</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../css/styles.css">
    <script>
        // Sincronizar modo claro/oscuro instantáneamente
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        }
    </script>
</head>
<body>
<div id="stars-container"></div>

<nav class="navbar navbar-expand-lg custom-navbar py-3 sticky-top">
    <div class="container-fluid px-4 px-lg-5">
        <a class="navbar-brand d-flex align-items-center gap-2" href="<%= request.getContextPath() %>/index.jsp">
            <img src="<%= request.getContextPath() %>/img/logo-cinestore.svg" alt="CineStore" class="brand-logo" style="width: 50px; height: 50px; object-fit: contain;">
        </a>
        <ul class="navbar-nav ms-auto align-items-center">
            <li class="nav-item">
                <button class="btn btn-outline-light rounded-pill px-4" data-action="go-back" data-fallback="../index.jsp">
                    <i class="bi bi-arrow-left me-2"></i>Volver al Catálogo
                </button>
            </li>
        </ul>
    </div>
</nav>

<header class="category-hero text-white position-relative overflow-hidden" style="background-image: linear-gradient(135deg, rgba(10,10,15,0.95), rgba(30,15,50,0.85)); border-bottom: 2px solid var(--accent-color);">
    <div class="container py-5 text-center text-md-start">
        <div class="category-hero-card border-0" style="background: rgba(0, 0, 0, 0.4); backdrop-filter: blur(4px);">
            <p class="category-hero-label text-info" style="letter-spacing: 0.4em;"><i class="bi bi-layer-forward me-2"></i>INMERSIÓN TOTAL</p>
            <h1 class="display-3 fw-bold mb-3 text-white clear-3d-title">SALA DIGITAL 3D</h1>
            <p class="fs-5 text-white-50">Explora producciones cinematográficas masterizadas con profundidad estereoscópica avanzada y efectos volumétricos dinámicos.</p>
        </div>
    </div>
</header>

<main class="container py-5">
    <!-- PRIMER BLOQUE: God of War -->
    <div class="mb-5">
        <h2 class="text-center mb-3">God of War</h2>
        <div class="d-flex justify-content-center mb-2">
            <a href="compra.jsp" class="btn btn-success btn-lg">Comprar</a>
        </div>
        <div class="sketchfab-embed-wrapper d-flex justify-content-center align-items-center" style="min-height: 80vh;">
            <iframe title="God of War" frameborder="0" allowfullscreen mozallowfullscreen="true" webkitallowfullscreen="true" allow="autoplay; fullscreen; xr-spatial-tracking" xr-spatial-tracking execution-while-out-of-viewport execution-while-not-rendered web-share width="960" height="720" src="https://sketchfab.com/models/d5c542e24bee490fbdf130413983f124/embed?autospin=1&autostart=1&preload=1&transparent=1&ui_hint=0&ui_theme=dark&autoplay=1"> </iframe>
        </div>
    </div>

    <!-- SEGUNDO BLOQUE: Resident Evil 4 -->
    <div>
        <h2 class="text-center mb-3">Resident Evil 4</h2>
        <div class="d-flex justify-content-center mb-2">
            <a href="compra.jsp" class="btn btn-success btn-lg">Comprar</a>
        </div>
        <div class="sketchfab-embed-wrapper d-flex justify-content-center align-items-center" style="min-height: 60vh;">
            <iframe title="Resident Evil 4" frameborder="0" allowfullscreen allow="autoplay; fullscreen" width="960" height="720" src="https://sketchfab.com/models/7c3e9934a24e4884b923c0ebbb7af547/embed?autospin=1&autostart=1&preload=1&transparent=1&ui_theme=dark"></iframe>
        </div>
    </div>

    <!-- TERCER BLOQUE: Mortal Kombat Armageddon -->
    <div class="mt-5">
        <h2 class="text-center mb-3">Mortal Kombat Armageddon</h2>
        <div class="d-flex justify-content-center mb-2">
            <a href="compra.jsp" class="btn btn-success btn-lg">Comprar</a>
        </div>
        <div class="sketchfab-embed-wrapper d-flex justify-content-center align-items-center" style="min-height: 60vh;">
            <iframe title="Mortal Kombat Armageddon" frameborder="0" allowfullscreen allow="autoplay; fullscreen" width="960" height="720" src="https://sketchfab.com/models/60c2e703f9764cd6885811452802b3aa/embed?autospin=1&autostart=1&preload=1&transparent=1&ui_theme=dark"></iframe>
        </div>
    </div>

    <!-- CUARTO BLOQUE: Shrek -->
    <div class="mt-5">
        <h2 class="text-center mb-3">Shrek</h2>
        <div class="d-flex justify-content-center mb-2">
            <a href="compra.jsp" class="btn btn-success btn-lg">Comprar</a>
        </div>
        <div class="sketchfab-embed-wrapper d-flex justify-content-center align-items-center" style="min-height: 60vh;">
            <iframe title="Shrek" frameborder="0" allowfullscreen allow="autoplay; fullscreen" width="960" height="720" src="https://sketchfab.com/models/4c5613eba422484b904988ae1144a2fb/embed?autospin=1&autostart=1&preload=1&transparent=1&ui_theme=dark"></iframe>
        </div>
    </div>

    <!-- QUINTO BLOQUE: Chaos -->
    <div class="mt-5">
        <h2 class="text-center mb-3">CHAOS</h2>
        <div class="d-flex justify-content-center mb-2">
            <a href="compra.jsp" class="btn btn-success btn-lg">Comprar</a>
        </div>
        <div class="sketchfab-embed-wrapper d-flex justify-content-center align-items-center" style="min-height: 60vh;">
            <iframe title="CHAOS" frameborder="0" allowfullscreen allow="autoplay; fullscreen" width="960" height="720" src="https://sketchfab.com/models/dcf043918a354680ad4ad86a5d2af4ae/embed?autospin=1&autostart=1&preload=1&transparent=1&ui_theme=dark"></iframe>
        </div>
    </div>

    <!-- SEXTO BLOQUE: Harry Potter -->
    <div class="mt-5">
        <h2 class="text-center mb-3">Harry Potter - movie collection</h2>
        <div class="d-flex justify-content-center mb-2">
            <a href="compra.jsp" class="btn btn-success btn-lg">Comprar</a>
        </div>
        <div class="sketchfab-embed-wrapper d-flex justify-content-center align-items-center" style="min-height: 60vh;">
            <iframe title="Harry Potter - movie collection" frameborder="0" allowfullscreen allow="autoplay; fullscreen" width="960" height="720" src="https://sketchfab.com/models/bb1fbd03ae3b4dff89bc358b4cbda7fd/embed?autospin=1&autostart=1&preload=1&transparent=1&ui_theme=dark"></iframe>
        </div>
    </div>
</main>

<script src="../js/script.js"></script>
</body>
</html>