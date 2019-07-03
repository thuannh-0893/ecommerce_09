
$(document).ready(function () {
  jQuery('body').on('click', '.message', function () {
    var id = $(this).attr('data_id');
    var url = '/notifications/' + id;
    var redirect_url = $(this).attr('data_href');
    $.ajax({
      url: url,
      type: 'PATCH',
      cache: false,
      success: function (data) {
        window.location.replace(redirect_url);
      },
      error: function () {
        alert(I18n.t('alert.error[notification]'));
      }
    });
  });
});
