$('.radio-sort').click(function() {
  $( '#click-radio-sort' ).submit();
});
$('.radio-rating').click(function() {
  $( '#click-radio-sort' ).submit();
});
var getUrlParameter = function getUrlParameter(sParam) {
  var sPageURL = window.location.search.substring(1),
      sURLVariables = sPageURL.split('&'),
      sParameterName,
      i;

  for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split('=');

      if (sParameterName[0] === sParam) {
          return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
      }
  }
};
var sort = getUrlParameter('sort');
if (sort == 'sort_a_z') {
  document.getElementById('sort_a_z').checked = true;
}
if (sort == 'sort_z_a') {
  document.getElementById('sort_z_a').checked = true;
}
if (sort == 'sort_new') {
  document.getElementById('sort_new').checked = true;
}
if (sort == 'sort_price_a_z') {
  document.getElementById('sort_price_a_z').checked = true;
}
if (sort == 'sort_price_z_a') {
  document.getElementById('sort_price_z_a').checked = true;
}
var rating = getUrlParameter('rating');
if (rating == '4') {
  document.getElementById('rating-4').checked = true;
}
if (rating == '3') {
  document.getElementById('rating-3').checked = true;
}
if (rating == '2') {
  document.getElementById('rating-2').checked = true;
}
if (rating == '1') {
  document.getElementById('rating-1').checked = true;
}

function getVals(){
  // Get slider values
  var parent = this.parentNode;
  var slides = parent.getElementsByTagName("input");
  var slide1 = parseFloat( slides[0].value );
  var slide2 = parseFloat( slides[1].value );
  // Neither slider will clip the other, so make sure we determine which is larger
  if( slide1 > slide2 ){ var tmp = slide2; slide2 = slide1; slide1 = tmp; }
  
  var displayElement = parent.getElementsByClassName("rangeValues")[0];
  displayElement.innerHTML = "$ " + slide1 + "- $" + slide2;
}

window.onload = function(){
  // Initialize Sliders 
  var sliderSections = document.getElementsByClassName("range-slider");
  for( var x = 0; x < sliderSections.length; x++ ){
    var sliders = sliderSections[x].getElementsByTagName("input");
    for( var y = 0; y < sliders.length; y++ ){
      if( sliders[y].type ==="range" ){
        sliders[y].oninput = getVals;
        // Manually trigger event first time to display values
        sliders[y].oninput();
      }
    }
  }
}
$('#price_min').click(function() {
  $( '#click-radio-sort' ).submit();
});
$('#price_max').click(function() {
  $( '#click-radio-sort' ).submit();
});
