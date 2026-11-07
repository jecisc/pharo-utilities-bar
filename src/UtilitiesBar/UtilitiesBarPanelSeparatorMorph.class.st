"
I am the thin horizontal handle between two panels of a utilities bar (see UtilitiesBarMorph).
Dragging me moves height from one of the panels to the other one.
"
Class {
	#name : 'UtilitiesBarPanelSeparatorMorph',
	#superclass : 'Morph',
	#instVars : [
		'bar',
		'upperUtility',
		'lowerUtility'
	],
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'instance creation' }
UtilitiesBarPanelSeparatorMorph class >> bar: aUtilitiesBar above: anUpperUtility below: aLowerUtility [

	^ self new
		  setBar: aUtilitiesBar above: anUpperUtility below: aLowerUtility;
		  yourself
]

{ #category : 'event handling' }
UtilitiesBarPanelSeparatorMorph >> handlesMouseDown: anEvent [

	^ true
]

{ #category : 'event handling' }
UtilitiesBarPanelSeparatorMorph >> handlesMouseOver: anEvent [

	^ true
]

{ #category : 'initialization' }
UtilitiesBarPanelSeparatorMorph >> initialize [

	super initialize.
	self
		hResizing: #spaceFill;
		vResizing: #rigid;
		height: 4;
		color: self theme borderColor
]

{ #category : 'event handling' }
UtilitiesBarPanelSeparatorMorph >> mouseEnter: anEvent [

	anEvent hand showTemporaryCursor: Cursor resizeTop
]

{ #category : 'event handling' }
UtilitiesBarPanelSeparatorMorph >> mouseLeave: anEvent [

	anEvent hand showTemporaryCursor: nil
]

{ #category : 'event handling' }
UtilitiesBarPanelSeparatorMorph >> mouseMove: anEvent [

	bar resizePanelsAbove: upperUtility below: lowerUtility withSeparatorAt: anEvent position y
]

{ #category : 'initialization' }
UtilitiesBarPanelSeparatorMorph >> setBar: aUtilitiesBar above: anUpperUtility below: aLowerUtility [

	bar := aUtilitiesBar.
	upperUtility := anUpperUtility.
	lowerUtility := aLowerUtility
]
