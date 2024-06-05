document.addEventListener('turbo:load', function() {
  const cartIcon = document.getElementById('cart-icon');
  const cartModal = document.getElementById('cart-modal');
  const closeModal = document.getElementById('close-cart-modal');
  const overlay = document.querySelector('.overlay');


  if (cartIcon) {
    cartIcon.addEventListener('click', function() {
      cartModal.classList.remove('hidden');
      overlay.classList.remove('hidden');
    });
  }

  if (closeModal) {
    closeModal.addEventListener('click', function() {
      cartModal.classList.add('hidden');
      overlay.classList.add('hidden');
    });
  }
});
