###*
 * Grid JS Item
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
class GridJsItem
	constructor: (element, attrs)->
		# Attributes
		@element= element
		@attrs= _assign {}, GRID_ITEM_DEFAULTS, attrs
		element[GRID_SYMB]= this if element
		return
	### Adjust item ###
	adjustView: (isGridEnabled)->
		attrs= @attrs
		style= @element.style
		if isGridEnabled
			style.gridColumn= "auto / span #{attrs.cols}"
			style.gridRow= "auto / span #{attrs.rows}"
		else
			style.gridColumn= ''
			style.gridRow= ''
		this # chain

	###* Clear ###
	clear: ->
