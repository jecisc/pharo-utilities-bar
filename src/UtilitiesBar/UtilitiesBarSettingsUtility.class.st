"
I am the utility displaying the settings of the utilities bar (see UtilitiesBarSettingsPresenter).
I have no tab: the bar toggles my panel with its settings icon.
"
Class {
	#name : 'UtilitiesBarSettingsUtility',
	#superclass : 'UtilitiesBarUtility',
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'testing' }
UtilitiesBarSettingsUtility class >> isAvailable [
	"I have no tab: the bar displays me through its settings icon."

	^ false
]

{ #category : 'building' }
UtilitiesBarSettingsUtility >> newPresenter [

	^ UtilitiesBarSettingsPresenter on: UtilitiesBarMorph
]

{ #category : 'accessing' }
UtilitiesBarSettingsUtility >> title [

	^ 'Settings'
]
