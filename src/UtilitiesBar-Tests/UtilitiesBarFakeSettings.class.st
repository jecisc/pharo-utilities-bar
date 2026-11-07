"
I replace the settings of the utilities bar (the class side of UtilitiesBarMorph) in the tests, so that saving settings in a test does not change the real bar.
"
Class {
	#name : 'UtilitiesBarFakeSettings',
	#superclass : 'Object',
	#instVars : [
		'showUtilitiesBar',
		'edge',
		'contentWidth'
	],
	#category : 'UtilitiesBar-Tests',
	#package : 'UtilitiesBar-Tests'
}

{ #category : 'accessing' }
UtilitiesBarFakeSettings >> contentWidth [

	^ contentWidth
]

{ #category : 'accessing' }
UtilitiesBarFakeSettings >> contentWidth: anInteger [

	contentWidth := anInteger
]

{ #category : 'accessing' }
UtilitiesBarFakeSettings >> edge [

	^ edge
]

{ #category : 'accessing' }
UtilitiesBarFakeSettings >> edge: aSymbol [

	edge := aSymbol
]

{ #category : 'accessing' }
UtilitiesBarFakeSettings >> showUtilitiesBar [

	^ showUtilitiesBar
]

{ #category : 'accessing' }
UtilitiesBarFakeSettings >> showUtilitiesBar: aBoolean [

	showUtilitiesBar := aBoolean
]
