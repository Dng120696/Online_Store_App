document.addEventListener('turbo:load', function() {
  var cartIcon = document.getElementById('cart-icon');
  var cartModal = document.querySelector('#cart-modal');
  var closeModal = document.querySelector('#close-cart-modal');

  if (cartIcon) {
    cartIcon.addEventListener('click', function() {
      cartModal.classList.remove('hidden');
    });
  }

  if (closeModal) {
    closeModal.addEventListener('click', function() {
      cartModal.classList.add('hidden');
    });
  }
});
