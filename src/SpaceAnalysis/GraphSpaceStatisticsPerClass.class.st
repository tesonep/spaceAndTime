"
I am a simple object that represents the statistics of space of a given class in a graph
"
Class {
	#name : #GraphSpaceStatisticsPerClass,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'instances',
		'totalSize'
	],
	#category : #SpaceAnalysis
}

{ #category : #'instance creation' }
GraphSpaceStatisticsPerClass class >> forClass: aClass forObjects: aCollection [ 

	^ self new
		initializeWithClass: aClass andObjects: aCollection;
		yourself.
]

{ #category : #initialization }
GraphSpaceStatisticsPerClass >> initializeWithClass: aClass andObjects: aCollection [ 

	targetClass := aClass.
	instances := aCollection size.
	totalSize := aCollection sumNumbers: [ :anObject | anObject sizeInMemory ]
]

{ #category : #accessing }
GraphSpaceStatisticsPerClass >> instances [
	^ instances
]

{ #category : #accessing }
GraphSpaceStatisticsPerClass >> memorySize [
	
	^ totalSize
]

{ #category : #printing }
GraphSpaceStatisticsPerClass >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: ' ( ';
		print: targetClass name;
		nextPutAll: ' inst: ';
		print: instances;
		nextPutAll: ' bytes: ';
		print: totalSize;
		nextPutAll: ' )'
]

{ #category : #accessing }
GraphSpaceStatisticsPerClass >> targetClass [
	^ targetClass
]
