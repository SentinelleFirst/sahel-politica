document.addEventListener("DOMContentLoaded", function () {
    let carousel = document.querySelector(".carousel");
    let items = carousel.querySelectorAll(".item");
    let dotsContainer = document.querySelector(".dots");
    let currentIndex = 0;
    const intervalTime = 5000; // Time in milliseconds for each slide

    // Insert dots into the DOM
    items.forEach((_, index) => {
        let dot = document.createElement("span");
        dot.classList.add("dot");
        if (index === 0) dot.classList.add("active");
        dot.dataset.index = index;
        dotsContainer.appendChild(dot);
    });

    let dots = document.querySelectorAll(".dot");

    // Function to show a specific item
    function showItem(index) {
        items.forEach((item, idx) => {
            if (idx === index) {
                item.classList.add("active");
                dots[idx].classList.add("active");
            } else {
                item.classList.remove("active");
                dots[idx].classList.remove("active");
            }
        });
        currentIndex = index;
    }

    // Function to show the next item
    function showNextItem() {
        let nextIndex = (currentIndex + 1) % items.length;
        showItem(nextIndex);
    }

    // Event listeners for dots
    dots.forEach((dot) => {
        dot.addEventListener("click", () => {
            let index = parseInt(dot.dataset.index);
            showItem(index);
        });
    });

    // Automatically change slides at the set interval
    setInterval(showNextItem, intervalTime);
});

document.addEventListener('DOMContentLoaded', function () {
    const menuToggle = document.querySelector('.menu-toggle');
    const menuLink = document.querySelector('.menu-link');

    menuToggle.addEventListener('click', function () {
        menuLink.classList.toggle('active');
    });
});

//Send email for newsletter

const apiKey = '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';
const apiUrlContacts = 'https://api.brevo.com/v3/contacts';
const apiUrlEmail = 'https://api.brevo.com/v3/smtp/email';


document.getElementById('registerButton').addEventListener('click', async () => {
    const clientEmail = document.getElementById('newsletterEmail').value;
  
    if (!clientEmail) {
      alert('Please enter a valid email address.');
      return;
    }
  
    const emailSubscriberData = {
      'subject': 'Welcome to Sahel Politica Newsletter!',
      'sender': { 'name': 'Sahel Politica', 'email': 'info@sahelpolitica.ch' },
      'replyTo': { 'name': 'Sahel Politica', 'email': 'contact@sahelpolitica.com' },
      'to': [
        { 'name': 'Subscriber', 'email': clientEmail }
      ],
      'htmlContent': `
        <html>
        <body style="font-family: Arial, sans-serif; margin: 0; padding: 0;">
          <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
            <tr>
              <td align="center" bgcolor="#ffffff" style="padding: 20px 0 30px 0;">
                <img alt="" src="https://firebasestorage.googleapis.com/v0/b/sahelpolitica.appspot.com/o/logo.png?alt=media&token=e1d68437-e822-41a1-913d-15c04e513b77" alt="Logo" style="display: block; max-width: 150px; height: auto;" />
              </td>
            </tr>
            <tr>
              <td bgcolor="#ffffff" style="padding: 40px 30px 40px 30px;">
                <h1 style="color: #FACB01;">Welcome to Sahel Politica!</h1>
                <p >Dear Subscriber,</p>
                <p>We are thrilled to have you on board with our newsletter. At Sahel Politica, we strive to provide the best consulting services and insightful updates.</p>
                <p>Here’s what you can expect from our newsletters:</p>
                <ul>
                  <li>Updates on our latest projects and research.</li>
                  <li>Exclusive insights and analysis on current political events.</li>
                  <li>Invitations to our webinars and events.</li>
                </ul>
                <p>If you have any questions, feel free to reach out to us anytime.</p>
                <p>Thank you and welcome once again!</p>
                <p>Best regards,</p>
                <p>Sahel Politica Team</p>
              </td>
            </tr>
            <tr>
              <td bgcolor="#FACB01" style="padding: 30px 30px;">
                <p style="color: #000000; font-size: 12px;">&copy; 2024 Sahel Politica. All rights reserved.</p>
                <p style="color: #000000; font-size: 12px;">Contact: +41 778 12 40 73\nEmail: info@sahelpolitica.ch\nAddress: SAPAS Gmbh, Chamerstrasse 172, 6300 Zug</p>
                <p style="color: #000000; font-size: 12px;">You are receiving this email because you subscribed to our newsletter.</p>
              </td>
            </tr>
          </table>
        </body>
        </html>
      `,
      'params': { 'bodyMessage': 'We are thrilled to have you on board!' }
    };

    const emailAdminNotifData = {
        'subject': 'New Subscriber to the Newsletter!',
        'sender': { 'name': 'Sahel Politica', 'email': 'info@sahelpolitica.ch' },
        'replyTo': { 'name': 'Sahel Politica', 'email': 'contact@sahelpolitica.com' },
        'to': [
          { 'name': 'Subscriber', 'email': 'issaka.ouedraogo-iseli@sahelpolitica.ch' }
        ],
        'htmlContent': `
          <html>
          <body style="font-family: Arial, sans-serif; margin: 0; padding: 0;">
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
              <tr>
                <td align="center" bgcolor="#ffffff" style="padding: 20px 0 30px 0;">
                  <img alt="" src="https://firebasestorage.googleapis.com/v0/b/sahelpolitica.appspot.com/o/logo.png?alt=media&token=e1d68437-e822-41a1-913d-15c04e513b77" alt="Logo" style="display: block; max-width: 150px; height: auto;" />
                </td>
              </tr>
              <tr>
                <td bgcolor="#ffffff" style="padding: 40px 30px 40px 30px;">
                  <h1 style="color: #FACB01;">Welcome to Sahel Politica!</h1>
                  <p >Dear administrator,</p>
                  <p>You got a new subscriber to the newsletter.</p>
                  <p>${clientEmail}</p>
                </td>
              </tr>
              <tr>
                <td bgcolor="#FACB01" style="padding: 30px 30px;">
                  <p style="color: #000000; font-size: 12px;">&copy; 2024 Sahel Politica. All rights reserved.</p>
                  <p style="color: #000000; font-size: 12px;">Contact: +41 778 12 40 73\nEmail: info@sahelpolitica.ch\nAddress: SAPAS Gmbh, Chamerstrasse 172, 6300 Zug</p>
                  <p style="color: #000000; font-size: 12px;">You are receiving this email because you subscribed to our newsletter.</p>
                </td>
              </tr>
            </table>
          </body>
          </html>
        `,
        'params': { 'bodyMessage': 'New Subscriber to the Newsletter!' }
      };
  
    const headers = {
      'Content-Type': 'application/json',
      'api-key': apiKey,
    };
  
    try {
      const response = await fetch(apiUrlEmail, {
        method: 'POST',
        headers: headers,
        body: JSON.stringify(emailAdminNotifData)
      });
  
      if (response.status === 201) {
        console.log('Email sent successfully:', await response.json());
         // Vérifier les contacts existants
        const contacts = await getContacts();
        const emailExists = contacts.some(contact => contact.email === clientEmail);

        if (!emailExists) {
            // Ajouter le contact s'il n'existe pas
            await createContact(clientEmail);
            
        }const response2 = await fetch(apiUrlEmail, {
            method: 'POST',
            headers: headers,
            body: JSON.stringify(emailAdminNotifData)
          });
        
        document.getElementById('footerMailForm').innerHTML = `
          <div class="thank-you-message">
            <h5 class="langue-en">Thank you for subscribing to the Sahel Politica newsletter!\nWe have sent a welcome email to ${clientEmail}.</h5>
            <h5 class="langue-fr">Merci de vous être abonné à la newsletter Sahel Politica !\nNous avons envoyé un e-mail de bienvenue à ${clientEmail}.</h5>
          </div>
        `;
      } else {
        console.error('Error sending email:', response.status, await response.text());
      }
    } catch (error) {
      console.error('Exception while sending email:', error);
    }
  });
  
