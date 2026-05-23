<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%@ page import="java.util.List" %>
<%
    Usuario userSession = (Usuario) session.getAttribute("usuarioLogueado");
    if (userSession == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    if (usuarios == null) {
        usuarios = new java.util.ArrayList<>();
    }
    // Solo administradores pueden cambiar roles
    boolean esAdmin = userSession.getIdPer() == 1;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>CineStore - Gestión de Usuarios</title>
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
        .avatar-img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--accent-color);
        }
        .avatar-placeholder {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: var(--accent-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            border: 2px solid var(--accent-color);
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        .status-online {
            background-color: #28a745;
            color: white;
        }
        .status-offline {
            background-color: #6c757d;
            color: white;
        }
        .status-indicator {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
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
                    <a class="nav-link active" href="<%= request.getContextPath() %>/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a>
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
                    <h2 class="fw-bold text-dark m-0">Gestión de Usuarios</h2>
                    <p class="text-muted m-0">Visualiza y administra todos los usuarios registrados en CineStore.</p>
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
                                <span class="text-muted small text-uppercase fw-bold">Total de Usuarios</span>
                                <h3 class="fw-bold m-0 mt-1"><%= usuarios.size() %></h3>
                            </div>
                            <div class="bg-primary bg-opacity-10 p-3 rounded-3 text-primary fs-3">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Conectados</span>
                                <h3 class="fw-bold m-0 mt-1 text-success">
                                    <%
                                        int conectados = 0;
                                        for (Usuario u : usuarios) {
                                            if (u.getIdEst() == 1) conectados++;
                                        }
                                    %>
                                    <%= conectados %>
                                </h3>
                            </div>
                            <div class="bg-success bg-opacity-10 p-3 rounded-3 text-success fs-3">
                                <i class="bi bi-check-circle-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Inactivos</span>
                                <h3 class="fw-bold m-0 mt-1 text-warning">
                                    <%
                                        int inactivos = 0;
                                        for (Usuario u : usuarios) {
                                            if (u.getIdEst() != 1) inactivos++;
                                        }
                                    %>
                                    <%= inactivos %>
                                </h3>
                            </div>
                            <div class="bg-warning bg-opacity-10 p-3 rounded-3 text-warning fs-3">
                                <i class="bi bi-clock-history"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card metric-card bg-white text-dark shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small text-uppercase fw-bold">Clientes</span>
                                <h3 class="fw-bold m-0 mt-1 text-info">
                                    <%
                                        int clientes = 0;
                                        for (Usuario u : usuarios) {
                                            if (u.getIdPer() == 3) clientes++;
                                        }
                                    %>
                                    <%= clientes %>
                                </h3>
                            </div>
                            <div class="bg-info bg-opacity-10 p-3 rounded-3 text-info fs-3">
                                <i class="bi bi-person"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card table-card bg-white p-4">
                <div class="mb-4">
                    <h5 class="fw-bold text-dark">Directorio de Usuarios</h5>
                    <p class="text-muted small m-0">Lista completa de todos los usuarios registrados en el sistema.</p>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light text-secondary small text-uppercase">
                        <tr>
                            <th class="ps-3">Avatar</th>
                            <th>Nombre de Usuario</th>
                            <th>Correo Electrónico</th>
                            <th>Rol</th>
                            <th>Estado</th>
                            <th class="text-end pe-3">Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (usuarios.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-3 d-block mb-2 text-secondary"></i>
                                No hay usuarios registrados en el sistema.
                            </td>
                        </tr>
                        <% } else {
                            for (Usuario u : usuarios) {
                                String rolNombre = "Cliente";
                                if (u.getIdPer() == 1) rolNombre = "Administrador";
                                else if (u.getIdPer() == 2) rolNombre = "Empleado";

                                String estatusEstadoConexion = u.getIdEst() == 1 ? "Conectado" : "Inactivo";
                                String classeStatus = u.getIdEst() == 1 ? "status-online" : "status-offline";
                                String iconStatus = u.getIdEst() == 1 ? "bi-circle-fill" : "bi-x-circle-fill";
                        %>
                        <tr>
                            <td class="ps-3">
                                <% if (u.getAvatarUrl() != null && !u.getAvatarUrl().isEmpty()) { %>
                                    <img src="<%= u.getAvatarUrl() %>" alt="Avatar" class="avatar-img">
                                <% } else { %>
                                    <div class="avatar-placeholder">
                                        <%= u.getNombreUs().substring(0, 1).toUpperCase() %>
                                    </div>
                                <% } %>
                            </td>
                            <td class="fw-bold text-dark">
                                <i class="bi bi-person-circle me-2 text-secondary"></i><%= u.getNombreUs() %>
                            </td>
                            <td class="text-muted"><%= u.getCorreoUs() %></td>
                            <td>
                                <% if (u.getIdPer() == 1) { %>
                                    <span class="badge bg-danger"><i class="bi bi-shield-check me-1"></i> Administrador</span>
                                <% } else if (u.getIdPer() == 2) { %>
                                    <span class="badge bg-primary"><i class="bi bi-briefcase me-1"></i> Empleado</span>
                                <% } else { %>
                                    <span class="badge bg-secondary"><i class="bi bi-person me-1"></i> Cliente</span>
                                <% } %>
                            </td>
                            <td>
                                <span class="status-badge <%= classeStatus %>">
                                    <span class="status-indicator" style="background-color: currentColor;"></span>
                                    <%= estatusEstadoConexion %>
                                </span>
                            </td>
                            <td class="text-end pe-3">
                                <% if (esAdmin) { %>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-bold dropdown-toggle" type="button" id="dropdownAcciones<%= u.getIdUs() %>" data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="bi bi-gear"></i> Acciones
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownAcciones<%= u.getIdUs() %>">
                                            <li><a class="dropdown-item" href="#" onclick="abrirModalCambioRol(<%= u.getIdUs() %>, '<%= u.getNombreUs() %>', 1)"><i class="bi bi-shield-check me-2"></i> Administrador</a></li>
                                            <li><a class="dropdown-item" href="#" onclick="abrirModalCambioRol(<%= u.getIdUs() %>, '<%= u.getNombreUs() %>', 2)"><i class="bi bi-briefcase me-2"></i> Vendedor</a></li>
                                            <li><a class="dropdown-item" href="#" onclick="abrirModalCambioRol(<%= u.getIdUs() %>, '<%= u.getNombreUs() %>', 3)"><i class="bi bi-person me-2"></i> Cliente</a></li>
                                        </ul>
                                    </div>
                                <% } else { %>
                                    <button class="btn btn-sm btn-outline-secondary rounded-pill px-3 fw-bold disabled" disabled>
                                        <i class="bi bi-eye me-1"></i> Ver
                                    </button>
                                <% } %>
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

<!-- Modal para cambio de rol con verificación de contraseña -->
<div class="modal fade" id="modalCambioRol" tabindex="-1" aria-labelledby="modalCambioRolLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-danger text-white border-0">
                <h5 class="modal-title" id="modalCambioRolLabel">
                    <i class="bi bi-shield-check me-2"></i> Verificación de Seguridad
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="alert alert-warning d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                    <div>
                        <strong>Cambio de Rol</strong><br>
                        <small>Estás a punto de cambiar el rol de <strong id="userNameDisplay"></strong>.</small>
                    </div>
                </div>

                <form id="formCambioRol">
                    <input type="hidden" id="usuarioIdInput" name="usuarioId">
                    <input type="hidden" id="nuevoRolInput" name="nuevoRol">
                    <div class="mb-4">
                        <label for="passwordVerificacion" class="form-label fw-bold">
                            <i class="bi bi-lock-fill me-2"></i>Confirma tu contraseña
                        </label>
                        <div class="input-group">
                            <input type="password" class="form-control form-control-lg border-2" id="passwordVerificacion" placeholder="Ingresa tu contraseña" required onkeypress="if(event.key === 'Enter') confirmarCambioRol()">
                            <button class="btn btn-outline-secondary" type="button" onclick="togglePasswordVisibility()">
                                <i class="bi bi-eye" id="toggleIcon"></i>
                            </button>
                        </div>
                        <small class="form-text text-muted d-block mt-2">Por razones de seguridad, debes confirmar tu contraseña.</small>
                    </div>

                    <div id="mensajeExito" class="alert alert-success d-none align-items-center" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <div id="textoExito"></div>
                    </div>

                    <div id="mensajeError" class="alert alert-danger d-none align-items-center" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>
                        <div id="textoError"></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer bg-light border-top-0 p-3">
                <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-danger rounded-pill px-4 fw-bold" onclick="confirmarCambioRol()">
                    <i class="bi bi-check2-circle me-1"></i> Cambiar Rol
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Inicializar tooltips de Bootstrap
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Variables globales para el modal
    let modalCambioRol = new bootstrap.Modal(document.getElementById('modalCambioRol'), {
        keyboard: false
    });

    // Función para abrir el modal de cambio de rol
    function abrirModalCambioRol(usuarioId, nombreUsuario, nuevoRol) {
        document.getElementById('usuarioIdInput').value = usuarioId;
        document.getElementById('nuevoRolInput').value = nuevoRol;
        document.getElementById('userNameDisplay').textContent = nombreUsuario;
        document.getElementById('passwordVerificacion').value = '';
        document.getElementById('passwordVerificacion').type = 'password';
        document.getElementById('toggleIcon').classList.remove('bi-eye-slash');
        document.getElementById('toggleIcon').classList.add('bi-eye');
        limpiarMensajes();
        modalCambioRol.show();
        setTimeout(() => document.getElementById('passwordVerificacion').focus(), 300);
    }

    // Función para mostrar/ocultar contraseña
    function togglePasswordVisibility() {
        const input = document.getElementById('passwordVerificacion');
        const icon = document.getElementById('toggleIcon');

        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        }
    }

    // Función para confirmar el cambio de rol
    function confirmarCambioRol() {
        const usuarioId = document.getElementById('usuarioIdInput').value;
        const nuevoRol = document.getElementById('nuevoRolInput').value;
        const password = document.getElementById('passwordVerificacion').value;

        if (!password || password.trim() === '') {
            mostrarError('Por favor ingresa tu contraseña');
            return;
        }

        // Deshabilitar botón mientras se procesa
        const btnConfirmar = document.querySelector('button[onclick="confirmarCambioRol()"]');
        const btnCancelar = document.querySelector('.modal-footer .btn-secondary');
        btnConfirmar.disabled = true;
        btnCancelar.disabled = true;
        btnConfirmar.innerHTML = '<i class="bi bi-hourglass-split me-1"></i> Procesando...';

        // Enviar al servidor para verificar contraseña y cambiar rol
        fetch('<%= request.getContextPath() %>/cambiarRol', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'usuarioId=' + usuarioId + '&nuevoRol=' + nuevoRol + '&password=' + encodeURIComponent(password)
        })
        .then(response => response.json())
        .then(data => {
            btnConfirmar.disabled = false;
            btnCancelar.disabled = false;
            btnConfirmar.innerHTML = '<i class="bi bi-check2-circle me-1"></i> Cambiar Rol';

            if (data.success) {
                // Mostrar mensaje de éxito
                mostrarExito('¡Rol actualizado exitosamente!');
                // Actualizar la fila en la tabla sin recargar
                actualizarRolEnTabla(usuarioId, nuevoRol);
                // Cerrar modal después de 1.5 segundos
                setTimeout(() => {
                    modalCambioRol.hide();
                    limpiarMensajes();
                }, 1500);
            } else {
                mostrarError(data.message || 'Error al cambiar el rol. Verifica tu contraseña.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            btnConfirmar.disabled = false;
            btnCancelar.disabled = false;
            btnConfirmar.innerHTML = '<i class="bi bi-check2-circle me-1"></i> Cambiar Rol';
            mostrarError('Error de conexión. Por favor intenta de nuevo.');
        });
    }

    // Función para actualizar el rol en la tabla sin recargar
    function actualizarRolEnTabla(usuarioId, nuevoRol) {
        let rolTexto = 'Cliente';
        let rolClase = 'bg-secondary';
        let rolIcono = 'bi-person';

        if (nuevoRol == 1) {
            rolTexto = 'Administrador';
            rolClase = 'bg-danger';
            rolIcono = 'bi-shield-check';
        } else if (nuevoRol == 2) {
            rolTexto = 'Empleado';
            rolClase = 'bg-primary';
            rolIcono = 'bi-briefcase';
        }

        // Buscar todos los botones dropdown y encontrar el que corresponde a este usuario
        const botones = document.querySelectorAll('button[id^="dropdownAcciones"]');
        botones.forEach(boton => {
            if (boton.id === 'dropdownAcciones' + usuarioId) {
                // Encontramos el botón para este usuario, ahora buscamos su fila
                const fila = boton.closest('tr');
                if (fila) {
                    // Buscar la cuarta celda (columna de Rol)
                    const celdas = fila.querySelectorAll('td');
                    if (celdas.length >= 4) {
                        // La cuarta celda (índice 3) contiene el rol
                        celdas[3].innerHTML = '<span class="badge ' + rolClase + '"><i class="bi ' + rolIcono + ' me-1"></i> ' + rolTexto + '</span>';
                    }
                }
            }
        });
    }

    function mostrarError(mensaje) {
        const errorDiv = document.getElementById('mensajeError');
        const textoError = document.getElementById('textoError');
        textoError.textContent = mensaje;
        errorDiv.classList.remove('d-none');
        document.getElementById('mensajeExito').classList.add('d-none');
    }

    function mostrarExito(mensaje) {
        const exitoDiv = document.getElementById('mensajeExito');
        const textoExito = document.getElementById('textoExito');
        textoExito.textContent = mensaje;
        exitoDiv.classList.remove('d-none');
        document.getElementById('mensajeError').classList.add('d-none');
    }

    function limpiarMensajes() {
        document.getElementById('mensajeError').classList.add('d-none');
        document.getElementById('mensajeExito').classList.add('d-none');
    }

    // Permitir Enter en el campo de contraseña
    document.addEventListener('shown.bs.modal', function(e) {
        if (e.target.id === 'modalCambioRol') {
            const passwordInput = document.getElementById('passwordVerificacion');
            if (passwordInput) {
                passwordInput.focus();
            }
        }
    });

</script>
</body>
</html>

