$( ->
  window.graphs = {}
  $.jqplot._noToImageButton = true;
  
  $('.graph').each( -> 
    if !window[$(this).data('variable-name')]
      return;
    try
      g = $.jqplot($(this).attr("id"), [], {
        # seriesColors: ["rgba(78, 135, 194, 0.7)", "rgb(211, 235, 59)"]
        # title: 'Formulary vs NonFormulary Costs'
        dataRenderer: window[$(this).data('variable-name')]
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
          placement: 'inside'
        seriesDefaults:
          rendererOptions:
            smooth: true
            animation:
              show: true
          showMarker: true
        series: window["#{$(this).data('variable-name')}_labels"],
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
              angle: -30
              textColor: '#dddddd'
            min: window["#{$(this).data('variable-name')}_min"]
            max: window["#{$(this).data('variable-name')}_max"]
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
      # g.replot()
      window.graphs[$(this).data('variable-name')] = g
    catch
      #
  )
)