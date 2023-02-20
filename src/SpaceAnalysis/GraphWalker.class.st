"
I am a simple class to take a root object and return all the objects that are reacheable from the root object. 
I traverse all the slots and variable parts of the objects to collect the visited objects in an IdentitySet. So, I can handle graphs full of loops.
However, I require to have enough space to keep the IdentitySet.
"
Class {
	#name : #GraphWalker,
	#superclass : #Object,
	#instVars : [
		'root',
		'visitedObjects',
		'statistics'
	],
	#category : #SpaceAnalysis
}

{ #category : #initialization }
GraphWalker >> initialize [

	super initialize.
	visitedObjects := IdentitySet new
]

{ #category : #operations }
GraphWalker >> iterateAllGraph [

	self visitObject: root
]

{ #category : #accessing }
GraphWalker >> rootObject: anObject [

	root := anObject.
	visitedObjects removeAll
]

{ #category : #accessing }
GraphWalker >> statistics [

	^ statistics
]

{ #category : #accessing }
GraphWalker >> statistics: anObject [

	statistics := anObject
]

{ #category : #anObject }
GraphWalker >> visitObject: anObject [

	(statistics shouldIgnore: anObject) ifTrue: [ ^ self ].
	(visitedObjects includes: anObject) ifTrue: [ ^ self ].

	visitedObjects add: anObject.

	anObject class allSlots
		reject: [ :anSlot | anSlot isVirtual and: [ anSlot class = WeakSlot ] ]
		thenDo: [ :anSlot | self visitObject: (anSlot read: anObject) ].

	"For variable objects"
	(anObject isCompiledBlock or: [ anObject isCompiledMethod ]) ifTrue: [
		anObject allLiterals do: [ :e | self visitObject: e ].
		^ self ].

	"If a byte array, or word array, do not scan anything"
	anObject class isBytes ifTrue: [ ^ self ].

	1 to: anObject basicSize do: [ :anIndex | self visitObject: (anObject basicAt: anIndex) ]
]

{ #category : #accessing }
GraphWalker >> visitedObjects [

	^ visitedObjects
]
