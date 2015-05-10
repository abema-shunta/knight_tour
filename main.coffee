_ = window.global = {}

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
		top: "120px"
		left: "#{_.WIDTH/4}px"


window.onresize = ()->
	do getWindowSize