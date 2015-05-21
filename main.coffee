_ = window.global = {}

_.MAX = 10
_.MIN = 3

_.HEADER_SIZE = 120
_.BUTTON_SIZE = 30
_.LABEL_SIZE = 40
_.BUTTON_MARGIN = 10

_.TOP = _.HEADER_SIZE + _.BUTTON_SIZE + _.BUTTON_MARGIN

_.COL = 4
_.ROW = 4

_.COLOR = [
	"#000",
	"#000",
	"#0FF",
	"#F30",
	"#6F0",
	"#FF0",
	"#F90",
	"#09F",
	"#90F",
	"#309",
	"#000"
]
_.ANOTHER_COLOR = [
	"#FF0",
	"#FF0",
	"#F30",
	"#6F0",
	"#F30",
	"#6F0",
	"#F30",
	"#6F0",
	"#F30",
	"#6F0",

]

# =====================================================================================

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

genPathData = (answer)->
	pathdata = []
	source = null 
	target = null
	for a in answer
		target = a 
		pathdata.push {source: source, target: target} if source != null 
		source = a 
	pathdata

gx = (num) -> ((num%_.COL)+0.5)*_.SQUARE_SIZE 
gy = (num) -> (parseInt(num/_.COL)+0.5)*_.SQUARE_SIZE 

getCandidates = (pos)->

	candidates = []
	x = pos % _.COL 
	y = parseInt(pos / _.COL) 

	if x-2 >= 0
		candidates.push (y-1) * _.COL + x-2 if y-1 >= 0
		candidates.push (y+1) * _.COL + x-2 if y+1 < _.ROW
	if x+2 < _.COL
		candidates.push (y-1) * _.COL + x+2 if y-1 >= 0
		candidates.push (y+1) * _.COL + x+2 if y+1 < _.ROW
	if y-2 >= 0
		candidates.push (y-2) * _.COL + x-1 if x-1 >= 0
		candidates.push (y-2) * _.COL + x+1 if x+1 < _.COL
	if y+2 < _.ROW
		candidates.push (y+2) * _.COL + x-1 if x-1 >= 0
		candidates.push (y+2) * _.COL + x+1 if x+1 < _.COL
	candidates

move = (pos, m)->

	return false if _.VISITED[pos] == true
	_.VISITED[pos] = true

	if m == _.ANSWER_LENGTH
	
		_.ANSWER.unshift(pos)
		_.VISITED[pos] = true
		return true
	
	else
		
		candidates = getCandidates pos
		res = false

		for candidate in candidates 
			res = move(candidate, m+1) || res

		if res == true
			_.ANSWER.unshift(pos)
			return true
		else 
			_.VISITED[pos] = false
			return false
			
calucuration = ()->

	_.ANSWER = []
	_.VISITED = []
	_.ANSWER_LENGTH = -1
	
	for t,i in _.TABLE 
		_.ANSWER_LENGTH += 1 if t
		_.VISITED[i] = !t

	move(_.START, 0)

