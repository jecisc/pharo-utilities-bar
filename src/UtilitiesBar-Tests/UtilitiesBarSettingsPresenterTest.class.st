"
I test UtilitiesBarSettingsPresenter on fake settings.
"
Class {
	#name : 'UtilitiesBarSettingsPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'settings',
		'presenter'
	],
	#category : 'UtilitiesBar-Tests',
	#package : 'UtilitiesBar-Tests'
}

{ #category : 'running' }
UtilitiesBarSettingsPresenterTest >> setUp [

	super setUp.
	settings := UtilitiesBarFakeSettings new
		            showUtilitiesBar: true;
		            edge: #right;
		            contentWidth: 400;
		            yourself.
	presenter := UtilitiesBarSettingsPresenter on: settings
]

{ #category : 'tests' }
UtilitiesBarSettingsPresenterTest >> testChangesAreNotAppliedBeforeSaving [

	presenter showCheckBox state: false.
	presenter edgeDropList selectItem: #left.
	presenter widthInput number: 500.
	self assert: settings showUtilitiesBar.
	self assert: settings edge equals: #right.
	self assert: settings contentWidth equals: 400
]

{ #category : 'tests' }
UtilitiesBarSettingsPresenterTest >> testFieldsDisplayTheCurrentSettings [

	self assert: presenter showCheckBox state.
	self assert: presenter edgeDropList selectedItem equals: #right.
	self assert: presenter widthInput number equals: 400
]

{ #category : 'tests' }
UtilitiesBarSettingsPresenterTest >> testSaveAppliesTheChanges [

	presenter showCheckBox state: false.
	presenter edgeDropList selectItem: #left.
	presenter widthInput number: 500.
	presenter save.
	self deny: settings showUtilitiesBar.
	self assert: settings edge equals: #left.
	self assert: settings contentWidth equals: 500
]
