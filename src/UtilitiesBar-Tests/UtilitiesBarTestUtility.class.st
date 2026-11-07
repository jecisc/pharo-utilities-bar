"
I am a utility used by the tests of the utilities bar.
I am not available so I never appear in the real bar: tests instantiate me directly.
I count how many times my content was built.
"
Class {
	#name : 'UtilitiesBarTestUtility',
	#superclass : 'UtilitiesBarUtility',
	#instVars : [
		'title',
		'priority',
		'buildCount',
		'visibilityEvents',
		'minimumContentHeight'
	],
	#category : 'UtilitiesBar-Tests',
	#package : 'UtilitiesBar-Tests'
}

{ #category : 'testing' }
UtilitiesBarTestUtility class >> isAvailable [

	^ false
]

{ #category : 'instance creation' }
UtilitiesBarTestUtility class >> title: aString priority: anInteger [

	^ self new
		  title: aString;
		  priority: anInteger;
		  yourself
]

{ #category : 'building' }
UtilitiesBarTestUtility >> buildContent [

	buildCount := buildCount + 1.
	^ Morph new
		  minHeight: (minimumContentHeight ifNil: [ 2 ]);
		  yourself
]

{ #category : 'accessing' }
UtilitiesBarTestUtility >> buildCount [

	^ buildCount
]

{ #category : 'events' }
UtilitiesBarTestUtility >> displayed [

	visibilityEvents add: #displayed
]

{ #category : 'events' }
UtilitiesBarTestUtility >> hidden [

	visibilityEvents add: #hidden
]

{ #category : 'initialization' }
UtilitiesBarTestUtility >> initialize [

	super initialize.
	buildCount := 0.
	priority := 100.
	title := 'Test'.
	visibilityEvents := OrderedCollection new
]

{ #category : 'accessing' }
UtilitiesBarTestUtility >> minimumContentHeight: anInteger [
	"Make my content report a minimum height, as Spec presenters do."

	minimumContentHeight := anInteger
]

{ #category : 'accessing' }
UtilitiesBarTestUtility >> priority [

	^ priority
]

{ #category : 'accessing' }
UtilitiesBarTestUtility >> priority: anInteger [

	priority := anInteger
]

{ #category : 'accessing' }
UtilitiesBarTestUtility >> title [

	^ title
]

{ #category : 'accessing' }
UtilitiesBarTestUtility >> title: aString [

	title := aString
]

{ #category : 'accessing' }
UtilitiesBarTestUtility >> visibilityEvents [

	^ visibilityEvents
]
