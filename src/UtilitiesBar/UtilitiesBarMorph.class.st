"
I am a bar docked on the right or left edge of the world, displaying utilities (see UtilitiesBarUtility).

I am made of a strip of vertical tabs, one per utility, and of a content panel displaying the selected utility. The button at the top of the strip collapses the content panel so that I only take the width of the strip. Clicking a tab selects its utility and expands me; clicking the tab of the selected utility collapses me.

The world considers me as a docking bar so that maximized windows do not cover me.

The settings (Settings browser > Appearance > Morphic > Utilities bar) control whether I am displayed and on which edge.

Public API (class side):
- #open / #closeAll / #reset: open, close or recreate the bar of the current world
- #showUtilitiesBar: / #edge: change the settings and recreate the bar

Instance variables:
- utilities: the utilities I display, sorted by priority then title
- selectedUtility: the utility whose content is displayed when I am expanded
- expanded: whether the content panel is displayed
- edge: the edge of my owner I adhere to, #right or #left
- contents: cache of the content morphs already built for each utility, so that their state is kept when switching tabs
- contentWidth: the width of the content panel
"
Class {
	#name : 'UtilitiesBarMorph',
	#superclass : 'Morph',
	#instVars : [
		'utilities',
		'selectedUtility',
		'expanded',
		'edge',
		'contents',
		'contentWidth'
	],
	#classVars : [
		'Edge',
		'ShowUtilitiesBar'
	],
	#category : 'UtilitiesBar',
	#package : 'UtilitiesBar'
}

{ #category : 'opening' }
UtilitiesBarMorph class >> closeAll [
	"Close the utilities bars of the current world."

	<script>
	self currentWorld submorphs
		select: [ :morph | morph isUtilitiesBar ]
		thenDo: [ :bar | bar delete ]
]

{ #category : 'private' }
UtilitiesBarMorph class >> codeChanged: aCodeAnnouncement [

	(aCodeAnnouncement classAffected instanceSide inheritsFrom: UtilitiesBarUtility) ifTrue: [ UIManager default defer: [ self reset ] ]
]

{ #category : 'settings' }
UtilitiesBarMorph class >> edge [
	"Answer the edge of the world the bar adheres to, #right or #left."

	^ Edge ifNil: [ Edge := #right ]
]

{ #category : 'settings' }
UtilitiesBarMorph class >> edge: aSymbol [

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
	"Open the utilities bar in the current world if the settings ask for it."

	<script>
	self showUtilitiesBar ifFalse: [ ^ self ].
	self new openInWorld: self currentWorld
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
					description: 'The edge of the world the utilities bar adheres to.' ]
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

	contentWidth := anInteger.
	self rebuild
]

{ #category : 'change reporting' }
UtilitiesBarMorph >> displayExtentChanged [

	self updateBounds
]

{ #category : 'accessing' }
UtilitiesBarMorph >> displayedContent [
	"Answer the morph of the selected utility if it is displayed, nil otherwise."

	self isExpanded ifFalse: [ ^ nil ].
	^ self contentOf: selectedUtility
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
	"Display the content of the selected utility, or of the first one if none is selected."

	(selectedUtility isNil and: [ utilities isEmpty ]) ifTrue: [ ^ self ].
	self selectUtility: (selectedUtility ifNil: [ utilities first ])
]

{ #category : 'initialization' }
UtilitiesBarMorph >> initialize [

	super initialize.
	expanded := false.
	edge := self class edge.
	contents := IdentityDictionary new.
	contentWidth := 400.
	self
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #rigid;
		vResizing: #rigid;
		utilities: UtilitiesBarUtility availableUtilities
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
UtilitiesBarMorph >> isDockingBar [
	"Being a docking bar makes the world exclude me from its clear area."

	^ true
]

{ #category : 'testing' }
UtilitiesBarMorph >> isExpanded [

	^ expanded
]

{ #category : 'testing' }
UtilitiesBarMorph >> isUtilitiesBar [

	^ true
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newContentPanel [

	^ Morph new
		  changeTableLayout;
		  listDirection: #topToBottom;
		  cellPositioning: #topCenter;
		  cellInset: 4;
		  layoutInset: 4;
		  hResizing: #rigid;
		  vResizing: #spaceFill;
		  width: contentWidth;
		  color: self theme backgroundColor;
		  addMorphBack: ((StringMorph contents: selectedUtility title)
				   color: self theme textColor;
				   emphasis: TextEmphasis bold emphasisCode;
				   yourself);
		  addMorphBack: (self contentOf: selectedUtility);
		  yourself
]

{ #category : 'private - building' }
UtilitiesBarMorph >> newTabFor: aUtility [

	^ Morph new
		  changeTableLayout;
		  hResizing: #shrinkWrap;
		  vResizing: #shrinkWrap;
		  layoutInset: self tabInset;
		  cornerStyle: #rounded;
		  color: ((self isExpanded and: [ selectedUtility == aUtility ])
				   ifTrue: [ self theme selectionColor ]
				   ifFalse: [ self theme baseColor ]);
		  borderStyle: (BorderStyle width: 1 color: self theme borderColor);
		  addMorph: (self verticalLabel: aUtility title) asMorph;
		  setBalloonText: aUtility title;
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

{ #category : 'change reporting' }
UtilitiesBarMorph >> ownerChanged [

	self updateBounds.
	super ownerChanged
]

{ #category : 'private - building' }
UtilitiesBarMorph >> rebuild [

	| panels |
	self removeAllMorphs.
	panels := OrderedCollection with: self newTabStrip.
	self isExpanded ifTrue: [ panels add: self newContentPanel ].
	self isAdheringToLeft ifTrue: [ panels := panels reversed ].
	panels do: [ :panel | self addMorphBack: panel ].
	self updateBounds
]

{ #category : 'actions' }
UtilitiesBarMorph >> selectUtility: aUtility [
	"Display the content of aUtility."

	selectedUtility := aUtility.
	expanded := true.
	self rebuild
]

{ #category : 'accessing' }
UtilitiesBarMorph >> selectedUtility [

	^ selectedUtility
]

{ #category : 'actions' }
UtilitiesBarMorph >> tabClicked: aUtility [

	(self isExpanded and: [ selectedUtility == aUtility ]) ifTrue: [ ^ self collapse ].
	self selectUtility: aUtility
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
			 ifFalse: [ area topLeft corner: area left + width @ area bottom ])
]

{ #category : 'accessing' }
UtilitiesBarMorph >> utilities [

	^ utilities
]

{ #category : 'accessing' }
UtilitiesBarMorph >> utilities: aCollection [
	"Display aCollection of utilities, sorted by priority then by title. If the selected utility is not part of them, the bar gets collapsed."

	utilities := aCollection asArray sorted: #priority ascending , #title ascending.
	(utilities includes: selectedUtility) ifFalse: [
			selectedUtility := nil.
			expanded := false ].
	contents keysDo: [ :utility | (utilities includes: utility) ifFalse: [ contents removeKey: utility ] ].
	self rebuild
]

{ #category : 'private - building' }
UtilitiesBarMorph >> verticalLabel: aString [
	"Answer a form displaying aString from bottom to top."

	| font form |
	font := self tabLabelFont.
	form := Form extent: (font widthOfString: aString) @ font height depth: 32.
	form getCanvas
		drawString: aString
		at: 0 @ 0
		font: font
		color: self theme textColor.
	^ form rotateBy: #left centerAt: 0 @ 0
]

{ #category : 'accessing' }
UtilitiesBarMorph >> wantsToBeTopmost [

	^ true
]
