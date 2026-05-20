// src/main/webapp/js/utils/avatar.js

export function initAvatarGenerator() {
    const avatarImage = document.getElementById('avatarImage');
    const avatarUrlInput = document.getElementById('avatarUrl');
    const optionsContainer = document.getElementById('avatarOptionsContainer');
    const togglePanelBtn = document.getElementById('toggleAvatarPanelBtn');
    const drawerPanel = document.getElementById('avatarDrawerPanel');

    if (!avatarImage || !optionsContainer || !togglePanelBtn || !drawerPanel) return;

    // Aquí centralizas todos los links de imágenes que quieras ofrecer
    const linksDeAvatares = [
        'https://images.avataranimals.com/animals/transparent/albatross.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/alligator.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/alpaca.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/anaconda.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/anteater.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/antelope.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/armadillo.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/baboon.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/badger.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/bear.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/beaver.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/bison.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/boar.webp?v=a60026c088dc0dee',
        'https://images.avataranimals.com/animals/transparent/buffalo.webp?v=a60026c088dc0dee'
    ];

    // 1. Manejar la apertura y cierre del apartado de opciones
    togglePanelBtn.addEventListener('click', () => {
        drawerPanel.classList.toggle('hidden');

        // Cambiar el texto del botón según el estado del panel
        if (drawerPanel.classList.contains('hidden')) {
            togglePanelBtn.innerHTML = '<i class="fas fa-images me-1"></i> Cambiar opción';
        } else {
            togglePanelBtn.innerHTML = '<i class="fas fa-times me-1"></i> Ocultar catálogo';
        }
    });

    // 2. Construir la cuadrícula interna del catálogo
    function renderAvatarGrid() {
        optionsContainer.innerHTML = '';

        linksDeAvatares.forEach((url, index) => {
            const optionDiv = document.createElement('div');
            optionDiv.classList.add('avatar-option');

            // Marcar visualmente cuál es la opción actualmente seleccionada en el círculo grande
            if (url === avatarImage.src) {
                optionDiv.classList.add('active');
            }

            const img = document.createElement('img');
            img.src = url;
            img.alt = `Opción ${index + 1}`;
            optionDiv.appendChild(img);

            // Evento al elegir un elemento del catálogo expandido
            optionDiv.addEventListener('click', () => {
                // Quitar la selección activa a todos los demás círculos pequeños
                document.querySelectorAll('.avatar-option').forEach(el => el.classList.remove('active'));

                // Activar el círculo cliqueado
                optionDiv.classList.add('active');

                // Actualizar la imagen de la vista previa principal y el valor del input para el backend
                avatarImage.src = url;
                avatarUrlInput.value = url;
            });

            optionsContainer.appendChild(optionDiv);
        });
    }

    // Inicializar la carga de elementos dentro de la caja oculta
    renderAvatarGrid();
}