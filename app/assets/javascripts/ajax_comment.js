$('#btn-comment').on('click', function () {
  var fdata = new FormData();
  fdata.append('product_id', $('#comment').attr('pid'));
  fdata.append('parent_id', $('#comment').attr('parent_id'));
  fdata.append('comment', $('#comment').val());
  $.ajax({
    url: '/comments',
    type: 'POST',
    cache: false,
    processData: false,
    contentType: false,
    data: fdata,
    success: function (data) {
      $('#comment').val('');
      var commentDiv = $('.comment_list');
      commentDiv.text('');
      for (var i = 0; i < data.comments.length; i++) {
        commentDiv.append(data.comments[i]);
      }
      loadComment();
      loadReplies();
    },
    error: function () {
      alert(I18n.t('alert.error[ajax_shopping]'));
    }
  });
});

jQuery('body').on('click', '.reply_btn', function () {
  var parent_id = $(this).attr('parent_id');
  var user = $(this).attr('user');
  $('#comment').attr('parent_id', parent_id);
  var newline = String.fromCharCode(13, 10);
  $('#comment').val(I18n.t('products.comment.reply') + ' @' + user + ':' + newline);
});
