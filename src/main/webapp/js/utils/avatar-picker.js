(function () {
    const DEFAULT_AVATARS = [
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

    window.initAvatarPicker = function initAvatarPicker() {
        const avatarImage = document.getElementById('avatarImage');
        const avatarUrlInput = document.getElementById('avatarUrl');
        const optionsContainer = document.getElementById('avatarOptionsContainer');
        const togglePanelBtn = document.getElementById('toggleAvatarPanelBtn');
        const drawerPanel = document.getElementById('avatarDrawerPanel');

        if (!avatarImage || !avatarUrlInput || !optionsContainer || !togglePanelBtn || !drawerPanel) return;
        if (optionsContainer.dataset.avatarPickerReady === 'true') return;
        optionsContainer.dataset.avatarPickerReady = 'true';

        if (!avatarUrlInput.value) {
            avatarUrlInput.value = avatarImage.currentSrc || avatarImage.src;
        }

        const setButtonText = () => {
            togglePanelBtn.innerHTML = drawerPanel.classList.contains('hidden')
                ? '<i class="fas fa-images me-1"></i> Cambiar Avatar'
                : '<i class="fas fa-times me-1"></i> Ocultar catalogo';
        };

        togglePanelBtn.addEventListener('click', () => {
            drawerPanel.classList.toggle('hidden');
            setButtonText();
        });

        optionsContainer.innerHTML = '';
        DEFAULT_AVATARS.forEach((url, index) => {
            const option = document.createElement('button');
            option.type = 'button';
            option.className = 'avatar-option';
            if (url === avatarImage.getAttribute('src') || url === avatarUrlInput.value) {
                option.classList.add('active', 'is-selected');
            }

            const img = document.createElement('img');
            img.src = url;
            img.alt = `Avatar ${index + 1}`;
            option.appendChild(img);

            option.addEventListener('click', () => {
                optionsContainer
                    .querySelectorAll('.avatar-option')
                    .forEach(element => element.classList.remove('active', 'is-selected'));

                option.classList.add('active', 'is-selected');
                avatarImage.src = url;
                avatarUrlInput.value = url;
            });

            optionsContainer.appendChild(option);
        });

        setButtonText();
    };

    document.addEventListener('DOMContentLoaded', window.initAvatarPicker);
}());
