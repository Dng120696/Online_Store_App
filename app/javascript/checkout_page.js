function initializCheckout() {
  const addressSelect = document.getElementById('address-select');
  const newAddressForm = document.getElementById('new-address-form');

  addressSelect.addEventListener('change', function() {
    if (addressSelect.value === 'new') {
      newAddressForm.classList.remove('hidden');
    } else {
      newAddressForm.classList.add('hidden');
    }
  });
}