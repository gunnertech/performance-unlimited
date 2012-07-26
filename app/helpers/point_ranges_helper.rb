module PointRangesHelper
  def point_range_to_html(survey,point_range,position=nil)
    css_classes = ['label-success', 'label-info', '', 'label-warning', 'label-important']
    css_class = if survey.point_ranges.first == point_range
      'label-success'
    elsif survey.point_ranges.last == point_range
      'label-important'
    else
      css_classes[position]
    end
    
    text = if point_range.high.nil?
      "#{point_range.low} or More"
    elsif point_range.low.nil? || point_range.low == 0
      "Less than #{point_range.high}"
    else
      "#{point_range.low}-#{point_range.high}"
    end
    
    raw "<span class='label #{css_class}'>#{text}</span>"
  end
end
