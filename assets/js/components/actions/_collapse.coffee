###*
 * Collapse
 * d-click="collapse"    # Means accordion
 * d-click="collapse in"
 * d-click="collapse out"
 * d-click="collapse toggle"
 * @example 1
 * <div d-click="collpase">Collapse next element</div>
 * <div> loremIpsum </div>
###
collapse: (event, args)->
	currentTarget= event.currentTarget
	currentTargetClassList= currentTarget.classList
	# target
	if args.length > 2
		selector= args.slice(2).join ' '
		if selector.startsWith ':scope'
			targetDiv= currentTarget.querySelector selector
		else
			targetDiv= document.querySelector selector
	else
		targetDiv= currentTarget.nextSibling
	if targetDiv
		targetDivOp= Core.op(targetDiv).stop()
		# Collapse
		switch args[1]
			when 'in'
				currentTargetClassList.add 'active'
				targetDivOp.slideDown()
			when 'out'
				currentTargetClassList.remove 'active'
				targetDivOp.slideDown()
			when 'toggle'
				targetDivOp.slideToggle currentTargetClassList.toggle('active')
			else # Accordion
				# Slide down current targetDiv
				isDown= currentTargetClassList.toggle('active')
				targetDivOp.slideToggle isDown
				# Hide other active accords
				if parent= targetDiv.parentNode
					# select active elements
					sibs= []
					for element in parent.querySelectorAll ':scope>.active[d-click^=collapse]' when element isnt currentTarget
						element.classList.remove 'active'
						sibs.push sib if sib= element.nextSibling
					# Slide up
					Core.op(sibs).slideUp()
	return
