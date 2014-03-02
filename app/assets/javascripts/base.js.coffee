window.graphs = {}
window['averages_off'] = true
$.jqplot._noToImageButton = true
$.jqplot.config.enablePlugins = true

clone = (obj) ->
  return obj  if obj is null or typeof (obj) isnt "object"
  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])
  temp

update_comments = ->
  if $('#taken option').length == 1
    $(".comments").show()
    $.each(window['_metric_ids'],(i,hash) ->
      $("##{hash.key.replace(/_/g,"-")}-comments #comment_body").attr('placeholder', "Comment on #{$('#taken option:first').text()}...")
      $("##{hash.key.replace(/_/g,"-")}-comments .messages").empty()    
      $('#taken option').each( ->
        $("##{hash.key.replace(/_/g,"-")}-comments #comment_for_user_id").val($(this).attr('value'))
        $.ajax("/users/#{$(this).attr('value')}/comments?metric_id=#{hash.id}",
          dataType: 'json'
        ).done( (items) ->
          $.each(items, (i,data) ->
            html = "<blockquote><p>#{data.body}</p><small>#{data.commenter.name} <cite>#{data.left_on}</cite></small></blockquote>"
            $("##{hash.key.replace(/_/g,"-")}-comments .messages").prepend($(html))
          )
        )
      )
    )

update_bar_charts = ->
  update_comments()
  
  $.each(window['_metrics'],(i,key) ->
    window["_#{key}_data"] = if window['averages_off'] then window["_#{key}_data_orig"].slice(1) else window["_#{key}_data_orig"].slice(0)
    window["_#{key}_labels"] = if window['averages_off'] then window["_#{key}_labels_orig"].slice(1) else window["_#{key}_labels_orig"].slice(0)
    graph = window.graphs["_#{key}"]
    if graph
      id = $(graph.targetId).attr('id')
      graph.destroy()
      if window["_#{key}_data"].length
        $.jqplot(id, [window["_#{key}_data"]],
          animate: !$.jqplot.use_excanvas
          seriesDefaults:
            renderer:$.jqplot.BarRenderer
            pointLabels: { show: true }
          axes:
            xaxis:
              renderer: $.jqplot.CategoryAxisRenderer
              ticks: window["_#{key}_labels"]
            highlighter: { show: false }
        )
  )
  
  $('#taken option').each( ->
    
    _user_data = []
    
    $.ajax("/users/#{$(this).attr('value')}/recorded_metrics?most_recent=true",
      dataType: 'json'
    ).done( (data) -> 
      user_id = if data.length then data[0].user.id else null
      name = if data.length then data[0].user.name else null
      window['dynamically_added'] = window['dynamically_added'] || {}


      grouped_arr = _.groupBy(data, (item, key) -> 
        return item.metric.name
      )

      _.each(grouped_arr, (data,key,obj) ->
        grouped_arr[key] = _.map(data, (item, key) -> 
          return item.numerical_value
        )
      )

      _.each(grouped_arr, (data,key,obj) ->
        graph = window.graphs["_#{key.toLowerCase().replace(/\W+/g,"_")}"]
        if graph
          
          dk = "_#{key.toLowerCase().replace(/\W+/g,"_")}"
          window["#{dk}_data"].push(parseFloat(data[data.length-1]))
          window["#{dk}_labels"].push(name)
          
          id = $(graph.targetId).attr('id')
          graph.destroy()
          $.jqplot(id, [window["#{dk}_data"]],
            animate: !$.jqplot.use_excanvas
            seriesDefaults:
              renderer:$.jqplot.BarRenderer
              pointLabels: { show: true }
            axes:
              xaxis:
                renderer: $.jqplot.CategoryAxisRenderer
                ticks: window["#{dk}_labels"]
              highlighter: { show: false }
          )
        return false
      )
    )
  )
  
