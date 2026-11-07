"
I test UtilitiesBarUtility.
"
Class {
	#name : 'UtilitiesBarUtilityTest',
	#superclass : 'TestCase',
	#category : 'UtilitiesBar-Tests',
	#package : 'UtilitiesBar-Tests'
}

{ #category : 'tests' }
UtilitiesBarUtilityTest >> testAvailableUtilitiesExcludeAbstractAndUnavailableUtilities [

	| utilityClasses |
	utilityClasses := UtilitiesBarUtility availableUtilities collect: [ :utility | utility class ].
	self deny: (utilityClasses includes: UtilitiesBarUtility).
	self deny: (utilityClasses includes: UtilitiesBarTestUtility)
]

{ #category : 'tests' }
UtilitiesBarUtilityTest >> testDefaultPriority [

	self assert: UtilitiesBarUtility new priority equals: 100
]

{ #category : 'tests' }
UtilitiesBarUtilityTest >> testDefaultTitleIsTheClassName [

	self assert: UtilitiesBarUtility new title equals: 'UtilitiesBarUtility'
]

{ #category : 'tests' }
UtilitiesBarUtilityTest >> testIsAbstract [

	self assert: UtilitiesBarUtility isAbstract.
	self deny: UtilitiesBarTestUtility isAbstract
]
