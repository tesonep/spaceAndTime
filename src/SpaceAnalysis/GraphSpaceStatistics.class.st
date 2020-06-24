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
		'statisticsPerClass'
	],
	#category : #SpaceAnalysis
}

{ #category : #statistics }
GraphSpaceStatistics >> collectedObjects [
	^ walker iterateAllGraph visitedObjects
]

{ #category : #accessing }
GraphSpaceStatistics >> ignoreReferencesToClasses [

	walker ignoreReferencesToClasses: true
]

{ #category : #accessing }
GraphSpaceStatistics >> rootObject: anObject [

 	walker := GraphWalker new
		rootObject: anObject;
		yourself
]

{ #category : #statistics }
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

{ #category : #printing }
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
				nextPutAll: '"'; nextPutAll: anEntry memorySize printString; nextPutAll: '"' ]	].
			
]

{ #category : #statistics }
GraphSpaceStatistics >> totalInstances [
	^ self collectedObjects size
]

{ #category : #statistics }
GraphSpaceStatistics >> totalSizeInBytes [

	^ self collectedObjects sumNumbers: [ :anObject | anObject sizeInMemory ] 
]