update_line_charts = ->
  update_comments()
  
  start_date_pieces = $('#start-date').val().split('/')
  end_date_pieces = $('#end-date').val().split('/')
  
  converted_start_date = "#{start_date_pieces[2]}-#{start_date_pieces[0]}-#{start_date_pieces[1]}"
  converted_end_date = "#{end_date_pieces[2]}-#{end_date_pieces[0]}-#{end_date_pieces[1]}"
  
  $.ajax("/recorded_metrics/average?#{$('#entity').data('variable')}=#{$('#entity').data('value')}&start_date=#{$('#start-date').val()}&end_date=#{$('#end-date').val()}",
    dataType: 'script'
  ).done( ->
    $.each(window['_metrics'],(i,key) ->
      
      
      
      try
        graph = window.graphs["_#{key}"]
        $.each(graph.series, (k,series) ->
          if !series.label.match(/Average/)
            graph.series[k].show = false
            graph.replot()
            
          else
            graph.replot(
              data: window["_#{key}_data"]
              series: window["_#{key}_labels"]
              axes:
                xaxis:
                  min: converted_start_date
                  max: converted_end_date
            )
            
            graph.series[0].show = !window['averages_off']
            graph.replot()
        )
      catch e
        #nothing
      
      window['dynamically_added'] = {}
      $('#taken option').each( ->
        _user_data = []
        $.ajax("/users/#{$(this).attr('value')}/recorded_metrics?start_date=#{$('#start-date').val()}&end_date=#{$('#end-date').val()}",
          dataType: 'json'
        ).done( (data) -> 
          user_id = if data.length then data[0].user.id else null
          name = if data.length then data[0].user.name else null
          
          window['dynamically_added'] = window['dynamically_added'] || {}

          # return if window['dynamically_added'][user_id]

          if window['dynamically_added'][user_id]
            # $.each(window['_metrics'],(i,key) ->
            #   # try
            #   graph = window.graphs["_#{key}"]
            #   if graph
            #     $.each(graph.series, (i,item) ->
            #       if !item.label.match(/Average/)
            #         graph.series[i].show = true
            #         graph.replot()
            #     )
            #   else
            #     
            #   # catch e
            #     # console.log(key)
            #     #nothing
            # 
            # )
            return true

          window['dynamically_added'][user_id] = {}

          grouped_arr = _.groupBy(data, (item, key) -> 
            return item.metric.name
          )

          _.each(grouped_arr, (data,key,obj) ->
            grouped_arr[key] = _.map(data, (item, k) -> 
              console.log(key)
              if key == "Weight"
                console.log(item.recorded_on)
                console.log(item.numerical_value)
                console.log(item.value)
              return [item.recorded_on, item.numerical_value||item.value]
            )
          )

          _.each(grouped_arr, (data,key,obj) ->
            
            graph = window.graphs["_#{key.toLowerCase().replace(/\W+/g,"_")}"]
            if graph
              dk = "_#{key.toLowerCase().replace(/\W+/g,"_")}"
              
              # console.log(dk)
              
              data = _.sortBy(data, (d) -> return d[0] )
              
              window["#{dk}_data"].push(data)
              if(!_.find(window["#{dk}_labels"],(item) -> item.label == name))
                window["#{dk}_labels"].push({
                  label: name
                })
                
              window['dynamically_added'][user_id] = {
                label: {
                  label: name
                }
                data: data
                index: window["#{dk}_data"].length - 1
              }
              
              # console.log(window["#{dk}_labels"])
              
              
              
              graph.replot(
                data: window["#{dk}_data"]
                series: window["#{dk}_labels"]
              )
              
              
              
              graph.series[0].show = !window['averages_off']
              graph.replot()
            else
              # console.log("NO GRAPH FOR: _#{key.toLowerCase().replace(/\W+/g,"_")}")
          )
          
        )
      )
    )
  ).always( -> 
    
  )


