jQuery ->
  if $("#user_is_admin").is ":checked"
    $("#subscription_to_admin").show()
  else
    $("#subscription_to_admin").hide()

  $("#user_is_admin").change -> $("#subscription_to_admin").toggle()
