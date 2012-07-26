module ResponsesHelper
  def response_css_point_class(response,position)
    if position == 1
      'btn-success'
    elsif position == response.question.responses.length
      'btn-danger'
    elsif position == 2 && response.question.responses.length >= 3
      'btn-primary'
    elsif position == 3 && response.question.responses.length >= 3
      'btn-warning'
    else 
      'btn-danger'
    end
  end
end
