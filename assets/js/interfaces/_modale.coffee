###*
 * Show modals
 * @param {String} html - HTML modal
 * @return {Object} Model object
###
modal: (html)->
	# Create promise
	_close= null
	_historyBackClose= null
	element= null
	# Keyboard listener
	# _keyboardListener= (event)->
	# 	k= event.keyCode
	# 	if k is 27 then _close 'cancel'
	# 	else console.log 'k>>', k
	# 	return
	# return promise
	p= new Promise (res, rej)->
		# close Fx
		_close= (value)->
			res value or 'close'
			return
		# Close modal when history back
		if ob= Core.defaultRouter
			_historyBackClose= ob.whenBack ->
				res 'close'
				return 
		# DOM
		body= document.body
		body.classList.add 'modal-open'
		# Render
		element= _toHTMLElement html
		body.appendChild element
		# Promise
		_click= (event)->
			target= event.target
			if btn= target.closest('[d-value]')
				res btn.getAttribute 'd-value'
			else unless target.closest '.modal-body'
				if card= element.querySelector '.modal-body'
					Core.op(card).buzzOut()
			return
		element.addEventListener 'click', _click, false
		return
	# Add finnaly
	p= p.finally (res)->
		# Remove _close from Router
		_historyBackClose?.cancel()
		# Body classes
		body= document.body
		body.removeChild element if element?
		body.classList.remove 'modal-open' unless body.querySelector ':scope>.modal'
		return res
	# Add APIs
	p.body= element
	p.close= _close
	# Return
	return p

###* Alert message ###
alert: (message)->
	# Options
	if typeof message is 'object' and message then opt= message
	else opt= text: message
	# render
	opt.ok?= i18n.ok or 'ok'
	@modal Core.html.alert opt

###* Confirm message ###
confirm: (message)->
	# Options
	if typeof message is 'object' and message then opt= message
	else opt= text: message
	# render
	opt.ok ?= i18n.ok or 'ok'
	opt.cancel ?= i18n.cancel or 'Cancel'
	@modal Core.html.confirm opt
