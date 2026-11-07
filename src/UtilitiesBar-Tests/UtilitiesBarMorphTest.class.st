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

{ #category : 'tests' }
UtilitiesBarMorphTest >> testCollapse [

	bar expand.
	bar collapse.
	self deny: bar isExpanded.
	self assert: bar displayedContent isNil.
	self assert: bar selectedUtility identicalTo: firstUtility
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testContentIsBuiltOnlyOnce [

	bar
		selectUtility: firstUtility;
		selectUtility: secondUtility;
		selectUtility: firstUtility;
		collapse;
		expand.
	self assert: firstUtility buildCount equals: 1.
	self assert: secondUtility buildCount equals: 1
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testExpandSelectsFirstUtility [

	bar expand.
	self assert: bar isExpanded.
	self assert: bar selectedUtility identicalTo: firstUtility.
	self assert: bar displayedContent isNotNil
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testExpandWithoutUtilitiesStaysCollapsed [

	bar utilities: #(  ).
	bar expand.
	self deny: bar isExpanded.
	self assert: bar selectedUtility isNil
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

{ #category : 'tests' }
UtilitiesBarMorphTest >> testIsCollapsedByDefault [

	self deny: bar isExpanded.
	self assert: bar selectedUtility isNil.
	self assert: bar displayedContent isNil.
	self assert: bar width equals: bar tabStripWidth
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testSelectUtilityDisplaysItsContent [

	bar selectUtility: secondUtility.
	self assert: bar isExpanded.
	self assert: bar selectedUtility identicalTo: secondUtility.
	self assert: (bar displayedContent hasOwner: bar)
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testSettingUtilitiesForgetsRemovedSelectedUtility [

	bar selectUtility: secondUtility.
	bar utilities: { firstUtility }.
	self deny: bar isExpanded.
	self assert: bar selectedUtility isNil
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testTabClickedOnOtherUtilitySelectsIt [

	bar selectUtility: firstUtility.
	bar tabClicked: secondUtility.
	self assert: bar isExpanded.
	self assert: bar selectedUtility identicalTo: secondUtility
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testTabClickedOnSelectedUtilityCollapses [

	bar selectUtility: firstUtility.
	bar tabClicked: firstUtility.
	self deny: bar isExpanded.
	bar tabClicked: firstUtility.
	self assert: bar isExpanded
]

{ #category : 'tests' }
UtilitiesBarMorphTest >> testToggleExpanded [

	bar toggleExpanded.
	self assert: bar isExpanded.
	bar toggleExpanded.
	self deny: bar isExpanded
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
