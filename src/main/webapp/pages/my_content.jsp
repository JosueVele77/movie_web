<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%@ page import="io.github.josuevele77.movie_web.dao.CompraDAO" %>
<%@ page import="java.util.List" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Verificación de seguridad: Validar que el usuario esté logueado
    Usuario userSession = (Usuario) session.getAttribute("usuarioLogueado");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Obtener películas compradas
    CompraDAO compraDAO = new CompraDAO();
    List<String> peliculasCompradas = compraDAO.obtenerPelículasCompradasPorUsuario(userSession.getIdUs());
    int totalCompras = compraDAO.contarComprasPorUsuario(userSession.getIdUs());
    String avatarUsuario = userSession.getAvatarUrl() != null ? userSession.getAvatarUrl().trim() : "";
    String inicialUsuario = userSession.getNombreUs() != null && !userSession.getNombreUs().trim().isEmpty()
            ? userSession.getNombreUs().trim().substring(0, 1).toUpperCase()
            : "?";
%>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Contenido - CineStore</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/styles.css">

    <style>
        /* Estilos específicos para la cabecera del cliente */
        .client-hero {
            position: relative;
            padding: 120px 0 60px;
            background: linear-gradient(to bottom, rgba(20, 20, 24, 0.4), var(--bg-color));
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            overflow: hidden;
        }

        [data-bs-theme="light"] .client-hero {
            background: linear-gradient(to bottom, rgba(231, 233, 239, 0.4), var(--bg-color));
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .user-profile-badge {
            width: 110px;
            height: 110px;
            background: linear-gradient(135deg, var(--accent-color), #ff8c00);
            color: #000;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3.5rem;
            font-weight: 800;
            box-shadow: 0 15px 35px rgba(241, 179, 78, 0.4);
            border: 4px solid var(--bg-color);
            position: relative;
            z-index: 2;
        }

        .client-stats {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 15px 25px;
            backdrop-filter: blur(10px);
        }

        [data-bs-theme="light"] .client-stats {
            background: rgba(0, 0, 0, 0.03);
            border: 1px solid rgba(0, 0, 0, 0.08);
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--accent-color);
        }

        /* Estilo para la barra de progreso en películas alquiladas */
        .movie-progress-bar {
            height: 4px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 2px;
            margin-top: 12px;
            overflow: hidden;
        }

        .movie-progress-fill {
            height: 100%;
            background: var(--accent-color);
            border-radius: 2px;
        }
    </style>
</head>
<body class="catalog-page">

<div id="stars-container"></div>
<div class="planet"></div>

<jsp:include page="navbar.jsp" />

<header class="client-hero">
    <div class="container px-4 px-lg-5">
        <div class="row align-items-center gy-4">
            <div class="col-md-7 d-flex align-items-center gap-4">
                <div class="user-profile-badge">
                    <% if (!avatarUsuario.isEmpty()) { %>
                    <img src="<%= avatarUsuario %>" alt="Avatar de <%= userSession.getNombreUs() %>">
                    <% } else { %>
                    <%= inicialUsuario %>
                    <% } %>
                </div>
                <div>
                    <h1 class="display-5 fw-bold mb-1">Hola, <%= userSession.getNombreUs() %></h1>
                    <p class="text-muted mb-2 fs-5"><i class="bi bi-envelope-fill me-2"></i><%= userSession.getCorreoUs() %></p>
                    <span class="badge bg-secondary px-3 py-2 rounded-pill fw-normal">
                            <i class="bi bi-star-fill text-warning me-1"></i> Cuenta Activa
                        </span>
                </div>
            </div>
            <div class="col-md-5 d-flex justify-content-md-end">
                <div class="client-stats d-flex gap-4 text-center">
                    <div>
                        <div class="stat-value"><%= totalCompras %></div>
                        <div class="text-muted small text-uppercase fw-bold mt-1">Compradas</div>
                    </div>
                    <div class="vr bg-secondary opacity-25"></div>
                    <div>
                        <div class="stat-value">0</div>
                        <div class="text-muted small text-uppercase fw-bold mt-1">Alquiladas</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<main class="container px-4 px-lg-5 my-5">
    <div class="d-flex justify-content-start mb-4">
        <a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-outline-light rounded-pill px-4 fw-bold">
            <i class="bi bi-arrow-left me-2"></i>Volver
        </a>
    </div>

    <div class="d-flex gap-3 mb-5 catalog-tabs overflow-auto pb-2 border-bottom border-secondary border-opacity-25">
        <button class="streaming-tab active" onclick="location.href='my_content.jsp'">
            <i class="bi bi-play-circle-fill me-2"></i> Mis Películas
        </button>
        <button class="streaming-tab" onclick="location.href='favorites.jsp'">
            <i class="bi bi-heart-fill me-2"></i> Mi Lista
        </button>
        <button class="streaming-tab" onclick="location.href='profile.jsp'">
            <i class="bi bi-person-badge-fill me-2"></i> Ajustes de Cuenta
        </button>
    </div>

    <h4 class="section-title fw-bold mb-4 d-flex align-items-center gap-2">
        <i class="bi bi-play-circle-fill text-warning"></i> Empezar a ver la película que compraste
    </h4>

    <div class="row g-4 mb-5" id="start-watching-grid">
        <div class="col-6 col-md-4 col-lg-3 d-none">
            <div class="movie-card catalog-panel">
                <div class="position-relative">
                    <img src="<%=request.getContextPath()%>/img/fallback-poster.svg" alt="Película Alquilada">
                    <div class="position-absolute top-0 end-0 p-2 m-1">
                            <span class="badge bg-dark border border-warning text-warning rounded-pill shadow-sm">
                                <i class="bi bi-hourglass-split me-1"></i> 24h restantes
                            </span>
                    </div>
                </div>
                <div class="movie-info">
                    <h5 class="movie-title">Dune: Parte Dos</h5>
                    <p class="movie-meta mb-1">Alquilada el 18 de Mayo</p>

                    <div class="movie-progress-bar">
                        <div class="movie-progress-fill" style="width: 65%;"></div>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <button class="btn btn-card-comprar w-100"><i class="bi bi-play-fill me-1 fs-5"></i> Reanudar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <h4 class="section-title fw-bold mb-4 d-flex align-items-center gap-2">
        <i class="bi bi-collection-play-fill" style="color: var(--accent-color);"></i> Mi Biblioteca
    </h4>

    <div class="row g-4" id="library-grid">
        <% if (peliculasCompradas != null && !peliculasCompradas.isEmpty()) { %>
            <% for (String pelicula : peliculasCompradas) {
                String[] partes = pelicula.split(":");
                String idPr = partes[0];
                String nombrePr = partes.length > 1 ? partes[1] : "Película";
            %>
            <div class="col-6 col-md-4 col-lg-3">
                <div class="movie-card catalog-panel" data-movie-id="<%= idPr %>">
                    <div class="position-relative">
                        <img src="<%=request.getContextPath()%>/img/fallback-poster.svg" alt="<%= nombrePr %>">
                        <div class="position-absolute top-0 end-0 p-2 m-1">
                            <span class="badge bg-success rounded-pill shadow-sm">
                                <i class="bi bi-check-circle-fill me-1"></i> Comprada
                            </span>
                        </div>
                    </div>
                    <div class="movie-info">
                        <h5 class="movie-title"><%= nombrePr %></h5>
                        <div class="movie-rating mb-2">
                            <span class="movie-rating-text"><small class="text-muted">ID: <%= idPr %></small></span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <button class="btn btn-card-comprar w-100" onclick="openMovieDetail(<%= idPr %>)">
                                <i class="bi bi-play-fill me-1 fs-5"></i> Ver Detalles
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        <% } else { %>
            <div class="col-12 text-center py-5">
                <i class="bi bi-inbox fs-1 text-secondary d-block mb-3"></i>
                <h5 class="text-muted mb-2">Aún no has comprado películas</h5>
                <p class="text-muted small mb-4">Explora nuestro catálogo y comienza a construir tu biblioteca</p>
                <a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-primary rounded-pill px-5">
                    <i class="bi bi-shop me-2"></i>Ir a la Tienda
                </a>
            </div>
        <% } %>

        <div class="col-6 col-md-4 col-lg-3 d-flex align-items-stretch">
            <div class="movie-card catalog-panel w-100 d-flex flex-column align-items-center justify-content-center text-center p-4" style="background: rgba(255,255,255,0.02); border: 2px dashed rgba(255,255,255,0.1); cursor: pointer;" onclick="location.href='<%=request.getContextPath()%>/index.jsp'">
                <div class="rounded-circle p-3 mb-3" style="background: rgba(241, 179, 78, 0.1);">
                    <i class="bi bi-plus-lg fs-1" style="color: var(--accent-color);"></i>
                </div>
                <h5 class="fw-bold mb-2">Descubrir más</h5>
                <p class="text-muted small mb-0">Explora la tienda para añadir películas a tu colección.</p>
            </div>
        </div>

    </div>
</main>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=request.getContextPath()%>/js/script.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const libraryGrid = document.getElementById('library-grid');
        if (!libraryGrid) return;
        const startWatchingGrid = document.getElementById('start-watching-grid');

        const existingIds = new Set(
            Array.from(libraryGrid.querySelectorAll('[data-movie-id]'))
                .map(node => String(node.getAttribute('data-movie-id')))
        );

        let storedPurchases = [];
        try {
            storedPurchases = JSON.parse(localStorage.getItem('cinestore.purchases') || '[]');
        } catch (error) {
            storedPurchases = [];
        }

        const IMG_URL = 'https://image.tmdb.org/t/p/w500';
        const FALLBACK_POSTER = '<%=request.getContextPath()%>/img/fallback-poster.svg';
        const playId = new URLSearchParams(window.location.search).get('play');
        const latestPurchase = storedPurchases.find(item => String(item.id) === String(playId)) || storedPurchases[0];

        if (startWatchingGrid && latestPurchase && latestPurchase.id) {
            const posterSrc = latestPurchase.posterPath ? `${IMG_URL}${latestPurchase.posterPath}` : FALLBACK_POSTER;
            startWatchingGrid.innerHTML = `
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="movie-card catalog-panel" data-start-movie-id="${latestPurchase.id}">
                        <div class="position-relative">
                            <img src="${posterSrc}" alt="${latestPurchase.title || 'PelÃ­cula'}" onerror="this.onerror=null;this.src='${FALLBACK_POSTER}'">
                            <div class="position-absolute top-0 end-0 p-2 m-1">
                                <span class="badge bg-success rounded-pill shadow-sm">
                                    <i class="bi bi-check-circle-fill me-1"></i> Lista para ver
                                </span>
                            </div>
                        </div>
                        <div class="movie-info">
                            <h5 class="movie-title">${latestPurchase.title || 'PelÃ­cula'}</h5>
                            <p class="movie-meta mb-1">Compra realizada correctamente</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <button class="btn btn-card-comprar w-100" onclick="openMovieDetail(${latestPurchase.id})">
                                    <i class="bi bi-play-fill me-1 fs-5"></i> Empezar a ver
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        }

        storedPurchases.forEach(item => {
            const idStr = String(item.id);
            if (!item.id || existingIds.has(idStr)) return;

            const col = document.createElement('div');
            col.className = 'col-6 col-md-4 col-lg-3';
            const posterSrc = item.posterPath ? `${IMG_URL}${item.posterPath}` : FALLBACK_POSTER;
            col.innerHTML = `
                <div class="movie-card catalog-panel" data-movie-id="${idStr}">
                    <div class="position-relative">
                        <img src="${posterSrc}" alt="${item.title || 'Película'}" onerror="this.onerror=null;this.src='${FALLBACK_POSTER}'">
                        <div class="position-absolute top-0 end-0 p-2 m-1">
                            <span class="badge bg-success rounded-pill shadow-sm">
                                <i class="bi bi-check-circle-fill me-1"></i> Comprada
                            </span>
                        </div>
                    </div>
                    <div class="movie-info">
                        <h5 class="movie-title">${item.title || 'Película'}</h5>
                        <div class="movie-rating mb-2">
                            <span class="movie-rating-text"><small class="text-muted">ID: ${idStr}</small></span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <button class="btn btn-card-comprar w-100" onclick="openMovieDetail(${idStr})">
                                <i class="bi bi-play-fill me-1 fs-5"></i> Ver Detalles
                            </button>
                        </div>
                    </div>
                </div>
            `;
            libraryGrid.appendChild(col);
            existingIds.add(idStr);
        });
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const libraryGrid = document.getElementById('library-grid');
        const startWatchingGrid = document.getElementById('start-watching-grid');
        if (!libraryGrid || typeof buildApiUrl !== 'function') return;

        const fallbackPoster = '<%=request.getContextPath()%>/img/fallback-poster.svg';
        const storageKey = 'cinestore.purchases';

        const readPurchases = () => {
            try {
                return JSON.parse(localStorage.getItem(storageKey) || '[]');
            } catch (error) {
                return [];
            }
        };

        const savePurchases = (purchases) => {
            try {
                localStorage.setItem(storageKey, JSON.stringify(purchases));
            } catch (error) {
                console.warn('No se pudo guardar la biblioteca local:', error);
            }
        };

        const posterSrc = (movie) => movie && movie.posterPath ? IMG_URL + movie.posterPath : fallbackPoster;

        async function fetchMovie(movieId) {
            if (!movieId) return null;
            try {
                const response = await fetch(buildApiUrl('/movie/' + encodeURIComponent(movieId)));
                if (!response.ok) return null;
                const movie = await response.json();
                return {
                    id: movie.id,
                    title: movie.title || movie.name || 'Pelicula',
                    posterPath: movie.poster_path || null,
                    date: movie.release_date ? movie.release_date.split('-')[0] : 'N/D',
                    rating: typeof movie.vote_average === 'number' ? movie.vote_average : null
                };
            } catch (error) {
                console.warn('No se pudo cargar la pelicula comprada:', error);
                return null;
            }
        }

        function normalizePurchase(item) {
            return {
                id: item && item.id ? Number(item.id) : null,
                title: item && item.title && item.title !== 'false' ? item.title : 'Pelicula',
                posterPath: item && item.posterPath ? item.posterPath : null,
                date: item && item.date ? item.date : 'N/D',
                rating: item && item.rating ? item.rating : null
            };
        }

        function updateCard(card, movie) {
            if (!card || !movie) return;
            const image = card.querySelector('img');
            const title = card.querySelector('.movie-title');
            if (image) {
                image.src = posterSrc(movie);
                image.alt = movie.title || 'Pelicula';
                image.onerror = function () {
                    this.onerror = null;
                    this.src = fallbackPoster;
                };
            }
            if (title) {
                title.textContent = movie.title || 'Pelicula';
            }
        }

        function startCard(movie) {
            if (!startWatchingGrid || !movie || !movie.id) return;
            startWatchingGrid.innerHTML = `
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="movie-card catalog-panel" data-start-movie-id="${movie.id}">
                        <div class="position-relative">
                            <img src="${posterSrc(movie)}" alt="${movie.title || 'Pelicula'}" onerror="this.onerror=null;this.src='${fallbackPoster}'">
                            <div class="position-absolute top-0 end-0 p-2 m-1">
                                <span class="badge bg-success rounded-pill shadow-sm">
                                    <i class="bi bi-check-circle-fill me-1"></i> Lista para ver
                                </span>
                            </div>
                        </div>
                        <div class="movie-info">
                            <h5 class="movie-title">${movie.title || 'Pelicula'}</h5>
                            <p class="movie-meta mb-1">Compra realizada correctamente</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <button class="btn btn-card-comprar w-100" onclick="openMovieDetail(${movie.id})">
                                    <i class="bi bi-play-fill me-1 fs-5"></i> Empezar a ver
                                </button>
                            </div>
                        </div>
                    </div>
                </div>`;
        }

        function addLibraryCard(movie) {
            const id = String(movie.id);
            if (!movie.id || libraryGrid.querySelector('[data-movie-id="' + id + '"]')) return;
            const col = document.createElement('div');
            col.className = 'col-6 col-md-4 col-lg-3';
            col.innerHTML = `
                <div class="movie-card catalog-panel" data-movie-id="${id}">
                    <div class="position-relative">
                        <img src="${posterSrc(movie)}" alt="${movie.title || 'Pelicula'}" onerror="this.onerror=null;this.src='${fallbackPoster}'">
                        <div class="position-absolute top-0 end-0 p-2 m-1">
                            <span class="badge bg-success rounded-pill shadow-sm">
                                <i class="bi bi-check-circle-fill me-1"></i> Comprada
                            </span>
                        </div>
                    </div>
                    <div class="movie-info">
                        <h5 class="movie-title">${movie.title || 'Pelicula'}</h5>
                        <div class="movie-rating mb-2">
                            <span class="movie-rating-text"><small class="text-muted">ID: ${id}</small></span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <button class="btn btn-card-comprar w-100" onclick="openMovieDetail(${id})">
                                <i class="bi bi-play-fill me-1 fs-5"></i> Ver Detalles
                            </button>
                        </div>
                    </div>
                </div>`;
            libraryGrid.appendChild(col);
        }

        async function hydratePurchases() {
            const stored = readPurchases().map(normalizePurchase).filter(item => item.id);
            const hydrated = await Promise.all(stored.map(async item => {
                if (item.posterPath && item.title && item.title !== 'false') return item;
                return await fetchMovie(item.id) || item;
            }));

            savePurchases(hydrated);

            const playId = new URLSearchParams(window.location.search).get('play');
            const latest = hydrated.find(item => String(item.id) === String(playId)) || hydrated[0];
            if (latest) startCard(latest);
            hydrated.forEach(addLibraryCard);

            const cards = Array.from(libraryGrid.querySelectorAll('[data-movie-id]'));
            await Promise.all(cards.map(async card => {
                const movie = await fetchMovie(card.getAttribute('data-movie-id'));
                if (movie) updateCard(card, movie);
            }));
        }

        hydratePurchases();
    });
</script>
</body>
</html>
