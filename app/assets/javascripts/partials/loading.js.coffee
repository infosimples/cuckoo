class @Loading

  @loading = $('#loading')
  @bar = $('#loading .bar')
  @loading_timeouts = []

  @show: ->
    @loading.show()
    @bar.width('20%')
    t = setTimeout((-> Loading.bar.width('40%')), 500)
    @loading_timeouts.push(t)
    t = setTimeout((-> Loading.bar.width('60%')), 1000)
    @loading_timeouts.push(t)

  @hide: ->
    $.each @loading_timeouts, (i, t) ->
      clearTimeout(t)
    @loading_timeouts = []
    @loading.hide()
    @bar.width('0%')