updateUI = ()->

	$("body").css("background","#{_.COLOR[_.COL-1]}")

	_.SQUARE_SIZE = _.WIDTH/(2*_.COL)
	_.CHESS_WIDTH = _.SQUARE_SIZE * _.COL
	_.CHESS_HEIGHT = _.SQUARE_SIZE * _.ROW

	$("#ChessTable").css 
		width: "#{_.CHESS_WIDTH}px"
		height: "#{_.CHESS_HEIGHT}px"
		top: "#{_.TOP}px"
		left: "#{_.WIDTH/4}px"

	$("#Help").css
		top: "#{_.TOP + _.CHESS_HEIGHT}px"

	$("#ColDecrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH/4}px"} 
	$("#ColIncrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH*3/4 - _.BUTTON_SIZE}px"}
	$("#ColNumber").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH/2 - _.LABEL_SIZE/2}px"}
	$("#RowDecrease").css {top: "#{_.TOP}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}
	$("#RowIncrease").css {top: "#{_.TOP + _.CHESS_HEIGHT - _.BUTTON_SIZE}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}
	$("#RowNumber").css {top: "#{_.TOP + _.CHESS_HEIGHT/2 - _.LABEL_SIZE/2}px", left: "#{_.WIDTH/4 - _.LABEL_SIZE}px"}

	_.SVG.attr("width", _.CHESS_WIDTH).attr("height", _.CHESS_HEIGHT)
	
	_.RECT = _.RECT.data(_.TABLE)      
	_.RECT.enter().append("rect")
				.on("dblclick", (d,i)->
					c "clidked"
					_.START = i
					updateUI()
				).on("click",(d,i)-> 
					_.TABLE[i] = !_.TABLE[i]
					updateUI()
				)
				
	_.RECT.attr("width", (d)-> _.SQUARE_SIZE)
			.attr("height", (d)-> _.SQUARE_SIZE)
			.attr("x", (d,i)-> (i % _.COL) * _.SQUARE_SIZE )
			.attr("y", (d,i)-> parseInt(i / _.COL) * _.SQUARE_SIZE )
			.attr("fill", (d)-> "#FFF")
			.attr("opacity", (d)-> if d then "1.0" else "0.1")
			.attr("stroke", (d)-> "#{_.COLOR[_.COL-1]}")
			.attr("stroke-width", "2px")

	_.RECT.exit().remove()

	_.START_MARKER = _.START_MARKER.data([_.START])
	_.START_MARKER.enter().append("rect")

	_.START_MARKER.attr("width", (d)-> _.SQUARE_SIZE-10)
			.attr("height", (d)-> _.SQUARE_SIZE-10)
			.attr("x", (d)-> ((d % _.COL) * _.SQUARE_SIZE)+5 )
			.attr("y", (d)-> (parseInt(d / _.COL) * _.SQUARE_SIZE)+5 )
			.attr("fill", "none")
			.attr("stroke", "#{_.ANOTHER_COLOR[_.COL-1]}")
			.attr("stroke-width", "10px")
	_.START_MARKER.exit().remove()

	_.ANSWER_LINE = _.ANSWER_LINE.data(genPathData(_.ANSWER))
	_.ANSWER_LINE.enter().append("path")
	_.ANSWER_LINE.attr("style", (d) -> 
      "stroke: #{_.ANOTHER_COLOR[_.COL-1]};
       stroke-width: 5px;
       opacity: 0.7;"
    ).attr("d", (d)->"M#{gx(d.source)},#{gy(d.source)}L#{gx(d.target)},#{gy(d.target)}")
	_.ANSWER_LINE.exit().remove()

	_.ANSWER_CIRCLE = _.ANSWER_CIRCLE.data(_.ANSWER)
	_.ANSWER_CIRCLE.enter().append("circle")
	_.ANSWER_CIRCLE.attr("r", (d)-> _.SQUARE_SIZE/4)
			.attr("cx", (d,i)-> gx d )
			.attr("cy", (d,i)-> gy d )
			.attr("style", (d) -> 
      	"fill: #{_.ANOTHER_COLOR[_.COL-1]};
       	 stroke-width: 0px;"
    	)
	_.ANSWER_CIRCLE.exit().remove()

	_.ANSWER_TEXT = _.ANSWER_TEXT.data(_.ANSWER)
	_.ANSWER_TEXT.enter().append("text")
	_.ANSWER_TEXT.attr("width", (d)-> _.SQUARE_SIZE-10)
			.attr("height", (d)-> _.SQUARE_SIZE-10)
			.attr("x", (d,i)-> gx d )
			.attr("y", (d,i)-> gy d )
			.text((d,i) -> i+1)
	_.ANSWER_TEXT.exit().remove()

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
	length = (_.COL * _.ROW)-1
	c length

	for i in [0..length]
		TEMP[i] = true
	PCOL = _.COL-1
	for t,i in _.TABLE
		row = parseInt(i/PCOL)
		TEMP[i + row] = _.TABLE[i]

	_.TABLE = TEMP

updateTableByDecreaceCol = ()->

	TEMP = []
	length = (_.COL * _.ROW)-1
	c length

	for i in [0..length]
		TEMP[i] = true

	PCOL = _.COL + 1
	for i in [0..length]
		row = parseInt(i/PCOL)
		TEMP[i - row] = _.TABLE[i]

	_.TABLE = TEMP

updateTableByIncreaceRow = ()->

	TEMP = []
	length = (_.COL * _.ROW)-1
	c length
	for i in [0..length]
		TEMP[i] = true
	for t,i in _.TABLE
		TEMP[i] = t
	_.TABLE = TEMP

updateTableByDecreaceRow = ()->
	TEMP = []
	length = (_.COL * _.ROW)-1
	c length
	for i in [0..length]
		TEMP[i] = _.TABLE[i]
	_.TABLE = TEMP

do initializeUI = ()->

	# InitializeTable
	_.TABLE = []
	_.ANSWER = []
	_.START = 0

	for i in [1.._.COL]
		for j in [1.._.ROW]
			_.TABLE.push true

	_.SVG = d3.select("#ChessTable").append("svg")

	_.RECT_GROUP = _.SVG.append("g").attr("id", "Rects")
	_.START_GROUP = _.SVG.append("g").attr("id", "StartGroup")
	_.ANSWER_GROUP = _.SVG.append("g").attr("id", "AnswerGroup")
	
	_.RECT = _.RECT_GROUP.selectAll("rect")
	_.START_MARKER = _.START_GROUP.selectAll("rect")

	_.ANSWER_LINE = _.ANSWER_GROUP.selectAll("path")
	_.ANSWER_CIRCLE = _.ANSWER_GROUP.selectAll("circle")
	_.ANSWER_TEXT = _.ANSWER_GROUP.selectAll("text")


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

	$("#Execution").click ()->
		$button = $(@)
		if $button.hasClass("calucurated")
			_.ANSWER = []
			$button.text("CALC")
			$button.removeClass("calucurated")
			do updateUI
		else
			do calucuration
			$button.text("CLEAR")
			$button.addClass("calucurated")
			do updateUI

window.onresize = ()->
	do getWindowSize
	do updateUI