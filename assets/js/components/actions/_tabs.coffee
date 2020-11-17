###*
 * Tabs
 * @example
 * <div d-click="tabs">
 *		<div class="tab">tab1</div>
 *		<div class="tab">tab2</div>
 *		<div class="tab">tab3</div>
 * </div>
 * <!-- tab-items cound be in the same parent or inside a sub container -->
 * <div class="tab-item">item 1</div>
 * <div class="tab-item">item 2</div>
 * <div class="tab-item">item 3</div>
###
tabs: (event, args)->
	tabsContainer= event.currentTarget
	tabsContainerClassList= tabsContainer.classList
	# Cancel if active
	currentTab= event.realTarget.closest '.tab'
	return if (not currentTab) or currentTab.classList.has 'active'
	# Active tab
	activeTab= tabsContainer.querySelector('.tab.active')
	# Check tabs are initialized
	if tabsContainerClassList.has 'tabs-enabled'
		tabBar= tabsContainer.querySelector '.tabs-bar'
	else
		tabsContainerClassList.add 'tabs-enabled'
		# add tab bar
		tabBar= document.createElement 'div'
		tabBar.className= 'tabs-bar'
		# Apply style
		if activeTab
			barStyle= tabBar.style
			barStyle.width= "#{activeTab.offsetWidth}px"
			barStyle.left= "#{activeTab.offsetLeft}px"
		tabsContainer.appendChild tabBar
	# Get tab items
	tabItems= tabsContainer.querySelectorAll ':scope>.tabItems'
	unless tabItems.length
		tabItems= tabsContainer.querySelector ':scope>*>.tabItems'
	# Disactivate previous active tab
	if activeTab
		activeTab.classList.remove 'active'
		if tabItem= tabItems[_elementIndexOf activeTab]
			tabItem.classList.add 'hidden'
	# Enable clicked tab
	currentTab.classList.add 'active'
	if tabItem= tabItems[_elementIndexOf currentTab]
		tabItem.classList.add 'hidden'
	# Apply animation
	anim.remove tabBar # stop previous animation
	anim
		targets:	tabBar
		width:		activeTab.offsetWidth
		left:		activeTab.offsetLeft
	return
