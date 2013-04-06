jQuery ->

  # Tooltips (also working with ajax and dynamically created tooltips)
  $('[rel=tooltip]').livequery(
    # Newly matched elements
    () ->
      $(this).tooltip()
    # Newly unmatched elements
    () -> # Do nothing
  )


  # Activate popovers
  $('[rel=popover]').livequery(
    # Newly matched elements
    () ->
      $(this).popover()
    # Newly unmatched elements
    () -> # Do nothing
  )


  # Close popovers when click in a close button
  $('.popover .close').livequery(
    # Newly matched elements
    () ->
      $(this).click ->
        $('[rel=popover]').popover('hide') # hide all popovers
    # Newly unmatched elements
    () -> # Do nothing
  )


  # Close popovers when click outside
  $('[rel=popover], .popover').livequery(
    # Newly matched elements
    () ->
      $(this).click (e) ->

        # close the opened popovers
        this_index = $(this).data('index')
        $.each $('[rel=popover]'), (i, element) ->
          if $(element).data('index') != this_index
            $(element).popover('hide')

        # helps closing current popover
        e.stopPropagation()
    # Newly unmatched elements
    () -> # Do nothing
  )


  # Close popovers when click outside
  $('html').click ->
    $('[rel=popover]').popover('hide')


  # Modals with tabs
  $('a[data-modal-tab]').click ->
    selector = $(this).attr('href')
    tab_to_open = $(this).data('modal-tab')
    $("a[href='##{tab_to_open}']").click()
