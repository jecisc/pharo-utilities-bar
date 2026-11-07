# pharo-utilities-bar

[![CI](https://github.com/jecisc/pharo-utilities-bar/actions/workflows/ci.yml/badge.svg)](https://github.com/jecisc/pharo-utilities-bar/actions/workflows/ci.yml)

An utility to add some utilities in a collapsable panel in Pharo IDE

The bar is docked on the right edge of the world (or the left one, see the settings). Each utility adds a vertical tab to the bar, telling whether the utility is active. Clicking a tab shows or hides the panel of its utility, so several utilities can be displayed at the same time, stacked in the order of the tabs. Drag the separators between panels to share the height between them. The arrow at the top of the bar collapses the panels so that only the tabs remain visible, without changing which utilities are active. Maximized windows do not cover the bar.

The active utilities and the heights of their panels are kept when the bar is recreated.

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

Click the settings icon at the bottom of the bar to edit its settings in the bar itself. The changes are applied when clicking the Save button.

The same settings are in the Settings browser, `Appearance > Morphic > Utilities bar`, which is also where a hidden bar can be shown again:
- Show utilities bar
- Edge: right or left
- Panel width: the width of the panel displaying the selected utility. It can also be changed by dragging the inner edge of the opened panel

The bar can also be recreated with `UtilitiesBarMorph reset`.
