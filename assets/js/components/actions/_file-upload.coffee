###*
 * File-upload
 * @example <div d-click="fileUpload {inputFileName}">
###
fileUpload: (event, args)->
	try
		# Get input
		currentTarget= event.currentTarget
		if inputName= args[1]
			throw "Missing parent form" unless parent= currentTarget.closest 'form'
			throw "Missing input file: #{inputName}" unless (inpFile= parent[inputName]) and inpFile.type is 'file'
		else
			throw 'Missing parent with class="f-cntrl"' unless parent= currentTarget.closest '.f-cntrl'
			throw "Missing input file" unless inpFile= parent.querySelector 'input[type=file]'
		# Get input file
		# reset files
		inpFile.value= ''
		# set on change
		inpFile.addEventListener 'change', @fileUploadChange.bind(this), {once: yes, passive: yes}
		inpFile.click()
	catch err
		@emit 'form-error', err
	return
###* This method is called when files are selected ###
fileUploadChange: (event)->
	try
		input= event.target
		# File list
		if fileLst= input[FILE_LIST_SYMB]
			fileLst.splice 0 unless input.multiple
		else
			fileLst= input[FILE_LIST_SYMB]= []
		# add files
		files= input.files
		len= files.length
		i= 0
		addedFiles= []
		`rt: //`
		while i < len
			file= files[i++]
			# continue if file already selected
			for f in fileLst when (f.type is file.type) and (f.size is file.size) and (f.lastModified is file.lastModified) and (f.name is file.name)
				`continue rt`
			# add to queue
			fileLst.push file
			addedFiles.push file
		# Create preview
		@filePreview input, fileLst, addedFiles
	catch err
		@emit 'form-error',
			element:	this
			form:		input.form
			error:		err
	return

###*
 * Default File preview
 * @example
 * 		d-preview	# Use default preview and lookup for '.files-preview' container
 * 		d-preview="cssSelector"			# lookup for 'cssSelector' container
 * 		d-preview-bg="cssSelector"		# lookup for 'cssSelector' and change it's background
###
filePreview: do ->
	# create preview for each file
	_createPreview= (component, input, previewContainer, file)->
		# Preview
		fContainer= component.filePreviewRender file
		# Convert to HTML element
		fContainer= _toHTMLElement fContainer if typeof fContainer is 'string'
		fContainer[FILE_LIST_SYMB]= {file:file, input: input}
		previewContainer.appendChild fContainer
		# Load image preview
		if file.type.startsWith('image/')
			_readFile(file).then (data)->
				component.filePreviewSrc fContainer, file, data
				return
		return
	# Interface
	return (input, files, addedFiles)->
		# SHOW PREVIEWS
		if input.hasAttribute 'd-preview'
			# Get container
			if selector= input.getAttribute('d-preview').trim()
				previewContainer= document.querySelector selector
			else
				previewContainer= input.closest('.f-cntrl').querySelector '.files-preview'
			# Add previews
			if previewContainer
				_emptyElement(previewContainer) unless input.multiple
				_createPreview this, input, previewContainer, file for file in addedFiles
		# BACKGROUND PREVIEW
		if (file= addedFiles[0]) and input.hasAttribute 'd-preview-bg'
			# Get target element
			if selector= input.getAttribute('d-preview-bg').trim()
				element= document.querySelector selector
			else
				element= input.closest('.f-cntrl').querySelector '.bg-preview'
			if element
				eClassList= element.classList
				eClassList.add 'loading'
				fileData= await _readFile file
				eClassList.remove 'loading'
				element.style.backgroundImage= "url(#{fileData})"
		return
###* Create file preview HTML with loading ###
filePreviewRender: (file)->
	return Core.html.filePreview {file: file}

###* file preview: show image ###
filePreviewSrc: (fContainer, file, fileData)->
	fContainer.classList.remove 'loading'
	if img= fContainer.querySelector('.img')
		img.style.backgroundImage= "url(#{fileData})"
	return

###* Reset input file preview ###
filePreviewReset: (input)->
	# SHOW PREVIEWS
	if input.hasAttribute 'd-preview'
		# Get container
		if selector= input.getAttribute('d-preview').trim()
			previewContainer= document.querySelector selector
		else
			previewContainer= input.closest('.f-cntrl').querySelector '.files-preview'
		# Empty container
		_emptyElement(previewContainer) if previewContainer
	# BACKGROUND PREVIEW
	if input.hasAttribute 'd-preview-bg'
		# Get target element
		if selector= input.getAttribute('d-preview-bg').trim()
			element= document.querySelector selector
		else
			element= input.closest('.f-cntrl').querySelector '.bg-preview'
		if element
			element.style.removeProperty 'backgroundImage'
	return

# Remove file from preview list
rmFile: (event, args)->
	target= event.realTarget
	while target
		if obj= target[FILE_LIST_SYMB]
			# Remove file
			queue= obj.input[FILE_LIST_SYMB]
			if ~(idx= queue.indexOf obj.file)
				queue.splice idx, 1
			# Remove from DOM
			target.parentNode.removeChild target
			break
		target= target.parentElement
	return
