function initializeOrder(){
  
  const viewCommentBtns = document.querySelectorAll('.view-comment-btn');
  const overlay = document.querySelector('.overlay');

  viewCommentBtns.forEach(btn => {
    btn.addEventListener('click', function() {
      const commentBox = this.nextElementSibling;
      commentBox.classList.toggle('hidden');
    });
  });


  const refund_modals = document.querySelectorAll('[id^=refund_modal_]');

  refund_modals.forEach(refund_modal => {
    const orderId = refund_modal.id.split('_')[2];
     const refund_order_container = document.getElementById(`refund_order_container_${orderId}`);
     const close_modal = document.getElementById(`close_refund_modal_${orderId}`);

      refund_modal.addEventListener('click', function(){
        refund_order_container.classList.remove('hidden')
        overlay.classList.remove('hidden')

     })
      close_modal.addEventListener('click', function(){
          refund_order_container.classList.add('hidden')
          overlay.classList.add('hidden')

      })
  });
  const rate_modals = document.querySelectorAll('[id^=rate_modal_]')

  rate_modals.forEach(rate_product => {
    const product_id = rate_product.id.split('_')[2];
    const rate_product_container = document.getElementById(`rate_product_container_${product_id}`);
    const close_rating_modal = document.getElementById(`close_rating_modal_${product_id}`);

    rate_product.addEventListener('click', function(){
      rate_product_container.classList.remove('hidden');
      overlay.classList.remove('hidden');
    });

    close_rating_modal.addEventListener('click', function(){
      rate_product_container.classList.add('hidden');
      overlay.classList.add('hidden');
    });
  });

   // Modal functionality
 const cancel_modals = document.querySelectorAll('[id^=cancel_modal_]')

  cancel_modals.forEach(cancel_modal => {
    const orderId = cancel_modal.id.split('_')[2];
    const confirm_cancel_container = document.getElementById(`confirm_cancel_container_${orderId}`);
    const close_order_modal = document.getElementById(`close_order_modal_${orderId}`);

    cancel_modal.addEventListener('click', function(){
      confirm_cancel_container.classList.remove('hidden');
      overlay.classList.remove('hidden');
    });

    close_order_modal.addEventListener('click', function(){
      confirm_cancel_container.classList.add('hidden');
      overlay.classList.add('hidden');
    });
  });

}