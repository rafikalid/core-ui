# ###*
#  * AUTO-COMPLETE
# ###
class AutoComplete extends _Popup
	constructor: (options)->
		# Checks
		throw new Error "Illegal arguments" unless arguments.length is 1
		super options
		@_data= null # if all data is loaded from the server
		@_cData= null # Current visible data
		@_uri=	null # JSON API URI
		@_jsonCall= null # json call
		@_useCache= on # use cache
		@_limit= null # limit visible results
		# Add attribute autocomplete="off"
		element= @element
		unless element.hasAttribute 'autocomplete'
			element.setAttribute 'autocomplete', 'off'
		# Create popup container
		unless options.popup
			tx= @_createPopup()
			tx= _toHTMLElement tx if typeof tx is 'string'
			@setPopup tx
		# Remove popup from DOM when closed
		@on 'close', @_detach.bind this
		# Listeners
		@_keyup= @_keyup.bind this
		@_keydown= @_keydown.bind this
		# Add keyup event listener
		element.addEventListener 'keydown', @_keydown, false
		element.addEventListener 'keyup', @_keyup, {capture: no, passive: yes}
		return
	###* Open  ###
	open: ->
		unless @_isOpen
			# Format popup
			element= @element
			isMobile=	innerWidth < MOBILE_WIDTH
			showInput=	isMobile or element.tagName isnt 'INPUT'
			popupDiv= @_popup
			throw new Error "Missing popup" unless popupDiv
			popupDiv.innerHTML= @_initPopup({element: element, isMobile: isMobile, showInput: showInput})
			# Events
			popupDiv.addEventListener 'click', @_itemClick.bind(this), {capture: no, passive: yes}
			# Link to DOM
			document.body.appendChild popupDiv
			# Open popup
			super.open()
			# Focus input
			if showInput and (input= popupDiv.querySelector('input.f-input'))
				# TODO: check why not working
				input.addEventListener 'keyup', @_keyup, {capture:no, passive: yes}
				input.focus()
				input.select()
		this # chain
	# ###* Close  ###
	# close: ->
	# 	this # chain
	###* keyup listener ###
	_keydown: (event)->
		event.preventDefault() if event.keyCode in [38, 40, 13]
		return
	_keyup: (event)->
		input= event.target
		switch event.keyCode
			when 13 # Enter
				@_apply input
			# when 27 # ESC
			# 	return # close popup
			when 37, 39 # Arrow left, Arrow right
				return # ignore
			when 38 # Arrow up
				@up(input)
			when 40 # Arrow down
				@down(input)
			else
				@find event.target.value
		return
	###* Apply enter keyup ###
	_apply: (input)->
		inpValue= input.value
		if obj= input[INPUT_COMPONENT_SYMB]
			item= obj.item
			if item.title is inpValue
				@done obj, item.title
				return
		@done null, inpValue
		return
	###* Find element ###
	find: (q)->
		try
			# Open the popup
			@open() unless @_isOpen
			resultContainer= @_popup.querySelector '.results'
			throw new Error "Missing result container on popup" unless resultContainer
			# Lookup
			q= q.trim().toLowerCase()
			if @_data
				data= @fromData q
			else
				data= await @fromServer q
			# Highlight
			@highlight data, q
		catch err
			return if err and err.aborted
			Core.fatalError 'AutoComplete', err
			data= {results: []}
		# Render results
		@_cData= data
		resultContainer.innerHTML= Core.html.autocompleteResults data
		# Adjust popup
		await @adjust()
		return
	###* Load data from server ###
	fromServer: (q)->
		# URL
		uri= @_uri
		throw new Error "Missing URI" unless uri
		uri= new URL uri
		uri.searchParams.set 'q', q
		limit= @_limit
		if limit
			uri.searchParams.set 'limit', limit
		else if q.length
			limit= AUTO_COMPLETE_LIMIT
			uri.searchParams.set 'limit', limit
		# Call
		@_jsonCall.abort() if @_jsonCall
		callOptions=
			id:		Core.defaultRouter?.id
			url:	uri
		if @_useCache
			call= Core.getJSONOnce callOptions
		else
			call= Core.getJSON callOptions
		@_jsonCall= call
		data= await call
		# Format data
		@formatData(data)
		# Check if final
		if data.partial is false
			@_data= data
			data.total= (r= data.results) and r.length or 0
			return @fromData(q)
		else
			return data
	###* From data ###
	fromData: (q)->
		items= @_data.results
		results= []
		if items and items.length
			# Limit results
			unless limit= @_limit
				limit= if q.length then AUTO_COMPLETE_LIMIT else Infinity
			foundStarts= 0
			# Search
			resultDocs= []
			if limit is Infinity
				for item in items when ~(idx= item.titleL.indexOf q)
					resultDocs.push {i: idx, item: item}
			else
				for item in items when ~(idx= item.titleL.indexOf q)
					resultDocs.push {i: idx, item: item}
					if idx is 0
						++foundStarts
						break if foundStarts >= limit
			# Sort by index asc
			resultDocs.sort (a, b)-> a.i - b.i
			# Result results
			i= 0
			len= resultDocs.length
			len= limit if len > limit
			while i < len
				results.push resultDocs[i++].item
		r= _assign {}, @_data
		r.results= results
		return r
	###* Format data ###
	formatData: (data)->
		if results= data.results
			for result, i in results
				# Convert
				if typeof result is 'string'
					results[i]= {
						id: result
						title: result
						titleL: result.toLowerCase()
						titleHTML: Core.escape result
					}
				else if result.title
					result.titleL= result.title.toLowerCase()
					result.titleHTML= Core.escape result.title
		return data
	###* escape HTML and Highlight selected query ###
	highlight: (data, q)->
		if (results= data.results) and (qLen= q.length)
			for result, i in results
				if titleL= result.titleL
					title= Core.escape result.title
					if ~(idx= titleL.indexOf q)
						title= "#{title.substr(0, idx)}<b>#{title.substr(idx, qLen)}</b>#{title.substr(idx + qLen)}"
					result.titleHTML= title
		return data
	###* @private create popup ###
	_createPopup: -> Core.html.popupAutocomplete()
	###* @private Init popup content ###
	_initPopup: (data)-> Core.html.autocompleteContent data
	###* Detach from DOM ###
	_detach: ->
		document.body.removeChild @_popup
		return
	```
	get uri(){return this._uri; }
	set uri(v){
		this._uri= new URL(v, Core.getBaseURL());
	}
	get cache(){return this._useCache; }
	set cache(v){
		if(typeof v === 'boolean') this._useCache= v
		else throw new Error("Expected boolean")
	}
	get limit(){return this._limit}
	set limit(v){
		if(v==null || (typeof v === 'number' && v > 0)) this._limit= v;
		else throw new Error("Expected positive non null Number")
	}
	get data(){ return this._data; }
	set data(v){
		if(v && v.results)
			this._data= this.formatData(v);
		else
			throw new Error("Illegal data format");
	}
	```
	###* When an item is clicked ###
	_itemClick: (event)->
		if element= event.target.closest '[d-value]'
			item= @getById element.getAttribute 'd-value'
			@done {value: item.id, item: item}, item.title
		return
	###* GET data by id ###
	getById: (id)->
		if data= @_cData
			return item for item in data.results when item.id is id
		return null
	###*
	 * GET item by title
	 * @used when validating field
	 * @return promise
	###
	getByTitle: (title)->
		title= title.trim().toLowerCase()
		# Lookup in selected fields
		if data= @_cData
			return item for item in data.results when item.titleL is title
		# Lookup in local data
		if data= @_data
			return item for item in data.results when item.titleL is title
		# Lookup in the server
		else
			# URL
			uri= @_uri
			throw new Error "Missing URI" unless uri
			uri= new URL uri
			uri.searchParams.set 'title', title
			# Call
			data= await Core.getJSON
				id:		Core.defaultRouter?.id
				url:	uri
			return data
		# Not found
		return null
	###* list up down ###
	up: (input)-> @_up input, yes
	down: (input)-> @_up input, no
	_up: (input, isUp)->
		return unless resultsDiv= @_popup.querySelector '.results'
		if li= resultsDiv.querySelector ':scope>.active'
			li.classList.remove 'active'
			if isUp
				if li is resultsDiv.firstElementChild
					li= resultsDiv.lastElementChild
				else
					li= li.previousElementSibling
			else
				if li is resultsDiv.lastElementChild
					li= resultsDiv.firstElementChild
				else
					li= li.nextElementSibling
		else
			li= if isUp then resultsDiv.lastElementChild else resultsDiv.firstElementChild
		# Set value
		if li
			li.classList.add 'active'
			if input
				item= @getById li.getAttribute 'd-value'
				input.value= item.title
				input[INPUT_COMPONENT_SYMB]= {value: item.id, item: item}
		return

	###* DONE ###
	done: (component, textValue)->
		element= @element
		element[INPUT_COMPONENT_SYMB]= component
		if element.formAction then element.value= textValue
		else input.innerText= strValue # otherwise (div, ...)
		# Close popup
		@close()
		return
