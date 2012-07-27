$('.back').live('click', (event) ->
  event.preventDefault()
  
  history.go(-1)
)