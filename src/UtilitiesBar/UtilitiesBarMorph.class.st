"
I am a bar docked on the right or left edge of the world, displaying utilities (see UtilitiesBarUtility).

I am made of a strip of vertical tabs, one per utility, and of a stack of panels displaying the active utilities. The button at the top of the strip collapses the panels so that I only take the width of the strip, without changing which utilities are active.
A tab tells whether its utility is active: an active tab is highlighted, even when I am collapsed. Clicking the tab of an inactive utility activates it and expands me. Clicking the tab of a displayed utility deactivates it; clicking the tab of an active utility while I am collapsed expands me. I collapse when the last active utility is deactivated.
The panels are stacked in the order of the tabs. Each panel has a header with the title of its utility and a button to deactivate it. The utilities are told when their panel becomes visible or hidden, so that they can stop costly work while hidden.
Dragging the separators between panels (see UtilitiesBarPanelSeparatorMorph) shares the height between them. The heights are kept as proportions so that they follow my height.
Dragging the handle on the inner edge of the panels (see UtilitiesBarResizeHandleMorph) resizes them, and the new width is saved in the settings.

The settings icon at the bottom of the strip toggles a panel with my settings below the other panels (see UtilitiesBarSettingsUtility).

The world considers me as a docking bar so that maximized windows do not cover me.

The settings (from my settings icon or from the Settings browser > Appearance > Morphic > Utilities bar) control whether I am displayed, on which edge and the width of my panels.

When I am recreated (reset, code change of a utility, change of settings), my layout is restored in the new bar (see UtilitiesBarLayout).

Public API (class side):
- #open / #closeAll / #reset: open, close or recreate the bar of the current world, keeping its layout
- #showUtilitiesBar: / #edge: change the settings and recreate the bar if they changed
- #contentWidth: changes the width of the panels of the opened bars without recreating them

Instance variables:
- utilities: the utilities I display, sorted by priority then title
- activeUtilities: the utilities whose panels are displayed when I am expanded
- expanded: whether the panels are displayed
- edge: the edge of my owner I adhere to, #right or #left
- contents: cache of the content morphs already built for each utility, so that their state is kept when they are hidden
- contentWidth: the width of the panels, resize handle included
- proportions: the share of my height given to the panel of each utility, 1 by default
- panels: the panel morph of each displayed utility
- panelStack: the morph holding the displayed panels, nil when I am collapsed
- settingsUtility: the utility displaying my settings, created the first time they are displayed
- notifiedUtilities: the utilities I last told that they are displayed (see UtilitiesBarUtility >> #displayed and #hidden)
"
Class {
	#name : 'UtilitiesBarMorph',
	#superclass : 'Morph',
	#instVars : [
		'utilities',
		'expanded',
		'edge',
		'contents',
		'contentWidth',
		'settingsUtility',
		'proportions',
		'panels',
		'panelStack',
		'activeUtilities',
		'notifiedUtilities'
	],
	#classVars : [
		'ContentWidth',
		'Edge',
		'Layout',
		'ShowUtilitiesBar'
	],
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'opening' }
UtilitiesBarMorph class >> closeAll [
	"Close the utilities bars of the current world, keeping the layout of the last one to restore it in the next bar."

	<script>
	self openedBars do: [ :bar |
			Layout := bar layoutSnapshot.
			bar delete ]
]

