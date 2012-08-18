window.draw_group_graphs = ->
  $(".group-graph").each( ->
    $el = $(this)
    if $(this).width() && $(this).data('day_range')
      if $(this).data('group_id')
        url = "/divisions/#{$(this).data('division_id')}/groups/#{$(this).data('group_id')}.json"
      
      day_range = $(this).data('day_range')
      $.ajax(url)
      .done((group, status, jqxhr) ->  
        group_data = []
        
        $.each(group.users, (i,user) -> 
          user_data = []
          $.ajax("/users/#{user.id}/completed_surveys.json?day_range=#{day_range}")
          .done((objects, status, jqxhr) ->
            $.each(objects, (i,item) -> user_data.push([new Date(item.date), item.score]) )
            group_data.push({data: user_data, label: user.name})
            
            $.plot(
              $el, 
              group_data
              series:
                lines:
                  show: true
                points:
                  show: true
              legend:
                show: true
              yaxis:
                tickDecimals: 0
              xaxis:
                mode: "time"
                timeformat: "%m/%d/%y"
                minTickSize: [1, "day"] 
            )
          )
        )
      )
  )

$( ->
  draw_group_graphs()
)