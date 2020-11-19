###* Add class ###
addClass: ->
	_each @_elements, (element)->
		c= element.classList
		c.add.apply c, arguments
		return
	this # chain

###* Remove class ###
removeClass: ->
	_each @_elements, (element)->
		c= element.classList
		c.remove.apply c, arguments
		return
	this # chain

###* Toggle class ###
toggleClass: ->
	_each @_elements, (element)->
		c= element.classList
		c.toggle.apply c, arguments
		return
	this # chain