{ #category : 'private' }
UtilitiesBarMorph class >> codeChanged: aCodeAnnouncement [

	(aCodeAnnouncement classAffected instanceSide inheritsFrom: UtilitiesBarUtility) ifTrue: [ UIManager default defer: [ self reset ] ]
]

{ #category : 'settings' }
UtilitiesBarMorph class >> contentWidth [
	"Answer the width in pixels of the panel displaying the selected utility."

	^ ContentWidth ifNil: [ ContentWidth := 400 ]
]

{ #category : 'settings' }
UtilitiesBarMorph class >> contentWidth: anInteger [
	"Resize the content panel of the opened bars without recreating them so that their state is kept."

	ContentWidth := anInteger.
	self openedBars do: [ :bar | bar contentWidth: anInteger ]
]

{ #category : 'settings' }
UtilitiesBarMorph class >> edge [
	"Answer the edge of the world the bar adheres to, #right or #left."

	^ Edge ifNil: [ Edge := #right ]
]

{ #category : 'settings' }
UtilitiesBarMorph class >> edge: aSymbol [
	"The bar is recreated only when the edge changes, so that it is not collapsed for nothing."

	self edge = aSymbol ifTrue: [ ^ self ].
	Edge := aSymbol.
	self reset
]

{ #category : 'class initialization' }
UtilitiesBarMorph class >> initialize [

	self install.
	self reset
]

{ #category : 'actions' }
UtilitiesBarMorph class >> install [
	"Recreate the bar each time the code of a utility changes so that it is always up to date."

	self codeChangeAnnouncer unsubscribe: self.
	self codeChangeAnnouncer weak when: ClassAdded , ClassRemoved , MethodAdded , MethodModified , MethodRemoved send: #codeChanged: to: self
]

{ #category : 'opening' }
UtilitiesBarMorph class >> open [
	"Open the utilities bar in the current world if the settings ask for it, with the layout of the last closed bar."

	<script>
	| bar |
	self showUtilitiesBar ifFalse: [ ^ self ].
	bar := self new.
	Layout ifNotNil: [ :savedLayout | bar restoreLayout: savedLayout ].
	bar openInWorld: self currentWorld
]

{ #category : 'opening' }
UtilitiesBarMorph class >> openedBars [
	"Answer the utilities bars of the current world."

	^ self currentWorld submorphs select: [ :morph | morph isUtilitiesBar ]
]

{ #category : 'class initialization' }
UtilitiesBarMorph class >> reset [
	"Recreate the utilities bar, for example to take into account new utilities or settings."

	<script>
	self closeAll.
	self open
]

{ #category : 'settings' }
UtilitiesBarMorph class >> showUtilitiesBar [

	^ ShowUtilitiesBar ifNil: [ ShowUtilitiesBar := true ]
]

{ #category : 'settings' }
UtilitiesBarMorph class >> showUtilitiesBar: aBoolean [

	self showUtilitiesBar = aBoolean ifTrue: [ ^ self ].
	ShowUtilitiesBar := aBoolean.
	self reset
]

{ #category : 'settings' }
UtilitiesBarMorph class >> utilitiesBarSettingsOn: aBuilder [

	<systemsettings>
	(aBuilder group: #utilitiesBar)
		parentName: #morphic;
		label: 'Utilities bar';
		description: 'A bar docked on an edge of the world, displaying utilities in collapsible tabs.';
		with: [
				(aBuilder setting: #showUtilitiesBar)
					target: self;
					label: 'Show utilities bar';
					defaultValue: true;
					description: 'Whether the utilities bar should be shown or not.'.
				(aBuilder pickOne: #edge)
					target: self;
					label: 'Edge';
					defaultValue: #right;
					domainValues: {
							('Right' -> #right).
							('Left' -> #left) };
					description: 'The edge of the world the utilities bar adheres to.'.
				(aBuilder setting: #contentWidth)
					target: self;
					label: 'Panel width';
					defaultValue: 400;
					description: 'The width in pixels of the panel displaying the selected utility. It can also be changed by dragging the inner edge of the panel.' ]
]

{ #category : 'actions' }
UtilitiesBarMorph >> activate: aUtility [
	"Display the panel of aUtility with the panels of the other active utilities."

	activeUtilities add: aUtility.
	expanded := true.
	self rebuild
]

{ #category : 'accessing' }
UtilitiesBarMorph >> activeUtilities [
	"Answer the active utilities in the order of the tabs, the settings last. Their panels are displayed when I am expanded."

	| active |
	active := utilities select: [ :utility | self isActive: utility ].
	(self isActive: self settingsUtility) ifFalse: [ ^ active ].
	^ active copyWith: self settingsUtility
]

{ #category : 'private - layout' }
UtilitiesBarMorph >> availableArea [
	"Answer the area of my owner that is not covered by the docking bars adhering to its top or bottom."

	| top bottom |
	top := owner top.
	bottom := owner bottom.
	owner dockingBars do: [ :dockingBar |
			dockingBar isAdheringToTop ifTrue: [ top := top max: dockingBar bottom ].
			dockingBar isAdheringToBottom ifTrue: [ bottom := bottom min: dockingBar top ] ].
	^ owner left @ top corner: owner right @ bottom
]

{ #category : 'actions' }
UtilitiesBarMorph >> collapse [
	"Hide the content panel so that only the tab strip is displayed."

	expanded := false.
	self rebuild
]

{ #category : 'private - building' }
UtilitiesBarMorph >> contentOf: aUtility [

	^ contents at: aUtility ifAbsentPut: [
			  aUtility buildContent
				  hResizing: #spaceFill;
				  vResizing: #spaceFill;
				  yourself ]
]

{ #category : 'accessing' }
UtilitiesBarMorph >> contentWidth [

	^ contentWidth
]

{ #category : 'accessing' }
UtilitiesBarMorph >> contentWidth: anInteger [
	"The content width includes the resize handle and is never smaller than the minimum."

	contentWidth := anInteger max: self minimumContentWidth.
	self updateBounds
]

{ #category : 'actions' }
UtilitiesBarMorph >> deactivate: aUtility [
	"Hide the panel of aUtility. I collapse if it was the last active utility."

	activeUtilities remove: aUtility ifAbsent: [ ].
	activeUtilities ifEmpty: [ expanded := false ].
	self rebuild
]

{ #category : 'submorphs - add/remove' }
UtilitiesBarMorph >> delete [
	"The displayed utilities are told that they are hidden so that they can stop their work."

	notifiedUtilities do: [ :utility | utility hidden ].
	notifiedUtilities := IdentitySet new.
	super delete
]

{ #category : 'change reporting' }
UtilitiesBarMorph >> displayExtentChanged [

	self updateBounds
]

{ #category : 'accessing' }
UtilitiesBarMorph >> edge [

	^ edge
]

{ #category : 'accessing' }
UtilitiesBarMorph >> edge: aSymbol [
	"aSymbol is #right or #left."

	edge := aSymbol.
	self rebuild
]

{ #category : 'accessing' }
UtilitiesBarMorph >> edgeToAdhereTo [

	^ edge
]

{ #category : 'actions' }
UtilitiesBarMorph >> expand [
	"Display the panels of the active utilities, activating the first utility if none is active."

	activeUtilities ifEmpty: [
			utilities ifEmpty: [ ^ self ].
			activeUtilities add: utilities first ].
	expanded := true.
	self rebuild
]

{ #category : 'event handling' }
UtilitiesBarMorph >> handlesMouseDown: anEvent [
	"Handling the mouse down events, even to do nothing, prevents the hand from grabbing me when the mouse is pressed and moved over me."

	^ true
]

{ #category : 'initialization' }
UtilitiesBarMorph >> initialize [

	super initialize.
	expanded := false.
	edge := self class edge.
	contents := IdentityDictionary new.
	contentWidth := self class contentWidth.
	activeUtilities := IdentitySet new.
	notifiedUtilities := IdentitySet new.
	proportions := IdentityDictionary new.
	panels := IdentityDictionary new.
	self
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #rigid;
		vResizing: #rigid;
		color: Color transparent;
		utilities: UtilitiesBarUtility availableUtilities
]

{ #category : 'testing' }
UtilitiesBarMorph >> isActive: aUtility [

	^ activeUtilities includes: aUtility
]

{ #category : 'testing' }
UtilitiesBarMorph >> isAdheringToBottom [

	^ false
]

{ #category : 'testing' }
UtilitiesBarMorph >> isAdheringToLeft [

	^ edge = #left
]

{ #category : 'testing' }
UtilitiesBarMorph >> isAdheringToRight [

	^ edge = #right
]

{ #category : 'testing' }
UtilitiesBarMorph >> isAdheringToTop [

	^ false
]

{ #category : 'testing' }
UtilitiesBarMorph >> isDisplayed: aUtility [

	^ self isExpanded and: [ self isActive: aUtility ]
]

{ #category : 'testing' }
UtilitiesBarMorph >> isDockingBar [
	"Being a docking bar makes the world exclude me from its clear area."

	^ true
]

{ #category : 'testing' }
UtilitiesBarMorph >> isExpanded [

	^ expanded
]

{ #category : 'testing' }
UtilitiesBarMorph >> isShowingSettings [

	^ self isDisplayed: self settingsUtility
]

{ #category : 'testing' }
UtilitiesBarMorph >> isUtilitiesBar [

	^ true
]

{ #category : 'layout' }
UtilitiesBarMorph >> layoutSnapshot [
	"Answer a snapshot of my layout, to restore it in another bar (see #restoreLayout:)."

	^ UtilitiesBarLayout new
		  activeTitles: (self activeUtilities collect: [ :utility | utility title ] as: Array);
		  expanded: expanded;
		  proportions: (proportions associations collect: [ :association | association key title -> association value ] as: Dictionary);
		  yourself
]

{ #category : 'resizing' }
UtilitiesBarMorph >> maximumContentWidth [
	"Answer the largest content width keeping some of the world visible next to me."

	^ self availableArea width - self tabStripWidth - self minimumFreeWidth max: self minimumContentWidth
]

{ #category : 'resizing' }
UtilitiesBarMorph >> minimumContentWidth [

	^ 150
]

{ #category : 'resizing' }
UtilitiesBarMorph >> minimumFreeWidth [
	"Answer the width of the world that must stay visible next to me when the content panel is resized."

	^ 100
]

{ #category : 'resizing' }
UtilitiesBarMorph >> minimumPanelHeight [

	^ 60
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newCloseButtonFor: aUtility [

	^ (self iconNamed: #windowClose) asMorph
		  setBalloonText: 'Hide the panel';
		  on: #mouseUp send: #value to: [ self deactivate: aUtility ];
		  yourself
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newContentContainerFor: aUtility [
	"The content of a utility is displayed in a container without minimum size so that its panel can be smaller than the minimum of the content (see UtilitiesBarFillLayout). What does not fit is clipped."

	^ Morph new
		  layoutPolicy: UtilitiesBarFillLayout new;
		  clipSubmorphs: true;
		  hResizing: #spaceFill;
		  vResizing: #spaceFill;
		  color: Color transparent;
		  addMorph: (self contentOf: aUtility);
		  yourself
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newHeaderFor: aUtility [
	"Answer a row with the title of aUtility and a button to hide its panel."

	^ Morph new
		  changeTableLayout;
		  listDirection: #leftToRight;
		  cellPositioning: #center;
		  cellInset: 4;
		  hResizing: #spaceFill;
		  vResizing: #shrinkWrap;
		  color: Color transparent;
		  addMorphBack: ((StringMorph contents: aUtility title)
				   color: self theme textColor;
				   emphasis: TextEmphasis bold emphasisCode;
				   yourself);
		  addMorphBack: (Morph new
				   color: Color transparent;
				   hResizing: #spaceFill;
				   extent: 0 @ 0;
				   yourself);
		  addMorphBack: (self newCloseButtonFor: aUtility);
		  yourself
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newPanelFor: aUtility [

	^ Morph new
		  changeTableLayout;
		  listDirection: #topToBottom;
		  cellInset: 4;
		  layoutInset: 4;
		  hResizing: #spaceFill;
		  vResizing: #rigid;
		  color: Color transparent;
		  addMorphBack: (self newHeaderFor: aUtility);
		  addMorphBack: (self newContentContainerFor: aUtility);
		  yourself
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newPanelStack [
	"Answer a column of the panels of the active utilities, separated by handles to resize them."

	| active |
	active := self activeUtilities.
	panelStack := Morph new
		              changeTableLayout;
		              listDirection: #topToBottom;
		              hResizing: #spaceFill;
		              vResizing: #spaceFill;
		              color: self theme backgroundColor;
		              yourself.
	active doWithIndex: [ :utility :index |
			index > 1 ifTrue: [ panelStack addMorphBack: (UtilitiesBarPanelSeparatorMorph bar: self above: (active at: index - 1) below: utility) ].
			panelStack addMorphBack: (panels at: utility put: (self newPanelFor: utility)) ].
	^ panelStack
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newSettingsButton [

	^ (self iconNamed: #configuration) asMorph
		  setBalloonText: 'Settings of the utilities bar';
		  on: #mouseUp send: #toggleSettings to: self;
		  yourself
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newTabFor: aUtility [
	"The tab of an active utility is highlighted, even when I am collapsed. The tab of an inactive one has a faded label."

	| isActive |
	isActive := self isActive: aUtility.
	^ Morph new
		  changeTableLayout;
		  hResizing: #shrinkWrap;
		  vResizing: #shrinkWrap;
		  layoutInset: self tabInset;
		  cornerStyle: #rounded;
		  color: (isActive
				   ifTrue: [ self theme selectionColor ]
				   ifFalse: [ Color transparent ]);
		  borderStyle: (BorderStyle width: 1 color: self theme borderColor);
		  addMorph: (self verticalLabel: aUtility title color: (isActive
						    ifTrue: [ self theme textColor ]
						    ifFalse: [ self theme textColor alpha: 0.5 ])) asMorph;
		  setBalloonText: (isActive
				   ifTrue: [ aUtility title , ': click to hide' ]
				   ifFalse: [ aUtility title , ': click to show' ]);
		  on: #mouseUp send: #value to: [ self tabClicked: aUtility ];
		  yourself
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newTabStrip [

	| strip |
	strip := Morph new
		         changeTableLayout;
		         listDirection: #topToBottom;
		         cellPositioning: #topCenter;
		         cellInset: 4;
		         layoutInset: self tabStripInset;
		         hResizing: #rigid;
		         vResizing: #spaceFill;
		         width: self tabStripWidth;
		         color: self theme lightBackgroundColor;
		         addMorphBack: self newToggleButton;
		         yourself.
	utilities do: [ :utility | strip addMorphBack: (self newTabFor: utility) ].
	^ strip
		  addMorphBack: (Morph new
				   color: Color transparent;
				   hResizing: #spaceFill;
				   vResizing: #spaceFill;
				   yourself);
		  addMorphBack: self newSettingsButton;
		  yourself
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newToggleButton [

	^ (self iconNamed: self toggleIconName) asMorph
		  setBalloonText: (self isExpanded
				   ifTrue: [ 'Collapse the utilities' ]
				   ifFalse: [ 'Expand the utilities' ]);
		  on: #mouseUp send: #toggleExpanded to: self;
		  yourself
]

{ #category : 'submorphs - accessing' }
UtilitiesBarMorph >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	self updateBounds
]

{ #category : 'private - building' }
UtilitiesBarMorph >> notifyVisibilityChanges [
	"Tell the utilities whose panel became visible or stopped being visible since the last notification."

	| displayed |
	displayed := self isExpanded
		             ifTrue: [ self activeUtilities asIdentitySet ]
		             ifFalse: [ IdentitySet new ].
	notifiedUtilities
		reject: [ :utility | displayed includes: utility ]
		thenDo: [ :utility | utility hidden ].
	displayed
		reject: [ :utility | notifiedUtilities includes: utility ]
		thenDo: [ :utility | utility displayed ].
	notifiedUtilities := displayed
]

{ #category : 'change reporting' }
UtilitiesBarMorph >> ownerChanged [

	self updateBounds.
	super ownerChanged
]

{ #category : 'accessing' }
UtilitiesBarMorph >> panelOf: aUtility [

	^ panels at: aUtility
]

{ #category : 'accessing' }
UtilitiesBarMorph >> proportionOf: aUtility [
	"Answer the share of the height of the bar given to the panel of aUtility, relatively to the other displayed panels."

	^ proportions at: aUtility ifAbsent: [ 1 ]
]

{ #category : 'private - building' }
UtilitiesBarMorph >> rebuild [

	| parts |
	self removeAllMorphs.
	panels := IdentityDictionary new.
	panelStack := nil.
	parts := OrderedCollection with: self newTabStrip.
	self isExpanded ifTrue: [
			parts
				add: (UtilitiesBarResizeHandleMorph for: self);
				add: self newPanelStack ].
	self isAdheringToLeft ifTrue: [ parts := parts reversed ].
	parts do: [ :part | self addMorphBack: part ].
	self updateBounds.
	self notifyVisibilityChanges
]

{ #category : 'resizing' }
UtilitiesBarMorph >> resizeContentWithHandleAt: aNumber [
	"The resize handle was dragged to the horizontal position aNumber. The content panel is resized so that its inner edge follows it."

	| requestedWidth |
	requestedWidth := self isAdheringToRight
		                  ifTrue: [ self right - aNumber ]
		                  ifFalse: [ aNumber - self left ].
	self contentWidth: (requestedWidth min: self maximumContentWidth) rounded
]

{ #category : 'resizing' }
UtilitiesBarMorph >> resizePanelsAbove: anUpperUtility below: aLowerUtility withSeparatorAt: aNumber [
	"The separator between the panels of the two utilities was dragged to the vertical position aNumber. Height is moved from one panel to the other, keeping the total proportion of both."

	| upperPanel combinedHeight upperHeight combinedProportion |
	upperPanel := panels at: anUpperUtility.
	combinedHeight := upperPanel height + (panels at: aLowerUtility) height.
	upperHeight := (aNumber - upperPanel top max: self minimumPanelHeight) min: combinedHeight - self minimumPanelHeight.
	combinedProportion := (self proportionOf: anUpperUtility) + (self proportionOf: aLowerUtility).
	proportions at: anUpperUtility put: combinedProportion * upperHeight / combinedHeight.
	proportions at: aLowerUtility put: combinedProportion - (proportions at: anUpperUtility).
	self updatePanelHeights
]

{ #category : 'layout' }
UtilitiesBarMorph >> restoreLayout: aLayout [
	"Restore the layout of another bar. The utilities are matched by title; the ones I do not have are ignored."

	| utilitiesByTitle |
	utilitiesByTitle := utilities collect: [ :utility | utility title -> utility ] as: Dictionary.
	activeUtilities := (aLayout activeTitles
		                    select: [ :title | utilitiesByTitle includesKey: title ]
		                    thenCollect: [ :title | utilitiesByTitle at: title ]) asIdentitySet.
	proportions := IdentityDictionary new.
	aLayout proportions keysAndValuesDo: [ :title :proportion | utilitiesByTitle at: title ifPresent: [ :utility | proportions at: utility put: proportion ] ].
	expanded := aLayout isExpanded and: [ activeUtilities isNotEmpty ].
	self rebuild
]

{ #category : 'resizing' }
UtilitiesBarMorph >> saveContentWidth [
	"Store my content width in the settings so that it is kept by the next bars."

	self class contentWidth: contentWidth
]

{ #category : 'accessing' }
UtilitiesBarMorph >> settingsUtility [

	^ settingsUtility ifNil: [ settingsUtility := UtilitiesBarSettingsUtility new ]
]

{ #category : 'actions' }
UtilitiesBarMorph >> tabClicked: aUtility [
	"Clicking the tab of a displayed utility deactivates it. Clicking another tab activates its utility, expanding me if needed."

	(self isDisplayed: aUtility) ifTrue: [ ^ self deactivate: aUtility ].
	self activate: aUtility
]

{ #category : 'private - building' }
UtilitiesBarMorph >> tabInset [

	^ 4
]

{ #category : 'private - building' }
UtilitiesBarMorph >> tabLabelFont [

	^ StandardFonts defaultFont
]

{ #category : 'private - building' }
UtilitiesBarMorph >> tabStripInset [

	^ 2
]

{ #category : 'accessing' }
UtilitiesBarMorph >> tabStripWidth [
	"The tab strip is as wide as the vertical labels of the tabs and their insets."

	^ self tabLabelFont height + (self tabInset * 2) + (self tabStripInset * 2)
]

{ #category : 'theme' }
UtilitiesBarMorph >> themeChanged [

	self rebuild.
	super themeChanged
]

{ #category : 'actions' }
UtilitiesBarMorph >> toggleExpanded [

	self isExpanded
		ifTrue: [ self collapse ]
		ifFalse: [ self expand ]
]

{ #category : 'private - building' }
UtilitiesBarMorph >> toggleIconName [
	"The arrow points toward the direction the content panel will move."

	^ self isExpanded = self isAdheringToRight
		  ifTrue: [ #forward ]
		  ifFalse: [ #back ]
]

{ #category : 'actions' }
UtilitiesBarMorph >> toggleSettings [
	"Display the settings of the bar below the active utilities, or hide them if they are displayed."

	self tabClicked: self settingsUtility
]

{ #category : 'private - layout' }
UtilitiesBarMorph >> updateBounds [

	| width area |
	width := self tabStripWidth + (self isExpanded
		          ifTrue: [ contentWidth ]
		          ifFalse: [ 0 ]).
	owner ifNil: [ ^ self width: width ].
	area := self availableArea.
	self bounds: (self isAdheringToRight
			 ifTrue: [ area right - width @ area top corner: area bottomRight ]
			 ifFalse: [ area topLeft corner: area left + width @ area bottom ]).
	self updatePanelHeights
]

{ #category : 'private - layout' }
UtilitiesBarMorph >> updatePanelHeights [
	"Share the height of the panel stack between the displayed panels according to their proportions. The last panel takes what remains so that rounding errors do not leave a gap."

	| active separatorsHeight availableHeight totalProportion |
	panelStack ifNil: [ ^ self ].
	active := self activeUtilities.
	separatorsHeight := panelStack submorphs inject: 0 into: [ :sum :morph |
			                    (panels includes: morph)
				                    ifTrue: [ sum ]
				                    ifFalse: [ sum + morph height ] ].
	availableHeight := self height - separatorsHeight.
	totalProportion := active inject: 0 into: [ :sum :utility | sum + (self proportionOf: utility) ].
	active allButLast do: [ :utility |
			(panels at: utility)
				vResizing: #rigid;
				height: (availableHeight * (self proportionOf: utility) / totalProportion) rounded ].
	(panels at: active last) vResizing: #spaceFill
]

{ #category : 'accessing' }
UtilitiesBarMorph >> utilities [

	^ utilities
]

{ #category : 'accessing' }
UtilitiesBarMorph >> utilities: aCollection [
	"Display aCollection of utilities, sorted by priority then by title. The utilities that are not part of them are deactivated and their proportions forgotten."

	utilities := aCollection asArray sorted: #priority ascending , #title ascending.
	activeUtilities := activeUtilities select: [ :utility | (utilities includes: utility) or: [ utility == settingsUtility ] ].
	activeUtilities ifEmpty: [ expanded := false ].
	contents keys do: [ :utility | (utilities includes: utility) ifFalse: [ contents removeKey: utility ] ].
	proportions keys do: [ :utility | (utilities includes: utility) ifFalse: [ proportions removeKey: utility ] ].
	self rebuild
]

{ #category : 'private - building' }
UtilitiesBarMorph >> verticalLabel: aString color: aColor [
	"Answer a form displaying aString from bottom to top."

	| font form |
	font := self tabLabelFont.
	form := Form extent: (font widthOfString: aString) @ font height depth: 32.
	form getCanvas
		drawString: aString
		at: 0 @ 0
		font: font
		color: aColor.
	^ form rotateBy: #left centerAt: 0 @ 0
]

{ #category : 'accessing' }
UtilitiesBarMorph >> wantsToBeTopmost [

	^ true
]
