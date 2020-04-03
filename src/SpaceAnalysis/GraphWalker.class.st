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
		'visitedObjects'
	],
	#category : #SpaceAnalysis
}

{ #category : #initialization }
GraphWalker >> initialize [
	
	super initialize.
	visitedObjects := IdentitySet new.
]

{ #category : #operations }
GraphWalker >> iterateAllGraph [
	
	self visitObject: root
]

{ #category : #accessing }
GraphWalker >> rootObject: anObject [ 

	root := anObject
]

{ #category : #anObject }
GraphWalker >> visitObject: anObject [

	(visitedObjects includes: anObject) ifTrue: [ ^ self ].
	
	self withAllReferencesFrom: anObject do: [ :aReferenced |
		self visitObject: aReferenced ].
	
	visitedObjects add: anObject
	
	
]

{ #category : #accessing }
GraphWalker >> visitedObjects [
	^ visitedObjects
]

{ #category : #visiting }
GraphWalker >> withAllReferencesFrom: anObject do: aBlockClosure [ 
	
	self withAllSlotsOf: anObject do: [ :anSlot |
		aBlockClosure value: (anSlot read: anObject ) ].
	
	"For variable objects"
	1 to: anObject basicSize	do: [ :anIndex |
		aBlockClosure value: (anObject basicAt: anIndex)]

]

{ #category : #visiting }
GraphWalker >> withAllSlotsOf: anObject do: aBlockClosure [ 
	
	anObject class allSlots 
		reject: [ :anSlot | anSlot isVirtual ] 
		thenDo: aBlockClosure
]
