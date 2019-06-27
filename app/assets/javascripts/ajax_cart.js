$('.shopping').on('click', function () {
  var product_id = $(this).attr('data_product_id');
  var qty = $(".qty").val();
  $.ajax({
    url: '/cart',
    type: 'POST',
    cache: false,
    data: {
      product_aid: product_id,
      qty: qty
    },
    success: function (data) {
      $('#size-cart').text(data.size_cart);
      alert(I18n.t("alert.success[ajax_shopping]"));
    },
    error: function () {
      alert(I18n.t("alert.error[ajax_shopping]"));
    }
  });
});

$('.changing').change(function () {
  var product_id = $(this).attr('data-product-id');
  var quantity = $(this).val();
  $.ajax({
    url: '/cart/0',
    type: 'PUT',
    cache: false,
    data: {
      product_aid: product_id,
      aquantity: quantity
    },
    success: function (data) {
      $('#subtotal').text('$' + data.subtotal.toFixed(2));
      $('#input-quantity-' + product_id).attr('value', data.total_quantity);
      $('#total-price-' + product_id).text('$' + (data.price_discounted * data.total_quantity).toFixed(2));
    },
    error: function () {
      alert(I18n.t("alert.error[ajax_shopping]"));
    }
  });
});
