function initializeProducts(){

  const profilePictureContainers = document.querySelectorAll('[id^=image_container_]');
  profilePictureContainers.forEach(container => {
    const productId = container.id.split('_')[2];
    const profileForm = document.getElementById(`image_form_${productId}`);
    container.addEventListener('click', function() {
      profileForm.querySelector('input[type=file]').click();
    });
  });
}