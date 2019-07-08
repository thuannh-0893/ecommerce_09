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
      $('.box_total h6').text('(' + I18n.t('products.review.reviews', { count: data.counter_reviews }) + ')');
      $('.rateyo-readonly').attr('data', data.overall);
      $('.rateyo-readonly').rateYo('option', 'rating', data.overall);
      $('#content').val('');
      var reviewDiv = $('.review_list');
      reviewDiv.text('');
      for (var i = 0; i < data.reviews.length; i++) {
        reviewDiv.append(data.reviews[i]);
      }
      loadReviews();
    },
    error: function () {
      alert(I18n.t('alert.error[ajax_shopping]'));
    }
  });
});

jQuery('body').on('click', '.delete_review_btn', function () {
  if (confirm(I18n.t('products.review.confirm'))) {
    var fdata = new FormData();
    fdata.append('product_id', $(this).attr('pid'));
    fdata.append('review_id', $(this).attr('data_id'));
    $.ajax({
      url: '/rates/' + $(this).attr('data_id'),
      type: 'DELETE',
      cache: false,
      processData: false,
      contentType: false,
      data: fdata,
      success: function (data) {
        $('.box_total h3').text(data.overall);
        $('.box_total h6').text('(' + I18n.t('products.review.reviews', { count: data.counter_reviews }) + ')');
        $('.rateyo-readonly').attr('data', data.overall);
        $('.rateyo-readonly').rateYo('option', 'rating', data.overall);
        $('#content').val('');
        var reviewDiv = $('.review_list');
        reviewDiv.text('');
        for (var i = 0; i < data.reviews.length; i++) {
          reviewDiv.append(data.reviews[i]);
        }
        loadReviews();
      },
      error: function () {
        alert(I18n.t('alert.error[ajax_shopping]'));
      }
    });
  }
});
