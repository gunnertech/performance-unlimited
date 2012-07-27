# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('.user.navigate').live('click', (event) ->
  event.preventDefault()
  $('.navigate.btn-primary').data('user_id', $(this).data('user_id'))
)

$('.navigate.btn-primary').live('click', (event) ->
  event.preventDefault()
  response_string = ''
  $('.answer.active').each(->
    response_string = "#{response_string},#{$(this).data('question_id')}-#{$(this).data('response_id')}"
  )
  
  response_string = response_string.replace(/^,/,'')
  
  $.ajax(
    $(this).data('sumbission-uri'),
    type: 'POST',
    dataType: "json",
    data: 
      responses: response_string
      taker_id: $(this).data('user_id')
  )
)

$('.navigate').live('click', (event) ->
  event.preventDefault()
  if $(this).hasClass('disabled')
    $(this).popover(
      trigger: 'manual'
      placement: 'top'
      title: 'Incomplete Question Set'
      content: 'You must answer all the questions before moving on'
    )
    $(this).popover('show')
    _this = this
    setTimeout( ->
      $(_this).popover('hide')
    ,2000)
  else
    $(this).parents('section').hide()
    $($(this).attr('href')).show()
)

$('.home.index .table .btn').live('click', (event) ->
  score = 0
  event.preventDefault()
  $(this).parents('tr').find('.btn').removeClass('active')
  $(this).addClass('active')
  
  $(this).parents('tr').find('.score strong').html($(this).data('value'))
  
  if $(this).parents('table').find('tr').length == $(this).parents('table').find('.active').length
    $(this).parents('section').find('.disabled').removeClass('disabled')
  
  $('table .active').each( -> 
    score += $(this).data('value')
  )
  
  $('#score').html(score)
)

Response.action( ->
  if Response.band(479)
    $('table').removeClass('table-condensed')
    $('.btn').removeClass('btn-small')
  else
    $('table').addClass('table-condensed')
    $('.btn').addClass('btn-small')
)