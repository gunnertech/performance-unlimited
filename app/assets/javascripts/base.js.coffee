$('.back').live('click', (event) ->
  event.preventDefault()
  
  history.go(-1)
)

$('.btn-print').live('click', (event) ->
  event.preventDefault()
  window.print()
)