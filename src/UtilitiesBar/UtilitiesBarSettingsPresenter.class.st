"
I am a form editing the settings of the utilities bar, displayed in the bar itself when clicking its settings icon (see UtilitiesBarSettingsUtility).

The changes are only applied when clicking the save button, so that unchecking the option showing the bar does not make it vanish while editing.

My model is the holder of the settings, answering and accepting #showUtilitiesBar, #edge and #contentWidth. It is the class side of UtilitiesBarMorph, except in the tests.
"
Class {
	#name : 'UtilitiesBarSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'settings',
		'showCheckBox',
		'edgeDropList',
		'widthInput',
		'saveButton'
	],
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'layout' }
UtilitiesBarSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 6;
		  add: showCheckBox expand: false;
		  add: (self labelled: 'Edge' with: edgeDropList) expand: false;
		  add: (self labelled: 'Panel width' with: widthInput) expand: false;
		  add: saveButton expand: false;
		  add: 'Changes are applied when saving.' expand: false;
		  add: 'A hidden bar can be shown again from the Settings' expand: false;
		  add: 'browser: Appearance > Morphic > Utilities bar.' expand: false;
		  yourself
]

{ #category : 'accessing' }
UtilitiesBarSettingsPresenter >> edgeDropList [

	^ edgeDropList
]

{ #category : 'initialization' }
UtilitiesBarSettingsPresenter >> initializePresenters [

	showCheckBox := self newCheckBox
		                label: 'Show utilities bar';
		                state: settings showUtilitiesBar;
		                yourself.
	edgeDropList := self newDropList
		                items: #( #right #left );
		                display: [ :edge | edge capitalized ];
		                selectItem: settings edge;
		                yourself.
	widthInput := self newNumberInput
		              beInteger;
		              number: settings contentWidth;
		              yourself.
	saveButton := self newButton
		              label: 'Save';
		              icon: (self iconNamed: #smallSave);
		              action: [ self save ];
		              yourself
]

{ #category : 'private' }
UtilitiesBarSettingsPresenter >> labelled: aString with: aPresenter [

	^ SpBoxLayout newLeftToRight
		  spacing: 4;
		  vAlignCenter;
		  add: aString width: 80;
		  add: aPresenter;
		  yourself
]

{ #category : 'actions' }
UtilitiesBarSettingsPresenter >> save [
	"Apply the edited settings. The width is applied first because changing the other settings may recreate the bar."

	settings
		contentWidth: widthInput number;
		edge: edgeDropList selectedItem;
		showUtilitiesBar: showCheckBox state
]

{ #category : 'accessing' }
UtilitiesBarSettingsPresenter >> saveButton [

	^ saveButton
]

{ #category : 'accessing - model' }
UtilitiesBarSettingsPresenter >> setModelBeforeInitialization: aSettingsHolder [

	settings := aSettingsHolder
]

{ #category : 'accessing' }
UtilitiesBarSettingsPresenter >> showCheckBox [

	^ showCheckBox
]

{ #category : 'accessing' }
UtilitiesBarSettingsPresenter >> widthInput [

	^ widthInput
]
