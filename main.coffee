_ = window.global = {}

_.MAX = 10
_.MIN = 4

_.HEADER_SIZE = 120
_.BUTTON_SIZE = 30
_.LABEL_SIZE = 40
_.BUTTON_MARGIN = 10

_.TOP = _.HEADER_SIZE + _.BUTTON_SIZE + _.BUTTON_MARGIN

_.COL = 4
_.ROW = 4

c = (dat)-> console.log dat

caltivate = (num) ->
	num = if num >= _.MAX then _.MAX else num 
	num = if num <= _.MIN then _.MIN else num 
	num

do getWindowSize = ()->  
  w = window
  d = document
  e = d.documentElement
  g = d.getElementsByTagName('body')[0]
  _.WIDTH = w.innerWidth || e.clientWidth || g.clientWidth
  _.HEIGHT = w.innerHeight|| e.clientHeight|| g.clientHeight

do updateUI = ()->
	$("#ChessTable").css 
		width: "#{_.WIDTH/2}px"
		height: "#{_.WIDTH/2}px"
		top: "#{_.TOP}px"
		left: "#{_.WIDTH/4}px"

	$("#ColDecrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH/4}px"} 
	$("#ColIncrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH*3/4 - _.BUTTON_SIZE}px"}
	$("#ColNumber").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH/2 - _.LABEL_SIZE/2}px"}
	$("#RowDecrease").css {top: "#{_.TOP}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}
	$("#RowIncrease").css {top: "#{_.TOP + _.WIDTH/2 - _.BUTTON_SIZE}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}
	$("#RowNumber").css {top: "#{_.TOP + _.WIDTH/4 - _.LABEL_SIZE/2}px", left: "#{_.WIDTH/4 - _.LABEL_SIZE}px"}
	
do updateColumn = ()->
	$("#ColNumber").text _.COL
	if _.COL == _.MIN 
		$("#ColDecrease").addClass("disabled")
	else if _.COL == _.MAX 
		$("#ColIncrease").addClass("disabled")
	else
		$("#ColIncrease").removeClass()
		$("#ColDecrease").removeClass()

do updateRow = ()->
	$("#RowNumber").text _.ROW
	if _.ROW == _.MIN 
		$("#RowDecrease").addClass("disabled")
	else if _.ROW == _.MAX 
		$("#RowIncrease").addClass("disabled")
	else
		$("#RowIncrease").removeClass()
		$("#RowDecrease").removeClass()

do initializeUI = ()->
	do updateUI
	$("#ColIncrease").click ()-> 
		_.COL = caltivate(_.COL + 1) 
		_.ROW = caltivate(_.ROW + 1) 
		do updateColumn
		do updateRow
	$("#ColDecrease").click ()-> 
		_.COL = caltivate(_.COL - 1) 
		_.ROW = caltivate(_.ROW - 1) 
		do updateColumn
		do updateRow
	$("#RowIncrease").click ()-> 
		_.ROW = caltivate(_.ROW + 1) 
		do updateRow
	$("#RowDecrease").click ()-> 
		_.ROW = caltivate(_.ROW - 1) 
		do updateRow

window.onresize = ()->
	do getWindowSize
	do initializeUI