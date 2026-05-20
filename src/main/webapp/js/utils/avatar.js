// src/main/webapp/js/utils/avatar.js

export function initAvatarGenerator() {
    const avatarImage = document.getElementById('avatarImage');
    const avatarUrlInput = document.getElementById('avatarUrl');
    const optionsContainer = document.getElementById('avatarOptionsContainer');
    const refreshBtn = document.getElementById('refreshAvatarBtn');

    if (!avatarImage || !optionsContainer) return;

    // Colecciones estéticas variadas de la API de DiceBear para poblar la baraja
    const avatarStyles = ['bottts', 'avataaars', 'adventurer', 'lorelei', 'bottts-neutral'];

    function generateAvatarCollection() {
        optionsContainer.innerHTML = ''; // Limpiar las miniaturas previas

        for (let i = 0; i < 5; i++) {
            const randomSeed = Math.random().toString(36).substring(2, 9);
            const chosenStyle = avatarStyles[i % avatarStyles.length];

            // Endpoint de la API pública
            const url = `https://api.dicebear.com/9.x/${chosenStyle}/svg?seed=${randomSeed}&backgroundColor=transparent`;

            // Construir dinámicamente la miniatura circular
            const optionDiv = document.createElement('div');
            optionDiv.classList.add('avatar-option');

            // Dejar la tercera opción (índice 2) preseleccionada por defecto de entrada
            if (i === 2) {
                optionDiv.classList.add('active');
                avatarImage.src = url;
                if (avatarUrlInput) avatarUrlInput.value = url;
            }

            const img = document.createElement('img');
            img.src = url;
            img.alt = `Opción de avatar ${i + 1}`;

            optionDiv.appendChild(img);
            optionsContainer.appendChild(optionDiv);

            // Manejador de eventos al alternar clic entre las miniaturas de la lista
            optionDiv.addEventListener('click', () => {
                // Limpiar la clase activa de las demás opciones en la fila
                document.querySelectorAll('.avatar-option').forEach(element => {
                    element.classList.remove('active');
                });

                // Asignar el borde activo a la opción cliqueada
                optionDiv.classList.add('active');

                // Transición fluida actualizando el visor principal superior
                avatarImage.style.opacity = '0.3';
                setTimeout(() => {
                    avatarImage.src = url;
                    avatarImage.style.opacity = '1';
                }, 120);

                // Actualizar el valor que viajará al Servlet por POST
                if (avatarUrlInput) avatarUrlInput.value = url;
            });
        }
    }

    // Ejecutar carga inicial de la galería de avatares
    generateAvatarCollection();

    // Evento para re-barajar las opciones
    if (refreshBtn) {
        refreshBtn.addEventListener('click', generateAvatarCollection);
    }
}