
function initializeProductEvents() {
  const all_products = document.querySelector('.all_products');
    if (!all_products) return;

    // Remove any existing event listeners
    const new_all_products = all_products.cloneNode(true);
    all_products.parentNode.replaceChild(new_all_products, all_products);

    new_all_products.addEventListener('click', function(e) {
      const target = e.target;
      if (!target) return;

      // Find the closest product container
      const productContainer = target.closest('.product');
      if (!productContainer) return;

      // Find the elements needed within the product container
      const productQuantityElement = productContainer.querySelector('.product_quantity');
      const productQuantityInput = productContainer.querySelector('.product_item');

      let currentQuantity = parseInt(productQuantityElement.textContent);

      // Handle increment
      if (target.classList.contains('btn_increment_product')) {
        currentQuantity += 1;
      }

      // Handle decrement
      if (target.classList.contains('btn_decrement_product')) {
        currentQuantity = Math.max(1, currentQuantity - 1);
      }

      productQuantityElement.textContent = currentQuantity;
      productQuantityInput.value = currentQuantity;
    });

    // Modal functionality
    const viewDetailsButtons = document.querySelectorAll('.view-details');
    const overlay = document.querySelector('.overlay');

    viewDetailsButtons.forEach(button => {
      button.addEventListener('click', function() {
        const productId = button.getAttribute('data-product-id');
        const modal = document.getElementById(`product_modal_${productId}`);
        modal.classList.remove('hidden');
        overlay.classList.remove('hidden');
      });
    });

    const closeModalButtons = document.querySelectorAll('.close-modal');

    closeModalButtons.forEach(button => {
      button.addEventListener('click', function() {
        const productId = button.getAttribute('data-product-id');
        const modal = document.getElementById(`product_modal_${productId}`);
        modal.classList.add('hidden');
        overlay.classList.add('hidden');
      });
    });

    overlay.addEventListener('click', function() {
      document.querySelectorAll('.fixed[id^="product_modal_"]').forEach(modal => {
        modal.classList.add('hidden');
      });
      overlay.classList.add('hidden');
    });
}
