document.addEventListener('turbo:load', function() {
  document.querySelector('#order_status').addEventListener('change', function(e) {
    fetch(this.form.action, {
      method: 'PATCH',
      body: new FormData(this.form)
    })
    .then(res => {
      if (res.ok) {
       
        const noticeElement = document.querySelector('.notice');

        noticeElement.textContent = 'Order Status updated successfully';
        noticeElement.style.opacity = 1;
        noticeElement.style.transition = 'opacity 600ms';

        setTimeout(() => {
          noticeElement.style.opacity = 0; 
          noticeElement.style.transition = 'opacity 600ms';
        }, 3000);
      } else {
        const alert = document.querySelector('.alert')

        notice.textContent = 'Order Status not succesfully updated '
        console.error('Error updating order status:', res.statusText);
      }
    });
  });

})