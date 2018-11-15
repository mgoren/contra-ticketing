var pricePerTshirt = 15;

$(function() {
  $('#admission-cost').bind('change click', function() {
    normalizeInput($(this));
    var pricePer = parseInt($(this).val());
    if (isNaN(pricePer) || pricePer > 25) {
      $(this).val("25");
    } else if (pricePer < 10) {
      $(this).val("10");
    }
    updateTotal();
  });

  $('#admission-quantity').bind('change click', function() {
    normalizeInput($(this));
    var quantity = parseInt($(this).val());
    if (isNaN(quantity) || quantity < 0) {
      $(this).val("0");
    }
    updateTotal();
  });

  $('#tshirt-quantity').bind('change click', function() {
    normalizeInput($(this));
    var quantity = parseInt($(this).val());
    if (isNaN(quantity) || quantity <= 0) {
      $(this).val("0");
      $('#tshirt-note').addClass('d-none');
    } else {
      $('#tshirt-note').removeClass('d-none');
    }
    updateTotal();
  });
});

var normalizeInput = function(selector) {
  selector.val(selector.val().split('.')[0]);
}

var updateTotal = function() {
  var pricePer = parseInt($('#admission-cost').val());
  var quantity = parseInt($('#admission-quantity').val());
  var quantityTshirts = parseInt($('#tshirt-quantity').val());
  var total = pricePer * quantity + pricePerTshirt * quantityTshirts;

  $('#total-price').text(total);
  $('#total-as-displayed').val(total);

  if (quantity > 0) {
    $('#total-admissions').text("Admissions: " + quantity + " at $" + pricePer + " each");
  } else {
    $('#total-admissions').text("");
  }
  if (quantityTshirts > 0) {
    $('#total-tshirts').text("T-shirts: " + quantityTshirts + " at $" + pricePerTshirt + " each");
  } else {
    $('#total-tshirts').text("");
  }
}

window.onload=window.onpageshow= function() {
    updateTotal();
};
