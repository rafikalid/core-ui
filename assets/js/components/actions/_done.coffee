###* Execute "done" action in popups ###
done: (event, args)->
	# check if inside popup
	element= event.target
	while element
		if popopArr= element[POPUP_SYMB]
			value= args[1]
			for popup in popopArr
				try
					popup.done {value: value}, value
				catch err
					Core.fatalError 'POPUP', err
			break
		element= element.parentElement
	return
