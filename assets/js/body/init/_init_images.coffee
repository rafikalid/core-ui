###* LAOD IMAGE ONCE VISIBLE ###
_imageViewPortObserver= (entries, observer)->
	for entry in entries
		target= entry.target
		observer.unobserve target
		target.src= v if v= target.getAttribute 'd-src'
		target.srcset= v if v= target.getAttribute 'd-srcset'
		if v= target.getAttribute 'd-src-bg'
			target.style.backgroundImage= "url(#{v})"
	return
# Load images when visible
_initDOMImages= (container)->
	try
		images= container.querySelectorAll '.i-img'
		if images.length
			# Create observer
			observerOptions=
				rootMargin: '40px' # tolerate to load image once near viewport
				threshold: 0
			observer= new IntersectionObserver _imageViewPortObserver, observerOptions
			# Observe each image
			for img in images
				img.classList.remove 'i-img'
				# Init observer
				observer.observe img
	catch err
		Core.error 'INIT-IMAGES', err
	return
