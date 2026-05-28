<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%@ page import="io.github.josuevele77.movie_web.dao.FavoritoDAO" %>
<%@ page import="io.github.josuevele77.movie_web.model.Favorito" %>
<%@ page import="java.util.List" %>
<%
    Usuario userSession = (Usuario) session.getAttribute("usuarioLogueado");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    FavoritoDAO favoritoDAO = new FavoritoDAO();
    List<Favorito> favoritos = favoritoDAO.listarPorUsuario(userSession.getIdUs());
%>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineStore - Mis Favoritos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div id="stars-container"></div>
<div class="planet"></div>

<nav class="navbar navbar-expand-lg custom-navbar py-3 sticky-top">
    <div class="container-fluid px-4 px-lg-5">
        <a class="navbar-brand d-flex align-items-center gap-2" href="<%= request.getContextPath() %>/index.jsp">
            <img src="<%= request.getContextPath() %>/img/logo-cinestore.svg" alt="CineStore" style="width: 50px; height: 50px; object-fit: contain;">
        </a>
        <span class="navbar-text text-light ms-auto me-auto">Mis Favoritos</span>
        <ul class="navbar-nav ms-auto align-items-center">
            <li class="nav-item">
                <button class="btn btn-outline-light rounded-pill px-4" data-action="go-back" data-fallback="../index.jsp">
                    <i class="bi bi-arrow-left me-2"></i>Volver
                </button>
            </li>
        </ul>
    </div>
</nav>

<div class="container py-5">
    <h1 class="mb-4">Mis Favoritos</h1>
    <div id="favorites-grid" class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-4">
        <% if (favoritos == null || favoritos.isEmpty()) { %>
            <p class="col-12 text-muted">No tienes películas favoritas todavía.</p>
        <% } else { %>
            <% for (Favorito movie : favoritos) {
                String posterPath = movie.getPosterPath();
                String posterSrc = (posterPath != null && !posterPath.isEmpty())
                        ? "https://image.tmdb.org/t/p/w500" + posterPath
                        : request.getContextPath() + "/img/fallback-poster.svg";
                String title = movie.getTitle() != null ? movie.getTitle() : "Película";
                String year = movie.getReleaseYear() != null ? movie.getReleaseYear() : "N/D";
            %>
            <div class="col">
                <div class="movie-card h-100 d-flex flex-column" style="cursor: pointer;" onclick="openMovieDetail(<%= movie.getTmdbId() %>)">
                    <img src="<%= posterSrc %>" alt="<%= title %>" class="img-fluid" style="height: 250px; object-fit: cover; border-radius: 8px;" onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/img/fallback-poster.svg'">
                    <div class="movie-info d-flex flex-column flex-grow-1 mt-2">
                        <h5 class="movie-title fw-bold"><%= title %></h5>
                        <small class="text-muted mt-1"><%= year %></small>
                    </div>
                </div>
            </div>
            <% } %>
        <% } %>
    </div>
</div>
<script src="../js/script.js"></script>
</body>
</html>