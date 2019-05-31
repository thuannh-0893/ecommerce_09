$('document').ready(function(){
  //lua chọn hoac bo lua chon cac checkbox class='checkbox'
  $('#checkAll').click(function () {
      $('.checkbox').not(this).prop('checked', this.checked);
  });
});

$('#schedule').on('click', function(){
  document.getElementById('product_in_schedule').innerHTML = '';
  var product_ids = [];
  var product_names = [];
  $('.checkbox').each(function() {
    if ($(this).is(':checked')) {
      product_ids.push($(this).val());
      product_names.push($(this).attr('name'))
    }
  });
  var ol = document.createElement('ol');
  product_names.forEach(element => {
    var li = document.createElement('li');
    li.append(element);
    ol.appendChild(li);
  });
  document.getElementById('product_in_schedule').append(ol);
  $('#product_ids').val(product_ids);

  $('#schedule_end_time').change(function () {
    document.getElementById('schedule_end_time').min = document.getElementById('schedule_start_time').value
  });
});
