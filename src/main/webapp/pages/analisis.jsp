<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    Usuario userSession = (Usuario) session.getAttribute("usuarioLogueado");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Map<String, Double> ventasPorDia = (Map<String, Double>) request.getAttribute("ventasPorDia");
    if (ventasPorDia == null) {
        ventasPorDia = new LinkedHashMap<>();
    }
    double totalVentas = (Double) request.getAttribute("totalVentas") != null ? (Double) request.getAttribute("totalVentas") : 0.0;
    int totalTransacciones = (Integer) request.getAttribute("totalTransacciones") != null ? (Integer) request.getAttribute("totalTransacciones") : 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>CineStore - Análisis de Ventas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .chart-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            background: white;
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
        .chart-container {
            position: relative;
            height: 400px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-3 col-lg-2 sidebar p-3 d-flex flex-column">
            <div class="brand text-center my-4">
                <a href="<%= request.getContextPath() %>/index.jsp" style="text-decoration: none;">
                    <img src="<%= request.getContextPath() %>/img/logo-cinestore.svg" alt="CineStore" style="width: 60px; height: 60px; object-fit: contain; margin-bottom: 0.5rem; cursor: pointer;">
                </a>
                <h3 class="fw-bold m-0 text-white" style="letter-spacing: 1px;">CINE<span style="color: var(--accent-color);">STORE</span></h3>
                <small class="text-white-50">Panel Administrativo</small>
            </div>
            <hr class="text-white-50">
            <ul class="nav flex-column flex-grow-1">
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%= request.getContextPath() %>/analisis"><i class="bi bi-bar-chart me-2"></i> Análisis de Ventas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/auditoria"><i class="bi bi-journal-text me-2"></i> Auditoría</a>
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
                    <h2 class="fw-bold text-dark m-0">Análisis de Ventas</h2>
                    <p class="text-muted m-0">Visualiza el desempeño de ventas y transacciones en tiempo real.</p>
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
                <div class="col-md-4">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Ventas Totales</span>
                                <h3 class="fw-bold m-0 mt-1 text-success">$<%= String.format("%.2f", totalVentas) %></h3>
                            </div>
                            <div class="bg-success bg-opacity-10 p-3 rounded-3 text-success fs-3">
                                <i class="bi bi-currency-dollar"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Transacciones</span>
                                <h3 class="fw-bold m-0 mt-1"><%= totalTransacciones %></h3>
                            </div>
                            <div class="bg-info bg-opacity-10 p-3 rounded-3 text-info fs-3">
                                <i class="bi bi-receipt"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Promedio por Venta</span>
                                <h3 class="fw-bold m-0 mt-1">$<%= String.format("%.2f", totalTransacciones > 0 ? totalVentas / totalTransacciones : 0) %></h3>
                            </div>
                            <div class="bg-primary bg-opacity-10 p-3 rounded-3 text-primary fs-3">
                                <i class="bi bi-graph-up"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card chart-card p-4 mb-5">
                <div class="mb-4">
                    <h5 class="fw-bold text-dark">Ventas por Día (Últimos 7 días)</h5>
                    <p class="text-muted small m-0">Visualiza el desempeño diario de ventas en el último período.</p>
                </div>
                <div class="chart-container">
                    <canvas id="ventasChart"></canvas>
                </div>
            </div>

            <div class="card chart-card p-4">
                <div class="mb-4">
                    <h5 class="fw-bold text-dark">Resumen Estadístico</h5>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light text-secondary small text-uppercase">
                        <tr>
                            <th class="ps-3">Día</th>
                            <th class="text-end pe-3">Ventas ($)</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (ventasPorDia.isEmpty()) { %>
                        <tr>
                            <td colspan="2" class="text-center py-5 text-muted">
                                <i class="bi bi-graph-up fs-3 d-block mb-2 text-secondary"></i>
                                No hay datos de ventas disponibles en este momento.
                            </td>
                        </tr>
                        <% } else {
                            for (Map.Entry<String, Double> entry : ventasPorDia.entrySet()) { %>
                        <tr>
                            <td class="ps-3 fw-bold text-dark"><%= entry.getKey() %></td>
                            <td class="text-end pe-3 text-success fw-bold">$<%= String.format("%.2f", entry.getValue()) %></td>
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
<script>
    // Datos para la gráfica
    const labels = [
        <% for (String dia : ventasPorDia.keySet()) { %>
            '<%= dia %>',
        <% } %>
    ];
    const data = [
        <% for (Double venta : ventasPorDia.values()) { %>
            <%= venta %>,
        <% } %>
    ];

    const ctx = document.getElementById('ventasChart').getContext('2d');
    const ventasChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Ventas ($)',
                data: data,
                borderColor: '#e50914',
                backgroundColor: 'rgba(229, 9, 20, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                pointBackgroundColor: '#e50914',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 5,
                pointHoverRadius: 7
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    labels: {
                        font: {
                            size: 12,
                            weight: 'bold'
                        },
                        color: '#333'
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return '$' + value.toFixed(2);
                        }
                    }
                }
            }
        }
    });
</script>
</body>
</html>

