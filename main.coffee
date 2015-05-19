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

updateUI = ()->

	_.SQUARE_SIZE = _.WIDTH/(2*_.COL)
	_.CHESS_WIDTH = _.SQUARE_SIZE * _.COL
	_.CHESS_HEIGHT = _.SQUARE_SIZE * _.ROW

	$("#ChessTable").css 
		width: "#{_.CHESS_WIDTH}px"
		height: "#{_.CHESS_HEIGHT}px"
		top: "#{_.TOP}px"
		left: "#{_.WIDTH/4}px"

	$("#ColDecrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH/4}px"} 
	$("#ColIncrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH*3/4 - _.BUTTON_SIZE}px"}
	$("#ColNumber").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH/2 - _.LABEL_SIZE/2}px"}
	$("#RowDecrease").css {top: "#{_.TOP}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}
	$("#RowIncrease").css {top: "#{_.TOP + _.CHESS_HEIGHT - _.BUTTON_SIZE}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}
	$("#RowNumber").css {top: "#{_.TOP + _.CHESS_HEIGHT/2 - _.LABEL_SIZE/2}px", left: "#{_.WIDTH/4 - _.LABEL_SIZE}px"}

	_.SVG.attr("width", _.CHESS_WIDTH).attr("height", _.CHESS_HEIGHT)
	
	_.RECT = _.RECT.data(_.TABLE)      
	_.RECT.enter().append("rect")	      
	_.RECT.attr("width", (d)-> _.SQUARE_SIZE)
			.attr("height", (d)-> _.SQUARE_SIZE)
			.attr("x", (d,i)-> (i % _.ROW) * _.SQUARE_SIZE )
			.attr("y", (d,i)-> parseInt(i / _.COL) * _.SQUARE_SIZE )
			.attr("fill", (d)-> if d then "#F00" else "#0F0")
			.attr("stroke", (d)-> if d then "#FFF" else "#FFF")
			.attr("stroke-width", "2px")
	_.RECT.exit().remove()

	return
	
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

updateTableByIncreaceCol = ()->

	TEMP = []
	for i in [0..(_.COL * _.ROW)-1]
		TEMP[i] = true
	PCOL = _.COL-1
	for t,i in _.TABLE.length
		row = parseInt(PCOL/i)
		TEMP[i + row] = _.TABLE[i]

	_.TABLE = TEMP

updateTableByDecreaceCol = ()->

	TEMP = []
	for i in [0..(_.COL * _.ROW)-1]
		TEMP[i] = true
	PCOL = _.COL + 1

	for t,i in _.TABLE.length
		row = parseInt(PCOL/i)
		TEMP[i - row] = _.TABLE[i]

	_.TABLE = TEMP

updateTableByIncreaceRow = ()->
	TEMP = []
	for i in [0..(_.COL * _.ROW)-1]
		TEMP[i] = true
	for t,i in _.TABLE.length
		TEMP[i] = _.TABLE[i]
	_.TABLE = TEMP

updateTableByDecreaceRow = ()->
	TEMP = []
	for i in [0..(_.COL * _.ROW)-1]
		TEMP[i] = _.TABLE[i]
	_.TABLE = TEMP



do initializeUI = ()->

	# InitializeTable
	_.TABLE = []
	for i in [1.._.COL]
		for j in [1.._.ROW]
			_.TABLE.push true

	_.SVG = d3.select("#ChessTable").append("svg")
	_.RECT_GROUP = _.SVG.append("g").attr("id", "Rects")
	_.RECT = _.SVG.selectAll("rect")

	do updateUI

	$("#ColIncrease").click ()-> 

		needsUpdateCol = _.COL != _.MAX
		needsUpdateRow = _.ROW != _.MAX

		_.COL = caltivate(_.COL + 1) 
		_.ROW = caltivate(_.ROW + 1) 
	
		if needsUpdateCol
			do updateTableByIncreaceCol 
		else if needsUpdateRow
			do updateTableByIncreaceRow 

		do updateColumn
		do updateRow
		do updateUI

	$("#ColDecrease").click ()-> 
		
		needsUpdateCol = _.COL != _.MIN
		needsUpdateRow = _.ROW != _.MAX

		_.COL = caltivate(_.COL - 1) 
		_.ROW = caltivate(_.ROW - 1) 

		if needsUpdateCol
			do updateTableByDecreaceCol 
		else if needsUpdateRow
			do updateTableByDecreaceRow

		do updateColumn
		do updateRow
		do updateUI

	$("#RowIncrease").click ()-> 

		_.ROW = caltivate(_.ROW + 1) 
		do updateTableByIncreaceRow 
		do updateRow
		do updateUI

	$("#RowDecrease").click ()-> 

		_.ROW = caltivate(_.ROW - 1) 
		do updateTableByDecreaceRow
		do updateRow
		do updateUI

window.onresize = ()->
	do getWindowSize
	do updateUI