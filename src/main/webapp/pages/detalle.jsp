<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineStore - Detalle de la Película</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../css/styles.css">
    <style>
        .movie-backdrop {
            width: 100%;
            height: 60vh;
            object-fit: cover;
            filter: brightness(0.4);
            position: absolute;
            top: 0;
            left: 0;
            z-index: -1;
        }
        .detail-container {
            margin-top: 15vh;
            background: rgba(var(--bg-color-rgb), 0.85);
            background-color: var(--bg-color);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            position: relative;
            z-index: 1;
        }

        [data-bs-theme="light"] .detail-container {
            background-color: rgba(255, 255, 255, 0.95);
        }

        .poster-img {
            width: 100%;
            max-width: 350px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            margin-top: -100px;
        }
        .genre-badge {
            background-color: var(--accent-color);
            color: #000;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.8rem;
            margin-right: 10px;
            margin-bottom: 10px;
            display: inline-block;
        }

        .cast-card {
            text-align: center;
        }

        .cast-card img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 10px;
        }

        .skeleton {
            background-color: #333;
            border-radius: 4px;
            animation: pulse 1.5s infinite ease-in-out;
        }

        [data-bs-theme="light"] .skeleton {
            background-color: #e0e0e0;
        }

        .skeleton-text { height: 20px; margin-bottom: 10px; width: 100%; }
        .skeleton-title { height: 40px; margin-bottom: 15px; width: 60%; }
        .skeleton-poster { height: 500px; width: 100%; max-width: 350px; margin-top: -100px; border-radius: 10px;}

        @keyframes pulse {
            0% { opacity: 0.6; }
            50% { opacity: 1; }
            100% { opacity: 0.6; }
        }

        #loading-state, #error-state {
            padding-top: 15vh;
        }
    </style>
</head>
<body>
<div id="stars-container"></div>
<div class="planet"></div>

<nav class="navbar navbar-expand-lg custom-navbar py-3 sticky-top">
    <div class="container-fluid px-4 px-lg-5">
        <a class="navbar-brand d-flex align-items-center gap-2" href="../index.jsp">
            <img src="../img/logo-cinestore.svg" alt="CineStore" class="brand-logo" onerror="this.src='https://cdn-icons-png.flaticon.com/512/3172/3172552.png'">
        </a>
        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center gap-3">
                <li class="nav-item">
                    <button class="btn btn-outline-light" data-action="go-back" data-fallback="../index.jsp">
                        <i class="bi bi-arrow-left me-2"></i>Volver
                    </button>
                </li>
                <li class="nav-item"><a class="nav-link" href="../index.jsp">Volver al Inicio</a></li>
            </ul>
        </div>
    </div>
</nav>

<img id="movieBackdrop" class="movie-backdrop" src="" alt="" style="display: none;">

