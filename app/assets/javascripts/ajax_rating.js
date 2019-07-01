$('#rate').on('click', function () {
  var fdata = new FormData();
  fdata.append('product_id', $('.rateyo').attr('pid'));
  fdata.append('rating', $('.rateyo').rateYo('option', 'rating'));
  fdata.append('content', $('#content').val());
  $.ajax({
    url: '/rates',
    type: 'POST',
    cache: false,
    processData: false,
    contentType: false,
    data: fdata,
    success: function (data) {
      $('.box_total h3').text(data.overall);
      $('.box_total h6').text('(' + data.counter_reviews + ' Reviews)');
      $('.rateyo-readonly').attr('data', data.overall);
      $('.rateyo-readonly').rateYo('option', 'rating', data.overall);
      $('#content').val('');
      var commentDiv = $('.review_list');
      commentDiv.text('');
      for (var i = 0; i < data.reviews.length; i++) {
        commentDiv.append(data.reviews[i]);
      }
      $(".review_item").slice(0, 6).show();
    },
    error: function () {
      alert(I18n.t('alert.error[ajax_shopping]'));
    }
  });
});
