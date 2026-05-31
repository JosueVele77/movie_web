<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%@ page import="io.github.josuevele77.movie_web.utils.CedulaValidator" %>
<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);

  Usuario userSession = (Usuario) session.getAttribute("usuarioLogueado");
  if (userSession == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  // Detectar provincia desde el backend de forma segura
  String provinciaInicial = "";
  if (userSession.getCedulaUs() != null && !userSession.getCedulaUs().trim().isEmpty()) {
    provinciaInicial = CedulaValidator.obtenerProvincia(userSession.getCedulaUs());
  }

  String defaultAvatarUrl = "https://images.avataranimals.com/animals/transparent/albatross.webp?v=a60026c088dc0dee";
  String avatarActual = userSession.getAvatarUrl() != null && !userSession.getAvatarUrl().trim().isEmpty()
          ? userSession.getAvatarUrl().trim()
          : defaultAvatarUrl;
%>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mi Perfil - CineStore</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/styles.css">
  <script>
    const savedProfileTheme = localStorage.getItem('theme');
    if (savedProfileTheme) {
      document.documentElement.setAttribute('data-bs-theme', savedProfileTheme);
    }
  </script>

  <style>
    .profile-card {
      background: rgba(31, 31, 31, 0.65);
      backdrop-filter: blur(12px);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 20px;
    }
    [data-bs-theme="light"] .profile-card {
      background: rgba(255, 255, 255, 0.85);
      border: 1px solid rgba(0, 0, 0, 0.08);
    }
    .provincia-badge {
      font-size: 0.75rem;
      color: var(--accent-color);
      position: absolute;
      right: 15px;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      font-weight: 600;
      background: var(--card-bg);
      padding: 2px 6px;
      border-radius: 4px;
    }
    .password-toggle { cursor: pointer; }
  </style>
</head>
<body class="catalog-page profile-page">

<div id="stars-container"></div>
<div class="planet"></div>

<jsp:include page="navbar.jsp" />

<main class="container px-4 px-lg-5 my-5" style="padding-top: 40px;">
  <div class="row justify-content-center">
    <div class="col-lg-10">

      <div class="d-flex align-items-center gap-3 mb-4">
        <a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-outline-secondary rounded-circle px-2 py-1">
          <i class="bi bi-arrow-left"></i>
        </a>
        <h2 class="fw-bold m-0 profile-title">Gestionar mi Cuenta</h2>
      </div>

      <% if (request.getParameter("success") != null) { %>
      <div class="alert alert-success alert-dismissible fade show rounded-3" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i> ¡Perfil actualizado con éxito en el servidor!
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
      <% } %>
      <% if ("cedula_invalida".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger rounded-3" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i> Error: La cédula ingresada no es matemáticamente válida en Ecuador.
      </div>
      <% } else if (request.getParameter("error") != null) { %>
      <div class="alert alert-danger rounded-3" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i> No se pudieron guardar los cambios. Inténtalo de nuevo.
      </div>
      <% } %>

      <div class="card profile-card p-4 p-md-5 shadow-lg">
        <form action="<%=request.getContextPath()%>/ActualizarPerfilServlet" method="POST" id="profileForm" novalidate>
          <div class="row g-5">

            <div class="col-md-4 text-center border-end border-secondary border-opacity-25">
              <p class="text-muted small mb-3 fw-bold text-uppercase">Avatar de Cuenta</p>

              <div class="avatar-main-container position-relative mb-3">
                <div class="avatar-main-preview shadow-lg">
                  <img src="<%= avatarActual %>" alt="Avatar" id="avatarImage">
                </div>
                <div class="avatar-checked-badge"><i class="fas fa-check"></i></div>
              </div>

              <button type="button" class="btn btn-sm btn-outline-warning rounded-pill px-3 fw-bold" id="toggleAvatarPanelBtn">
                <i class="fas fa-images me-1"></i> Cambiar Avatar
              </button>

              <div class="avatar-drawer mt-3 hidden" id="avatarDrawerPanel">
                <div class="avatar-grid-selection p-3" id="avatarOptionsContainer"></div>
              </div>

              <input type="hidden" name="avatarUrl" id="avatarUrl" value="<%= avatarActual %>">
            </div>

            <div class="col-md-8">
              <h5 class="fw-bold mb-4 text-warning"><i class="bi bi-person-lines-fill me-2"></i>Información Personal</h5>

              <div class="row g-3">
                <div class="col-md-6 position-relative">
                  <label class="form-label small text-muted fw-semibold">Nombre Completo</label>
                  <div class="input-group">
                    <span class="input-group-text bg-transparent"><i class="fas fa-user"></i></span>
                    <input type="text" class="form-control" id="nombre" name="nombre" value="<%= userSession.getNombreUs() %>" required>
                  </div>
                  <div class="invalid-feedback">El nombre no puede estar vacío.</div>
                </div>

                <div class="col-md-6 position-relative">
                  <label class="form-label small text-muted fw-semibold">Cédula de Identidad</label>
                  <div class="input-group">
                    <span class="input-group-text bg-transparent"><i class="fas fa-id-card"></i></span>
                    <input type="text" class="form-control pe-5" id="cedula" name="cedula" value="<%= userSession.getCedulaUs() != null ? userSession.getCedulaUs() : "" %>" maxlength="10" required>
                  </div>
                  <span class="provincia-badge" id="provinciaBadge" style="display: block;"><%= provinciaInicial %></span>
                  <div class="invalid-feedback" id="cedulaFeedback">Cédula ecuatoriana inválida.</div>
                </div>

                <div class="col-12 position-relative">
                  <label class="form-label small text-muted fw-semibold">Correo Electrónico</label>
                  <div class="input-group">
                    <span class="input-group-text bg-transparent"><i class="fas fa-envelope"></i></span>
                    <input type="email" class="form-control" id="correo" name="correo" value="<%= userSession.getCorreoUs() %>" required>
                  </div>
                  <div class="invalid-feedback">Ingresa un correo electrónico válido.</div>
                </div>

                <hr class="my-4 border-secondary opacity-25">
                <h5 class="fw-bold mb-2 text-warning"><i class="bi bi-shield-lock-fill me-2"></i>Seguridad</h5>

                <div class="col-md-12 position-relative mb-4">
                  <label class="form-label small text-muted fw-semibold">Contraseña Actual o Nueva</label>
                  <div class="input-group">
                    <span class="input-group-text bg-transparent"><i class="fas fa-lock"></i></span>
                    <input type="password" class="form-control" id="clave" name="clave" value="<%= userSession.getClaveUs() %>" minlength="6" required>
                    <span class="input-group-text password-toggle bg-transparent" id="togglePassword">
                                                <i class="fas fa-eye" id="eyeIcon"></i>
                                            </span>
                  </div>
                  <div class="invalid-feedback">La contraseña debe tener mínimo 6 caracteres.</div>
                </div>
              </div>

              <div class="d-flex justify-content-end gap-3">
                <button type="button" class="btn btn-outline-secondary rounded-pill px-4" onclick="location.href='my_content.jsp'">Cancelar</button>
                <button type="submit" class="btn btn-login rounded-pill px-4 fw-bold text-white">Guardar Cambios</button>
              </div>
            </div>

            <hr class="my-4 border-secondary opacity-25">
            <h5 class="fw-bold mb-3 text-warning">
              <i class="bi bi-bag-check-fill me-2"></i>Compras recientes
            </h5>

            <div class="list-group mb-4 shadow-sm">

              <div class="list-group-item bg-transparent border-secondary border-opacity-25 text-white d-flex justify-content-between align-items-center p-3">
                <div class="d-flex align-items-center gap-3">
                  <div class="bg-dark rounded p-2 border border-secondary border-opacity-50 shadow-sm">
                    <i class="fas fa-film text-info fs-4"></i>
                  </div>
                  <div>
                    <h6 class="mb-0 fw-semibold">Avengers: Endgame</h6>
                    <small class="text-muted">Fecha de compra: 18/05/2026</small>
                  </div>
                </div>
                <span class="badge bg-success rounded-pill px-3 py-2 border border-success border-opacity-50">$ 14.99</span>
              </div>

              <div class="list-group-item bg-transparent border-secondary border-opacity-25 text-white d-flex justify-content-between align-items-center p-3">
                <div class="d-flex align-items-center gap-3">
                  <div class="bg-dark rounded p-2 border border-secondary border-opacity-50 shadow-sm">
                    <i class="fas fa-film text-info fs-4"></i>
                  </div>
                  <div>
                    <h6 class="mb-0 fw-semibold">Spider-Man: No Way Home</h6>
                    <small class="text-muted">Fecha de compra: 12/05/2026</small>
                  </div>
                </div>
                <span class="badge bg-success rounded-pill px-3 py-2 border border-success border-opacity-50">$ 12.50</span>
              </div>

            </div>
            <div class="d-flex justify-content-end gap-3 mt-2">
              <button type="button" class="btn btn-outline-secondary rounded-pill px-4" onclick="location.href='my_content.jsp'">Cancelar</button>
              <button type="submit" class="btn btn-login rounded-pill px-4 fw-bold text-white">Guardar Cambios</button>
            </div>

          </div>
        </form>
      </div>

    </div>
  </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=request.getContextPath()%>/js/utils/avatar-picker.js"></script>
<script src="<%=request.getContextPath()%>/js/script.js"></script>
<script type="module" src="<%=request.getContextPath()%>/js/utils/profile.js"></script>
</body>
</html>