<div class="container pb-5">
    <div id="loading-state" class="row justify-content-center text-center mt-5">
        <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
            <span class="visually-hidden">Cargando...</span>
        </div>
        <h4 class="text-white mt-3">Buscando en los archivos de la galaxia...</h4>
    </div>

    <div id="error-state" class="text-center d-none" style="margin-top: 20vh;">
        <i class="bi bi-exclamation-triangle-fill text-warning" style="font-size: 4rem;"></i>
        <h2 class="text-white mt-3">¡Houston, tenemos un problema!</h2>
        <p class="text-muted fs-5">No pudimos encontrar esta película o el ID es incorrecto.</p>
        <a href="../index.jsp" class="btn btn-outline-light mt-3">Volver a la cartelera</a>
    </div>

    <div id="movie-content" class="row justify-content-center d-none">
        <div class="col-12 col-md-10 detail-container row">
            <div class="col-md-4 text-center text-md-start">
                <img id="moviePoster" src="" alt="Movie Poster" class="poster-img img-fluid">

                <div class="d-grid gap-2 mt-4">
                    <button class="btn btn-primary rounded-pill fw-bold py-2 btn-login" style="border:none;">
                        <i class="bi bi-ticket-perforated me-2"></i> COMPRAR ENTRADAS
                    </button>
                    <button class="btn btn-outline-light rounded-pill fw-bold py-2 border-secondary" style="color:var(--text-color);">
                        <i class="bi bi-play-circle me-2"></i> VER TRAILER
                    </button>
                </div>
            </div>
            <div class="col-md-8 mt-4 mt-md-0">
                <h1 id="movieTitle" class="display-5 fw-bold mb-2"></h1>
                <p id="movieTagline" class="text-muted fst-italic fs-5 mb-3"></p>
                <div id="movieGenres" class="mb-4"></div>
                <div class="row mb-4">
                    <div class="col-sm-4 mb-2">
                        <div class="text-muted small text-uppercase fw-bold">Fecha de Estreno</div>
                        <div id="movieReleaseDate" class="fs-6"></div>
                    </div>
                    <div class="col-sm-4 mb-2">
                        <div class="text-muted small text-uppercase fw-bold">Duración</div>
                        <div id="movieRuntime" class="fs-6"></div>
                    </div>
                    <div class="col-sm-4 mb-2">
                        <div class="text-muted small text-uppercase fw-bold">Rating</div>
                        <div id="movieRating" class="fs-6"></div>
                    </div>
                </div>
                <h4 class="fw-bold border-bottom border-secondary pb-2 mb-3">Sinopsis</h4>
                <p id="movieOverview" class="fs-6" style="line-height: 1.6;"></p>

                <h4 class="fw-bold border-bottom border-secondary pb-2 mb-3 mt-5">Reparto Principal</h4>
                <div id="movieCast" class="row">
                    <!-- Cast will be populated here -->
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', async () => {
        const API_KEY = 'e8351fedf872a5de8e6614d8f166a260';
        const BASE_URL = 'https://api.themoviedb.org/3';
        const IMG_URL_W500 = 'https://image.tmdb.org/t/p/w500';

        const urlParams = new URLSearchParams(window.location.search);
        let movieId = urlParams.get('id');
        if (!movieId || Number.isNaN(Number(movieId))) {
            try {
                movieId = localStorage.getItem('lastMovieId');
            } catch (error) {
                console.warn('No se pudo leer lastMovieId:', error);
            }
        }

        const loadingState = document.getElementById('loading-state');
        const errorState = document.getElementById('error-state');
        const movieContent = document.getElementById('movie-content');
        const savedTheme = localStorage.getItem('theme');

        if (!movieId || Number.isNaN(Number(movieId))) {
            loadingState.classList.add('d-none');
            errorState.classList.remove('d-none');
            return;
        }if (savedTheme) {
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        }

        try {
            // Escapando variables de la URL para que JSP no las procese
            const movieResponse = await fetch(`\${BASE_URL}/movie/\${movieId}?api_key=\${API_KEY}&language=es-ES`);
            const creditsResponse = await fetch(`\${BASE_URL}/movie/\${movieId}/credits?api_key=\${API_KEY}&language=es-ES`);

            if (!movieResponse.ok) throw new Error('Movie not found');

            const movie = await movieResponse.json();
            const credits = await creditsResponse.json();

            // Populate movie data (Escapando variables de imagen y runtime)
            document.getElementById('moviePoster').src = movie.poster_path ? IMG_URL_W500 + movie.poster_path : 'https://via.placeholder.com/500x750?text=No+Image';
            document.getElementById('movieTitle').textContent = movie.title;
            document.getElementById('movieTagline').textContent = movie.tagline || '';
            document.getElementById('movieRating').textContent = movie.vote_average ? movie.vote_average.toFixed(1) : 'N/A';
            document.getElementById('movieReleaseDate').textContent = new Date(movie.release_date).toLocaleDateString() || 'Desconocida';
            document.getElementById('movieRuntime').textContent = movie.runtime ? `\${movie.runtime} min` : 'Desconocida';
            document.getElementById('movieOverview').textContent = movie.overview || 'No hay sinopsis disponible.';

            // --- INSERTA ESTE BLOQUE AQUÍ PARA INICIALIZAR EL FONDO CINEMÁTICO ---
            const backdropEl = document.getElementById('movieBackdrop');
            if (backdropEl && movie.backdrop_path) {
                backdropEl.src = 'https://image.tmdb.org/t/p/original' + movie.backdrop_path;
                backdropEl.style.display = 'block';
            }
            // --------------------------------------------------------------------

            document.getElementById('movieTitle').textContent = movie.title;

            const genresContainer = document.getElementById('movieGenres');
            if (movie.genres && movie.genres.length > 0) {
                movie.genres.forEach(genre => {
                    const badge = document.createElement('span');
                    badge.className = 'genre-badge';
                    badge.textContent = genre.name;
                    genresContainer.appendChild(badge);
                });
            }

            const castContainer = document.getElementById('movieCast');
            if (credits.cast && credits.cast.length > 0) {
                credits.cast.slice(0, 6).forEach(actor => {
                    const castCard = document.createElement('div');
                    castCard.className = 'col-4 col-md-2 mb-4';
                    // Escapando las variables dentro del HTML inyectado
                    castCard.innerHTML = `
                <div class="cast-card">
                    <img src="\${actor.profile_path ? IMG_URL_W500 + actor.profile_path : 'https://via.placeholder.com/100x100?text=No+Image'}" alt="\${actor.name}">
                    <h6 class="mt-2 mb-0">\${actor.name}</h6>
                    <p class="text-muted small">\${actor.character}</p>
                </div>
            `;
                    castContainer.appendChild(castCard);
                });
            }

            loadingState.classList.add('d-none');
            movieContent.classList.remove('d-none');

        } catch (error) {
            console.error('Error:', error);
            loadingState.classList.add('d-none');
            errorState.classList.remove('d-none');
        }
    });
</script>
<script src="../js/script.js"></script>
</body>
</html>