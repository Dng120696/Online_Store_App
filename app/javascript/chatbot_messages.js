
function initializeChatBotMessage(){
  let select = document.getElementById('channel_select');
      let submitButtonTrigger = document.getElementById('submit_button_trigger');

      select.addEventListener('change', function() {
        submitButtonTrigger.click();
      });

      submitButtonTrigger.addEventListener('click', function() {
        let form = document.getElementById('channel_form');
        form.submit();
      });
}
