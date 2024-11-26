
//Langue manager

const languageButton = document.getElementById('languageButton');
    const languageMenu = document.getElementById('languageMenu');

    languageButton.addEventListener('click', () => {
      languageMenu.style.display = languageMenu.style.display === 'block' ? 'none' : 'block';
    });

    document.querySelectorAll('#languageMenu li').forEach(item => {
      item.addEventListener('click', () => {
        const lang = item.getAttribute('data-lang');
        document.querySelectorAll('.lang').forEach(el => {
          el.style.display = 'none';
        });
        document.querySelectorAll(`.lang.${lang}`).forEach(el => {
          el.style.display = 'block';
        });
        languageMenu.style.display = 'none';
      });
    });