<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineStore - Categoria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../css/styles.css">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme) {
                document.documentElement.setAttribute('data-bs-theme', savedTheme);
            }
        });
    </script>
</head>
<body>
<div id="stars-container"></div>
<div class="planet"></div>

<jsp:include page="/pages/navbar.jsp" />

<header class="category-hero text-white">
    <div class="container py-5">
        <div class="d-flex justify-content-start mb-3">
            <button class="btn btn-outline-light" data-action="go-back" data-fallback="../index.jsp">
                <i class="bi bi-arrow-left me-2"></i>Volver
            </button>
        </div>
        <div class="category-hero-card">
            <p class="category-hero-label">CATEGORIA DESTACADA</p>
            <h1 id="category-title" class="display-4 fw-bold mb-2"></h1>
            <p id="category-description" class="category-hero-subtitle"></p>
            <p id="category-highlight" class="category-hero-highlight"></p>
            <p id="category-meta" class="category-hero-meta"></p>
            <div class="category-hero-actions">
                <a href="#movie-grid" class="btn btn-primary">Comprar ahora</a>
            </div>
        </div>
    </div>
</header>

<main class="container py-5">
    <div id="movie-grid" class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-4"></div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/script.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', async () => {
        const urlParams = new URLSearchParams(window.location.search);
        const categoryId = urlParams.get('id');
        let categoryName = urlParams.get('name');

        const titleEl = document.getElementById('category-title');
        const descriptionEl = document.getElementById('category-description');
        const highlightEl = document.getElementById('category-highlight');
        const metaEl = document.getElementById('category-meta');
        const heroSection = document.querySelector('.category-hero');

        const normalizeKey = (value) => value
            .toLowerCase()
            .normalize('NFD')
            .replace(/\p{Diacritic}/gu, '')
            .replace(/\s+/g, ' ')
            .trim();

        const descriptions = {
            accion: 'Accion intensa y escenas impactantes para un maraton de adrenalina.',
            aventura: 'Viajes epicos, mundos nuevos y heroes inolvidables.',
            animacion: 'Historias vibrantes para toda la familia con estilo unico.',
            comedia: 'Risas aseguradas con lo mejor del humor y la ligereza.',
            crimen: 'Historias de intriga, poder y decisiones al limite.',
            documental: 'Relatos reales que inspiran y sorprenden.',
            drama: 'Narrativas profundas con actuaciones memorables.',
            familia: 'Momentos para compartir y disfrutar juntos.',
            fantasia: 'Magia, mundos imaginarios y aventuras sin limites.',
            historia: 'Grandes relatos del pasado con producciones impactantes.',
            terror: 'Tension y sustos para los mas valientes.',
            musica: 'Historias llenas de ritmo y pasion musical.',
            misterio: 'Enigmas que te mantienen atento de principio a fin.',
            romance: 'Historias de amor que conectan y emocionan.',
            'ciencia ficcion': 'Futuro, tecnologia y universos sorprendentes.',
            suspense: 'Peliculas que te mantienen en vilo.',
            belica: 'Historias intensas sobre conflictos historicos.',
            western: 'Clasicos del oeste con personajes legendarios.'
        };

        const isInvalidName = (value) => !value || ['false', 'undefined', 'null'].includes(value.toLowerCase());

        if (isInvalidName(categoryName) && categoryId) {
            try {
                const response = await fetch(buildApiUrl('/genre/movie/list'));
                const data = await response.json();
                const genre = Array.isArray(data.genres)
                    ? data.genres.find(item => String(item.id) === String(categoryId))
                    : null;
                categoryName = genre ? genre.name : 'Categoria';
            } catch (error) {
                categoryName = 'Categoria';
            }
        }

        const displayName = isInvalidName(categoryName) ? 'Categoria' : categoryName;
        document.title = `CineStore - ${displayName}`;
        if (titleEl) titleEl.textContent = displayName;
        if (descriptionEl) {
            descriptionEl.textContent = descriptions[normalizeKey(displayName)] || 'Explora las peliculas mas destacadas de este genero.';
        }

        if (categoryId) {
            fetchAndRenderMovies(`/discover/movie?with_genres=${categoryId}&sort_by=popularity.desc`, 'movie-grid', 100, 5);
        }

        if (categoryId && heroSection) {
            const heroEndpoint = `/discover/movie?with_genres=${categoryId}&sort_by=popularity.desc&vote_count.gte=50`;
            fetch(buildApiUrl(heroEndpoint))
                .then(response => response.json())
                .then(data => {
                    const popularMovie = Array.isArray(data.results)
                        ? data.results.find(movie => movie.backdrop_path)
                        : null;
                    if (!popularMovie || !popularMovie.backdrop_path) return;

                    heroSection.style.setProperty(
                        '--category-hero-image',
                        `url('https://image.tmdb.org/t/p/original${popularMovie.backdrop_path}')`
                    );

                    if (highlightEl) {
                        highlightEl.textContent = `Pelicula popular: ${popularMovie.title}`;
                    }
                    if (metaEl) {
                        const year = popularMovie.release_date ? popularMovie.release_date.split('-')[0] : 'N/D';
                        const rating = popularMovie.vote_average ? popularMovie.vote_average.toFixed(1) : 'N/D';
                        metaEl.textContent = `Ano: ${year} - Rating: ${rating}`;
                    }
                })
                .catch(error => console.error('Error loading category hero:', error));
        }
    });
</script>
</body>
</html>
