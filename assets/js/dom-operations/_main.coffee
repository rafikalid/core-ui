###*
 * Operations on DOM elements
###
DOMOperations= do ->
	#=include body/_*.coffee
	return class
		constructor: (elements)->
			if typeof elements is 'string'
				elements= document.querySelectorAll elements
			else unless typeof elements.length is 'number'
				elements= [elements]
			@_elements= elements
			return

		#=include interfaces/_*.coffee