plot_line_chart = (graph_element) ->
  if !window[$(graph_element).data('variable-name')]
    return;
  try
    placement = if window["#{$(graph_element).data('variable-name')}_is_focus"] then 'outside' else 'inside'
    g = $.jqplot($(graph_element).attr("id"), window["#{$(graph_element).data('variable-name')}_data"], {
      # seriesColors: ["rgba(78, 135, 194, 0.7)", "rgb(211, 235, 59)"]
      # title: 'Formulary vs NonFormulary Costs'
      # dataRenderer: window[$(graph_element).data('variable-name')]
      highlighter:
        show: true,
        sizeAdjust: 1
        tooltipOffset: 9
      grid:
        background: 'rgba(57,57,57,0.0)'
        drawBorder: false
        shadow: false
        gridLineColor: '#666666'
        gridLineWidth: 2
      legend:
        show: true
        placement: placement
      seriesDefaults:
        rendererOptions:
          smooth: true
          animation:
            show: true
        showMarker: true
      series: window["#{$(graph_element).data('variable-name')}_labels"],
      axesDefaults:
        rendererOptions:
          baselineWidth: 1.5,
          baselineColor: '#444444'
          drawBaseline: false
      axes:
        xaxis:
          renderer: $.jqplot.DateAxisRenderer,
          tickRenderer: $.jqplot.CanvasAxisTickRenderer
          tickOptions:
            formatString: "%b %e %Y"
            angle: -60
            textColor: '#000000'
          min: window["#{$(graph_element).data('variable-name')}_min"]
          max: window["#{$(graph_element).data('variable-name')}_max"]
          # tickInterval: "2 days"
          drawMajorGridlines: false
        yaxis:
          # renderer: $.jqplot.LogAxisRenderer
          pad: 0
          rendererOptions:
            minorTicks: 1
          tickOptions:
            # formatString: "$%'d"
            showMark: false
    });
    
    if window['averages_off']
      g.series[0].show = false
      g.replot()
      
    
    window.graphs[$(graph_element).data('variable-name')] = g
    window.graph_arr = window.graph_arr || []
    window.graph_arr.push(g)
  catch e
    # console.log($(graph_element).data('variable-name'))
    # console.log(e)


plot_bar_chart = (graph_element) ->
  s1 = [2, 6, 7, 10]
  ticks = ['a', 'b', 'c', 'd'];
  
  if window["#{$(graph_element).data('variable-name')}_data"].length
    g = $.jqplot($(graph_element).attr("id"), [window["#{$(graph_element).data('variable-name')}_data"]],
      animate: !$.jqplot.use_excanvas
      seriesDefaults:
        renderer:$.jqplot.BarRenderer
        pointLabels: { show: true }
      axes:
        xaxis:
          renderer: $.jqplot.CategoryAxisRenderer
          ticks: window["#{$(graph_element).data('variable-name')}_labels"]
        highlighter: { show: false }
    )
    window.graphs[$(graph_element).data('variable-name')] = g

$('.back').live('click', (event) ->
  event.preventDefault()
  
  history.go(-1)
)

$('.btn-print').live('click', (event) ->
  event.preventDefault()
  window.print()
)

$(document).on("ajax:success",".comments form", (evt, data, status, xhr) ->
  $(evt.currentTarget).find('#comment_body').val("")
  html = "<blockquote><p>#{data.body}</p><small>#{data.commenter.name} <cite>#{data.left_on}</cite></small></blockquote>"
  $(evt.currentTarget).parents('.comments').find('.messages').prepend($(html))
)

$(document).on("click",".scroll-pane tbody tr *", (evt) ->
  $(this).parents('tbody').find('tr').removeClass('highlighted')
  $(this).parents('tr').addClass('highlighted')
)

# $(document).on("click",".scroll-pane tbody tr", (evt) ->
#   console.log('hi')
#   $(this).parents('tbody').find('tr').removeClass('highlighted')
#   $(this).addClass('highlighted')
# )



