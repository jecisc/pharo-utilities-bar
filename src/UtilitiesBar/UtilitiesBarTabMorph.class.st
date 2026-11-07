"
I am the tab of a utility in a utilities bar (see UtilitiesBarMorph).

Clicking me shows or hides the panel of my utility. Pressing the mouse on me and moving it further than #dragThreshold drags me instead: the bar shows where I will be dropped, and releasing the mouse moves my utility there.
"
Class {
	#name : 'UtilitiesBarTabMorph',
	#superclass : 'Morph',
	#instVars : [
		'bar',
		'utility',
		'dragStart',
		'dragging'
	],
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'instance creation' }
UtilitiesBarTabMorph class >> for: aUtility in: aUtilitiesBar [

	^ self new
		  setUtility: aUtility bar: aUtilitiesBar;
		  yourself
]

{ #category : 'accessing' }
UtilitiesBarTabMorph >> dragThreshold [
	"The distance in pixels the mouse must move while pressed to start dragging me instead of clicking me."

	^ 5
]

{ #category : 'event handling' }
UtilitiesBarTabMorph >> handlesMouseDown: anEvent [

	^ true
]

{ #category : 'initialization' }
UtilitiesBarTabMorph >> initialize [

	super initialize.
	dragging := false
]

{ #category : 'event handling' }
UtilitiesBarTabMorph >> mouseDown: anEvent [

	dragStart := anEvent position.
	dragging := false
]

{ #category : 'event handling' }
UtilitiesBarTabMorph >> mouseMove: anEvent [

	dragStart ifNil: [ ^ self ].
	(dragging or: [ (anEvent position distanceTo: dragStart) > self dragThreshold ]) ifFalse: [ ^ self ].
	dragging := true.
	bar showTabDropIndicatorFor: utility at: anEvent position
]

{ #category : 'event handling' }
UtilitiesBarTabMorph >> mouseUp: anEvent [
	"A release without drag is a click."

	| wasDragging |
	wasDragging := dragging.
	dragStart := nil.
	dragging := false.
	wasDragging ifFalse: [ ^ bar tabClicked: utility ].
	bar hideTabDropIndicator.
	bar moveUtility: utility toIndex: (bar tabIndexFor: utility droppedAt: anEvent position)
]

{ #category : 'initialization' }
UtilitiesBarTabMorph >> setUtility: aUtility bar: aUtilitiesBar [

	utility := aUtility.
	bar := aUtilitiesBar
]
