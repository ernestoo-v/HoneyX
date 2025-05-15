document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('contactForm');
    if (form) {
      form.addEventListener('submit', function(e) {
        e.preventDefault();
        const data = new FormData(form);
        document.getElementById('formResult').innerText =
          `Gracias, ${data.get('name')}! Tu mensaje ha sido enviado.`;
        form.reset();
      });
    }
  });
  