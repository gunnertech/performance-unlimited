$('.back').live('click', (event) ->
  event.preventDefault()
  
  history.go(-1)
)

$('.btn-print').live('click', (event) ->
  event.preventDefault()
  window.print()
)

$(->
  
  $('.global-submit').click( (event) ->
    event.preventDefault()
    $(".metric").each((i,item) ->
      if $(item).find('#recorded_metric_value').val()
        console.log( $(item).find('#recorded_metric_value').parents('form').serialize() )
        console.log( $(item).find('#recorded_metric_value').parents('form').attr('action') )
        
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