$(function() {
  if( $("body").hasClass('orders') && $("body").hasClass('new') ) {
    // Create a Stripe client
    var stripe = Stripe('pk_test_s37XBfVqAW9ZQKy0GVNNfsrI');
    var elements = stripe.elements();

    // Custom styling can be passed to options when creating an Element.
    var style = {
      base: {
        // Add your base input styles here. For example:
        fontSize: '16px',
        color: "#32325d",
      }
    };

    // Create an instance of the card Element.
    var card = elements.create('card', {style: style});

    // Add an instance of the card Element into the `card-element` <div>.
    card.mount('#card-element');

    // Handle real-time validation errors from the card Element.
    card.addEventListener('change', function(event) {
      var displayError = document.getElementById('card-errors');
      if (event.error) {
        displayError.textContent = event.error.message;
      } else {
        displayError.textContent = '';
      }
    });

    // Create a token or display an error when the form is submitted.
    var form = document.getElementById('new_order');
    var submitted = false;

    form.addEventListener('submit', function(event) {
      event.preventDefault();

      if (submitted === false) {
        submitted = true;
        $('#payment-button').prop('disabled', true);
        $('#payment-button').text('Validating...')
      } else {
        return;
      }

      stripe.createToken(card).then(function(result) {
        if (result.error) {
          // Inform the customer that there was an error.
          var errorElement = document.getElementById('card-errors');
          errorElement.textContent = result.error.message;
          submitted = false;
          $('#payment-button').prop('disabled', false);
          $('#payment-button').text('Submit Payment')
        } else {
          $('#payment-button').text('Processing...')
          // Send the token to your server.
          stripeTokenHandler(result.token);
        }
      });
    });

    function stripeTokenHandler(token) {
      // Insert the token ID into the form so it gets submitted to the server
      var form = document.getElementById('new_order');
      $('input#order_stripe_token').val(token.id);
      form.submit();
    }
  }
});
