import { initAvatarGenerator } from '../utils/avatar.js';
import { initPasswordToggle } from '../utils/password.js';

const PROVINCIAS_ECUADOR = {
    '01': 'Azuay',
    '02': 'Bolivar',
    '03': 'Canar',
    '04': 'Carchi',
    '05': 'Cotopaxi',
    '06': 'Chimborazo',
    '07': 'El Oro',
    '08': 'Esmeraldas',
    '09': 'Guayas',
    '10': 'Imbabura',
    '11': 'Loja',
    '12': 'Los Rios',
    '13': 'Manabi',
    '14': 'Morona Santiago',
    '15': 'Napo',
    '16': 'Pastaza',
    '17': 'Pichincha',
    '18': 'Tungurahua',
    '19': 'Zamora Chinchipe',
    '20': 'Galapagos',
    '21': 'Sucumbios',
    '22': 'Orellana',
    '23': 'Santo Domingo',
    '24': 'Santa Elena',
    '30': 'Extranjero'
};

function validarCedulaEcuatoriana(cedula) {
    if (!/^\d{10}$/.test(cedula)) return false;
    if (!PROVINCIAS_ECUADOR[cedula.substring(0, 2)]) return false;
    if (Number(cedula.charAt(2)) > 5) return false;

    const coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
    let suma = 0;

    for (let i = 0; i < coeficientes.length; i += 1) {
        let valor = Number(cedula.charAt(i)) * coeficientes[i];
        if (valor > 9) valor -= 9;
        suma += valor;
    }

    let digito = Math.ceil(suma / 10) * 10 - suma;
    if (digito === 10) digito = 0;
    return digito === Number(cedula.charAt(9));
}

document.addEventListener('DOMContentLoaded', () => {
    initAvatarGenerator();
    initPasswordToggle();

    const form = document.getElementById('profileForm');
    if (!form) return;

    const inputs = form.querySelectorAll('input[required]');
    const cedulaInput = document.getElementById('cedula');
    const provinciaBadge = document.getElementById('provinciaBadge');
    const cedulaFeedback = document.getElementById('cedulaFeedback');

    const setValidationClass = (input, isValid) => {
        input.classList.toggle('is-valid', isValid);
        input.classList.toggle('is-invalid', !isValid);
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

    if (cedulaInput) {
        cedulaInput.addEventListener('input', function () {
            this.value = this.value.replace(/\D/g, '');
            const isComplete = this.value.length === 10;
            const isValid = isComplete && validarCedulaEcuatoriana(this.value);

            setValidationClass(this, isValid);
            if (isValid) {
                provinciaBadge.textContent = PROVINCIAS_ECUADOR[this.value.substring(0, 2)];
                provinciaBadge.style.display = 'block';
            } else {
                provinciaBadge.style.display = 'none';
                cedulaFeedback.textContent = isComplete ? 'Cedula invalida.' : 'Debe tener 10 digitos.';
            }
        });
    }

    form.addEventListener('submit', (event) => {
        if (cedulaInput && !validarCedulaEcuatoriana(cedulaInput.value)) {
            setValidationClass(cedulaInput, false);
            event.preventDefault();
            event.stopPropagation();
        }
    });
});
