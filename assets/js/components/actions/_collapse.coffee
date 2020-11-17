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
	if target= event.realTarget.nextSibling
		targetClassList= target.classList
		# cancel any active animation
		anim.remove target
		# Collapse
		switch args[1]
			when 'in'
				targetClassList.add 'active'
				targetHeight= '100%'
			when 'out'
				targetClassList.add 'active'
				targetHeight= 0
			when 'toggle'
				if target.classList.toggle 'active'
					targetHeight= '100%'
				else
					targetHeight= 0
			else # Accordion
				targetHeight= '100%'
				# Hide other active accords
				if parent= target.parentNode
					for element in parent.querySelectorAll ':scope>.active' when element isnt target
						element.classList.remove 'active'
						if sib= element.nextSibling
							anim.remove sib
							anime {targets: sib, height: 0}
		# do open
		anime
			targets:	target
			height:		targetHeight
	return
