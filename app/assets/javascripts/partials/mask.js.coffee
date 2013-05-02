

jQuery ->
  $.mask.definitions['m'] = "[0-5]";
  $.mask.definitions['h'] = "[0-2]";
  $("input.time").mask("h9:m9");