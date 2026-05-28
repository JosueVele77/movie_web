<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="io.github.josuevele77.movie_web.model.Usuario" %>
<%
    Usuario userSession = (Usuario) session.getAttribute("usuarioLogueado");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineStore - Checkout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="../css/styles.css">
    <style>
        .checkout-card {
            background: rgba(20, 20, 24, 0.95);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            box-shadow: 0 18px 40px rgba(0,0,0,0.45);
        }

        .card-brand {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 10px;
            border-radius: 999px;
            border: 1px solid rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.65);
            transition: all 0.2s ease;
        }

        .card-brand.active {
            border-color: var(--accent-color);
            color: #fff;
            box-shadow: 0 0 0 2px rgba(241, 179, 78, 0.25);
        }

        .checkout-poster {
            width: 100%;
            border-radius: 12px;
            box-shadow: 0 12px 25px rgba(0,0,0,0.4);
        }

        .card-brand-preview {
            min-width: 150px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: rgba(255, 255, 255, 0.65);
            font-weight: 600;
        }

        .card-brand-preview i {
            font-size: 1.25rem;
        }

        .card-brand-preview.is-valid {
            border-color: var(--accent-color);
            color: #fff;
            box-shadow: 0 0 0 2px rgba(241, 179, 78, 0.25);
        }
    </style>
</head>
<body class="catalog-page">
<div id="stars-container"></div>
<div class="planet"></div>

<nav class="navbar navbar-expand-lg custom-navbar py-3 sticky-top">
    <div class="container-fluid px-4 px-lg-5">
        <a class="navbar-brand d-flex align-items-center gap-2" href="<%= request.getContextPath() %>/index.jsp">
            <img src="<%= request.getContextPath() %>/img/logo-cinestore.svg" alt="CineStore" style="width: 50px; height: 50px; object-fit: contain;">
        </a>
        <span class="navbar-text text-light ms-auto me-auto">Finalizar Compra</span>
        <ul class="navbar-nav ms-auto align-items-center">
            <li class="nav-item">
                <button class="btn btn-outline-light rounded-pill px-4" data-action="go-back" data-fallback="../index.jsp">
                    <i class="bi bi-arrow-left me-2"></i>Volver
                </button>
            </li>
        </ul>
    </div>
</nav>

