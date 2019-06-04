// function shopping(product_id){
//   $.ajax({
//     url: '/shopping',
//     type: 'POST',
//     cache: false,
//     data: {
//       product_aid : product_id
//     },
//     success: function(data){
//       $("#size-cart").text(data.size_cart);
//       alert(I18n.t("alert.success[ajax_shopping]"));
//     },
//     error: function(){
//       alert(I18n.t("alert.error[ajax_shopping]"));
//     }
//   });
// }
$('.shopping').on('click', function(){
  var product_id = $(this).attr("data_product_id")
  $.ajax({
    url: '/shopping',
    type: 'POST',
    cache: false,
    data: {
      product_aid : product_id
    },
    success: function(data){
      $("#size-cart").text(data.size_cart);
      alert(I18n.t("alert.success[ajax_shopping]"));
    },
    error: function(){
      alert(I18n.t("alert.error[ajax_shopping]"));
    }
  });
}); 
