
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

const form = document.getElementById('newsletter-fil');
form.addEventListener('submit', async (event) => {
  event.preventDefault();
  const formData = new FormData(form);
  const data = {
    email: formData.get('email'),
    attributes: {
      FIRSTNAME: formData.get('firstname'),
    },
  };
  try {
    const response = await fetch('https://api.brevo.com/v3/contacts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'api-key': '',
      },
      body: JSON.stringify(data),
    });
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    alert('Subscription successful!');
  } catch (error) {
    console.error('Error:', error);
    alert('There was an error with your subscription.');
  }
});
