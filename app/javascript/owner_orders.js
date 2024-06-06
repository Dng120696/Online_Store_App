function intitializeOwnerOrders(){
  const orderContainers = document.querySelectorAll('[id^=order_container_]');

  orderContainers.forEach(container => {
    const orderId = container.id.split('_')[2];
    const profileForm = document.getElementById(`order_form_${orderId}`);
    const selectElement = profileForm.querySelector('select[name="order[status]"]');

    selectElement.addEventListener('change', function() {
      this.form.submit();
    });
  });
}