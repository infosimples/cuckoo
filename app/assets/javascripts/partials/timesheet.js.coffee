jQuery ->
  $("#datepicker").datepicker
    onSelect: (dateText, inst) ->
      [month, day, year] = dateText.split('/')
      window.location = "/timesheet/#{year}/#{month}/#{day}"

  $(".icon-calendar").on 'click', ->
    $('#datepicker').toggle()
