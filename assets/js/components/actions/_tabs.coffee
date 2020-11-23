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
	tabsContainerClassList.add 'r'	# Add relative class
	# Cancel if active
	currentTab= event.realTarget.closest '.tab'
	return if (not currentTab) or currentTab.classList.contains 'active'
	# Active tab
	activeTab= tabsContainer.getElementsByClassName('tab active')[0]
	# Check tabs are initialized
	if tabsContainerClassList.contains 'tabs-enabled'
		tabBar= tabsContainer.getElementsByClassName('tabs-bar')[0]
	else
		tabsContainerClassList.add 'tabs-enabled'
		# add tab bar
		tabBar= document.createElement 'div'
		tabBar.className= 'tabs-bar'
		# Apply style
		if activeTab
			tabBar.style.cssText= "width: #{activeTab.offsetWidth}px; left: #{activeTab.offsetLeft}px"
		tabsContainer.appendChild tabBar
	# Disactivate previous active tab
	if activeTab
		activeTab.classList.remove 'active'
	# Enable clicked tab
	currentTab.classList.add 'active'
	# Get tab items
	if container= tabsContainer.parentNode
		tabItems= container.querySelectorAll ':scope>.tab-item'
		unless tabItems.length
			tabItems= container.querySelectorAll ':scope>*>.tab-item'
		# show body
		currentTabIndex= _elementIndexOf currentTab
		for item, i in tabItems
			if i is currentTabIndex then item.classList.add 'active'
			else item.classList.remove 'active'
	# Apply animation
	tabBar.style.cssText= "width: #{currentTab.offsetWidth}px; left: #{currentTab.offsetLeft}px"	
	return
