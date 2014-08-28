jQuery ->
  if $("#user_is_admin").is ":checked"
    $("#admin-summary-email-subscription").show()
  else
    $("#admin-summary-email-subscription").hide()

  $("#user_is_admin").change ->
    $("#admin-summary-email-subscription").toggle()
    if !$(this).is ":checked"
      admin_email_checkbox = $("#admin-summary-email-subscription").find("input:checkbox:first")
      admin_email_checkbox.prop("checked", false)
