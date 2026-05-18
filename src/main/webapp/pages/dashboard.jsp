<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%@ page import="io.github.josuevele77.movie_web.dao.ProductoDAO" %>
<%@ page import="io.github.josuevele77.movie_web.dao.UsuarioDAO" %>
<%@ page import="io.github.josuevele77.movie_web.model.Producto" %>
<%@ page import="java.util.List" %>
<%
    // FILTRO DE SEGURIDAD: Evita que clientes o empleados entren por URL directa
    Usuario userSession = (Usuario) session.getAttribute("usuarioLogueado");
    if (userSession == null || userSession.getIdPer() != 1) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=NoAutorizado");
        return;
    }

    // Instancia de DAOs para pintar información en tiempo real
    ProductoDAO prodDAO = new ProductoDAO();
    UsuarioDAO userDAO = new UsuarioDAO();

    int totalProductos = prodDAO.contarTotalProductos();
    int productosOcultos = prodDAO.contarProductosOcultos();
    int totalClientes = userDAO.contarClientes();
    List<Producto> ocultos = prodDAO.listarOcultos();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>CineStore - Panel de Administración</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --dark-bg: #141414;
            --card-dark: #1f1f1f;
            --accent-color: #e50914; /* Rojo Cinema */
        }
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            background-color: var(--dark-bg);
            min-height: 100vh;
            color: white;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.7);
            border-radius: 8px;
            margin-bottom: 5px;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: var(--accent-color);
            color: white;
        }
        .metric-card {
            border: none;
            border-radius: 15px;
            transition: transform 0.2s;
        }
        .metric-card:hover {
            transform: translateY(-5px);
        }
        .custom-table-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .avatar-circle {
            width: 45px;
            height: 45px;
            background-color: var(--accent-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            border-radius: 50%;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-3 col-lg-2 sidebar p-3 d-flex flex-column">
            <div class="brand text-center my-4">
                <h3 class="fw-bold m-0 text-white" style="letter-spacing: 1px;">CINE<span style="color: var(--accent-color);">STORE</span></h3>
                <small class="text-white-50">Panel Administrativo</small>
            </div>
            <hr class="text-white-50">
            <ul class="nav flex-column flex-grow-1">
                <li class="nav-item">
                    <a class="nav-link active" href="#"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="editar_productos.jsp"><i class="bi bi-film me-2"></i> Películas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="bi bi-people me-2"></i> Usuarios</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="bi bi-journal-text me-2"></i> Auditoría</a>
                </li>
            </ul>
            <hr class="text-white-50">
            <div class="dropdown mb-3">
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-outline-light btn-sm w-100 rounded-pill mb-2">
                    <i class="bi bi-shop me-1"></i> Ver Tienda
                </a>
                <a href="<%= request.getContextPath() %>/pages/login.jsp" class="btn btn-danger btn-sm w-100 rounded-pill">
                    <i class="bi bi-box-arrow-left me-1"></i> Salir
                </a>
            </div>
        </div>

        <div class="col-md-9 col-lg-10 p-4 p-lg-5">
            <div class="d-flex justify-content-between align-items-center mb-5">
                <div>
                    <h2 class="fw-bold text-dark m-0">Bienvenido de nuevo, <%= userSession.getNombreUs() %></h2>
                    <p class="text-muted m-0">Aquí está el resumen del estado actual de tu catálogo y usuarios.</p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <div class="text-end d-none d-sm-block">
                        <span class="fw-bold d-block text-dark"><%= userSession.getCorreoUs() %></span>
                        <span class="badge bg-dark text-uppercase">Administrador</span>
                    </div>
                    <div class="avatar-circle fs-5">
                        <%= userSession.getNombreUs().substring(0, 1).toUpperCase() %>
                    </div>
                </div>
            </div>

            <%-- Mensajes de acción con alertas estilizadas --%>
            <% if(request.getParameter("reactivado") != null) { %>
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> El producto ha sido reactivado con éxito y ya es visible para los clientes.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Películas Totales</span>
                                <h3 class="fw-bold m-0 mt-1"><%= totalProductos %></h3>
                            </div>
                            <div class="bg-primary bg-opacity-10 p-3 rounded-3 text-primary fs-3">
                                <i class="bi bi-collection-play"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Clientes Activos</span>
                                <h3 class="fw-bold m-0 mt-1"><%= totalClientes %></h3>
                            </div>
                            <div class="bg-success bg-opacity-10 p-3 rounded-3 text-success fs-3">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Películas Ocultas</span>
                                <h3 class="fw-bold m-0 mt-1 text-danger"><%= productosOcultos %></h3>
                            </div>
                            <div class="bg-danger bg-opacity-10 p-3 rounded-3 text-danger fs-3">
                                <i class="bi bi-eye-slash-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card custom-table-card bg-white p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold text-dark m-0">Películas Ocultas (Requieren Aprobación)</h4>
                        <p class="text-muted small m-0">Listado de productos desactivados por el personal de ventas que puedes volver a activar.</p>
                    </div>
                    <span class="badge bg-danger rounded-pill px-3 py-2"><%= ocultos.size() %> Pendientes</span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light text-secondary small text-uppercase">
                        <tr>
                            <th class="ps-3">ID</th>
                            <th>Nombre de Película</th>
                            <th>Cantidad / Stock</th>
                            <th>Precio Unitario</th>
                            <th>Estado</th>
                            <th class="text-end pe-3">Acción Autorizada</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (ocultos.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-emoji-smile fs-3 d-block mb-2 text-secondary"></i>
                                No hay películas ocultas en este momento. ¡Todo el catálogo está activo!
                            </td>
                        </tr>
                        <% } else {
                            for (Producto p : ocultos) { %>
                        <tr>
                            <td class="fw-bold ps-3">#<%= p.getIdPr() %></td>
                            <td class="fw-bold text-dark"><%= p.getNombrePr() %></td>
                            <td><span class="badge bg-secondary"><%= p.getCantidadPr() %> unidades</span></td>
                            <td class="text-success fw-bold">$<%= String.format("%.2f", p.getPrecioPr()) %></td>
                            <td><span class="badge bg-warning text-dark"><i class="bi bi-exclamation-circle-fill me-1"></i> Oculto por Empleado</span></td>
                            <td class="text-end pe-3">
                                <form action="${pageContext.request.contextPath}/ReactivarProductoServlet" method="POST" style="display:inline;">
                                    <input type="hidden" name="id_pr" value="<%= p.getIdPr() %>">
                                    <button type="submit" class="btn btn-sm btn-success rounded-pill px-3 fw-bold shadow-sm">
                                        <i class="bi bi-eye me-1"></i> Volver a Activar
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <%   }
                        } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>