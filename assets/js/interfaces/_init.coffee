# Init Basic framework elements
init: (container)->
	container?= document
	# Init components
	Component.__initComponents container
	# Init images
	_initDOMImages container
	# Init date
	@applyDateTo container
	this # chain

# Run on load
onLoad: _runOnLoad
