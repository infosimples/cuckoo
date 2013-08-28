jQuery ->
  $("#datepicker-start-date").datepicker
    onSelect: (dateText, inst) ->
      [month, day, year] = dateText.split('/')
      $("input[name='report[start_date]']").val("#{year}-#{month}-#{day}")
      $(this).toggle()

  $("#datepicker-end-date").datepicker
    onSelect: (dateText, inst) ->
      [month, day, year] = dateText.split('/')
      $("input[name='report[end_date]']").val("#{year}-#{month}-#{day}")
      $(this).toggle()

  $(".start-date").on 'click', ->
    $('#datepicker-end-date').hide()
    $('#datepicker-start-date').toggle()
    false

  $(".end-date").on 'click', ->
    $('#datepicker-start-date').hide()
    $('#datepicker-end-date').toggle()
    false