<main class="container py-5">
    <div class="row g-4 align-items-start">
        <div class="col-lg-5">
            <div class="checkout-card p-4">
                <div id="movie-summary" class="text-center">
                    <div class="spinner-border text-warning" role="status"></div>
                    <p class="text-muted mt-3">Cargando datos de la película...</p>
                </div>
            </div>
        </div>
        <div class="col-lg-7">
            <div class="checkout-card p-4">
                <h3 class="fw-bold mb-4"><i class="bi bi-credit-card me-2"></i>Pago con tarjeta</h3>
                <div id="checkout-message"></div>
                <form id="checkout-form" novalidate>
                    <div class="mb-3">
                        <label class="form-label text-muted">Titular de la tarjeta</label>
                        <input type="text" class="form-control" id="inputTitular" placeholder="NOMBRE APELLIDO" maxlength="50" required>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <label class="form-label text-muted mb-0">Número de tarjeta</label>
                            <small id="cardTypeInfo" class="text-muted">Detección automática</small>
                        </div>
                        <div class="input-group mt-2">
                            <input type="text" class="form-control" id="inputNumeroTarjeta" placeholder="1234 5678 9012 3456" inputmode="numeric" required>
                            <span class="input-group-text card-brand-preview" id="cardBrandPreview">
                                <i class="fa-regular fa-credit-card"></i>
                                <span class="brand-label">Tarjeta</span>
                            </span>
                        </div>
                        <small class="text-muted d-block mt-2">No necesitas seleccionar, detectamos la tarjeta al escribir.</small>
                        <div class="d-flex flex-wrap gap-2 mt-3">
                            <span class="card-brand" data-brand="visa"><i class="fab fa-cc-visa"></i> Visa</span>
                            <span class="card-brand" data-brand="mastercard"><i class="fab fa-cc-mastercard"></i> Mastercard</span>
                            <span class="card-brand" data-brand="amex"><i class="fab fa-cc-amex"></i> Amex</span>
                            <span class="card-brand" data-brand="discover"><i class="fab fa-cc-discover"></i> Discover</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Vencimiento (MM/AA)</label>
                            <input type="text" class="form-control" id="inputVencimiento" placeholder="12/25" maxlength="5" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">CVV</label>
                            <input type="password" class="form-control" id="inputCVV" placeholder="123" maxlength="4" inputmode="numeric" required>
                        </div>
                    </div>
                    <div class="form-check mb-4">
                        <input class="form-check-input" type="checkbox" id="checkTerminos">
                        <label class="form-check-label text-muted" for="checkTerminos">
                            Acepto los <a href="#" class="text-info text-decoration-none">términos y condiciones</a> de compra
                        </label>
                    </div>
                    <button type="submit" class="btn btn-success rounded-pill px-5 fw-bold" id="btnConfirmarCompra">
                        <i class="bi bi-check-circle me-2"></i>Confirmar compra
                    </button>
                </form>
                <div id="checkout-success" class="d-none">
                    <div class="alert alert-success d-flex align-items-center" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <div>Compra realizada correctamente. Ya puedes verla en tu biblioteca.</div>
                    </div>
                    <a class="btn btn-primary rounded-pill px-4" href="<%= request.getContextPath() %>/pages/my_content.jsp">
                        Ir a Mi Contenido
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/script.js"></script>
<script>
    const API_KEY = 'e8351fedf872a5de8e6614d8f166a260';
    const BASE_URL = 'https://api.themoviedb.org/3';
    const IMG_URL_W500 = 'https://image.tmdb.org/t/p/w500';
    const FALLBACK_POSTER_URL = '<%= request.getContextPath() %>/img/fallback-poster.svg';

    const urlParams = new URLSearchParams(window.location.search);
    const movieId = urlParams.get('id');
    const movieSummary = document.getElementById('movie-summary');
    const checkoutMessage = document.getElementById('checkout-message');
    const checkoutForm = document.getElementById('checkout-form');
    const checkoutSuccess = document.getElementById('checkout-success');
    const btnConfirmarCompra = document.getElementById('btnConfirmarCompra');
    const cardBrandPreview = document.getElementById('cardBrandPreview');

    let movieData = null;
    let moviePrice = null;

    const brandConfig = {
        visa: { label: 'Visa', icon: 'fab fa-cc-visa' },
        mastercard: { label: 'Mastercard', icon: 'fab fa-cc-mastercard' },
        amex: { label: 'Amex', icon: 'fab fa-cc-amex' },
        discover: { label: 'Discover', icon: 'fab fa-cc-discover' }
    };

    function setMessage(type, message) {
        checkoutMessage.innerHTML = `
            <div class="alert alert-${type}" role="alert">
                ${message}
            </div>
        `;
    }

    function detectarTipoTarjeta(numero) {
        const clean = numero.replace(/\D/g, '');
        if (/^4/.test(clean)) return 'visa';
        if (/^5[1-5]/.test(clean) || /^2[2-7]/.test(clean)) return 'mastercard';
        if (/^3[47]/.test(clean)) return 'amex';
        if (/^6(?:011|5)/.test(clean)) return 'discover';
        return null;
    }

    function validarTarjeta(numero) {
        const clean = numero.replace(/\D/g, '');
        if (clean.length < 13 || clean.length > 19) return false;
        let suma = 0;
        let multiplicar = false;
        for (let i = clean.length - 1; i >= 0; i--) {
            let digito = parseInt(clean.charAt(i), 10);
            if (multiplicar) {
                digito *= 2;
                if (digito > 9) digito -= 9;
            }
            suma += digito;
            multiplicar = !multiplicar;
        }
        return suma % 10 === 0;
    }

    function validarVencimiento(valor) {
        if (!/^\d{2}\/\d{2}$/.test(valor)) return false;
        const [mm, yy] = valor.split('/').map(Number);
        if (mm < 1 || mm > 12) return false;
        const now = new Date();
        const expiry = new Date(2000 + yy, mm);
        return expiry > now;
    }

    function actualizarPreviewTarjeta(cardType, isValid) {
        if (!cardBrandPreview) return;
        const icon = cardBrandPreview.querySelector('i');
        const label = cardBrandPreview.querySelector('.brand-label');
        if (!cardType || !brandConfig[cardType]) {
            cardBrandPreview.classList.remove('is-valid');
            if (icon) icon.className = 'fa-regular fa-credit-card';
            if (label) label.textContent = 'Tarjeta';
            return;
        }
        const config = brandConfig[cardType];
        if (icon) icon.className = config.icon;
        if (label) label.textContent = config.label;
        cardBrandPreview.classList.toggle('is-valid', Boolean(isValid));
    }

    function guardarCompraLocal(movie) {
        if (!movie || !movie.id) return;
        const storageKey = 'cinestore.purchases';
        const entry = {
            id: movie.id,
            title: movie.title || 'Película',
            posterPath: movie.poster_path || null,
            year: movie.release_date ? movie.release_date.split('-')[0] : 'N/D'
        };
        try {
            const existing = JSON.parse(localStorage.getItem(storageKey) || '[]');
            const hasItem = existing.some(item => Number(item.id) === Number(entry.id));
            if (!hasItem) {
                existing.unshift(entry);
                localStorage.setItem(storageKey, JSON.stringify(existing));
            }
        } catch (error) {
            console.warn('No se pudo guardar la compra local:', error);
        }
    }

    document.getElementById('inputNumeroTarjeta').addEventListener('input', (event) => {
        const input = event.target;
        const clean = input.value.replace(/\D/g, '');
        input.value = clean.replace(/(.{4})/g, '$1 ').trim();

        const cardType = detectarTipoTarjeta(clean);
        const info = document.getElementById('cardTypeInfo');
        const badges = document.querySelectorAll('.card-brand');
        const isValid = cardType ? validarTarjeta(clean) : false;

        badges.forEach(badge => badge.classList.toggle('active', badge.dataset.brand === cardType));
        if (cardType) {
            const label = brandConfig[cardType]?.label || cardType.toUpperCase();
            info.textContent = isValid ? `Tarjeta ${label} validada` : `Detectada: ${label}`;
            info.className = isValid ? 'text-success' : 'text-warning';
        } else {
            info.textContent = 'Detección automática';
            info.className = 'text-muted';
        }
        actualizarPreviewTarjeta(cardType, isValid);
    });

    checkoutForm.addEventListener('submit', async (event) => {
        event.preventDefault();
        checkoutMessage.innerHTML = '';

        if (!movieData || !moviePrice) {
            setMessage('warning', 'Todavía estamos cargando la película. Intenta en unos segundos.');
            return;
        }

        const titular = document.getElementById('inputTitular').value.trim();
        const numeroTarjeta = document.getElementById('inputNumeroTarjeta').value.replace(/\s/g, '');
        const vencimiento = document.getElementById('inputVencimiento').value.trim();
        const cvv = document.getElementById('inputCVV').value.trim();
        const checkTerminos = document.getElementById('checkTerminos').checked;
        const cardType = detectarTipoTarjeta(numeroTarjeta);
        const cvvMin = cardType === 'amex' ? 4 : 3;

        if (!titular) {
            setMessage('warning', 'Ingresa el titular de la tarjeta.');
            return;
        }
        if (!numeroTarjeta || !validarTarjeta(numeroTarjeta)) {
            setMessage('warning', 'Número de tarjeta inválido.');
            return;
        }
        if (!validarVencimiento(vencimiento)) {
            setMessage('warning', 'La fecha de vencimiento no es válida.');
            return;
        }
        if (cvv.length < cvvMin) {
            setMessage('warning', 'El CVV no es válido para esta tarjeta.');
            return;
        }
        if (!checkTerminos) {
            setMessage('warning', 'Debes aceptar los términos y condiciones.');
            return;
        }

        btnConfirmarCompra.disabled = true;
        const originalText = btnConfirmarCompra.innerHTML;
        btnConfirmarCompra.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Procesando...';

        try {
            const response = await fetch('<%= request.getContextPath() %>/procesarCompra', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `productoId=${movieId}&titularTarjeta=${encodeURIComponent(titular)}&numeroTarjeta=${numeroTarjeta}&total=${moviePrice}&productoNombre=` + encodeURIComponent(movieData?.title || 'Película')
            });
            const data = await response.json();
            if (data.success) {
                guardarCompraLocal(movieData);
                setMessage('success', 'Compra realizada correctamente. Ya puedes verla en tu biblioteca.');
                checkoutForm.classList.add('d-none');
                checkoutSuccess.classList.remove('d-none');
            } else {
                setMessage('danger', data.message || 'No se pudo completar la compra.');
            }
        } catch (error) {
            console.error(error);
            setMessage('danger', 'Error de conexión. Intenta de nuevo.');
        } finally {
            btnConfirmarCompra.disabled = false;
            btnConfirmarCompra.innerHTML = originalText;
        }
    });

    cargarPelicula();
</script>
</body>
</html>
