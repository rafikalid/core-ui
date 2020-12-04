###*
 * Create popup
###
Popup: _Popup

###* Get BaseURL ###
getBaseURL: _getBaseURL

###* Escape HTML ###
escape: pug.escape

# Parse HTML
toHTMLElement: _toHTMLElement
toHTMLFragment: (html)->
	# create element
	_toHTMLElementDiv.innerHTML= html
	frag= document.createDocumentFragment()
	frag.appendChild c while c= _toHTMLElementDiv.firstChild
	return frag
