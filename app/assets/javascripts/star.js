$(function () {
  var rating = $(".rateyo-readonly").attr("data");
  if (rating == '') rating = 0

  $(".rateyo-readonly").rateYo({
    rating: rating,
    readOnly: true
  });

  $(".rateyo").rateYo({
    rating: 0,
    fullStar: true
  });
});

$(function () {
  $(".review_item").slice(0, 6).show();
  $("#loadMore").on('click', function (e) {
    e.preventDefault();
    $(".review_item:hidden").slice(0, 6).slideDown();
    if ($(".review_item:hidden").length == 0) {
      $("#load").fadeOut('slow');
      $("#loadMore a").css("cursor", "not-allowed");
    }
    $('html,body').animate({
      scrollTop: $(this).offset().top
    }, 1500);
  });
});
