"
I am the class that can be used to inspect the statistics of space usage of a given graph of objects.
I use a GraphWalker to get all the recheable objects in the graph. 
Use my messages to access the statistics. 

I can give: 

- totalInstances: The total number of instances
- totalSizeInBytes: The sum of all the space used by the objects in the graph
- statisticsPerClass: I return a collection of GraphSpaceStatisticsPerClass with the information for each of the classes the graph have instances.
- statisticsPerClassCSV: a simple CSV to import in your favorite analysis and graphing tool.
"
Class {
	#name : #GraphSpaceStatistics,
	#superclass : #Object,
	#instVars : [
		'walker',
		'statisticsPerClass',
		'ignoredObjects',
		'ignoreReferencesToClasses',
		'ignorePredicates'
	],
	#category : #SpaceAnalysis
}

{ #category : #'api - statistics' }
GraphSpaceStatistics >> collectedObjects [

	^ walker iterateAllGraph visitedObjects
]

{ #category : #api }
GraphSpaceStatistics >> doNotIgnoreReferencesToClasses [

	ignoreReferencesToClasses := false
]

{ #category : #api }
GraphSpaceStatistics >> ignore: anObject [

	ignoredObjects add: anObject
]

{ #category : #api }
GraphSpaceStatistics >> ignoreReferencesToClasses [

	ignoreReferencesToClasses := true
]

{ #category : #api }
GraphSpaceStatistics >> ignoreWhen: aBlock [

	ignorePredicates add: aBlock
]

{ #category : #initialization }
GraphSpaceStatistics >> initialize [

	super initialize.
	self ignoreReferencesToClasses.
	ignoredObjects := IdentitySet new.
	ignorePredicates := OrderedCollection new.
	walker := GraphWalker new
		          statistics: self;
		          yourself
]

{ #category : #api }
GraphSpaceStatistics >> rootObject: anObject [

	walker rootObject: anObject
]

{ #category : #api }
GraphSpaceStatistics >> shouldIgnore: anObject [

	(ignoreReferencesToClasses and: [ anObject isKindOf: Behavior ])
		ifTrue: [ ^ true ].

	(ignoredObjects includes: anObject) ifTrue: [ ^ true ].
	(ignorePredicates anySatisfy: [ :e | e value: anObject ]) ifTrue: [ ^ true ].

	^ false
]

{ #category : #'api - statistics' }
GraphSpaceStatistics >> statisticsPerClass [

	| classDictionary |

	statisticsPerClass ifNotNil: [ ^ statisticsPerClass ].

	classDictionary := IdentityDictionary new.
	self collectedObjects do: [ :anObject |
			(classDictionary at: anObject class ifAbsentPut: [ IdentitySet new ])
				add: anObject ].

	^ statisticsPerClass := classDictionary associations
		collect: [ :anAssociation | GraphSpaceStatisticsPerClass
				forClass: anAssociation key
				forObjects: anAssociation value ]
		as: OrderedCollection
]

{ #category : #'api - statistics' }
GraphSpaceStatistics >> statisticsPerClassCSV [

	^ String streamContents: [ :anStream |
		anStream
			nextPutAll: '"Class name"'; nextPut: $,;
			nextPutAll: '"# Instances"'; nextPut: $,;
			nextPutAll: '"Size in Memory"'; nextPut: $,.

		self statisticsPerClass do: [ :anEntry |
			anStream crlf;
				nextPutAll: '"'; nextPutAll: anEntry targetClass name asString; nextPutAll: '"'; nextPut: $,;
				nextPutAll: '"'; nextPutAll: anEntry instances printString ; nextPutAll: '"'; nextPut: $,;
				nextPutAll: '"'; nextPutAll: anEntry memorySize printString; nextPutAll: '"' ] ]
]

{ #category : #'api - statistics' }
GraphSpaceStatistics >> totalInstances [
	^ self collectedObjects size
]

{ #category : #'api - statistics' }
GraphSpaceStatistics >> totalSizeInBytes [

	^ self collectedObjects sumNumbers: [ :anObject | anObject sizeInMemory ]
]
