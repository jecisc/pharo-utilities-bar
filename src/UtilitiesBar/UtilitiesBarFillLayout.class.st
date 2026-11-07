"
I give all the bounds of a morph to its submorphs, whatever their minimum size.

The utilities bar uses me for the container of the content of each panel (see UtilitiesBarMorph >> #newContentContainerFor:). Spec presenters report a minimum size and a table layout never makes a morph smaller than it, so a panel could not be shrunk below the minimum of its content: the content overflowed on the next panel. With me, the container has no minimum (the inherited #minExtentOf:in: answers 0@0), the content takes the size of the container, and the container clips what does not fit.
"
Class {
	#name : 'UtilitiesBarFillLayout',
	#superclass : 'LayoutPolicy',
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'layout' }
UtilitiesBarFillLayout >> layout: aMorph in: newBounds [

	aMorph submorphsDo: [ :submorph | submorph bounds: newBounds ]
]