$(->
  
  $('#start-date, #end-date').change( (event) ->
    window['redraw'] = true
  )
  
  $('.toggle-averages-off').click( (event) -> 
    # window['redraw'] = true
    $(this).addClass('active')
    $('.toggle-averages-on').removeClass('active')
    event.preventDefault()
    window['averages_off'] = true
  )
  
  $('.toggle-averages-on').click( (event) -> 
    # window['redraw'] = true
    $(this).addClass('active')
    $('.toggle-averages-off').removeClass('active')
    event.preventDefault()
    window['averages_off'] = false
  )
  
  
  $('#record-date').change( -> 
    $('#recorded_date').val($('#record-date').val())
  )
  
  window.graphs = {}
  $.jqplot._noToImageButton = true;
  
  $('.graph').each( -> 
    if $('#graph-type').val() == 'line'
      plot_line_chart(this)
    else if $('#graph-type').val() == 'bar'
      plot_bar_chart(this)
  )
  
  if $('#taken option').length && $('#graph-type').val() != 'raw'
    setTimeout(->
      $('.graph-btn').trigger('click')
    ,100)
    
  
  $('#graph-type').change( ->
    $('#graph-type').data('changed',true)
  )
  
  $(".add").click( (event) ->
    event.preventDefault()
    $('#available option:selected').remove().prependTo($('#taken'))
  )
  
  $(".remove").click( (event) ->
    event.preventDefault()
    $('#taken option:selected').remove().prependTo($('#available'))
  )
  
  $('.print-btn').click( (event) -> 
    event.preventDefault()
    window.print()
  )
  
  $(".graph-btn").click( (event) ->
    event.preventDefault()
    
    if $('#graph-type').val() == 'raw'
      location.href = "?taken_users=#{$.makeArray($('#taken option').map(-> $(this).attr('value'))).join(",")}&graph_type=#{$('#graph-type').val()}&graph_end_date=#{$('#end-date').val()}&graph_start_date=#{$('#start-date').val()}"
      return false
    
    if $('#graph-type').data('changed')
      location.href = "?taken_users=#{$.makeArray($('#taken option').map(-> $(this).attr('value'))).join(",")}&graph_type=#{$('#graph-type').val()}"
      return false
    
    else if window['redraw']
      location.href = "?graph_start_date=#{$('#start-date').val()}&graph_end_date=#{$('#end-date').val()}&taken_users=#{$.makeArray($('#taken option').map(-> $(this).attr('value'))).join(",")}&graph_type=#{$('#graph-type').val()}"
    
    $('#player-alerts').empty()
    $('#taken option').each( ->
      $.ajax("/users/#{$(this).attr('value')}/assigned_alerts",
        dataType: 'json'
      ).done( (data) ->
        if data.length
          html = "<div class=\"alert alert-error\"><h5>#{data[0].user.name}</h5><table class=\"table table-striped\"><thead><tr><th>Metric</th><th>Value</th><th>On</th><th></th></tr></thead><tbody>"
          $.map(data, (item,i) -> 
            html = "#{html}<tr><td>#{item.metric.name}</td><td>#{item.recorded_metric.value}</td><td>#{item.recorded_metric.recorded_on}</td><td>#{item.alert.message}</td></tr>"
          )
          html = "#{html}</tbody></table></div>"
          $('#player-alerts').append(html)
      )
    )
      
    if $('#graph-type').val() == 'line'
      update_line_charts()
    else if $('#graph-type').val() == 'bar'
      update_bar_charts()
  )
  
  $('#metric_metric_type_id').change( -> 
    if $(this).find('option:selected').text() == 'Text'
      $('#metric_decimal_places').parents('.control-group').hide()
    else
      $('#metric_decimal_places').parents('.control-group').show()
  )
  
  if $(this).find('option:selected').text() == 'Text'
    $('#metric_decimal_places').parents('.control-group').hide()
  else
    $('#metric_decimal_places').parents('.control-group').show()
  
  $('.global-submit').click( (event) ->
    event.preventDefault()
    $(".metric").each((i,item) ->
      if $(item).find('#recorded_metric_value').val()
        
        $.post(
          $(item).find('#recorded_metric_value').parents('form').attr('action'),
          $(item).find('#recorded_metric_value').parents('form').serialize(),
          null,
          'json'
        )
        .done(-> 
          $(item).find("input[type='text']").attr('disabled','disabled')
          $(item).find(".control-group").addClass('success')
        )
        .fail(-> 
          $(item).find("input[type='text']").attr('disabled','disabled')
          $(item).find(".control-group").addClass('error')
        )
        .always(-> )
    )
  )
  
  $('.base-date').on('change', ->
    $('.hidden.datepicker').val($(this).val())
  )
  
  $(".datepicker").datepicker()
  
  $(".modal-trigger").on('click', (event) ->
    event.preventDefault()
    $modal = $("##{$(this).data('modal')}").modal('show')
    $modal.find('.close-it').on('click', (event) ->
      event.preventDefault()
      
      $modal.modal('hide')
    )
  )
  
  $(".sortable" ).sortable(axis: "y", 
    helper: (e, ui) ->
      ui.children().each( ->
        $(this).width($(this).width());
      )
      return ui
    update: (e,ui) ->      
      position = ui.item.index()
      
      $.ajax(
        $(ui.item).data("object-url"),
        data: "#{$(ui.item).data("object-type")}[position]=#{position}&_method=PUT"
        type: 'POST'
        dataType: 'json'
      )
      
      return ui
  ).disableSelection()
  
  if location.href.match(/print/)
    window.print()
)