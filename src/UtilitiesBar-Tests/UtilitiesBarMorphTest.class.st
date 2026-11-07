"
I test UtilitiesBarMorph. The bar is placed in a fake world morph so that the real world is not affected.
"
Class {
	#name : 'UtilitiesBarMorphTest',
	#superclass : 'TestCase',
	#instVars : [
		'bar',
		'world',
		'firstUtility',
		'secondUtility'
	],
	#category : 'UtilitiesBar-Tests',
	#package : 'UtilitiesBar-Tests'
}

{ #category : 'running' }
UtilitiesBarMorphTest >> setUp [

	super setUp.
	world := Morph new
		         bounds: (0 @ 0 extent: 1000 @ 800);
		         yourself.
	firstUtility := UtilitiesBarTestUtility title: 'First' priority: 10.
	secondUtility := UtilitiesBarTestUtility title: 'Second' priority: 20.
	bar := UtilitiesBarMorph new
		       edge: #right;
		       utilities: {
				       secondUtility.
				       firstUtility };
		       yourself
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testActivateDisplaysThePanel [

	bar activate: secondUtility.
	self assert: bar isExpanded.
	self assert: (bar isDisplayed: secondUtility).
	self assert: ((bar contentOf: secondUtility) hasOwner: bar)
]

{ #category : 'tests - visibility' }
UtilitiesBarMorphTest >> testActivateNotifiesThatTheUtilityIsDisplayed [

	bar activate: firstUtility.
	self assert: firstUtility visibilityEvents asArray equals: #( #displayed ).
	self assertEmpty: secondUtility visibilityEvents
]

{ #category : 'tests - visibility' }
UtilitiesBarMorphTest >> testActivatingAnotherUtilityDoesNotNotifyTheDisplayedOnesAgain [

	bar activate: firstUtility.
	bar activate: secondUtility.
	self assert: firstUtility visibilityEvents asArray equals: #( #displayed )
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testActiveUtilitiesAreInTheOrderOfTheTabs [

	bar activate: secondUtility.
	bar activate: firstUtility.
	self assert: bar activeUtilities asArray equals: {
			firstUtility.
			secondUtility }
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testBoundsAvoidTopAndBottomDockingBars [

	| topBar bottomBar |
	topBar := DockingBarMorph new.
	world addMorph: topBar.
	topBar
		adhereToTop;
		bounds: (0 @ 0 extent: 1000 @ 20).
	bottomBar := DockingBarMorph new.
	world addMorph: bottomBar.
	bottomBar
		adhereToBottom;
		bounds: (0 @ 770 extent: 1000 @ 30).
	world addMorph: bar.
	self assert: bar top equals: 20.
	self assert: bar bottom equals: 770
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testBoundsOnLeftEdge [

	bar edge: #left.
	world addMorph: bar.
	bar expand.
	self assert: bar left equals: 0.
	self assert: bar width equals: bar tabStripWidth + bar contentWidth.
	self assert: bar height equals: 800
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testBoundsOnRightEdge [

	world addMorph: bar.
	self assert: bar right equals: 1000.
	self assert: bar top equals: 0.
	self assert: bar height equals: 800
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testBoundsStayOnEdgeWhenExpanded [

	world addMorph: bar.
	bar expand.
	self assert: bar right equals: 1000.
	self assert: bar width equals: bar tabStripWidth + bar contentWidth
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testCannotBeGrabbedByTheHand [

	| event |
	event := MouseButtonEvent new
		         setType: #mouseDown
		         position: 0 @ 0
		         which: MouseButtonEvent redButton
		         buttons: MouseButtonEvent redButton
		         hand: nil
		         stamp: 0.
	self assert: (bar handlesMouseDown: event)
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testChangingEdgeMovesTheBar [

	world addMorph: bar.
	bar edge: #left.
	self assert: bar left equals: 0.
	self assert: bar isAdheringToLeft.
	self deny: bar isAdheringToRight
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testClearAreaOfOwnerExcludesTheBar [

	world addMorph: bar.
	bar expand.
	self assert: world clearArea right equals: 1000 - bar width.
	bar edge: #left.
	self assert: world clearArea left equals: bar width
]

{ #category : 'tests - visibility' }
UtilitiesBarMorphTest >> testCollapseAndExpandNotifyTheVisibility [

	bar activate: firstUtility.
	bar collapse.
	bar expand.
	self assert: firstUtility visibilityEvents asArray equals: #( #displayed #hidden #displayed )
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testCollapseKeepsActiveUtilities [

	bar activate: secondUtility.
	bar collapse.
	self deny: bar isExpanded.
	self deny: (bar isDisplayed: secondUtility).
	self assert: (bar isActive: secondUtility)
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testContentIsBuiltOnlyOnce [

	bar
		activate: firstUtility;
		activate: secondUtility;
		deactivate: firstUtility;
		activate: firstUtility;
		collapse;
		expand.
	self assert: firstUtility buildCount equals: 1.
	self assert: secondUtility buildCount equals: 1
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testContentWidthDefaultsToTheSetting [

	self assert: bar contentWidth equals: UtilitiesBarMorph contentWidth
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testContentWidthIsAtLeastTheMinimum [

	bar contentWidth: 10.
	self assert: bar contentWidth equals: bar minimumContentWidth
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testDeactivateHidesThePanel [

	bar activate: firstUtility.
	bar activate: secondUtility.
	bar deactivate: firstUtility.
	self assert: bar isExpanded.
	self assert: bar activeUtilities asArray equals: { secondUtility }
]

{ #category : 'tests - visibility' }
UtilitiesBarMorphTest >> testDeactivateNotifiesThatTheUtilityIsHidden [

	bar activate: firstUtility.
	bar deactivate: firstUtility.
	self assert: firstUtility visibilityEvents asArray equals: #( #displayed #hidden )
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testDeactivatingLastActiveUtilityCollapses [

	bar activate: firstUtility.
	bar deactivate: firstUtility.
	self deny: bar isExpanded
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testDefaultHeightIsReplacedByResizing [

	firstUtility defaultHeight: 100.
	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	bar resizePanelsAbove: firstUtility below: secondUtility withSeparatorAt: bar top + 300.
	bar fullBounds.
	self assert: ((bar panelOf: firstUtility) height - 300) abs <= 1
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testDefaultHeightIsUsedUntilThePanelIsResized [

	firstUtility defaultHeight: 100.
	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	self assert: (bar panelOf: firstUtility) height equals: 100.
	self assert: (bar panelOf: secondUtility) bottom equals: bar bottom
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testDefaultHeightOfTheLastPanel [

	secondUtility defaultHeight: 100.
	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	self assert: (bar panelOf: secondUtility) height equals: 100.
	self assert: (bar panelOf: firstUtility) top equals: bar top
]

{ #category : 'tests - visibility' }
UtilitiesBarMorphTest >> testDeleteNotifiesThatTheDisplayedUtilitiesAreHidden [

	world addMorph: bar.
	bar activate: firstUtility.
	bar delete.
	self assert: firstUtility visibilityEvents asArray equals: #( #displayed #hidden )
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testExpandActivatesFirstUtilityWhenNoneIsActive [

	bar expand.
	self assert: bar isExpanded.
	self assert: bar activeUtilities asArray equals: { firstUtility }
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testExpandKeepsActiveUtilities [

	bar activate: secondUtility.
	bar collapse.
	bar expand.
	self assert: bar activeUtilities asArray equals: { secondUtility }
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testExpandWithoutUtilitiesStaysCollapsed [

	bar utilities: #(  ).
	bar expand.
	self deny: bar isExpanded.
	self assertEmpty: bar activeUtilities
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testIsAdheringToItsEdge [

	self assert: bar edgeToAdhereTo equals: #right.
	self assert: bar isAdheringToRight.
	self deny: bar isAdheringToLeft.
	self deny: bar isAdheringToTop.
	self deny: bar isAdheringToBottom.
	self assert: bar isDockingBar
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testIsCollapsedByDefault [

	self deny: bar isExpanded.
	self assertEmpty: bar activeUtilities.
	self assert: bar width equals: bar tabStripWidth
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testLastPanelTakesTheRemainingHeightWhenAllHaveADefaultHeight [

	firstUtility defaultHeight: 100.
	secondUtility defaultHeight: 100.
	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	self assert: (bar panelOf: firstUtility) height equals: 100.
	self assert: (bar panelOf: secondUtility) bottom equals: bar bottom
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testLayoutIgnoresMissingUtilities [

	| newBar |
	bar activate: firstUtility.
	newBar := UtilitiesBarMorph new
		          edge: #right;
		          utilities: #(  );
		          restoreLayout: bar layoutSnapshot;
		          yourself.
	self deny: newBar isExpanded.
	self assertEmpty: newBar activeUtilities
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testLayoutIsRestoredInANewBar [

	| newBar newFirstUtility newSecondUtility |
	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	bar resizePanelsAbove: firstUtility below: secondUtility withSeparatorAt: (bar panelOf: firstUtility) bottom + 100.
	newFirstUtility := UtilitiesBarTestUtility title: 'First' priority: 10.
	newSecondUtility := UtilitiesBarTestUtility title: 'Second' priority: 20.
	newBar := UtilitiesBarMorph new
		          edge: #right;
		          utilities: {
				          newFirstUtility.
				          newSecondUtility };
		          restoreLayout: bar layoutSnapshot;
		          yourself.
	self assert: newBar isExpanded.
	self assert: newBar activeUtilities asArray equals: {
			newFirstUtility.
			newSecondUtility }.
	self assert: (newBar proportionOf: newFirstUtility) equals: (bar proportionOf: firstUtility)
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testLayoutKeepsActiveUtilitiesOfACollapsedBar [

	| newBar newSecondUtility |
	bar activate: secondUtility.
	bar collapse.
	newSecondUtility := UtilitiesBarTestUtility title: 'Second' priority: 20.
	newBar := UtilitiesBarMorph new
		          edge: #right;
		          utilities: { newSecondUtility };
		          restoreLayout: bar layoutSnapshot;
		          yourself.
	self deny: newBar isExpanded.
	self assert: (newBar isActive: newSecondUtility)
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testPanelCanBeSmallerThanTheMinimumHeightOfItsContent [

	| panel |
	firstUtility minimumContentHeight: 300.
	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	bar resizePanelsAbove: firstUtility below: secondUtility withSeparatorAt: bar top.
	bar fullBounds.
	panel := bar panelOf: firstUtility.
	self assert: (panel height - bar minimumPanelHeight) abs <= 1.
	self assert: panel top equals: bar top.
	self assert: (bar contentOf: firstUtility) bottom <= panel bottom
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testPanelHeightsAreSharedEquallyByDefault [

	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	self assert: ((bar panelOf: firstUtility) height - (bar panelOf: secondUtility) height) abs <= 1
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testPanelProportionsAreKeptWhenTheBarHeightChanges [

	| ratio |
	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	bar resizePanelsAbove: firstUtility below: secondUtility withSeparatorAt: (bar panelOf: firstUtility) bottom + 100.
	bar fullBounds.
	ratio := (bar panelOf: firstUtility) height / (bar panelOf: secondUtility) height.
	world extent: 1000 @ 500.
	bar updateBounds.
	bar fullBounds.
	self assert: ((bar panelOf: firstUtility) height / (bar panelOf: secondUtility) height - ratio) abs < 0.05
]

{ #category : 'tests - visibility' }
UtilitiesBarMorphTest >> testRemovedUtilityIsNotifiedAsHidden [

	bar activate: firstUtility.
	bar activate: secondUtility.
	bar utilities: { secondUtility }.
	self assert: firstUtility visibilityEvents asArray equals: #( #displayed #hidden )
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testRemovingAllActiveUtilitiesCollapses [

	bar activate: secondUtility.
	bar utilities: { firstUtility }.
	self deny: bar isExpanded.
	self assertEmpty: bar activeUtilities
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testResizeContentFromHandleOnLeftEdge [

	bar edge: #left.
	world addMorph: bar.
	bar expand.
	bar resizeContentWithHandleAt: 300.
	self assert: bar contentWidth equals: 300.
	self assert: bar left equals: 0.
	self assert: bar width equals: bar tabStripWidth + 300
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testResizeContentFromHandleOnRightEdge [

	world addMorph: bar.
	bar expand.
	bar resizeContentWithHandleAt: 700.
	self assert: bar contentWidth equals: 300.
	self assert: bar right equals: 1000.
	self assert: bar width equals: bar tabStripWidth + 300
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testResizeContentIsLimitedByTheAvailableWidth [

	world addMorph: bar.
	bar expand.
	bar resizeContentWithHandleAt: 0.
	self assert: bar contentWidth equals: bar maximumContentWidth.
	self assert: bar left >= (world left + bar minimumFreeWidth)
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testResizeContentIsLimitedByTheMinimumWidth [

	world addMorph: bar.
	bar expand.
	bar resizeContentWithHandleAt: 990.
	self assert: bar contentWidth equals: bar minimumContentWidth
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testSaveContentWidthStoresItInTheSettings [

	| previousWidth |
	previousWidth := UtilitiesBarMorph contentWidth.
	[
		bar contentWidth: previousWidth + 50.
		bar saveContentWidth.
		self assert: UtilitiesBarMorph contentWidth equals: previousWidth + 50 ] ensure: [ UtilitiesBarMorph contentWidth: previousWidth ]
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testSeparatorDragKeepsAMinimumHeight [

	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	bar resizePanelsAbove: firstUtility below: secondUtility withSeparatorAt: bar top.
	bar fullBounds.
	self assert: ((bar panelOf: firstUtility) height - bar minimumPanelHeight) abs <= 1
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testSeparatorDragMovesHeightBetweenNeighbours [

	| firstHeight secondHeight |
	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	firstHeight := (bar panelOf: firstUtility) height.
	secondHeight := (bar panelOf: secondUtility) height.
	bar resizePanelsAbove: firstUtility below: secondUtility withSeparatorAt: (bar panelOf: firstUtility) bottom + 100.
	bar fullBounds.
	self assert: ((bar panelOf: firstUtility) height - (firstHeight + 100)) abs <= 1.
	self assert: ((bar panelOf: secondUtility) height - (secondHeight - 100)) abs <= 1
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testSettingsAreDisplayedBelowTheUtilities [

	bar toggleSettings.
	bar activate: secondUtility.
	self assert: bar isShowingSettings.
	self assert: bar activeUtilities asArray equals: {
			secondUtility.
			bar settingsUtility }
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testSettingsAreHiddenByDefault [

	self deny: bar isShowingSettings
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testSettingsStayDisplayedWhenUtilitiesChange [

	bar toggleSettings.
	bar utilities: { firstUtility }.
	self assert: bar isShowingSettings
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testTabClickedOnActiveUtilityDeactivatesIt [

	bar activate: firstUtility.
	bar activate: secondUtility.
	bar tabClicked: firstUtility.
	self assert: bar activeUtilities asArray equals: { secondUtility }
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testTabClickedOnActiveUtilityOfACollapsedBarExpandsIt [

	bar activate: firstUtility.
	bar collapse.
	bar tabClicked: firstUtility.
	self assert: bar isExpanded.
	self assert: (bar isActive: firstUtility)
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testTabClickedOnInactiveUtilityActivatesIt [

	bar activate: firstUtility.
	bar tabClicked: secondUtility.
	self assert: bar activeUtilities asArray equals: {
			firstUtility.
			secondUtility }
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testToggleExpanded [

	bar toggleExpanded.
	self assert: bar isExpanded.
	bar toggleExpanded.
	self deny: bar isExpanded
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testToggleSettingsDisplaysThem [

	bar toggleSettings.
	self assert: bar isExpanded.
	self assert: bar isShowingSettings.
	self assert: ((bar contentOf: bar settingsUtility) hasOwner: bar)
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testToggleSettingsTwiceHidesThem [

	bar activate: firstUtility.
	bar toggleSettings.
	bar toggleSettings.
	self deny: bar isShowingSettings.
	self assert: bar isExpanded
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testUtilitiesAreSortedByPriorityThenTitle [

	| thirdUtility |
	thirdUtility := UtilitiesBarTestUtility title: 'Another' priority: 20.
	bar utilities: {
			secondUtility.
			thirdUtility.
			firstUtility }.
	self assert: bar utilities asArray equals: {
			firstUtility.
			thirdUtility.
			secondUtility }
]

{ #category : 'tests - panels' }
UtilitiesBarMorphTest >> testUtilityActivatedAfterAResizeGetsAnAverageShare [

	| thirdUtility |
	thirdUtility := UtilitiesBarTestUtility title: 'Third' priority: 30.
	bar utilities: {
			firstUtility.
			secondUtility.
			thirdUtility }.
	world addMorph: bar.
	bar activate: firstUtility.
	bar activate: secondUtility.
	bar fullBounds.
	bar resizePanelsAbove: firstUtility below: secondUtility withSeparatorAt: bar top + 300.
	bar activate: thirdUtility.
	bar fullBounds.
	self assert: ((bar panelOf: thirdUtility) height - (bar height / 3)) abs < 10
]
