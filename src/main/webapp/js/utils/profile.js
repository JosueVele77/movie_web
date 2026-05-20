import { initAvatarGenerator } from '../utils/avatar.js';
import { initPasswordToggle } from '../utils/password.js';
import { validarCedulaEcuatoriana, provinciasEcuador } from '../validators/cedula.js';

document.addEventListener('DOMContentLoaded', () => {
    initAvatarGenerator();
    initPasswordToggle();

    const form = document.getElementById('profileForm');
    const inputs = form.querySelectorAll('input[required]');
    const cedulaInput = document.getElementById('cedula');
    const provinciaBadge = document.getElementById('provinciaBadge');
    const cedulaFeedback = document.getElementById('cedulaFeedback');

    const setValidationClass = (input, isValid) => {
        if (isValid) {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
        } else {
            input.classList.remove('is-valid');
            input.classList.add('is-invalid');
        }
    };

    inputs.forEach(input => {
        input.addEventListener('input', () => {
            if (input.id === 'cedula') return;
            if (input.type === 'email') {
                setValidationClass(input, /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input.value));
            } else if (input.id === 'clave') {
                setValidationClass(input, input.value.length >= 6);
            } else {
                setValidationClass(input, input.value.trim().length > 0);
            }
        });
    });

    cedulaInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
        if (this.value.length === 10) {
            const esValida = validarCedulaEcuatoriana(this.value);
            setValidationClass(this, esValida);
            if (esValida) {
                provinciaBadge.textContent = provinciasEcuador[this.value.substring(0, 2)];
                provinciaBadge.style.display = 'block';
            } else {
                provinciaBadge.style.display = 'none';
                cedulaFeedback.textContent = "Cédula inválida.";
            }
        } else {
            this.classList.remove('is-valid');
            this.classList.add('is-invalid');
            cedulaFeedback.textContent = "Debe tener 10 dígitos.";
            provinciaBadge.style.display = 'none';
        }
    });

    form.addEventListener('submit', (e) => {
        let valid = true;
        if (!validarCedulaEcuatoriana(cedulaInput.value)) {
            setValidationClass(cedulaInput, false);
            valid = false;
        }
        if (!valid) {
            e.preventDefault();
            e.stopPropagation();
        }
    });
});