###* OBJECT ###
# _create=	Object.create
_assign=			Object.assign
_keys=				Object.keys
_defineProperty=	Object.defineProperty
_defineProperties=	Object.defineProperties

_getOwnPropertyDescriptors=	Object.getOwnPropertyDescriptors
_defineProperties=			Object.defineProperties

###* ARRAY ###
_isArray= Array.isArray

# Get base URL
_getBaseURLValue= null
_getBaseURL= ->
	unless _getBaseURLValue
		try
			_getBaseURLValue= document.getElementsByTagName('base')[0].href
		catch error
			_getBaseURLValue= document.location.href
		# fix base URL
		_getBaseURLValue= new URL _getBaseURLValue
		_getBaseURLValue= _getBaseURLValue.origin + _getBaseURLValue.pathname.replace(/[^\/]+$/, '')
	return _getBaseURLValue

# Run document on load
_runOnLoad= (fn)->
	if document.readyState is 'complete'
		fn()
	else
		window.addEventListener 'DOMContentLoaded', fn, {passive:yes, once: yes}
	return

# Empty html element
_emptyElement= (element)->
	element.removeChild el while el= element.lastChild
	return

###* READ FILE DATA ###
_readFile= (file)->
	new Promise (res, rej)->
		reader = new FileReader()
		reader.onload= ->
			res reader.result
			return
		reader.onerror= rej
		reader.readAsDataURL file
		return

###* Pase HTML and return element ###
_toHTMLElementDiv= document.createElement 'div'
_toHTMLElement= (html)->
	# create element
	_toHTMLElementDiv.innerHTML= html
	throw new Error "The html must contain exactly one element!" if _toHTMLElementDiv.childElementCount isnt 1
	return _toHTMLElementDiv.firstElementChild

###* Get index of an element inside its parentNode ###
_elementIndexOf= (element)->
	if parent= element.parentNode
		i= 0
		children= parent.children
		i++ while element isnt children[i]
	else
		i= -1
	return i

# MATH
_min= Math.min
_max= Math.max

# Each element
_each= (arr, cb)->
	cb el for el in arr
	return

# Parsers
_int= (value, defaultValue)->
	value= parseInt value
	return if isNaN value then defaultValue else value
_float= (value, defaultValue)->
	value= parseFloat value
	return if isNaN value then defaultValue else value


###* Disable html elements ###
_disableAll= (nodes)->
	for elC in nodes
		elC.classList.add 'disabled'
	return
###* Disable html elements width index less than ###
_disableLessThan= (nodes, index)->
	len= nodes.length
	if index >= len
		_disableAll nodes
	else if index > 0
		i= 0
		while i < index
			nodes[i++].classList.add 'disabled'
	return
###* Disable html elements width index greater than ###
_disableGreaterThan= (nodes, index)->
	len= nodes.length
	if index < 0
		_disableAll nodes
	else if index < len
		i= index+1
		while i < len
			nodes[i++].classList.add 'disabled'
	return

# Chrome VH fix
_vhFix= (event)->
	requestAnimationFrame (t)->
		document.documentElement.style.setProperty '--vh', "#{window.innerHeight}px"
		return
	return
window.addEventListener 'resize', _vhFix, {capture: no, passive: yes}
_vhFix()
