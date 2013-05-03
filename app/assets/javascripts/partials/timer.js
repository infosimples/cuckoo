function time_window(count_holder, callback){

  var time = 0;
  var mode = 1;
  var status = 0;
  var timer_interval; //  This is used by setInterval function
  var id = id;
  positions = count_holder.find('.position');

  this.reset = function(time_sec){

    time_sec = (typeof(time_sec) !== 'undefined') ? time_sec : 0;
    time = time_sec;
    generateTime(time);

  }

  // this will start the timer ex. start the timer with 1 second interval timer.start(1000)
  this.start = function(interval){

    interval = 1000;

    if (status == 0){
      status = 1;
      timer_interval = setInterval( function(){

        switch(mode){

          default:
          if(time){
            time--;
            generateTime();
            if (typeof(callback) === 'function') callback(time);
          }
          break;

          case 1:
          if(time < 86400){
            time++;
            generateTime();
            if(typeof(callback) === 'function') callback(time);
          }
          break;
        }
      }, interval);
    }
  }

  //  Same as the name, this will stop or pause the timer ex. timer.stop()
  this.stop =  function(){

    if(status == 1){
      status = 0;
      clearInterval(timer_interval);
    }
  }

  // This methode return the current value of the timer
  this.getTime = function(){
    return time;
  }

  this.getStatus = function(){
    return status;
  }

  // This methode will render the time variable to hour:minute:second format
  function generateTime(){

    var second = time % 60;
    var minute = Math.floor(time / 60) % 60;
    var hour = Math.floor(time / 3600) % 60;
    var day = Math.floor(time / 86400) % 60;

    second = (second < 10) ? '0'+second : second;
    minute = (minute < 10) ? '0'+minute : minute;
    hour = (hour < 10) ? '0'+hour : hour;

    updateDuo(0, 1, day);
    updateDuo(2, 3, hour);
    updateDuo(4, 5, minute);
    updateDuo(6, 7, second);

  }

  function updateDuo(minor,major,value){
      switchDigit(positions.eq(minor),Math.floor(value/10)%10);
      switchDigit(positions.eq(major),value%10);
    }
  // Creates an animated transition between the two numbers
  function switchDigit(position,number){

    var digit = position.find('.digit')

    if(digit.is(':animated')){
      return false;
    }

    if(position.data('digit') == number){
      // We are already showing this number
      return false;
    }

    position.data('digit', number);

    var replacement = $('<span>',{
      'class':'digit',
      css:{
        top:'-2.1em',
        opacity:0
      },
      html:number
    });

    // The .static class is added when the animation
    // completes. This makes it run smoother.
    digit
      .before(replacement)
      .removeClass('static')
      .animate({top:'2.5em',opacity:0},'fast',function(){
        digit.remove();
      })

    replacement
      .delay(100)
      .animate({top:0,opacity:1},'fast',function(){
        replacement.addClass('static');
      });
  }
}

$(document).ready(function(e){

  $.each($('div.stopped'), function(i) {
    var time_sec = $(this).attr("data-id");

    timer = new time_window( $(this) );
    timer.reset(time_sec);
    timer.stop();
  });

  $.each($('div.running'), function(i) {
    var time_sec = $(this).attr("data-id");

    timer = new time_window( $(this) );

    $(this).data('timer', timer);

    timer.reset(time_sec);

    timer.start();

  });

  $('.stop_button').click(function(){

    var clock = $(this).parent().siblings('.running');
    var timer = clock.data('timer');
    var time = timer.getTime();

    clock.removeClass('running').addClass('.stopped');

    clock.attr('data-id', time );

    timer.stop();

    $(this).addClass('none').siblings('.btn-inverse').removeClass('none');

  });

});