//Gestion du menu
document.addEventListener('DOMContentLoaded', function () {
    const menuToggle = document.querySelector('.menu-toggle');
    const menuLink = document.querySelector('.menu-link');

    menuToggle.addEventListener('click', function () {
        menuLink.classList.toggle('active');
    });
});

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