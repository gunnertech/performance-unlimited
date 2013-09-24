clone = (obj) ->
  return obj  if obj is null or typeof (obj) isnt "object"
  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])
  temp

$('.back').live('click', (event) ->
  event.preventDefault()
  
  history.go(-1)
)

$('.btn-print').live('click', (event) ->
  event.preventDefault()
  window.print()
)

$(->
  
  $(".add").click( (event) ->
    event.preventDefault()
    $('#available option:selected').remove().prependTo($('#taken'))
  )
  
  $(".remove").click( (event) ->
    event.preventDefault()
    $('#taken option:selected').remove().prependTo($('#available'))
  )
  
  $(".graph-btn").click( (event) ->
    event.preventDefault()
    
    start_date_pieces = $('#start-date').val().split('/')
    end_date_pieces = $('#end-date').val().split('/')
    
    converted_start_date = "#{start_date_pieces[2]}-#{start_date_pieces[0]}-#{start_date_pieces[1]}"
    converted_end_date = "#{end_date_pieces[2]}-#{end_date_pieces[0]}-#{end_date_pieces[1]}"
    
    $.ajax("/recorded_metrics/average?organization_id=1&start_date=#{$('#start-date').val()}&end_date=#{$('#end-date').val()}",
      dataType: 'script'
    ).done( ->
      $.each(window['_metrics'],(i,key) ->
        try
          graph = window.graphs["_#{key}"]
          $.each(graph.series, (k,series) ->
            if k > 0
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
          )
          # graph.series[0].show = true
          # graph.replot()
        catch e
          #nothing
        
        
        
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
              $.each(window['_metrics'],(i,key) ->
                try
                  graph = window.graphs["_#{key}"]
                  $.each(graph.series, (i,item) ->
                    if i > 0
                      series.show = true
                      graph.replot()
                  )
                  
                catch e
                  #nothing

              )
              return true

            window['dynamically_added'][user_id] = {}

            grouped_arr = _.groupBy(data, (item, key) -> 
              return item.metric.name
            )

            _.each(grouped_arr, (data,key,obj) ->
              grouped_arr[key] = _.map(data, (item, key) -> 
                return [item.recorded_on, item.numerical_value]
              )
            )

            _.each(grouped_arr, (data,key,obj) ->
              graph = window.graphs["_#{key.toLowerCase().replace(/\W/,"_")}"]
              if graph
                dk = "_#{key.toLowerCase().replace(/\W/,"_")}"
                window["#{dk}_data"].push(data)
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
                graph.replot(
                  data: window["#{dk}_data"]
                  series: window["#{dk}_labels"]
                )
            )
          )
        )
      )
    ).always( -> 
      
    )
    
    
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
        .always(-> console.log("always"))
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
      position = ui.item.index()+1
      
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