document.addEventListener('DOMContentLoaded', function() {
    var cartIcon = document.getElementById('cart-icon');
    var cartModal = document.querySelector('#cart-modal');
    var closeModal = document.querySelector('#close-cart-modal');
  
    cartIcon.addEventListener('click', function() {
      cartModal.classList.remove('hidden');
    });
  
    closeModal.addEventListener('click', function() {
      cartModal.classList.add('hidden');
    });
  });
  