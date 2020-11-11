Class {
	#name : #WBTBuildTargetDependencySorter,
	#superclass : #Object,
	#instVars : [
		'result',
		'visited'
	],
	#category : #'WBT-Core-Algorithms'
}

{ #category : #adding }
WBTBuildTargetDependencySorter >> addBuildTarget: aBuildTarget [
	(visited includes: aBuildTarget) ifTrue: [ ^ self ].
	visited add: aBuildTarget.
	aBuildTarget buildTargetDependencies do: [ :each |
		self addBuildTarget: each
	].
	result add: aBuildTarget.
]

{ #category : #initialization }
WBTBuildTargetDependencySorter >> initialize [
	result := OrderedCollection new.
	visited := IdentitySet new.
]

{ #category : #'as yet unclassified' }
WBTBuildTargetDependencySorter >> unsatisfiedBuildTargets [
	^ self value
]

{ #category : #evaluating }
WBTBuildTargetDependencySorter >> value [
	^ result
]
