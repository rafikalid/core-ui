###*
 * AUTO-COMPLETE
###
autocomplete: (event, args)->
	element= event.target
	# Create autocomplete object
	unless o= element[AUTO_COMPLETE_SYMB]
		o= element[AUTO_COMPLETE_SYMB]= new AutoComplete element: element
	o.uri= args[1] or document.location.href
	# limit
	if l= element.getAttribute 'd-limit'
		l= parseInt l
		l= Infinity if isNaN l
	else l= Infinity
	o.limit= l
	# Use cache
	if l= element.getAttribute('d-cache')
		l= l.toLowerCase() isnt 'off'
	else l= on
	o.cache= l
	# Data
	if l= element.getAttribute 'data'
		o.data= JSON.parse l
	# Open popup
	o.find ''
	return

###* AUTO-COMPLETE CLASS ###
AutoComplete: AutoComplete
