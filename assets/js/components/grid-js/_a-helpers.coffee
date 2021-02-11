###* Check if resize ###
_gridJsResizeArea= (target, childOptions, event)->
	# CHECK IF CURSOR IS IN THE RESIZE ZONE
	resizeMargin= childOptions.resizeMargin
	return unless childOptions.resizableX and childOptions.resizableY
	# Item bounds
	bounds= target.getBoundingClientRect()
	isInBottom= event.y > bounds.y + bounds.height - resizeMargin
	if event.x > bounds.x + bounds.width - resizeMargin
		if isInBottom then resizeArea= GRID_RESIZE_CURSORS.BR
		else if childOptions.resizableX
			resizeArea= GRID_RESIZE_CURSORS.R
	else if isInBottom and childOptions.resizableY
		resizeArea= GRID_RESIZE_CURSORS.B
	return resizeArea
