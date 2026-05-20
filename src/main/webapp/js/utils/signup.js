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

function getProvincia(cedula) {
    if (!cedula || cedula.length < 2) return '';
    return PROVINCIAS_ECUADOR[cedula.substring(0, 2)] || 'Desconocida';
}

function esCedulaValida(cedula) {
    if (!cedula || !/^\d{10}$/.test(cedula)) return false;

    const provincia = cedula.substring(0, 2);
    if (!PROVINCIAS_ECUADOR[provincia]) return false;

    const tercerDigito = Number(cedula.charAt(2));
    if (tercerDigito < 0 || tercerDigito > 5) return false;

    const coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
    let suma = 0;

    for (let i = 0; i < 9; i += 1) {
        let valor = Number(cedula.charAt(i)) * coeficientes[i];
        if (valor > 9) valor -= 9;
        suma += valor;
    }

    const digitoVerificador = Number(cedula.charAt(9));
    const decenaSuperior = Math.ceil(suma / 10) * 10;
    let digitoCalculado = decenaSuperior - suma;

    if (digitoCalculado === 10) digitoCalculado = 0;

    return digitoCalculado === digitoVerificador;
}

function setFieldState(input, isValid) {
    const group = input.closest('.input-group');
    if (!group) return;
    group.classList.toggle('field-valid', isValid);
    group.classList.toggle('field-invalid', !isValid);
}

function clearFieldState(input) {
    const group = input.closest('.input-group');
    if (!group) return;
    group.classList.remove('field-valid', 'field-invalid');
}

export function initSignupValidation() {
    const form = document.getElementById('signup-form');
    if (!form) return;

    const nameInput = document.getElementById('signupName');
    const cedulaInput = document.getElementById('signupCedula');
    const provinciaLabel = document.getElementById('cedulaProvince');
    const emailInput = document.getElementById('signupEmail');
    const estadoSelect = document.getElementById('estado_civil');
    const passwordInput = document.getElementById('signupPassword');

    const updateName = () => {
        if (!nameInput) return;
        const value = nameInput.value.trim();
        if (!value) {
            clearFieldState(nameInput);
            return;
        }
        setFieldState(nameInput, value.length >= 3);
    };

    const updateEmail = () => {
        if (!emailInput) return;
        const value = emailInput.value.trim();
        if (!value) {
            clearFieldState(emailInput);
            return;
        }
        setFieldState(emailInput, emailInput.checkValidity());
    };

    const updatePassword = () => {
        if (!passwordInput) return;
        const value = passwordInput.value.trim();
        if (!value) {
            clearFieldState(passwordInput);
            return;
        }
        setFieldState(passwordInput, value.length >= 6);
    };

    const updateEstado = () => {
        if (!estadoSelect) return;
        if (!estadoSelect.value) {
            clearFieldState(estadoSelect);
            return;
        }
        setFieldState(estadoSelect, true);
    };

    const updateCedula = () => {
        if (!cedulaInput) return;
        let value = cedulaInput.value.replace(/\D/g, '');
        if (cedulaInput.value !== value) {
            cedulaInput.value = value;
        }

        if (!value) {
            clearFieldState(cedulaInput);
            cedulaInput.setCustomValidity('');
            if (provinciaLabel) provinciaLabel.textContent = 'Provincia';
            return;
        }

        const provincia = getProvincia(value);
        if (provinciaLabel) {
            provinciaLabel.textContent = provincia;
        }

        const valida = esCedulaValida(value);
        setFieldState(cedulaInput, valida);
        cedulaInput.setCustomValidity(valida ? '' : 'Cedula invalida');
    };

    if (nameInput) {
        nameInput.addEventListener('input', updateName);
        nameInput.addEventListener('blur', updateName);
    }

    if (emailInput) {
        emailInput.addEventListener('input', updateEmail);
        emailInput.addEventListener('blur', updateEmail);
    }

    if (passwordInput) {
        passwordInput.addEventListener('input', updatePassword);
        passwordInput.addEventListener('blur', updatePassword);
    }

    if (estadoSelect) {
        estadoSelect.addEventListener('change', updateEstado);
    }

    if (cedulaInput) {
        cedulaInput.addEventListener('input', updateCedula);
        cedulaInput.addEventListener('blur', updateCedula);
    }

    form.addEventListener('submit', (event) => {
        updateName();
        updateEmail();
        updatePassword();
        updateEstado();
        updateCedula();

        if (!form.checkValidity()) {
            event.preventDefault();
        }
    });
}

