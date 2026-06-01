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
            text-decoration: none;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .genre-badge:hover {
            color: #000;
            transform: translateY(-1px);
            box-shadow: 0 8px 18px rgba(0,0,0,0.18);
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

        .trailer-frame {
            width: 100%;
            aspect-ratio: 16 / 9;
            border: 0;
            border-radius: 10px;
            background: #000;
        }
    </style>
</head>
<body>
<div id="stars-container"></div>

<nav class="navbar navbar-expand-lg custom-navbar py-3 sticky-top">
    <div class="container-fluid px-4 px-lg-5">
        <a class="navbar-brand d-flex align-items-center gap-2" href="<%= request.getContextPath() %>/index.jsp">
            <img src="<%= request.getContextPath() %>/img/logo-cinestore.svg" alt="CineStore" class="brand-logo" style="width: 50px; height: 50px; object-fit: contain;">
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
                    <button type="button" class="btn btn-primary rounded-pill fw-bold py-2 btn-login" style="border:none;" id="btn-comprar-detalle">
                        <i class="bi bi-ticket-perforated me-2"></i> COMPRAR PELÍCULA
                    </button>
                    <button type="button" class="btn btn-outline-light rounded-pill fw-bold py-2 border-secondary" style="color:var(--text-color);" id="btn-ver-trailer">
                        <i class="bi bi-play-circle me-2"></i> VER TRAILER
                    </button>
                    <button type="button" class="btn btn-outline-warning rounded-pill fw-bold py-2" id="btn-favorito-detalle">
                        <i class="bi bi-heart me-2"></i> FAVORITO
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

        // Aplicamos el tema guardado
        if (savedTheme) {
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        }

        if (!movieId || Number.isNaN(Number(movieId))) {
            loadingState.classList.add('d-none');
            errorState.classList.remove('d-none');
            return;
        }

        try {
            const movieResponse = await fetch(BASE_URL + '/movie/' + movieId + '?api_key=' + API_KEY + '&language=es-ES');
            const creditsResponse = await fetch(BASE_URL + '/movie/' + movieId + '/credits?api_key=' + API_KEY + '&language=es-ES');
            const videosResponse = await fetch(BASE_URL + '/movie/' + movieId + '/videos?api_key=' + API_KEY + '&language=es-ES');

            if (!movieResponse.ok) throw new Error('Movie not found');

            window.movieGlobal = await movieResponse.json();
            const credits = await creditsResponse.json();
            const videos = videosResponse.ok ? await videosResponse.json() : { results: [] };
            let trailer = Array.isArray(videos.results)
                ? videos.results.find(video => video.site === 'YouTube' && video.type === 'Trailer')
                : null;
            if (!trailer) {
                const fallbackVideosResponse = await fetch(BASE_URL + '/movie/' + movieId + '/videos?api_key=' + API_KEY + '&language=en-US');
                const fallbackVideos = fallbackVideosResponse.ok ? await fallbackVideosResponse.json() : { results: [] };
                trailer = Array.isArray(fallbackVideos.results)
                    ? fallbackVideos.results.find(video => video.site === 'YouTube' && video.type === 'Trailer') || fallbackVideos.results.find(video => video.site === 'YouTube')
                    : null;
            }

            // Populate movie data (Escapando variables de imagen y runtime)
            const posterEl = document.getElementById('moviePoster');
            posterEl.src = window.movieGlobal.poster_path ? IMG_URL_W500 + window.movieGlobal.poster_path : 'https://via.placeholder.com/500x750?text=No+Image';

            document.getElementById('movieTitle').textContent = window.movieGlobal.title;
            document.getElementById('movieTagline').textContent = window.movieGlobal.tagline || '';
            document.getElementById('movieRating').textContent = window.movieGlobal.vote_average ? window.movieGlobal.vote_average.toFixed(1) : 'N/A';
            document.getElementById('movieReleaseDate').textContent = new Date(window.movieGlobal.release_date).toLocaleDateString() || 'Desconocida';
            document.getElementById('movieRuntime').textContent = window.movieGlobal.runtime ? window.movieGlobal.runtime + ' min' : 'Desconocida';
            document.getElementById('movieOverview').textContent = window.movieGlobal.overview || 'No hay sinopsis disponible.';

            // --- FONDO CINEMÁTICO ---
            const backdropEl = document.getElementById('movieBackdrop');
            if (backdropEl && window.movieGlobal.backdrop_path) {
                backdropEl.src = 'https://image.tmdb.org/t/p/original' + window.movieGlobal.backdrop_path;
                backdropEl.style.display = 'block';
            }

            // --- GÉNEROS ---
            const genresContainer = document.getElementById('movieGenres');
            if (window.movieGlobal.genres && window.movieGlobal.genres.length > 0) {
                window.movieGlobal.genres.forEach(genre => {
                    const badge = document.createElement('a');
                    badge.className = 'genre-badge';
                    badge.href = 'category.jsp?id=' + encodeURIComponent(genre.id) + '&name=' + encodeURIComponent(genre.name);
                    badge.textContent = genre.name;
                    genresContainer.appendChild(badge);
                });
            }

            // --- REPARTO ---
            const castContainer = document.getElementById('movieCast');
            if (credits.cast && credits.cast.length > 0) {
                credits.cast.slice(0, 6).forEach(actor => {
                    const castCard = document.createElement('div');
                    castCard.className = 'col-4 col-md-2 mb-4';
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

            // --- BOTÓN DE COMPRAR ---
            const btnComprarDetalle = document.getElementById('btn-comprar-detalle');
            if (btnComprarDetalle) {
                btnComprarDetalle.addEventListener('click', () => {
                    if (localStorage.getItem('isLoggedIn') !== 'true') {
                        window.location.href = 'login.jsp';
                        return;
                    }
                    if (window.movieGlobal && window.movieGlobal.id) {
                        try {
                            localStorage.setItem('lastMovieId', String(window.movieGlobal.id));
                            localStorage.setItem('cinestore.pendingPurchase', JSON.stringify({
                                id: window.movieGlobal.id,
                                title: window.movieGlobal.title,
                                posterPath: window.movieGlobal.poster_path || null,
                                date: window.movieGlobal.release_date ? window.movieGlobal.release_date.split('-')[0] : 'N/D',
                                rating: typeof window.movieGlobal.vote_average === 'number' ? window.movieGlobal.vote_average : null
                            }));
                        } catch (error) {
                            console.warn('No se pudo guardar la pelicula pendiente:', error);
                        }
                        window.location.href = 'compra.jsp?id=' + encodeURIComponent(window.movieGlobal.id);
                    }
                });
            }

            const btnTrailer = document.getElementById('btn-ver-trailer');
            if (btnTrailer) {
                btnTrailer.addEventListener('click', () => {
                    const trailerBody = document.getElementById('trailerModalBody');
                    if (!trailer || !trailer.key) {
                        trailerBody.innerHTML = '<div class="alert alert-warning mb-0"><i class="bi bi-exclamation-triangle me-2"></i>No se puede mostrar el trailer de esta pelicula.</div>';
                    } else {
                        trailerBody.innerHTML = '<iframe class="trailer-frame" src="https://www.youtube.com/embed/' + trailer.key + '?autoplay=1" title="Trailer" allow="autoplay; encrypted-media; picture-in-picture" allowfullscreen></iframe>';
                    }
                    const trailerModal = new bootstrap.Modal(document.getElementById('trailerModal'));
                    trailerModal.show();
                });
            }

            const btnFavoritoDetalle = document.getElementById('btn-favorito-detalle');
            if (btnFavoritoDetalle) {
                btnFavoritoDetalle.addEventListener('click', () => {
                    const icon = btnFavoritoDetalle.querySelector('i');
                    const movieData = {
                        id: window.movieGlobal.id,
                        title: window.movieGlobal.title,
                        posterPath: window.movieGlobal.poster_path || null,
                        date: window.movieGlobal.release_date ? window.movieGlobal.release_date.split('-')[0] : 'N/D',
                        rating: typeof window.movieGlobal.vote_average === 'number' ? window.movieGlobal.vote_average : null
                    };

                    if (window.toggleFavorite) {
                        window.toggleFavorite(icon, movieData);
                    }
                });
            }

            // ==============================================================
            // --- EFECTO CAJA FÍSICA INTERACTIVA 3D ---
            // ==============================================================
            const comesFrom3d = localStorage.getItem('comesFrom3dSection') === 'true';

            if (posterEl && comesFrom3d) {
                // Borramos la bandera para que no afecte a futuras visitas normales
                localStorage.removeItem('comesFrom3dSection');

                // Preparamos el contenedor para el modo 3D
                const posterContainer = posterEl.parentElement;
                posterContainer.classList.add('case-active');

                // Creamos los elementos HTML de la caja
                const scene = document.createElement('div');
                scene.className = 'case-scene';

                const caseEl = document.createElement('div');
                caseEl.className = 'movie-case';

                const frontEl = document.createElement('div');
                frontEl.className = 'case-front';

                // Movemos el póster a la cara frontal
                posterContainer.replaceChild(scene, posterEl);
                posterEl.className = 'poster-case-active';
                frontEl.appendChild(posterEl);
                caseEl.appendChild(frontEl);

                // Creamos la contraportada
                const backEl = document.createElement('div');
                backEl.className = 'case-back';

                // Formateamos datos para imprimir en la contraportada
                const genresString = window.movieGlobal.genres ? window.movieGlobal.genres.map(g => g.name).join(', ') : 'N/D';
                const ratingValue = window.movieGlobal.vote_average ? window.movieGlobal.vote_average.toFixed(1) : 'N/D';

                // Limpiamos la sinopsis para que encaje
                const overviewText = window.movieGlobal.overview ? window.movieGlobal.overview : 'Sinopsis no disponible en este momento.';

                backEl.innerHTML = `
                    <div class="case-back-content">
                        <h5 class="back-title" style="color: var(--accent-color); font-weight: bold; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px; margin-bottom: 15px;">\${window.movieGlobal.title}</h5>
                        <p class="back-synopsis" style="font-size: 0.9rem; line-height: 1.5; color: rgba(255,255,255,0.8); display: -webkit-box; -webkit-line-clamp: 10; -webkit-box-orient: vertical; overflow: hidden;">\${overviewText}</p>
                        <div class="tech-specs mt-auto small text-muted" style="border-top: 1px solid rgba(255,255,255,0.1); padding-top: 10px;">
                            <p class="mb-1">Géneros: \${genresString}</p>
                            <p class="mb-0">Puntuación: \${ratingValue} / 10</p>
                        </div>
                        <div class="barcode mt-3 text-end" style="color: rgba(255,255,255,0.5);">
                            <i class="bi bi-upc-scan" style="font-size: 2.2rem;"></i>
                            <span class="d-block small text-muted">ID:\${window.movieGlobal.id}</span>
                        </div>
                    </div>
                `;

                caseEl.appendChild(backEl);
                scene.appendChild(caseEl);

                // Insertamos la instrucción de clic
                const instructionHint = document.createElement('p');
                instructionHint.className = 'text-center text-info mt-3 small flip-hint';
                instructionHint.innerHTML = '<i class="bi bi-arrow-repeat me-1 fs-6"></i> Haz clic en la portada para darle la vuelta';
                posterContainer.appendChild(instructionHint);

                // Evento para girar 180 grados
                scene.addEventListener('click', () => {
                    caseEl.classList.toggle('is-flipped');
                });
            }
            // ==============================================================

            loadingState.classList.add('d-none');
            movieContent.classList.remove('d-none');

        } catch (error) {
            console.error('Error:', error);
            loadingState.classList.add('d-none');
            errorState.classList.remove('d-none');
        }
    });
</script>

<!-- Modal de Trailer -->
<div class="modal fade" id="trailerModal" tabindex="-1" aria-labelledby="trailerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content bg-dark text-white border-secondary">
            <div class="modal-header border-secondary">
                <h5 class="modal-title fw-bold" id="trailerModalLabel">
                    <i class="bi bi-play-circle me-2 text-warning"></i>Trailer
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body" id="trailerModalBody"></div>
        </div>
    </div>
</div>

<!-- Modal de Compra -->
<div class="modal fade" id="modalCompra" tabindex="-1" aria-labelledby="modalCompraLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="background: linear-gradient(135deg, #1f1f1f 0%, #0d0d0d 100%); border: 1px solid rgba(255, 255, 255, 0.1);">
            <div class="modal-header border-bottom border-secondary">
                <h5 class="modal-title fw-bold" id="modalCompraLabel" style="color: var(--accent-color);">
                    <i class="bi bi-credit-card me-2"></i>Información de Compra
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Resumen de película -->
                <div class="row mb-4 pb-4 border-bottom border-secondary">
                    <div class="col-md-3 text-center">
                        <img id="modalMoviePoster" src="" alt="Película" style="max-width: 100%; border-radius: 8px; box-shadow: 0 5px 15px rgba(0,0,0,0.3);">
                    </div>
                    <div class="col-md-9">
                        <h5 id="modalMovieTitle" class="fw-bold text-white mb-2"></h5>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <span class="text-muted small">Precio:</span>
                                <p id="modalMoviePrice" class="fs-5 fw-bold text-success">$9.99</p>
                            </div>
                            <div class="col-md-6">
                                <span class="text-muted small">Acceso:</span>
                                <p class="fs-6 text-info">Acceso de por vida ∞</p>
                            </div>
                        </div>
                        <div class="alert alert-info py-2 mb-0">
                            <small><i class="bi bi-info-circle me-1"></i>Una vez comprada, podrás acceder a esta película desde "Mi Contenido"</small>
                        </div>
                    </div>
                </div>

                <!-- Métodos de pago -->
                <div class="mb-4">
                    <label class="form-label fw-bold text-white mb-3">
                        <i class="bi bi-credit-card me-2"></i>Tarjeta de Crédito/Débito
                    </label>
                    <div class="mb-3">
                        <label class="text-muted small mb-2">Titular de la Tarjeta</label>
                        <input type="text" class="form-control" id="inputTitular" placeholder="NOMBRE APELLIDO" maxlength="50">
                    </div>
                    <div class="mb-3">
                        <label class="text-muted small mb-2">Número de Tarjeta</label>
                        <input type="text" class="form-control" id="inputNumeroTarjeta" placeholder="1234 5678 9012 3456" maxlength="16" inputmode="numeric">
                        <small class="text-muted mt-2 d-block">
                            <i class="bi bi-shield-check me-1"></i>Empresas aceptadas:
                            <span class="badge bg-info" title="Visa">
                                <i class="fab fa-cc-visa"></i> Visa
                            </span>
                            <span class="badge bg-warning text-dark" title="Mastercard">
                                <i class="fab fa-cc-mastercard"></i> Mastercard
                            </span>
                            <span class="badge bg-danger" title="American Express">
                                <i class="fab fa-cc-amex"></i> Amex
                            </span>
                            <span class="badge bg-primary" title="Discover">
                                <i class="fab fa-cc-discover"></i> Discover
                            </span>
                        </small>
                        <div id="cardTypeInfo" class="mt-2 small"></div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="text-muted small mb-2">Vencimiento (MM/AA)</label>
                            <input type="text" class="form-control" id="inputVencimiento" placeholder="12/25" maxlength="5">
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small mb-2">CVV</label>
                            <input type="password" class="form-control" id="inputCVV" placeholder="123" maxlength="4" inputmode="numeric">
                        </div>
                    </div>
                </div>

                <!-- Confirmación de términos -->
                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" id="checkTerminos">
                    <label class="form-check-label text-muted small" for="checkTerminos">
                        Acepto los <a href="#" class="text-info text-decoration-none">términos y condiciones</a> de compra
                    </label>
                </div>
            </div>
            <div class="modal-footer border-top border-secondary">
                <button type="button" class="btn btn-outline-light rounded-pill px-4" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-success rounded-pill px-5 fw-bold" id="btnConfirmarCompra">
                    <i class="bi bi-check-circle me-2"></i>Confirmar Compra
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/script.js"></script>
<script>
    // Validador de tarjeta y manejo de compra
    let movieDataGlobal = {};

    // Limpiar formulario cuando se abre el modal
    const modalCompraEl = document.getElementById('modalCompra');
    if (modalCompraEl) {
        modalCompraEl.addEventListener('show.bs.modal', function() {
            // Limpiar inputs
            document.getElementById('inputTitular').value = '';
            document.getElementById('inputNumeroTarjeta').value = '';
            document.getElementById('inputVencimiento').value = '';
            document.getElementById('inputCVV').value = '';
            document.getElementById('checkTerminos').checked = false;
            document.getElementById('cardTypeInfo').innerHTML = '';
        });
    }

    // El evento show.bs.modal ya no es necesario porque los datos se establecen
    // en el evento click del botón de compra en detalle.jsp

    // Detectar tipo de tarjeta automáticamente
    document.getElementById('inputNumeroTarjeta').addEventListener('input', function(e) {
        let numero = e.target.value.replace(/\s/g, '');
        const cardType = detectarTipoTarjeta(numero);

        const infoEl = document.getElementById('cardTypeInfo');
        if (cardType) {
            infoEl.innerHTML = '<strong>Tarjeta detectada:</strong> <span class="badge bg-secondary">' + cardType + '</span>';
            infoEl.className = 'mt-2 small text-success';
        } else {
            infoEl.innerHTML = '';
        }
    });

    function detectarTipoTarjeta(numero) {
        numero = numero.replace(/\D/g, '');

        if (/^4/.test(numero)) return '💳 Visa';
        if (/^5[1-5]/.test(numero) || /^2[2-7]/.test(numero)) return '💳 Mastercard';
        if (/^3[47]/.test(numero)) return '💳 American Express';
        if (/^6(?:011|5)/.test(numero)) return '💳 Discover';

        return null;
    }

    function validarTarjeta(numero) {
        numero = numero.replace(/\D/g, '');

        if (numero.length < 13 || numero.length > 19) return false;

        let suma = 0;
        let multiplicar = false;

        for (let i = numero.length - 1; i >= 0; i--) {
            let digito = parseInt(numero.charAt(i));

            if (multiplicar) {
                digito *= 2;
                if (digito > 9) digito -= 9;
            }

            suma += digito;
            multiplicar = !multiplicar;
        }

        return suma % 10 === 0;
    }

    function formatearNumeroTarjeta(numero) {
        return numero.replace(/\s/g, '').replace(/(.{4})/g, '$1 ').trim();
    }

    // Botón confirmar compra
    document.getElementById('btnConfirmarCompra').addEventListener('click', async function() {
        const titular = document.getElementById('inputTitular').value.trim();
        const numeroTarjeta = document.getElementById('inputNumeroTarjeta').value.replace(/\s/g, '');
        const vencimiento = document.getElementById('inputVencimiento').value.trim();
        const cvv = document.getElementById('inputCVV').value.trim();
        const checkTerminos = document.getElementById('checkTerminos').checked;

        // Validaciones
        if (!titular) {
            alert('Por favor, ingresa el titular de la tarjeta');
            return;
        }
        if (!numeroTarjeta || numeroTarjeta.length < 13) {
            alert('Por favor, ingresa un número de tarjeta válido');
            return;
        }
        if (!validarTarjeta(numeroTarjeta)) {
            alert('Número de tarjeta inválido. Por favor, verifica los dígitos');
            return;
        }
        if (!vencimiento || !/^\d{2}\/\d{2}$/.test(vencimiento)) {
            alert('Por favor, ingresa la fecha de vencimiento en formato MM/AA');
            return;
        }
        if (!cvv || cvv.length < 3) {
            alert('Por favor, ingresa un CVV válido');
            return;
        }
        if (!checkTerminos) {
            alert('Debes aceptar los términos y condiciones');
            return;
        }

        // Desabilitar el botón
        this.disabled = true;
        const btnText = this.innerHTML;
        this.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Procesando...';

        try {
            const response = await fetch('<%= request.getContextPath() %>/procesarCompra', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'productoId=' + movieDataGlobal.id +
                      '&titularTarjeta=' + encodeURIComponent(titular) +
                      '&numeroTarjeta=' + numeroTarjeta +
                      '&total=' + document.getElementById('modalMoviePrice').textContent.replace('$', '')
            });

            const data = await response.json();

            if (data.success) {
                alert('¡Compra realizada exitosamente! Accede a "Mi Contenido" para verla');
                // Cerrar modal
                const modalEl = document.getElementById('modalCompra');
                const modal = bootstrap.Modal.getInstance(modalEl);
                modal.hide();

                // Limpiar formulario
                document.getElementById('inputTitular').value = '';
                document.getElementById('inputNumeroTarjeta').value = '';
                document.getElementById('inputVencimiento').value = '';
                document.getElementById('inputCVV').value = '';
                document.getElementById('checkTerminos').checked = false;
            } else {
                alert('Error: ' + data.message);
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Error de conexión. Intenta de nuevo');
        } finally {
            this.disabled = false;
            this.innerHTML = btnText;
        }
    });
</script>
</body>
</html>
