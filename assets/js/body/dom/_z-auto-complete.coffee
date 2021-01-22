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
		# Menu
		@setMenu @popup.querySelector '.results'
		# Remove popup from DOM when closed
		@on 'close', @_detach.bind this
		# Listeners
		@_keydown= @_keydown.bind this
		# Add keyup event listener
		element.addEventListener 'keydown', @_keydown, false
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
			# Link to DOM
			document.body.appendChild popupDiv
			# Open popup
			super.open()
			# Focus input
			if showInput and (input= popupDiv.querySelector('input.f-input'))
				input.focus()
				input.select()
		this # chain
	# 	this # chain
	###* keyup listener ###
	_keyup: (event)->
		super._keyup event
		# ---
		if event.keyCode not in [13, 27, 37, 38, 39, 40]
			@find event.target.value
		return
	###* Apply enter keyup ###
	_apply: (event)->
		input= event.target
		inpValue= input.value
		if obj= input[INPUT_COMPONENT_SYMB]
			item= obj.item
			if item.title is inpValue
				@done item
				return
		@done {id: null, title: inpValue}
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
	###* GET data by id ###
	getById: (id)->
		if data= @_cData
			return item for item in data.results when item.id is id
		return null
	###* set value by id ###
	setById: (id)->
		if item= @getById id
			@done item
		this # chain
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

	###* Done ###
	done: (item)->
		super.done {value: item.id, strValue: item.title, item: item}
		this # chain
	###* List up/down ###
	_up: (event, isUp)->
		li super._up(event, isUp)
		# Selected element
		if li and (input= event.target) and (item= @getById li.getAttribute 'd-value')
			input.value= item.title
			input[INPUT_COMPONENT_SYMB]= {value: item.id, item: item}
		return
