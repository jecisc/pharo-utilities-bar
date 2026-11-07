# pharo-utilities-bar
An utility to add some utilities in a collapsable panel in Pharo IDE

The bar is docked on the right edge of the world (or the left one, see the settings). Each utility adds a vertical tab to the bar. Clicking a tab displays its utility; clicking it again, or clicking the arrow at the top of the bar, collapses the bar so that only the tabs remain visible. Maximized windows do not cover the bar.

## Installation

```smalltalk
Metacello new
	githubUser: 'jecisc' project: 'pharo-utilities-bar' commitish: 'main' path: 'src';
	baseline: 'UtilitiesBar';
	load
```

## Adding a utility

Subclass `UtilitiesBarUtility` and answer a Spec presenter. The bar is updated as soon as the class is created or changed.

```smalltalk
UtilitiesBarUtility << #MyUtility
	package: 'MyPackage'

MyUtility >> title
	^ 'My utility'

MyUtility >> newPresenter
	^ SpTextPresenter new
		text: 'Hello';
		yourself
```

Optionally:
- override `#priority` to order the tabs (lowest first, 100 by default)
- override `#buildContent` to answer a Morph instead of a Spec presenter
- override `UtilitiesBarUtility class >> #isAvailable` to hide a utility

## Settings

In the Settings browser, `Appearance > Morphic > Utilities bar`:
- Show utilities bar
- Edge: right or left

The bar can also be recreated with `UtilitiesBarMorph reset`.
