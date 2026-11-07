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
		'buildCount'
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
]

{ #category : 'accessing' }
UtilitiesBarTestUtility >> buildCount [

	^ buildCount
]

{ #category : 'initialization' }
UtilitiesBarTestUtility >> initialize [

	super initialize.
	buildCount := 0.
	priority := 100.
	title := 'Test'
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
