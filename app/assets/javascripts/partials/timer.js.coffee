class TimeWindow

  time            = 0
  mode            = 1
  status          = 0
  timer_interval  = undefined

  constructor: (count_holder) ->
    @positions = count_holder.find('.position')

  switchDigit: (position, number) ->
    digit       = undefined
    replacement = undefined

    digit = position.find(".digit")

    return false if digit.is(":animated")
    return false if position.data("digit") is number

    position.data "digit", number

    replacement = $("<span>",
      class: "digit"
      css:
        top: "-2.1em"
        opacity: 0
      html: number
    )

    digit.before(replacement).removeClass("static").animate
      top: "2.5em"
      opacity: 0
    , "fast", ->
      digit.remove()

    replacement.delay(100).animate
      top: 0
      opacity: 1
    , "fast", ->
      replacement.addClass "static"

  updateDuo: (minor, major, value) ->
    @switchDigit @positions.eq(minor), Math.floor(value / 10) % 10
    @switchDigit @positions.eq(major), value % 10

  start: ->
    interval = 1000

    if status is 0
      status = 1
      timer_interval = setInterval( =>
        switch mode
          when 1
            if time < 86400
              time++
              @generateTime()
      , interval)

  generateTime: ->
    second  = time % 60
    minute  = Math.floor(time / 60) % 60
    hour    = Math.floor(time / 3600) % 60
    day     = Math.floor(time / 86400) % 60
    second  = (if (second < 10) then "0" + second else second)
    minute  = (if (minute < 10) then "0" + minute else minute)
    hour    = (if (hour < 10) then "0" + hour else hour)

    #@updateDuo 0, 1, day
    @updateDuo 0, 1, hour
    @updateDuo 2, 3, minute
    #@updateDuo 6, 7, second

  reset: (time_sec) ->

    time_sec = (if (typeof (time_sec) isnt "undefined") then time_sec else 0)
    time     = time_sec
    @generateTime time

  stop: ->
    if status is 1
      status = 0
      clearInterval timer_interval

  getTime: ->
    time

  getStatus: ->
    status

$(document).ready (e) ->
  $.each $("div.stopped"), (i) ->
    time_sec  = $(this).attr("data-duration")
    timer     = new TimeWindow($(this))

    timer.reset time_sec
    timer.stop()

  $.each $("div.running"), (i) ->
    time_sec  = $(this).attr("data-duration")
    timer     = new TimeWindow($(this))

    $(this).data "timer", timer

    timer.reset(time_sec)
    timer.start()

  $(document).on 'click', "a.stop-button", ->
    clock = $(this).parents(".timer-button").siblings(".running")
    timer = clock.data("timer")
    if $.isEmptyObject timer
      timer = new TimeWindow($(this).parents('tr').children('div.count-holder'))
    time  = timer.getTime()

    clock.removeClass("running").addClass "stopped"
    clock.attr "data-id", time
    timer.stop()
    $(this).addClass("none").siblings(".btn-inverse").removeClass "none"