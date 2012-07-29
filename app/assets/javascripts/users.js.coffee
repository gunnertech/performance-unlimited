# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.draw_graph = ->
  $(".graph").each( ->
    if user_id = $(this).data('user_id') && $(this).width()
      $el = $(this)
      $.ajax("/users/#{$(this).data('user_id')}/completed_surveys.json?day_range=#{$(this).data('day_range')}")
      .done((objects, status, jqxhr) ->
        data = []
        $.each(objects, (i,item) -> data.push([new Date(item.date), item.score]) )
        $.plot(
          $el, 
          [{ data: data, label: "" }] 
          series:
            lines:
              show: true
            points:
              show: true
          legend:
            show: false
          yaxis:
            tickDecimals: 0
          xaxis:
            mode: "time"
            timeformat: "%m/%d/%y"
            minTickSize: [1, "day"] 
        )
      )
  )

$( ->
  draw_graph()
)