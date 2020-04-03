Class {
	#name : #BaselineOfSpaceAndTime,
	#superclass : #BaselineOf,
	#category : #BaselineOfSpaceAndTime
}

{ #category : #baselines }
BaselineOfSpaceAndTime >> baseline: spec [

	<baseline>

	spec for: #'common' do: [
		spec 
			package: 'SpaceAnalysis'].
]
