function initializeCart(){
window.updateQuantity = function(itemId, change) {
  const form = document.getElementById(`quantity-form-${itemId}`);
  const quantityField = form.querySelector('.item_quantity');
  const quantityInput = form.querySelector('.item_quantity_input');
  let currentQuantity = parseInt(quantityField.textContent, 10);
  let newQuantity = currentQuantity + change;

  if (newQuantity <= 0) {
    newQuantity = 0;
  }

  quantityField.textContent = newQuantity;
  quantityInput.value = newQuantity;

  form.submit();
}
}


