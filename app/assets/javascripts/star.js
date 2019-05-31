$(function () {
  var rating = $('.rateyo-readonly').attr('data');
  if (rating == '') rating = 0

  $('.rateyo-readonly').rateYo({
    rating: rating,
    readOnly: true
  });

  $('.rateyo').rateYo({
    rating: 0,
    fullStar: true
  });
});

$(function loadReviews() {
  $('.review_item').slice(0, 6).show();
  if ($('.review_item:hidden').length == 0) {
    $('#loadMore').fadeOut('slow');
  }
  $('#loadMore').on('click', function (e) {
    e.preventDefault();
    $('.review_item:hidden').slice(0, 6).slideDown();
    if ($('.review_item:hidden').length == 0) {
      $('#loadMore').fadeOut('slow');
    }
    $('html,body').animate({
      scrollTop: $(this).offset().top
    }, 1500);
  });
});

$(function loadComment() {
  $('.comment_item').slice(0, 6).show();
  if ($('.comment_item:hidden').length == 0) {
    $('#loadMoreComment').fadeOut('slow');
  }
  $('#loadMoreComment').on('click', function (e) {
    e.preventDefault();
    $('.comment_item:hidden').slice(0, 6).slideDown();
    if ($('.comment_item:hidden').length == 0) {
      $('#loadMoreComment').fadeOut('slow');
    }
    $('html,body').animate({
      scrollTop: $(this).offset().top
    }, 1500);
  });
});

$(function loadReplies() {
  var data = 0;
  $('.reply_comment_item').each(function () {
    if ($(this).attr('data') != data) {
      $(this).slideDown();
      data = $(this).attr('data');
    }
  });
  $('.loadMoreReplyComment').on('click', function (e) {
    var self = $(this)
    e.preventDefault();
    $('.reply_comment_item').each(function () {
      if ($(this).attr('data') == self.attr('data')) {
        $(this).slideDown();
        self.fadeOut('slow');
      }
    });
    $('html,body').animate({
      scrollTop: $(this).offset().top
    }, 1500);
  });
});

$(function () {
  var url = $(location).attr('href');
  $('.fb-share-button').attr('data-href', url)
});

$(function () {
  $('div.alert-notice').addClass('alert-success');
  $('div.alert-alert').addClass('alert-danger');
});

$(function () {
  $(".notifications .messages").hide();
  $(".notifications").click(function () {
    if ($(this).children(".messages").children().length > 0) {
      $(this).children(".messages").fadeToggle(300);
    }
  });
});
