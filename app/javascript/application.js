// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"
import "./cart-modal.js"
import "./update_order_status.js"

function scrollBottom() {
  var messages = document.getElementById("chat-messages");
  console.log(messages)
  if (messages) {
    messages.scrollTop = messages.scrollHeight;

  }
}


document.addEventListener("turbo:load",function(){
  scrollBottom();
})
