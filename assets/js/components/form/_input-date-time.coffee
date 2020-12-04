###*
 * INPUT RANGE
###
INPUT_DATE_SPECIAL_ATTRS= ['pattern', 'weeks', 'min-span', 'max-span', 'multiple', 'range', 'view']
Component.defineInit 'input-date', class InputDate extends InputAbstract
	###* @private Get attributes ###
	_loadAttributes: ->
		@_setAttributes @_getAttributes(INPUT_DATE_SPECIAL_ATTRS)
		return
	###* @private Set attributes ###
	_setAttributes: (attributes)->
		@_attributes= attributes
		# attributes
		element= @element
		# Private attributes
		attrs= @_attrs=
			value:			null
			tmpValue:		null	# temp value when draging
			readonly:		!!attributes.readonly
			#
			min:	_parseDate attributes.min
			max:	_parseDate attributes.max
			#
			multiple:	element.hasAttribute 'multiple'
			range:		element.hasAttribute 'range'
			noHeader:	element.hasAttribute 'no-header'
			pattern:	null
			weeks:		element.hasAttribute 'weeks'
			minSpan: 	_strToMilliseconds element.getAttribute('min-span')
			maxSpan:	_strToMilliseconds element.getAttribute('max-span')
			# Params
			currentDate: null
			currentView: null
		# Check multiple and range
		throw new Error "DATE-PICKER>> Could not set 'multiple' and 'range' at the same time!" if attrs.range and attrs.multiple
		# Set
		@value= attributes.value or new Date()
		@pattern= element.getAttribute('pattern') or 'date'
		return
	###* Reload component html ###
	reload: ->
		# Check values
		@_fixValues()
		# render HTML
		cancelAnimationFrame @_raf if @_raf
		@_raf= requestAnimationFrame (t)=>
			@element.innerHTML= @_getHTML()
			@_getInput()[INPUT_COMPONENT_SYMB]= this # link hidden input to this component
			@_selectActiveDates(@_getActiveView())
			return
		return
	###* @private Get component html ###
	_getHTML: ->
		attrs= @_attrs
		inputAttrs= _assign {}, @_attributes
		inputAttrs.value= attrs.value
		inputAttrs.min= attrs.min
		inputAttrs.max= attrs.max
		Core.html.inputDate input: inputAttrs, attrs: attrs

	### GETTERS ###
	```
	get value(){ return this._attrs.value; }
	get pattern(){return this._attrs.pattern;}
	get multiple(){return this._attrs.multiple;}
	get range(){return this._attrs.range;}
	get min(){return this._attrs.min}
	get max(){return this._attrs.max}
	```

	###* Set value ###
	```
	set value(v){
		//# Checkes and format
		var selectedDates, ref, len, i, ref2;
		if(typeof v == 'string'){
			selectedDates= [];
			v= v.trim();
			if(v){
				ref= v.split(',');
				len= ref.length;
				for(i=0; i < len; i++)
					ref2= _parseDate(ref[i]);
					if(ref2 != null)
						selectedDates.push(ref2);
			}
		}
		else if(typeof v === 'number')
			selectedDates= Number.isFinite(v)? [new Date(v)] : []
		else if(v instanceof Date)
			selectedDates= [v]
		else if(_isArray(v) && v.each(e=> e instanceof Date))
			selectedDates= v.slice(0);
		else
			throw new Error('Illegal value: '+ v);
		//# Set
		this._attrs.value= selectedDates;
		this.reload(); //# Reload views
		// # this.emit('change');
	}
	set pattern(v){
		this._attrs.pattern= compileDatePattern(v);
		this._reinitVisibleViews();
	}
	set multiple(v){
		if(typeof v == 'boolean'){
			attrs= this._attrs
			attrs.multiple= v
			if(v) attrs.range= false
			this.reload() //# reload view
		}
		else throw new Error("Illegal value");
	}
	set range(v){
		if(typeof v == 'boolean'){
			attrs= this._attrs
			attrs.range= v
			if(v) attrs.range= false
			this.reload() //# reload view
		}
		else throw new Error("Illegal value");
	}
	set min(v){
		this._attrs.min= _parseDate(v);
		this.reload(); //# Reload views
	}
	set max(v){
		this._attrs.max= _parseDate(v);
		this.reload(); //# Reload views
	}
	```
	###* Fix values ###
	_fixValues: ->
		attrs=	@_attrs
		min=	attrs.min
		max=	attrs.max
		values=	attrs.value
		# min/max
		throw new Error "MAX is less than MIN!" if max and min and max < min
		# Value
		for v, i in values
			if min and v < min then values[i]= new Date(min)
			else if max and v > max then values[i]= new Date(max)
		# Current date
		attrs.currentDate= new Date(values[0]) or new Date()
		return

	###* Select visible views ###
	_reinitVisibleViews: ->
		attrs= @_attrs
		pattern= attrs.pattern
		# Load patterns
		reducedPatterns= new Set()
		reducedPatterns.add p.charAt(0).toLowerCase() for p in pattern.patterns
		# Visible views
		parentView= null
		datePatterns= i18n.datePatterns
		if reducedPatterns.has 'y'
			parentView= {parent: parentView, child: null, name: 'g-years'}
			lastChild= parentView= {parent: parentView, child: null, name: 'years'}
			startView= parentView
		if reducedPatterns.has 'm'
			lastChild= parentView= {parent: parentView, child: null, name: 'months', pattern: compileDatePattern datePatterns.year}
			startView= parentView
		if reducedPatterns.has('d')
			lastChild= parentView= {parent: parentView, child: null, name: 'days', pattern: compileDatePattern datePatterns.monthYear}
			startView= parentView
		if reducedPatterns.has('h') or reducedPatterns.has('i') or reducedPatterns.has('s')
			lastChild= parentView= {parent: parentView, child: null, name: 'time', pattern: compileDatePattern datePatterns.date}
			startView?= parentView
		# Complete view chain
		throw new Error "Illegal date format: #{pattern.source}" unless lastChild
		while parentView= lastChild.parent
			parentView.child= lastChild
			lastChild= parentView
		# save
		attrs.startView=	startView
		attrs.currentView=	startView
		return
	###* ACTION: Next ###
	go: (event, args)-> @_goToView args[1]
	###* ACTION: Select ###
	select: (event, args)->
		# element= event.currentTarget
		value= parseInt args[1]
		attrs= @_attrs
		currentView= attrs.currentView
		# set value
		# dateValue= attrs.value[0] # For now, we support only one selected date
		currentDate= attrs.currentDate
		switch currentView.name
			when 'years', 'g-years'
				# dateValue.setYear value
				currentDate.setYear value
			when 'months'
				# dateValue.setMonth value
				currentDate.setMonth value
			when 'days'
				# dateValue.setDate value
				currentDate.setDate value
			# when 'time'
			else
				throw new Error "Unimplemented type: #{currentView.name}"
		# Go to next view or trigger close
		if currentView.child
			@_goToView 'down'
		else
			@selectValue() # Validate value selection
		return
	###* AM/PM toggle ###
	toggleTT: (event, args)->
		element= event.currentTarget
		tt= element.closest('form').tt
		element.innerHTML= tt.value= if tt.value is 'AM' then 'PM' else 'AM'
		return
	###* Select current value ###
	selectValue: (event, args)->
		attrs= @_attrs
		return if attrs.readonly
		currentDate= attrs.currentDate
		# If from form
		if event
			form= event.target
			if inpt= form.h
				v= parseInt inpt.value
				if inpt= form.tt
					if inpt.value is 'AM'
						if v is 12 then v= 0
					else if v < 12
						v+= 12
				currentDate.setHours(v)
			currentDate.setMinutes(parseInt inpt.value) if inpt= form.i
			currentDate.setSeconds(parseInt inpt.value) if inpt= form.s
			currentDate.setMilliseconds(parseInt inpt.value) if inpt= form.ms
		# Save value
		values= attrs.value
		if attrs.range
			throw new Error "Range not implemented"
		else if attrs.multiple
			values.push new Date(currentDate)
		else
			values.splice 0
			values.push new Date(currentDate)
		# Show
		@_goToView('no')
		# Set to underline input
		@_getInput().value= values.join ','
		# value validated
		@_done()
		return
	###* @private Get active view ###
	_getActiveView: -> @element.getElementsByClassName('input-date-view')[0]
	###* @private CHANGE VIEW ###
	_goToView: (transition)->
		# create next month
		attrs= @_attrs
		currentView= attrs.currentView
		currentDate= attrs.currentDate
		# fix current view
		switch transition
			when 'up'
				pv= currentView.parent
			when 'down'
				pv= currentView.child
			when 'no' # No transition
				pv= currentView
			else
				pv= currentView
				# Next date
				isNext= transition is 'next'
				inc= if isNext then 1 else -1
				switch currentView.name
					when 'g-years'
						currentDate.setYear currentDate.getFullYear() + if isNext then 96 else -96
					when 'years'
						currentDate.setYear currentDate.getFullYear() + if isNext then 12 else -12
					when 'months'
						currentDate.setYear currentDate.getFullYear() + inc
					when 'days'
						currentDate.setMonth currentDate.getMonth() + inc
					when 'time'
						currentDate.setDate currentDate.getDate() + inc
					else
						throw new Error "Unimplemented type: #{currentView.name}"
		return unless pv # no more view
		currentView= attrs.currentView= pv

		# Create days view
		attrArg= {attrs:attrs}
		switch currentView.name
			when 'g-years'
				view= Core.html.inputDateGYears attrArg
			when 'years'
				view= Core.html.inputDateYears attrArg
			when 'months'
				view= Core.html.inputDateMonths attrArg
			when 'days'
				view= Core.html.inputDateDays attrArg
			when 'time'
				view= Core.html.inputDateTime attrArg
			else
				throw new Error "Unimplemented type: #{currentView.name}"
		view= _toHTMLElement view

		# append
		container= @element
		oldView= @_getActiveView()
		if transition is 'no'
			requestAnimationFrame (t)=>
				container.insertBefore view, oldView
				container.removeChild oldView
				# Highlight selected dates
				@_selectActiveDates(view)
				return
		else
			oldCss= "width:#{oldView.offsetWidth}px; height: #{oldView.offsetHeight}px; position: absolute; top: #{oldView.offsetTop}px; left: #{oldView.offsetLeft}px; background: inherit;"
			container.insertBefore view, oldView

			# Animation
			_animate= (el, keyframes)->
				el.style.cssText= oldCss
				el.animate(keyframes, {duration: 200, easing: 'ease'})
					.onfinish= ->
						container.removeChild oldView
						el.style.cssText= ''
						return
				return
			switch transition
				when 'up'
					_animate view,
						transform:	['scale(1.2)', '']
						opacity:	[0.2, 1]
				when 'down'
					_animate oldView,
						transform:	['', 'scale(1.2)']
						opacity:	[1, 0.2]
				when 'next'
					_animate view,
						transform:	['translate(20px, 0)', '']
						opacity:	[0.2, 1, 1]
				when 'prev'
					_animate view,
						transform:	['translate(-20px, 0)', '']
						opacity:	[0.2, 1, 1]
				else
					throw new Error "Unimplemented transition: #{transition}"
			# Update header and highlight selected dates
			header= view.previousElementSibling
			requestAnimationFrame (t)=>
				# Update header
				unless attrs.noHeader
					header2= _toHTMLElement Core.html.inputDateHeader(attrArg)
					viewContainer= header.parentNode
					viewContainer.insertBefore header2, header
					viewContainer.removeChild header
				# Highlight selected dates
				@_selectActiveDates(view)
				return
		return
	# Select active dates on the current view
	_selectActiveDates: (activeView)->
		# Get active view
		attrs= @_attrs
		currentView= attrs.currentView
		currentDate= attrs.currentDate
		minDate= attrs.min
		maxDate= attrs.max
		# Range
		if attrs.range
			throw new Error "Range not yeat implemented!"
		# signle or multiple dates
		else
			activeViewNodes= activeView.children
			activeViewNodesLen= activeViewNodes.length
			switch currentView.name
				when 'g-years'
					w= currentDate.getFullYear()
					for dt in attrs.value
						v= dt.getFullYear()
						index= ((v - w + 53)/12) >> 0
						if 0 <= index < activeViewNodesLen and (elC= activeViewNodes[index])
							elC= elC.classList
							elC.remove 'outline'
							elC.add 'primary'
					# Min date
					if minDate
						_disableLessThan activeViewNodes, ((minDate.getFullYear() - w + 53)/12)>>0
					if maxDate
						_disableGreaterThan activeViewNodes, ((maxDate.getFullYear() - w + 53)/12)>>0
				when 'years'
					w= currentDate.getFullYear()
					for dt in attrs.value
						v= dt.getFullYear()
						index= v - w + 5
						if 0 <= index < activeViewNodesLen and (elC= activeViewNodes[index])
							elC= elC.classList
							elC.remove 'flat'
							elC.add 'primary', 'crcl', 'lg', 'f-c'
					# Min date
					if minDate
						_disableLessThan activeViewNodes, (minDate.getFullYear() - w + 5)>>0
					if maxDate
						_disableGreaterThan activeViewNodes, (maxDate.getFullYear() - w + 5)>>0
				when 'months'
					year= currentDate.getFullYear()
					for dt in attrs.value when year is dt.getFullYear()
						if elC= activeViewNodes[dt.getMonth()]
							elC= elC.classList
							elC.remove 'flat'
							elC.add 'primary', 'crcl', 'lg', 'f-c'
					# Min date
					if minDate
						y= minDate.getFullYear()
						if y > year
							_disableAll activeViewNodes
						else if y is year
							_disableLessThan activeViewNodes, minDate.getMonth()
					# Max date
					if maxDate
						y= maxDate.getFullYear()
						if y < year
							_disableAll activeViewNodes
						else if y is year
							_disableGreaterThan activeViewNodes, maxDate.getMonth()
				when 'days'
					year= currentDate.getFullYear()
					month= currentDate.getMonth()
					for dt in attrs.value when year is dt.getFullYear() and month is dt.getMonth()
						if elC= activeViewNodes[6+dt.getDate()]
							elC= elC.classList
							elC.remove 'flat'
							elC.add 'primary', 'crcl', 'f-c'
					# Min date
					if minDate
						minYear= minDate.getFullYear()
						minMonth= minDate.getMonth()
						endIndex= 0
						# If some days will be disabled
						if year is minYear
							if month is minMonth
								endIndex= 5 + minDate.getDate()
							else if month < minMonth
								# Disable all
								endIndex= activeViewNodesLen - 1
						else if year < minYear
							# Disable all
							endIndex= activeViewNodesLen - 1
						# Disable
						i= 7
						while i <= endIndex
							activeViewNodes[i++].classList.add 'disabled'
					# Max date
					if maxDate
						maxYear= maxDate.getFullYear()
						maxMonth= maxDate.getMonth()
						startIndex= activeViewNodesLen
						if year is maxYear
							if month is maxMonth
								startIndex= 7 + maxDate.getDate()
							else if month > maxMonth
								# disable all
								startIndex= 7
						else if year > maxYear
							# disable all
							startIndex= 7
						# Disable
						i= startIndex
						while i < activeViewNodesLen
							activeViewNodes[i++].classList.add 'disabled'
				# when 'time'
				# 	console.log 'line'
				# 	# vievw= Core.html.inputDateTime attrArg
				# else
				# 	throw new Error "Unimplemented type: #{currentView.name}"
		return
	###* toString ###
	toString: ->
		values= []
		attrs= @_attrs
		pattern= attrs.pattern
		for v in attrs.value
			values.push pattern.format v
		return values.join ', '
