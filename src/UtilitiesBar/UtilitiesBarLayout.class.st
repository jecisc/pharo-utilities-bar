"
I am a snapshot of the layout of a utilities bar (see UtilitiesBarMorph >> #layoutSnapshot): its active utilities, whether it is expanded and the proportions of the heights of its panels.

The utilities are identified by their titles because the bar instantiates new utilities each time it is recreated (reset, code change of a utility, change of settings). UtilitiesBarMorph class keeps the layout of the last closed bar to restore it in the next one.

Instance variables:
- activeTitles: the titles of the active utilities
- expanded: whether the bar was expanded
- proportions: a dictionary from utility titles to the proportions of the heights of their panels
"
Class {
	#name : 'UtilitiesBarLayout',
	#superclass : 'Object',
	#instVars : [
		'expanded',
		'proportions',
		'activeTitles'
	],
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'accessing' }
UtilitiesBarLayout >> activeTitles [

	^ activeTitles
]

{ #category : 'accessing' }
UtilitiesBarLayout >> activeTitles: aCollection [

	activeTitles := aCollection
]

{ #category : 'accessing' }
UtilitiesBarLayout >> expanded: aBoolean [

	expanded := aBoolean
]

{ #category : 'accessing' }
UtilitiesBarLayout >> isExpanded [

	^ expanded
]

{ #category : 'accessing' }
UtilitiesBarLayout >> proportions [

	^ proportions
]

{ #category : 'accessing' }
UtilitiesBarLayout >> proportions: aDictionary [

	proportions := aDictionary
]
