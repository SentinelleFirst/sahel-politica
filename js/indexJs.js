//require('dotenv').config();

//Langue manager

const languageButton = document.getElementById('languageButton');
const languageMenu = document.getElementById('languageMenu');

/* languageButton.addEventListener('click', () => {
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
*/

//const brevoApiKey = process.env.BREVO_API_KEY;
// Newsletter form
// Elements selection
const userName = document.querySelector('#newsletterFirstname');
const userEmail = document.querySelector('#newsletterEmail');
const submitter = document.querySelector('#registerButton');

// Validate the email and text fields
const textRegex = /^[a-zA-Z0-9]/;
const emailRegex = /^[a-zA-Z0-9_\-\.]+\@[a-zA-Z0-9_\.]+\.([a-zA-Z]{2,4})$/;

// Validate
function validate (userName, userEmail){
  if (!userName || !userEmail) {
    addError('Please enter a Name and Email !');
    return false;}
  if (textRegex.test(userName)) {
    addError('Please enter a valid username!');
    return false;}
  if (!emailRegex.test(userEmail)) {
    addError('Please enter a valid email address!');
    return false;}
}

function addError( text) {
  messageDisplay.innerHTML = text;
  messageDisplay.classList.add('error');

  setTimeout (() => {
    messageDisplay.innerHTML = '';
    messageDisplay.classList.remove('error');}
  ,3000)
  }

// Trigger
submitter.addEventListener('click', async (e) => {
  const FIRSTNAME = userName.value.trim().toLowerCase();
  const EMAIL = userEmail.value.trim().toLowerCase();

  //console.log(FIRSTNAME,EMAIL);
  //validate(FIRSTNAME, EMAIL);

  const data = {
    EMAIL: EMAIL,
    FIRSTNAME: FIRSTNAME,
  };

  try {
    const response = await fetch('https://api.brevo.com/v3/contacts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'api-key': "",
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


const firstNameError = document.getElementById('firstNameError');
const emailError = document.getElementById('emailError');

function validateForm() {
  let isValid = true;

  if (userName.value.trim() === '') {
    firstNameError.textContent = 'First name is required';
    isValid = false;
  } else {
    firstNameError.textContent = '';
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(userEmail.value)) {
    emailError.textContent = 'Please enter a valid email address';
    isValid = false;
  } else {
    emailError.textContent = '';
  }

  return isValid;
}

/*const form = document.getElementById('newsletter-fil');
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
        'api-key': 'brevoApiKey',
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
*/