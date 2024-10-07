document.addEventListener('DOMContentLoaded', function() {

    var dropdown = document.getElementById('desktopLangDropdown');
    if (!dropdown) {
        return;
    }

    // Fonction pour obtenir la valeur de la langue depuis localStorage
    function getLanguage(name) {
        const value = localStorage.getItem(name);
        if (value === null) {
            return null;
        }
        return value; // Pas besoin de décoder car localStorage stocke des chaînes de caractères
    }

    // Fonction pour définir la langue dans localStorage
    function setLanguage(name, value) {
        localStorage.setItem(name, value);
    }

    // Fonction pour afficher le titre correspondant à la langue choisie
    function updateTitle(saveLanguage = true) {
        var selectedValue = dropdown.value;

        // Sélectionner tous les éléments de chaque langue
        var titlesFr = document.querySelectorAll('.langue-fr');
        var titlesEn = document.querySelectorAll('.langue-en');

        if (selectedValue === 'fr') {
            titlesFr.forEach(function(title) {
                title.style.display = 'block';
            });
            titlesEn.forEach(function(title) {
                title.style.display = 'none';
            });
        } else {
            titlesFr.forEach(function(title) {
                title.style.display = 'none';
            });
            titlesEn.forEach(function(title) {
                title.style.display = 'block';
            });
        }

        // Enregistrer la valeur dans localStorage si ce n'est pas l'initialisation
        if (saveLanguage) {
            setLanguage('lang', selectedValue);
        }
    }

    // Ajouter un écouteur d'événement pour détecter les changements de sélection
    dropdown.addEventListener('change', function() {
        updateTitle(true);  // Enregistrer dans localStorage lors du changement de langue
    });

    // Récupérer la valeur de la langue depuis localStorage si elle existe et l'appliquer
    var savedLang = getLanguage('lang');

    if (savedLang) {
        dropdown.value = savedLang;
    } else {
        // Définir la langue par défaut s'il n'y a pas de valeur stockée
        dropdown.value = 'en'; // Assurez-vous que cette valeur correspond à celle du `dropdown`
    }

    // Mettre à jour l'affichage initialement avec la valeur par défaut ou celle de localStorage
    updateTitle(false);  // Ne pas enregistrer dans localStorage lors de l'initialisation
});
