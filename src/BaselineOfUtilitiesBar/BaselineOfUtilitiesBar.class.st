"
I am the baseline of the project pharo-utilities-bar, adding a collapsible bar of utilities on an edge of the Pharo world.

Load it with:

Metacello new
	githubUser: 'jecisc' project: 'pharo-utilities-bar' commitish: 'main' path: 'src';
	baseline: 'UtilitiesBar';
	load

Groups:
- Core: the utilities bar
- Tests: the tests of the utilities bar
- default: Core and Tests
"
Class {
	#name : 'BaselineOfUtilitiesBar',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfUtilitiesBar',
	#package : 'BaselineOfUtilitiesBar'
}

{ #category : 'baselines' }
BaselineOfUtilitiesBar >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'UtilitiesBar';
				package: 'UtilitiesBar-Tests' with: [ spec requires: #( 'UtilitiesBar' ) ].
			spec
				group: 'Core' with: #( 'UtilitiesBar' );
				group: 'Tests' with: #( 'UtilitiesBar-Tests' );
				group: 'default' with: #( 'Core' 'Tests' ) ]
]
