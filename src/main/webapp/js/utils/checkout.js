(function () {
    var API = 'https://api.themoviedb.org/3';
    var KEY = 'e8351fedf872a5de8e6614d8f166a260';
    var IMG = 'https://image.tmdb.org/t/p/w500';
    var contextPath = '/' + window.location.pathname.split('/').filter(Boolean)[0];
    var FALLBACK = contextPath + '/img/fallback-poster.svg';
    var params = new URLSearchParams(window.location.search);
    var pending = null;
    var movieData = null;
    var moviePrice = null;

    try {
        pending = JSON.parse(localStorage.getItem('cinestore.pendingPurchase') || 'null');
    } catch (error) {
        pending = null;
    }

    var movieId = params.get('id') || (pending && pending.id) || localStorage.getItem('lastMovieId');
    if (!params.get('id') && movieId) {
        window.history.replaceState(null, '', 'compra.jsp?id=' + encodeURIComponent(movieId));
    }

    var form = document.getElementById('checkout-form');
    var movieSummary = document.getElementById('movie-summary');
    var checkoutMessage = document.getElementById('checkout-message');
    var checkoutSuccess = document.getElementById('checkout-success');
    var button = document.getElementById('btnConfirmarCompra');
    var preview = document.getElementById('cardBrandPreview');

    function setTheme(theme) {
        document.documentElement.setAttribute('data-bs-theme', theme);
        localStorage.setItem('theme', theme);
        var icon = document.querySelector('#theme-toggle i');
        if (icon) icon.className = theme === 'light' ? 'fas fa-moon' : 'fas fa-sun';
    }

    function initTheme() {
        setTheme(localStorage.getItem('theme') || document.documentElement.getAttribute('data-bs-theme') || 'dark');
        var toggle = document.getElementById('theme-toggle');
        if (toggle) {
            toggle.addEventListener('click', function () {
                setTheme(document.documentElement.getAttribute('data-bs-theme') === 'light' ? 'dark' : 'light');
            });
        }
    }

    function message(type, text) {
        checkoutMessage.innerHTML = '<div class="alert alert-' + type + '" role="alert">' + text + '</div>';
    }

    function typeCard(value) {
        var clean = value.replace(/\D/g, '');
        if (/^4/.test(clean)) return 'visa';
        if (/^5[1-5]/.test(clean) || /^2[2-7]/.test(clean)) return 'mastercard';
        if (/^3[47]/.test(clean)) return 'amex';
        if (/^6(?:011|5)/.test(clean)) return 'discover';
        return null;
    }

    function validateCard(value) {
        var clean = value.replace(/\D/g, '');
        if (clean.length < 13 || clean.length > 19) return false;
        var sum = 0;
        var doubleDigit = false;
        for (var i = clean.length - 1; i >= 0; i -= 1) {
            var digit = parseInt(clean.charAt(i), 10);
            if (doubleDigit) {
                digit *= 2;
                if (digit > 9) digit -= 9;
            }
            sum += digit;
            doubleDigit = !doubleDigit;
        }
        return sum % 10 === 0;
    }

    function validateExpiry(value) {
        if (!/^\d{2}\/\d{2}$/.test(value)) return false;
        var parts = value.split('/');
        var mm = Number(parts[0]);
        var yy = Number(parts[1]);
        if (mm < 1 || mm > 12) return false;
        return new Date(2000 + yy, mm) > new Date();
    }

    function renderMovie(movie, price) {
        var poster = movie.poster_path ? IMG + movie.poster_path : FALLBACK;
        var year = movie.release_date ? movie.release_date.split('-')[0] : 'N/D';
        var rating = typeof movie.vote_average === 'number' ? movie.vote_average.toFixed(1) : 'N/D';
        movieSummary.innerHTML =
            "<img class=\"checkout-poster mb-3\" src=\"" + poster + "\" alt=\"" + (movie.title || 'Pelicula') + "\" onerror=\"this.onerror=null;this.src='" + FALLBACK + "'\">" +
            '<h4 class="fw-bold mb-2">' + (movie.title || 'Pelicula') + '</h4>' +
            '<p class="text-muted small mb-3">' + year + ' &middot; Rating ' + rating + '</p>' +
            '<div class="d-flex justify-content-between align-items-center border-top border-secondary border-opacity-25 pt-3">' +
            '<span class="text-muted">Total</span><strong class="fs-4 text-warning">$' + price + '</strong></div>';
    }

    function loadMovie() {
        if (!movieId) {
            movieSummary.innerHTML = '<i class="bi bi-exclamation-circle fs-1 text-warning d-block mb-3"></i><h5 class="mb-2">Pelicula no encontrada</h5><p class="text-muted mb-0">Vuelve al catalogo y selecciona una pelicula.</p>';
            return;
        }

        fetch(API + '/movie/' + encodeURIComponent(movieId) + '?api_key=' + KEY + '&language=es-ES')
            .then(function (response) {
                if (!response.ok) throw new Error('No se pudo cargar');
                return response.json();
            })
            .then(function (movie) {
                movieData = movie;
                moviePrice = (9.99 + Math.min(8, Math.max(0, movie.vote_average || 0))).toFixed(2);
                renderMovie(movieData, moviePrice);
            })
            .catch(function () {
                if (pending && String(pending.id) === String(movieId)) {
                    movieData = {
                        id: pending.id,
                        title: pending.title || 'Pelicula',
                        poster_path: pending.posterPath || null,
                        release_date: pending.date ? pending.date + '-01-01' : '',
                        vote_average: typeof pending.rating === 'number' ? pending.rating : null
                    };
                    moviePrice = '12.99';
                    renderMovie(movieData, moviePrice);
                    return;
                }
                movieSummary.innerHTML = '<i class="bi bi-wifi-off fs-1 text-danger d-block mb-3"></i><h5 class="mb-2">No se pudo cargar la pelicula</h5><p class="text-muted mb-0">Intenta volver a abrir la compra desde el catalogo.</p>';
            });
    }

    function updateCardPreview(clean) {
        var type = typeCard(clean);
        var info = document.getElementById('cardTypeInfo');
        var valid = type ? validateCard(clean) : false;
        var labels = { visa: 'Visa', mastercard: 'Mastercard', amex: 'Amex', discover: 'Discover' };
        var icons = { visa: 'fab fa-cc-visa', mastercard: 'fab fa-cc-mastercard', amex: 'fab fa-cc-amex', discover: 'fab fa-cc-discover' };

        if (type) {
            info.textContent = valid ? 'Tarjeta ' + labels[type] + ' validada' : 'Detectada: ' + labels[type];
            info.className = valid ? 'text-success' : 'text-warning';
            preview.classList.add('is-detected');
            preview.classList.toggle('is-valid', valid);
            preview.querySelector('i').className = icons[type];
            preview.querySelector('.brand-label').textContent = labels[type];
            return;
        }

        info.textContent = 'Deteccion automatica';
        info.className = 'text-muted';
        preview.classList.remove('is-detected', 'is-valid');
        preview.querySelector('i').className = 'fa-regular fa-credit-card';
        preview.querySelector('.brand-label').textContent = 'Tarjeta';
    }

    document.getElementById('inputNumeroTarjeta').addEventListener('input', function (event) {
        var clean = event.target.value.replace(/\D/g, '');
        event.target.value = clean.replace(/(.{4})/g, '$1 ').trim();
        updateCardPreview(clean);
    });

    form.addEventListener('submit', function (event) {
        event.preventDefault();
        checkoutMessage.innerHTML = '';

        var titular = document.getElementById('inputTitular').value.trim();
        var numero = document.getElementById('inputNumeroTarjeta').value.replace(/\s/g, '');
        var vencimiento = document.getElementById('inputVencimiento').value.trim();
        var cvv = document.getElementById('inputCVV').value.trim();
        var aceptado = document.getElementById('checkTerminos').checked;
        var type = typeCard(numero);

        if (!movieData || !moviePrice) return message('warning', 'Todavia estamos cargando la pelicula. Intenta en unos segundos.');
        if (!titular) return message('warning', 'Ingresa el titular de la tarjeta.');
        if (!numero || !validateCard(numero)) return message('warning', 'Numero de tarjeta invalido.');
        if (!validateExpiry(vencimiento)) return message('warning', 'La fecha de vencimiento no es valida.');
        if (cvv.length < (type === 'amex' ? 4 : 3)) return message('warning', 'El CVV no es valido para esta tarjeta.');
        if (!aceptado) return message('warning', 'Debes aceptar los terminos y condiciones.');

        button.disabled = true;
        var original = button.innerHTML;
        button.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Procesando...';

        fetch(contextPath + '/procesarCompra', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'productoId=' + encodeURIComponent(movieId) +
                '&titularTarjeta=' + encodeURIComponent(titular) +
                '&numeroTarjeta=' + encodeURIComponent(numero) +
                '&total=' + encodeURIComponent(moviePrice) +
                '&productoNombre=' + encodeURIComponent(movieData.title || 'Pelicula')
        })
            .then(function (response) { return response.json(); })
            .then(function (data) {
                if (!data.success) {
                    message('danger', data.message || 'No se pudo completar la compra.');
                    return;
                }

                try {
                    var existing = JSON.parse(localStorage.getItem('cinestore.purchases') || '[]');
                    if (!existing.some(function (item) { return Number(item.id) === Number(movieData.id); })) {
                        existing.unshift({
                            id: movieData.id,
                            title: movieData.title || 'Pelicula',
                            posterPath: movieData.poster_path || null,
                            year: movieData.release_date ? movieData.release_date.split('-')[0] : 'N/D'
                        });
                        localStorage.setItem('cinestore.purchases', JSON.stringify(existing));
                    }
                } catch (error) {}

                message('success', 'Compra realizada correctamente. Te llevamos a Mi Contenido.');
                form.classList.add('d-none');
                checkoutSuccess.classList.remove('d-none');
                setTimeout(function () {
                    window.location.href = contextPath + '/pages/my_content.jsp?play=' + encodeURIComponent(movieData.id);
                }, 1200);
            })
            .catch(function () {
                message('danger', 'Error de conexion. Intenta de nuevo.');
            })
            .finally(function () {
                button.disabled = false;
                button.innerHTML = original;
            });
    });

    initTheme();
    loadMovie();
}());
