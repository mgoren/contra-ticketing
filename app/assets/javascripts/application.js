// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

var pricePerTshirt = 15;

$(function() {
  $('.total').toggleClass('hidden');

  $('#cost-per-admission').bind('change click', function() {
    normalizeInput($(this));
    var pricePer = parseInt($(this).val());
    if (isNaN(pricePer) || pricePer > 25) {
      $(this).val("25");
    } else if (pricePer < 10) {
      $(this).val("10");
    }
    updateTotal();
  });
  $('#admission-quantity, #tshirt-quantity').bind('change click', function() {
    normalizeInput($(this));
    var quantity = parseInt($(this).val());
    if (isNaN(quantity) || quantity < 0) {
      $(this).val("0");
    }
    updateTotal();
  });
});

var normalizeInput = function(selector) {
  selector.val(selector.val().split('.')[0]);
}

var updateTotal = function() {
  var pricePer = parseInt($('#cost-per-admission').val());
  var quantity = parseInt($('#admission-quantity').val());
  var quantityTshirts = parseInt($('#tshirt-quantity').val());
  var total = pricePer * quantity + pricePerTshirt * quantityTshirts;
  $('#total').text(total);

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
