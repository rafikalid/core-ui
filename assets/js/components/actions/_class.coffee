# Toggle class
toggleClass: (event, args)->
	cl= event.currentTarget.classList
	i= 1
	len= args.length
	while i < len
		cl.toggle args[i++]
	return
