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
    $('#taken option').each( ->
      _user_data = []
      $.ajax("/users/#{$(this).attr('value')}/recorded_metrics",
        dataType: 'json'
      ).done( (data) -> 
        user_id = if data.length then data[0].user.id else null
        name = if data.length then data[0].user.name else null
        window['dynamically_added'] = window['dynamically_added'] || {}
        
        return if window['dynamically_added'][user_id]
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