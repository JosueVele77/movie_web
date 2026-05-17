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
        <a class="navbar-brand d-flex align-items-center gap-2" href="../index.jsp">
            <img src="../img/logo-cinestore.svg" alt="CineStore" class="brand-logo">
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
    <div id="movie-3d-grid" class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-5 grid-render-3d">
    </div>
</main>

<script src="../js/script.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Consultamos películas de ciencia ficción de alto presupuesto (ID: 878) que destacan en 3D
        fetchAndRenderMovies('/discover/movie?with_genres=878&sort_by=revenue.desc', 'movie-3d-grid');

        // Aplicamos las clases tridimensionales especiales a las tarjetas una vez se rendericen
        const observer = new MutationObserver(() => {
            const cards = document.querySelectorAll('#movie-3d-grid .movie-card');
            cards.forEach(card => {
                card.classList.add('movie-card-3d');
            });
        });

        observer.observe(document.getElementById('movie-3d-grid'), { childList: true });
    });
</script>
</body>
</html>