<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Usuario userSession = (Usuario) session.getAttribute("usuarioLogueado");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, Object>> registroAuditoria = (List<Map<String, Object>>) request.getAttribute("registroAuditoria");
    if (registroAuditoria == null) {
        registroAuditoria = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>CineStore - Auditoría</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --dark-bg: #141414;
            --card-dark: #1f1f1f;
            --accent-color: #e50914;
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
        .table-card {
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
        .action-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }
        .action-create {
            background-color: #28a745;
            color: white;
        }
        .action-update {
            background-color: #0d6efd;
            color: white;
        }
        .action-delete {
            background-color: #dc3545;
            color: white;
        }
        .action-login {
            background-color: #6f42c1;
            color: white;
        }
        .action-logout {
            background-color: #fd7e14;
            color: white;
        }
        .timeline-item {
            padding: 20px;
            border-left: 3px solid var(--accent-color);
            margin-bottom: 15px;
            background-color: rgba(0, 0, 0, 0.02);
            border-radius: 8px;
        }
        .timeline-item.warning {
            border-left-color: #ffc107;
        }
        .timeline-item.danger {
            border-left-color: #dc3545;
        }
        .timeline-item.success {
            border-left-color: #28a745;
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
                    <a class="nav-link" href="<%= request.getContextPath() %>/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/analisis"><i class="bi bi-bar-chart me-2"></i> Análisis de Ventas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%= request.getContextPath() %>/auditoria"><i class="bi bi-journal-text me-2"></i> Auditoría</a>
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
                    <h2 class="fw-bold text-dark m-0">Registro de Auditoría</h2>
                    <p class="text-muted m-0">Historial completo de todas las actividades administrativas y cambios en el sistema.</p>
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

            <div class="row g-4 mb-5">
                <div class="col-md-3">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Total de Registros</span>
                                <h3 class="fw-bold m-0 mt-1"><%= registroAuditoria.size() %></h3>
                            </div>
                            <div class="bg-primary bg-opacity-10 p-3 rounded-3 text-primary fs-3">
                                <i class="bi bi-file-earmark-text"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Actividad Hoy</span>
                                <h3 class="fw-bold m-0 mt-1 text-success">
                                    <%
                                        int actividadHoy = 0;
                                        for (Map<String, Object> registro : registroAuditoria) {
                                            String fecha = (String) registro.getOrDefault("fecha", "");
                                            if (fecha.contains("Hace")) actividadHoy++;
                                        }
                                    %>
                                    <%= actividadHoy %>
                                </h3>
                            </div>
                            <div class="bg-success bg-opacity-10 p-3 rounded-3 text-success fs-3">
                                <i class="bi bi-activity"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Cambios Realizados</span>
                                <h3 class="fw-bold m-0 mt-1 text-info">
                                    <%
                                        int cambios = 0;
                                        for (Map<String, Object> registro : registroAuditoria) {
                                            String accion = (String) registro.getOrDefault("accion", "");
                                            if (accion.equals("UPDATE") || accion.equals("DELETE")) cambios++;
                                        }
                                    %>
                                    <%= cambios %>
                                </h3>
                            </div>
                            <div class="bg-info bg-opacity-10 p-3 rounded-3 text-info fs-3">
                                <i class="bi bi-pencil-square"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Eventos Críticos</span>
                                <h3 class="fw-bold m-0 mt-1 text-danger">
                                    <%
                                        int criticos = 0;
                                        for (Map<String, Object> registro : registroAuditoria) {
                                            String accion = (String) registro.getOrDefault("accion", "");
                                            if (accion.equals("DELETE")) criticos++;
                                        }
                                    %>
                                    <%= criticos %>
                                </h3>
                            </div>
                            <div class="bg-danger bg-opacity-10 p-3 rounded-3 text-danger fs-3">
                                <i class="bi bi-exclamation-triangle-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card table-card bg-white p-4">
                <div class="mb-4">
                    <h5 class="fw-bold text-dark">Historial de Actividades</h5>
                    <p class="text-muted small m-0">Registro detallado de todos los eventos del sistema ordenados por fecha.</p>
                </div>

                <% if (registroAuditoria.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-3 d-block mb-2 text-secondary"></i>
                        <p class="text-muted mb-0">No hay registros de auditoría disponibles en este momento.</p>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle m-0">
                            <thead class="table-light text-secondary small text-uppercase">
                            <tr>
                                <th class="ps-3">Fecha y Hora</th>
                                <th>Administrador</th>
                                <th>Acción</th>
                                <th>Entidad</th>
                                <th>Descripción</th>
                                <th class="text-end pe-3">Estado</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Map<String, Object> registro : registroAuditoria) {
                                String accion = (String) registro.getOrDefault("accion", "");
                                String claseAccion = "action-create";
                                String icono = "bi-plus-circle";
                                if (accion.equals("UPDATE")) {
                                    claseAccion = "action-update";
                                    icono = "bi-pencil-circle";
                                } else if (accion.equals("DELETE")) {
                                    claseAccion = "action-delete";
                                    icono = "bi-trash-fill";
                                } else if (accion.equals("LOGIN")) {
                                    claseAccion = "action-login";
                                    icono = "bi-box-arrow-in-right";
                                } else if (accion.equals("LOGOUT")) {
                                    claseAccion = "action-logout";
                                    icono = "bi-box-arrow-left";
                                }
                            %>
                            <tr>
                                <td class="ps-3 fw-bold text-dark"><%= registro.getOrDefault("fecha", "N/A") %></td>
                                <td class="fw-bold text-dark">
                                    <i class="bi bi-person-circle me-2 text-secondary"></i><%= registro.getOrDefault("administrador", "Sistema") %>
                                </td>
                                <td>
                                    <span class="action-badge <%= claseAccion %>">
                                        <i class="bi <%= icono %>"></i> <%= accion %>
                                    </span>
                                </td>
                                <td><%= registro.getOrDefault("entidad", "N/A") %></td>
                                <td class="text-muted"><%= registro.getOrDefault("descripcion", "N/A") %></td>
                                <td class="text-end pe-3">
                                    <% if (accion.equals("DELETE")) { %>
                                        <span class="badge bg-danger"><i class="bi bi-exclamation-circle-fill me-1"></i> Crítico</span>
                                    <% } else if (accion.equals("UPDATE")) { %>
                                        <span class="badge bg-warning text-dark"><i class="bi bi-info-circle me-1"></i> Modificado</span>
                                    <% } else { %>
                                        <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i> Exitoso</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%   }
                            } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

