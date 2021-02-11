# Get element attributes with "d-" prefex
_getPrefixedAttributes= (element)->
	result= {}
	for n in element.attributes
		nm= n.name
		if nm.startsWith('d-')
			result[nm]= n.value
	return result