// Fonction pour obtenir les contacts
async function getContacts() {
    const headers = {
      'Content-Type': 'application/json',
      'api-key': apiKey
    };
  
    const params = new URLSearchParams({
      limit: 1000,
      offset: 0,
      modifiedSince: new Date('2021-09-07T19:20:30+01:00').toISOString(),
      listIds: 6
    });
  
    try {
      const response = await fetch(`${apiUrlContacts}?${params.toString()}`, {
        method: 'GET',
        headers: headers
      });
  
      if (response.ok) {
        const data = await response.json();
        return data.contacts; // Retourne la liste des contacts
      } else {
        console.error('Error fetching contacts:', response.status, await response.text());
        return [];
      }
    } catch (error) {
      console.error('Exception while fetching contacts:', error);
      return [];
    }
  }
  
  // Fonction pour ajouter un contact
  async function createContact(email) {
    const headers = {
      'Content-Type': 'application/json',
      'api-key': apiKey
    };
  
    const contactData = {
      email: email,
      listIds: [6]
    };
  
    try {
      const response = await fetch(apiUrlContacts, {
        method: 'POST',
        headers: headers,
        body: JSON.stringify(contactData)
      });
  
      if (response.ok) {
        const data = await response.json();
        console.log('Contact created successfully:', data);
      } else {
        console.error('Error creating contact:', response.status, await response.text());
      }
    } catch (error) {
      console.error('Exception while creating contact:', error);
    }
  }

