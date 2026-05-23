<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%@ page import="io.github.josuevele77.movie_web.model.Producto" %>
<%@ page import="java.util.List" %>
<%
    Usuario userSession = (Usuario) session.getAttribute("usuarioLogueado");
    if (userSession == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    // Solo vendedores pueden acceder a este apartado
    if (userSession.getIdPer() != 2) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=unauthorized");
        return;
    }

    int totalProductos = (Integer) request.getAttribute("totalP");
    List<Producto> todosProductos = (List<Producto>) request.getAttribute("todosProductos");

    if (todosProductos == null) {
        todosProductos = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>CineStore - Panel de Vendedor</title>
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
                <small class="text-white-50">Panel Vendedor</small>
            </div>
            <hr class="text-white-50">
            <ul class="nav flex-column flex-grow-1">
                <li class="nav-item">
                    <a class="nav-link active" href="<%= request.getContextPath() %>/vendedor"><i class="bi bi-speedometer2 me-2"></i> Panel</a>
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
                    <p class="text-muted m-0">Gestiona tus películas, precios y ofertas desde aquí.</p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <div class="text-end d-none d-sm-block">
                        <span class="fw-bold d-block text-dark"><%= userSession.getCorreoUs() %></span>
                        <span class="badge bg-primary text-uppercase">Vendedor</span>
                    </div>
                    <div class="avatar-circle fs-5">
                        <%= userSession.getNombreUs().substring(0, 1).toUpperCase() %>
                    </div>
                </div>
            </div>

            <!-- VISTA PARA VENDEDOR -->
            <div class="row g-4 mb-5">
                <div class="col-md-3">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Películas Disponibles</span>
                                <h3 class="fw-bold m-0 mt-1"><%= totalProductos %></h3>
                            </div>
                            <div class="bg-info bg-opacity-10 p-3 rounded-3 text-info fs-3">
                                <i class="bi bi-film"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card custom-table-card bg-white p-4">
                <div class="mb-4">
                    <h5 class="fw-bold text-dark">Gestionar Películas</h5>
                    <p class="text-muted small m-0">Aquí puedes ocultar películas y modificar precios o crear ofertas.</p>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light text-secondary small text-uppercase">
                        <tr>
                            <th class="ps-3">ID</th>
                            <th>Nombre de Película</th>
                            <th>Stock</th>
                            <th>Precio</th>
                            <th>Estado</th>
                            <th class="text-end pe-3">Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (todosProductos.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-3 d-block mb-2 text-secondary"></i>
                                No hay películas disponibles en el catálogo.
                            </td>
                        </tr>
                        <% } else {
                            for (Producto p : todosProductos) { %>
                        <tr>
                            <td class="fw-bold ps-3">#<%= p.getIdPr() %></td>
                            <td class="fw-bold text-dark"><%= p.getNombrePr() %></td>
                            <td><span class="badge bg-secondary"><%= p.getCantidadPr() %></span></td>
                            <td class="text-success fw-bold">$<%= String.format("%.2f", p.getPrecioPr()) %></td>
                            <td><span class="badge bg-success"><i class="bi bi-eye me-1"></i> Activo</span></td>
                            <td class="text-end pe-3">
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-warning rounded-start" onclick="ocultarPelicula(<%= p.getIdPr() %>)" title="Ocultar película">
                                        <i class="bi bi-eye-slash"></i>
                                    </button>
                                    <button type="button" class="btn btn-danger disabled" title="Eliminar (No autorizado)" disabled>
                                        <i class="bi bi-trash"></i>
                                    </button>
                                    <button type="button" class="btn btn-primary rounded-end" onclick="abrirModalPrecio(<%= p.getIdPr() %>, '<%= p.getNombrePr() %>', <%= p.getPrecioPr() %>)" title="Modificar precio u oferta">
                                        <i class="bi bi-percent"></i>
                                    </button>
                                </div>
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

<!-- Modal para modificar precio y oferta -->
<div class="modal fade" id="modalPrecio" tabindex="-1" aria-labelledby="modalPrecioLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0">
            <div class="modal-header bg-primary text-white border-0">
                <h5 class="modal-title" id="modalPrecioLabel">
                    <i class="bi bi-percent me-2"></i> Modificar Precio u Oferta
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="nombrePelicula" class="fw-bold mb-3"></p>
                <form id="formPrecio">
                    <input type="hidden" id="productoIdInput" name="productoId">
                    <div class="mb-3">
                        <label for="nuevoPrecio" class="form-label fw-bold">Nuevo Precio</label>
                        <input type="number" class="form-control border-2" id="nuevoPrecio" placeholder="Ingresa el nuevo precio" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label for="porcentajeOferta" class="form-label fw-bold">Descuento (%)</label>
                        <input type="number" class="form-control border-2" id="porcentajeOferta" placeholder="Ej: 10 (10% descuento)" min="0" max="100">
                    </div>
                    <div id="precioFinal" class="alert alert-info d-none" role="alert">
                        <small>Precio con descuento: <strong id="precioResultado"></strong></small>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary rounded-pill" onclick="guardarPrecio()">
                    <i class="bi bi-check-circle me-1"></i> Guardar
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let modalPrecio = new bootstrap.Modal(document.getElementById('modalPrecio'), {
        keyboard: false
    });

    function abrirModalPrecio(productoId, nombrePelicula, precioActual) {
        document.getElementById('productoIdInput').value = productoId;
        document.getElementById('nombrePelicula').innerHTML = '📽️ <strong>' + nombrePelicula + '</strong><br><small class="text-muted">Precio actual: $' + precioActual.toFixed(2) + '</small>';
        document.getElementById('nuevoPrecio').value = '';
        document.getElementById('porcentajeOferta').value = '';
        document.getElementById('precioFinal').classList.add('d-none');
        modalPrecio.show();
    }

    // Calcular precio con descuento en tiempo real
    document.getElementById('porcentajeOferta').addEventListener('input', function() {
        let precio = parseFloat(document.getElementById('nuevoPrecio').value) || 0;
        let descuento = parseFloat(this.value) || 0;

        if (precio > 0 && descuento > 0) {
            let precioFinal = precio - (precio * descuento / 100);
            document.getElementById('precioResultado').textContent = '$' + precioFinal.toFixed(2);
            document.getElementById('precioFinal').classList.remove('d-none');
        } else {
            document.getElementById('precioFinal').classList.add('d-none');
        }
    });

    document.getElementById('nuevoPrecio').addEventListener('input', function() {
        let descuento = parseFloat(document.getElementById('porcentajeOferta').value) || 0;
        if (descuento > 0) {
            document.getElementById('porcentajeOferta').dispatchEvent(new Event('input'));
        }
    });

    function ocultarPelicula(productoId) {
        if (confirm('¿Estás seguro de que quieres ocultar esta película?')) {
            fetch('<%= request.getContextPath() %>/ocultarProducto', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'productoId=' + productoId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Película ocultada exitosamente');
                    location.reload();
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error de conexión');
            });
        }
    }

    function guardarPrecio() {
        const productoId = document.getElementById('productoIdInput').value;
        const nuevoPrecio = document.getElementById('nuevoPrecio').value;
        const porcentajeOferta = document.getElementById('porcentajeOferta').value || 0;

        if (!nuevoPrecio || nuevoPrecio <= 0) {
            alert('Por favor ingresa un precio válido');
            return;
        }

        fetch('<%= request.getContextPath() %>/actualizarPrecio', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'productoId=' + productoId + '&nuevoPrecio=' + nuevoPrecio + '&descuento=' + porcentajeOferta
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Precio actualizado exitosamente');
                modalPrecio.hide();
                location.reload();
            } else {
                alert('Error: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error de conexión');
        });
    }
</script>
</body>
</html>

