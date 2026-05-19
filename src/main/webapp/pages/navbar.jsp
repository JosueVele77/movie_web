<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%
    Usuario usuarioNav = (Usuario) session.getAttribute("usuarioLogueado");
%>
<nav class="navbar navbar-expand-lg custom-navbar py-3">
    <div class="container-fluid px-4 px-lg-5">
        <a class="navbar-brand d-flex align-items-center gap-2" href="<%=request.getContextPath()%>/index.jsp">
            <img src="<%=request.getContextPath()%>/img/logo-cinestore.svg" alt="CineStore" class="brand-logo">
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <form class="d-flex mx-auto search-form my-2 my-lg-0" role="search" id="search-form">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-end-0 search-icon"><i class="fas fa-search"></i></span>
                    <input class="form-control border-start-0 ps-0 search-input" type="search" placeholder="Buscar películas..." aria-label="Search" id="search-input">
                    <button class="btn btn-outline-secondary border-start-0" type="submit" aria-label="Buscar">
                        <i class="fas fa-search"></i>
                    </button>
                    <button class="btn btn-outline-secondary" type="button" id="search-clear" aria-label="Limpiar búsqueda">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </form>

            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center gap-3">
                <li class="nav-item">
                    <a class="nav-link text-decoration-none fw-bold d-flex align-items-center gap-1" href="<%=request.getContextPath()%>/pages/3d.jsp" style="color: var(--accent-color) !important;">
                        <i class="bi bi-badge-3d-fill fs-4"></i> 3D
                    </a>
                </li>

                <li class="nav-item">
                    <button class="nav-link btn btn-link p-0 text-decoration-none" id="categories-toggle" aria-haspopup="dialog" aria-controls="categories-overlay">
                        Categorías
                    </button>
                </li>

                <%-- A PARTIR DE AQUÍ SE MUESTRA EL MENÚ DINÁMICO A LA DERECHA DE CATEGORÍAS --%>
                <% if (usuarioNav == null) { %>

                <li class="nav-item" id="login-link">
                    <a href="<%=request.getContextPath()%>/pages/login.jsp" class="nav-link" aria-label="Iniciar sesión">
                        <i class="bi bi-person-circle login-icon" role="button"></i>
                    </a>
                </li>

                <% } else { %>

                <li class="nav-item" id="my-content-link">
                    <a class="nav-link" href="<%=request.getContextPath()%>/pages/my_content.jsp">Mi Contenido</a>
                </li>
                <li class="nav-item" id="favorites-link">
                    <a class="nav-link" href="<%=request.getContextPath()%>/pages/favorites.jsp">Favoritos</a>
                </li>

                <li class="nav-item dropdown" id="user-menu">
                    <a class="nav-link dropdown-toggle d-flex align-items-center gap-1" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle login-icon"></i>
                        <span class="fw-semibold"><%= usuarioNav.getNombreUs() %></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="#">Mi Perfil</a></li>

                        <%-- Si es Administrador (Rol 1), ve el Panel de Control --%>
                        <% if (usuarioNav.getIdPer() == 1) { %>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/dashboard">Panel Admin</a></li>
                        <% } %>

                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/LogoutServlet">Cerrar Sesión</a></li>
                    </ul>
                </li>

                <% } %>
                <%-- FIN DE LA LÓGICA DINÁMICA --%>

                <li class="nav-item">
                    <button id="theme-toggle" class="btn btn-outline-secondary rounded-circle theme-btn" aria-label="Cambiar tema">
                        <i class="fas fa-sun"></i>
                    </button>
                </li>
            </ul>
        </div>
    </div>
</nav>