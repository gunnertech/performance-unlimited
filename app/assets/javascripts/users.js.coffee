# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.draw_graphs = ->
  $(".graph").each( ->
    $el = $(this)
    if $(this).width() && $(this).data('day_range')
      url = "/completed_surveys.json?day_range=#{$(this).data('day_range')}"
      if $(this).data('user_id')
        url = "/users/#{$(this).data('user_id')}#{url}"
        
      $.ajax(url)
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
  draw_graphs()
)