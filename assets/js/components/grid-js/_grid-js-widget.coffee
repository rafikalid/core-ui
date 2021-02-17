###*
 * Grid JS widget
###
# Defaults
GRID_ITEM_DEFAULTS=
	draggable:	yes
	resizableX:	yes
	resizableY:	yes
	resizeMargin: 5
	# Size
	cols: 5
	rows: 4
	minCols:	1
	maxCols:	255
	minRows:	1
	maxRows:	255

# Class
class GridJsWidget extends GridJsItem
	constructor: (data)->
		super null, data.attrs
		@data= data
		element= @element= _toHTMLElement @getHTML()
		element[GRID_SYMB]= this
		return

	###* Method to be overrided ###
	getHTML: -> '<div></div>'

	###* Reload widget content ###
	reload: ->
		oldElement= @element
		element= @element= _toHTMLElement @getHTML()
		element[GRID_SYMB]= this
		if parent= oldElement.parentNode
			requestAnimationFrame (t)->
				parent.insertBefore element, oldElement
				parent.removeChild oldElement
				return
		return
