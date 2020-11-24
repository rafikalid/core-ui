###*
 * DropDown
 * @example
 * 		d-click="dropdown"
 * 		d-click="dropdown up"
 * 		d-click="dropdown down"
 * 		d-click="dropdown top"
 * 		d-click="dropdown top-right"
 *		...
###
dropdown: (event, args)->
	dropDownBtn= event.currentTarget
	# Create popup
	unless popupG= dropDownBtn[DROPDOWN_SYMB]
		if dropDownPopup= dropDownBtn.nextElementSibling
			popupG= dropDownBtn[DROPDOWN_SYMB]= new _Popup
				element:	dropDownBtn
				popup:		dropDownPopup
				onOpening:	(pos, pop)->
					dropDownBtn.classList.add 'active', 'caret-' + pos.split('-')[0]
					return
				onClose:	(pos, pop)->
					dropDownBtn.classList.remove 'active', 'caret-top', 'caret-right', 'caret-bottom', 'caret-left'
					return
		else
			throw new Error "Missing dropdown popup"
	# Toggle dropdown
	popupG.toggle()
	return
