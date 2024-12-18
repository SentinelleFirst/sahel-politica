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
        

        // Enregistrer la valeur dans localStorage si ce n'est pas l'initialisation
        if (saveLanguage) {
            setLanguage('lang', selectedValue);
        }
    }

    /**
     * Tu peux mettre toute ta fonction applyTranslations(lang) ici pour qu'il soit include dans le DOM
     * et qu'il soit exécuté après avoir sélectionné la langue
     */
     // Appliquer les traductions aux éléments
    //Cette fonction doit setrouver dans le document.addEventListener si non il ne sera pas lu
    function applyTranslations(lang) {
        const elements = document.querySelectorAll("[data-translate-key]");
        elements.forEach((el) => {
            const key = el.getAttribute("data-translate-key");
            const keys = key.split('.'); // Exemple : "header.home"
            let translation = translations[lang];

            // Parcourir les niveaux d'objet dans le JSON
            keys.forEach((k) => {
                if (translation[k]) translation = translation[k];
            });

            if (translation) {
                el.textContent = translation; // Remplacer le texte
            }
        });
    }
    // Chargement des fichiers de langue json et traductions
    const translations = {};

    // Charger les traductions depuis un fichier JSON
    async function loadTranslations(lang) {
        if (!translations[lang]) {
            const response = await fetch(`translations/${lang}.json`);
            translations[lang] = await response.json();
        }
        applyTranslations(lang);
    }
    //loadTranslations('en');
    //Traduction avec Deepl
    async function translateWithDeepL(text, targetLang) {
        const apiKey = "60eacb02-4951-40ca-9758-949c06c021e8:fx";
        const url = `https://api-free.deepl.com/v2/translate`;
        const params = new URLSearchParams();
        params.append("auth_key", apiKey);
        params.append("text", text);
        params.append("target_lang", targetLang.toUpperCase());
      
        const response = await fetch(url, {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: params,
        });
        const data = await response.json();
        return data.translations[0].text;
      }
      
      async function translateDynamicContent(targetLang) {
        const elements = document.querySelectorAll("[data-translate='true']");
        for (const el of elements) {
          const translatedText = await translateWithDeepL(el.textContent, targetLang);
          el.textContent = translatedText;
        }
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

// Chargement des fichiers de langue json et traductions
const translations = {};

// Charger les traductions depuis un fichier JSON
async function loadTranslations(lang) {
    if (!translations[lang]) {
        const response = await fetch(`translations/${lang}.json`);
        translations[lang] = await response.json();
    }
    applyTranslations(lang);
}

// Changer la langue
//Inutile de mettre ce document.addEventListener puisque y'en a déjà un en haut, celui ne sera pas compilé
/*
document.addEventListener('DOMContentLoaded', () => {
    const langDropdown = document.getElementById('mobilLangDropdown');

    langDropdown.addEventListener('change', () => {
        const selectedLanguage = langDropdown.value;
        loadTranslations(selectedLanguage);
    });
});
*/
// Charger la langue par défaut
loadTranslations('en');