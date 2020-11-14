Class {
	#name : #WBTLazyBuildActions,
	#superclass : #WBTBuildAction,
	#instVars : [
		'block'
	],
	#category : #'WBT-Core-Actions'
}

{ #category : #accessing }
WBTLazyBuildActions >> block [
	^ block
]

{ #category : #accessing }
WBTLazyBuildActions >> block: anObject [
	block := anObject
]

{ #category : #execution }
WBTLazyBuildActions >> execute [
	^ block value allSatisfy: [ :each | each parentTarget: parentTarget; execute ]
]
