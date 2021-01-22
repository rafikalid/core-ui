# Slide down element
_slideDown= (element, options)->
	element[HIDDEN_SYMB]= no	# flag: element is visible
	element.style.removeProperty 'height'
	element.classList.remove 'hidden', 'h'
	size= element.offsetHeight
	options= _assign({duration: Core.ANIM_FAST, easing: 'ease'}, options)
	return element.animate({height: [0, size+'px']}, options);

# Slideup
_slideUp= (element, options)->
	element[HIDDEN_SYMB]= yes	# flag: element is hidden
	options= _assign({duration: Core.ANIM_FAST, easing: 'ease'}, options)
	anim= element.animate({height: [ element.offsetHeight+'px' , 0]}, options)
	anim.finished.then ->
		element.classList.add 'h'
		return
	return anim

# Animations wrapper
class _AnimWrapper
	constructor: (animations)->
		@_a= animations
		return
	```
	get length(){return this._a.length}
	get currentTime(){return this._a.currentTime}
	get finished(){ return Promise.all(this._a.map((a)=> a.finished)) }
	```
