"
I am the thin vertical handle on the inner edge of the content panel of a utilities bar (see UtilitiesBarMorph).
Dragging me resizes the content panel. When the drag ends, the new width is saved in the settings so that it is kept by the next bars.
"
Class {
	#name : 'UtilitiesBarResizeHandleMorph',
	#superclass : 'Morph',
	#instVars : [
		'bar'
	],
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'instance creation' }
UtilitiesBarResizeHandleMorph class >> for: aUtilitiesBar [

	^ self new
		  bar: aUtilitiesBar;
		  yourself
]

{ #category : 'accessing' }
UtilitiesBarResizeHandleMorph >> bar: aUtilitiesBar [

	bar := aUtilitiesBar
]

{ #category : 'event handling' }
UtilitiesBarResizeHandleMorph >> handlesMouseDown: anEvent [

	^ true
]

{ #category : 'event handling' }
UtilitiesBarResizeHandleMorph >> handlesMouseOver: anEvent [

	^ true
]

{ #category : 'initialization' }
UtilitiesBarResizeHandleMorph >> initialize [

	super initialize.
	self
		hResizing: #rigid;
		vResizing: #spaceFill;
		width: 4;
		color: self theme borderColor
]

{ #category : 'event handling' }
UtilitiesBarResizeHandleMorph >> mouseEnter: anEvent [

	anEvent hand showTemporaryCursor: Cursor resizeLeft
]

{ #category : 'event handling' }
UtilitiesBarResizeHandleMorph >> mouseLeave: anEvent [

	anEvent hand showTemporaryCursor: nil
]

{ #category : 'event handling' }
UtilitiesBarResizeHandleMorph >> mouseMove: anEvent [

	bar resizeContentWithHandleAt: anEvent position x
]

{ #category : 'event handling' }
UtilitiesBarResizeHandleMorph >> mouseUp: anEvent [

	bar saveContentWidth
]
