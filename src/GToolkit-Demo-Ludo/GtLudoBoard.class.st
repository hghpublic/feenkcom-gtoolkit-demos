"
I contain all the pieces that represent the game state and that need to be rendered, namely Squares, Players, and indirectly through the players, their Tokens.

I don't manage the game logic, which is in LudoGame.
"
Class {
	#name : #GtLudoBoard,
	#superclass : #Object,
	#instVars : [
		'players',
		'squares',
		'startSquares',
		'goalSquares',
		'die',
		'announcer',
		'feedback'
	],
	#category : #'GToolkit-Demo-Ludo-Model'
}

{ #category : #announcements }
GtLudoBoard >> announcer [
	^ announcer
]

{ #category : #'gt - extensions' }
GtLudoBoard >> asElement [
	^ GtLudoBoardElement for: self
]

{ #category : #accessing }
GtLudoBoard >> die [
	^ die
]

{ #category : #moving }
GtLudoBoard >> enterPlayTokenFor: aPlayer [

	"What should be the behavior if there are no tokens left to put into play?"

	"aPlayer startTokens isEmpty ifTrue: [ ^ nil ]."
	
	self assert: aPlayer startTokens notEmpty.

	^ aPlayer startTokens first enterPlayOnSquare:
		(self startSquareFor: aPlayer)
]

{ #category : #feedback }
GtLudoBoard >> feedback [
	^ feedback
]

{ #category : #feedback }
GtLudoBoard >> feedback: aString [
	feedback := aString.
	self notifyFeedbackUpdated
]

{ #category : #accessing }
GtLudoBoard >> goalSquares [
	^ goalSquares
]

{ #category : #'gt - extensions' }
GtLudoBoard >> gtBoardFor: aView [
	<gtView>
	^ aView explicit
		  title: 'Board';
		  priority: 30;
		  stencil: [ self asElement ]
]

{ #category : #'gt - extensions' }
GtLudoBoard >> gtPlayersFor: aView [
	<gtView>
	^ aView columnedList
		  title: 'Players';
		  priority: 10;
		  items: [ self players ];
		  column: 'Player' text: [ :eachItem | eachItem gtDisplayText ]
]

{ #category : #'gt - extensions' }
GtLudoBoard >> gtSquaresFor: aView [
	<gtView>
	^ aView columnedList
		  title: 'Squares';
		  priority: 20;
		  items: [ self squares ];
		  column: 'Index'
		  text: [ :eachItem :eachIndex | 
			  eachIndex asRopedText foreground: Color gray ]
		  width: 45;
		  column: 'Tokens' text: [ :eachItem | eachItem gtDisplayText ]
]

{ #category : #initialization }
GtLudoBoard >> initialize [
	super initialize.
	announcer := Announcer new.
	feedback := ''.
	players := OrderedCollection new.
	($A to: $D) do: [ :player | players add: (GtLudoPlayer new name: player) ].
	self initializeSquares.
	players do: #initializeTokens.
	self initializeStartSquares.
	self initializeGoalSquares.
	die := GtLudoDie new
]

{ #category : #initialization }
GtLudoBoard >> initializeGoalSquares [
	goalSquares := OrderedCollection new.
	1
		to: 8
		do:
			[ :n | 
			goalSquares
				add:
					((GtLudoSquare new)
						kind: #goal;
						yourself) ]
]

{ #category : #initialization }
GtLudoBoard >> initializeSquares [
	squares := OrderedCollection new.
	1
		to: self totalPlaySquares
		do:
			[ :n | 
			| square |
			square := GtLudoSquare new.
			n \\ 10 = 1 ifTrue: [ square kind: #initial ].
			squares add: square ]
]

{ #category : #initialization }
GtLudoBoard >> initializeStartSquares [
	startSquares := OrderedCollection new.
	self tokens
		do:
			[ :token | 
			| square |
			square := (GtLudoSquare new)
				kind: #start;
				yourself.
			token goToSquare: square.
			startSquares add: square ]
]

{ #category : #announcements }
GtLudoBoard >> notifyFeedbackUpdated [
	self announcer announce: GtLudoBoardFeedbackUpdated new
]

{ #category : #accessing }
GtLudoBoard >> players [
	^ players
]

{ #category : #accessing }
GtLudoBoard >> positionOfToken: aToken [
	^ self squares indexOf: aToken square
]

{ #category : #'test - support' }
GtLudoBoard >> roll: aValue [
	"For testing only -- set the value rolled."
	self die roll: aValue
]

{ #category : #accessing }
GtLudoBoard >> routeFor: aPlayer [

	"Cache these?"

	| route playerNumber first |
	route := OrderedCollection new.
	playerNumber := self players indexOf: aPlayer.
	first := playerNumber - 1 * 10 + 1.
	route addAll:
		(self squares copyFrom: first to: self totalPlaySquares).
	route addAll: (self squares copyFrom: 1 to: first - 1).

	first := playerNumber - 1 * 2 + 1.
	route addAll: (self goalSquares copyFrom: first to: first + 1).

	^ route
]

{ #category : #accessing }
GtLudoBoard >> squares [
	^ squares
]

{ #category : #moving }
GtLudoBoard >> startSquareFor: aPlayer [
	"Compute the start square for a given player. Positions should be 1, 11, 21, 31."

	| index |
	self assert: (self players includes: aPlayer).
	index := 1 + (((self players indexOf: aPlayer) - 1) * (self squares size // self players size)).
	self assert: index <= squares size.
	self assert: index \\ 10 equals: 1.
	^ self squares at: index
]

{ #category : #accessing }
GtLudoBoard >> startSquares [
	^ startSquares
]

{ #category : #accessing }
GtLudoBoard >> tokenNamed: aString [
	^ self tokens detect: [ :token | token name = aString ]
]

{ #category : #accessing }
GtLudoBoard >> tokens [
	^ players flatCollect: #tokens
]

{ #category : #constants }
GtLudoBoard >> totalPlaySquares [
	^ 40
]