//Envoie d'email pour la prise de contact
document.getElementById('contactButton').addEventListener('click', async () => {
  const clientName = document.getElementById('name').value;
  const clientCompany = document.getElementById('company').value;
  const clientEmail = document.getElementById('email').value;
  const clientPhone = document.getElementById('phone').value;
  const clientMessage = document.getElementById('message').value;

  if (!clientEmail) {
    alert('Please enter a valid email address.');
    return;
  }

  const emailContactData = {
    'subject': 'New contact message',
    'sender': { 'name': 'Sahel Politica', 'email': 'info@sahelpolitica.ch' },
    'replyTo': { 'name': 'Sahel Politica', 'email': 'contact@sahelpolitica.com' },
    'to': [
      { 'name': 'Contacts Form', 'email': 'saydilsidibe352@gmail.com' }
    ],
    'htmlContent': `
      <html>
      <body style="font-family: Arial, sans-serif; margin: 0; padding: 0;">
        <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
          <tr>
            <td align="center" bgcolor="#ffffff" style="padding: 20px 0 30px 0;">
              <img alt="" src="https://firebasestorage.googleapis.com/v0/b/sahelpolitica.appspot.com/o/logo.png?alt=media&token=e1d68437-e822-41a1-913d-15c04e513b77" alt="Logo" style="display: block; max-width: 150px; height: auto;" />
            </td>
          </tr>
          <tr>
            <td bgcolor="#ffffff" style="padding: 40px 30px 40px 30px;">
              <h1 style="color: #FACB01;">New message from the contact form</h1>
              <ul>
                <li>Name : ${clientName}.</li>
                <li>Company : ${clientCompany}.</li>
                <li>Email : ${clientEmail}.</li>
                <li>Phone Number : ${clientPhone}.</li>
                <li>Message : ${clientMessage}.</li>
              </ul>
              <p>Sahel Politica Web</p>
            </td>
          </tr>
          <tr>
            <td bgcolor="#FACB01" style="padding: 30px 30px;">
              <p style="color: #000000; font-size: 12px;">&copy; 2024 Sahel Politica. All rights reserved.</p>
              <p style="color: #000000; font-size: 12px;">Contact: +41 778 12 40 73\nEmail: info@sahelpolitica.ch\nAddress: SAPAS Gmbh, Chamerstrasse 172, 6300 Zug</p>
              <p style="color: #000000; font-size: 12px;">You are receiving this email because you subscribed to our newsletter.</p>
            </td>
          </tr>
        </table>
      </body>
      </html>
    `,
    'params': { 'bodyMessage': 'New contact message' }
  };

  const emailClientNotifData = {
      'subject': 'We got your message!',
      'sender': { 'name': 'Sahel Politica', 'email': 'info@sahelpolitica.ch' },
      'replyTo': { 'name': 'Sahel Politica', 'email': 'contact@sahelpolitica.com' },
      'to': [
        { 'name': clientName, 'email': clientEmail }
      ],
      'htmlContent': `
        <html>
        <body style="font-family: Arial, sans-serif; margin: 0; padding: 0;">
        <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
          <tr>
            <td align="center" bgcolor="#ffffff" style="padding: 20px 0 30px 0;">
              <img alt="" src="https://firebasestorage.googleapis.com/v0/b/sahelpolitica.appspot.com/o/logo.png?alt=media&token=e1d68437-e822-41a1-913d-15c04e513b77" alt="Logo" style="display: block; max-width: 150px; height: auto;" />
            </td>
          </tr>
          <tr>
            <td bgcolor="#ffffff" style="padding: 40px 30px 40px 30px;">
              <h1 style="color: #FACB01;">Thank you for getting in touch.</h1>
              <p>We have received your message and we will get back to you as soon as possible.</p>
              <p>If you still do not have a response, contact us directly with our email address: info@sahelpolitica.ch</p>
              <p>Sahel Politica Web</p>
            </td>
          </tr>
          <tr>
            <td bgcolor="#FACB01" style="padding: 30px 30px;">
              <p style="color: #000000; font-size: 12px;">&copy; 2024 Sahel Politica. All rights reserved.</p>
              <p style="color: #000000; font-size: 12px;">Contact: +41 778 12 40 73\nEmail: info@sahelpolitica.ch\nAddress: SAPAS Gmbh, Chamerstrasse 172, 6300 Zug</p>
              <p style="color: #000000; font-size: 12px;">You are receiving this email because you subscribed to our newsletter.</p>
            </td>
          </tr>
        </table>
      </body>
        </html>
      `,
      'params': { 'bodyMessage': 'New Subscriber to the Newsletter!' }
    };

  const headers = {
    'Content-Type': 'application/json',
    'api-key': apiKey,
  };

  try {
    const response = await fetch(apiUrlEmail, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(emailContactData)
    });

    if (response.status === 201) {
      console.log('Email sent successfully:', await response.json());
    } else {
      console.error('Error sending email:', response.status, await response.text());
    }
  } catch (error) {
    console.error('Exception while sending email:', error);
  }

  try {
    const response2 = await fetch(apiUrlEmail, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(emailClientNotifData)
    });
    console.log(await response2.json());

    if (response2.status === 201) {
      console.log('Email sent successfully:', await response2.json());
      
      
      document.getElementById('contactForm').innerHTML = `
        <div class="thank-you-message">
          <h5 class="langue-en">We have received your message and we will get back to you as soon as possible.</h5>
          <h5 class="langue-fr">Nous avons bien reçu votre message et nous vous répondrons dans les plus brefs délais.</h5>
        </div>
      `;
    } else {
      console.error('Error sending email:', response2.status, await response2.text());
    }
  } catch (error) {
    console.error('Exception while sending email:', error);
  }
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