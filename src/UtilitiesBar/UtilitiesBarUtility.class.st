"
I am the abstract superclass of the utilities displayed in the utilities bar (see UtilitiesBarMorph).
Each available concrete subclass of mine adds a tab to the bar. Clicking the tab shows or hides a panel with the content I build.

To add a new utility, subclass me and implement:
- #title: the label of the tab (defaults to the class name)
- #newPresenter: answers the Spec presenter to display in the bar. Utilities based on Morphic can override #buildContent instead
- #priority (optional): utilities are sorted by ascending priority, then by title, until the user reorders the tabs by dragging them
- #defaultHeight (optional): the height in pixels of the panel until the user resizes it. Without it, the panel shares the height of the bar with the other ones
- #displayed and #hidden (optional): the bar sends them when the panel of the utility becomes visible and when it stops being visible (deactivated, bar collapsed or deleted). Use them to only do costly work, such as following a source of updates, while the utility is visible

The bar is rebuilt automatically when a utility class is added, removed or when one of its methods changes.

A utility can hide itself from the bar by overriding the class side method #isAvailable (for example when a dependency it needs is missing).
"
Class {
	#name : 'UtilitiesBarUtility',
	#superclass : 'Object',
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'accessing' }
UtilitiesBarUtility class >> availableUtilities [
	"Answer an instance of each utility that should be displayed in the utilities bar."

	^ self allSubclasses
		  select: [ :utilityClass | utilityClass isAvailable ]
		  thenCollect: [ :utilityClass | utilityClass new ]
]

{ #category : 'testing' }
UtilitiesBarUtility class >> isAbstract [

	^ self == UtilitiesBarUtility
]

{ #category : 'testing' }
UtilitiesBarUtility class >> isAvailable [
	"Answer whether the utility should be displayed in the utilities bar. Override to hide a utility, for example when a dependency it needs is missing."

	^ self isAbstract not
]

{ #category : 'building' }
UtilitiesBarUtility >> buildContent [
	"Answer the morph to display in the utilities bar when the utility is selected. It is built once and kept while the bar is alive."

	^ self newPresenter build
]

{ #category : 'accessing' }
UtilitiesBarUtility >> defaultHeight [
	"Answer the height in pixels of the panel of the utility until the user resizes it, or nil to share the height of the bar with the other panels. Useful for small utilities."

	^ nil
]

{ #category : 'events' }
UtilitiesBarUtility >> displayed [
	"The panel of the utility became visible in the utilities bar. Override to start work that is only useful while the utility is visible, such as following a source of updates."

	
]

{ #category : 'events' }
UtilitiesBarUtility >> hidden [
	"The panel of the utility stopped being visible in the utilities bar: the utility was deactivated, the bar was collapsed or deleted. Override to stop the work started in #displayed."

	
]

{ #category : 'building' }
UtilitiesBarUtility >> newPresenter [
	"Answer the Spec presenter displaying the utility."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
UtilitiesBarUtility >> priority [
	"Answer a number used to order the tabs of the utilities bar. Utilities with the lowest priority come first."

	^ 100
]

{ #category : 'accessing' }
UtilitiesBarUtility >> title [
	"Answer the label of the tab of the utility."

	^ self class name
]
