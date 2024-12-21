document.addEventListener('DOMContentLoaded', function () {

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

        //Mise à jour des langue des éléments de la DB (events, articles, reports,)
        // Sélectionner tous les éléments de chaque langue
        var titlesFr = document.querySelectorAll('.langue-fr');
        var titlesEn = document.querySelectorAll('.langue-en');

        if (selectedValue === 'fr') {
            titlesFr.forEach(function (title) {
                title.style.display = 'block';
            });
            titlesEn.forEach(function (title) {
                title.style.display = 'none';
            });
        } else {
            titlesFr.forEach(function (title) {
                title.style.display = 'none';
            });
            titlesEn.forEach(function (title) {
                title.style.display = 'block';
            });
        }

        /**
         * Fait appel à ta fonction applyTranslations(lang) ici pour que le changement se fasse au moment
         * de la selection de la langue
         * */
        applyTranslations(selectedValue)

        // Enregistrer la valeur dans localStorage si ce n'est pas l'initialisation
        if (saveLanguage) {
            setLanguage('lang', selectedValue);
        }
    }

     // Appliquer les traductions aux éléments
    function applyTranslations(lang) {
        const elements = document.querySelectorAll("[data-translate-key]");

        elements.forEach((el) => {
            const key = el.getAttribute("data-translate-key");
           
        let translation = "";

        if (lang === 'en') {
            if (key.slice(0, 6) === "header" || key.slice(0, 6) === "footer") {
                translation = translateHeaderFooterEN[key];
            } else {
                translation = translationsEN[key];
            } 
        } else {
            if (key.slice(0, 6) === "header" || key.slice(0, 6) === "footer") {
                translation = translateHeaderFooterFR[key];
            } else {
                translation = translationsFR[key];
            } 
        }

            el.innerHTML = translation; // Remplacer le texte
        });
    }
    // Chargement des fichiers de langue json et traductions
    

    // Charger les traductions depuis un fichier JSON
    async function loadTranslations(lang) {
        if (!translations[lang]) {
            const response = await fetch(`translations/${lang}.json`);
            translations[lang] = await response.json();
        }
        applyTranslations(lang);
    }
    // Récupérer la valeur de la langue depuis localStorage si elle existe et l'appliquer
    var savedLang = getLanguage('lang');

    if (savedLang) {
        dropdown.value = savedLang;
    } else {
        // Définir la langue par défaut s'il n'y a pas de valeur stockée
        dropdown.value = 'en'; // Assurez-vous que cette valeur correspond à celle du `dropdown`
    }

    // Ajouter un écouteur d'événement pour détecter les changements de sélection
    dropdown.addEventListener('change', function () {
        updateTitle(true);  // Enregistrer dans localStorage lors du changement de langue
    });

    // Mettre à jour l'affichage initialement avec la valeur par défaut ou celle de localStorage
    updateTitle(false);  // Ne pas enregistrer dans localStorage lors de l'initialisation
    
});
