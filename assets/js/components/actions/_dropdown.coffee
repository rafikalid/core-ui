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
		# Get next element
		if dropDownPopup= args[1]
			dropDownPopup= document.getElementById dropDownPopup
		else
			dropDownPopup= dropDownBtn.nextElementSibling
		# Drop down
		if dropDownPopup
			popupG= dropDownBtn[DROPDOWN_SYMB]= new _Popup
				element:	dropDownBtn
				popup:		dropDownPopup
			popupG.on 'opening', (data)->
				cl= dropDownBtn.classList
				cl.add 'active'
				if pos= data.position
					cl.add 'caret-' + pos.split('-')[0]
				return
			popupG.on 'close', (data)->
				dropDownBtn.classList.remove 'active', 'caret-top', 'caret-right', 'caret-bottom', 'caret-left'
				return
		else
			throw new Error "Missing dropdown popup"
	# Toggle dropdown
	popupG.toggle()
	return
