_ = window.global = {}

_.MAX

_.HEADER_SIZE = 120
_.BUTTON_SIZE = 30
_.BUTTON_MARGIN = 10
_.TOP = _.HEADER_SIZE + _.BUTTON_SIZE + _.BUTTON_MARGIN

c = (dat)-> console.log dat

do getWindowSize = ()->  
  w = window
  d = document
  e = d.documentElement
  g = d.getElementsByTagName('body')[0]
  _.WIDTH = w.innerWidth || e.clientWidth || g.clientWidth
  _.HEIGHT = w.innerHeight|| e.clientHeight|| g.clientHeight

do initializeUI = ()->
	$("#ChessTable").css 
		width: "#{_.WIDTH/2}px"
		height: "#{_.WIDTH/2}px"
		top: "#{_.TOP}px"
		left: "#{_.WIDTH/4}px"

	$("#ColIncrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH/4}px"} 
	$("#ColDecrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH*3/4 - _.BUTTON_SIZE}px"}
	$("#RowIncrease").css {top: "#{_.TOP}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}
	$("#RowDecrease").css {top: "#{_.TOP + _.WIDTH/2 - _.BUTTON_SIZE}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}

window.onresize = ()->
	do getWindowSize
	do initializeUI