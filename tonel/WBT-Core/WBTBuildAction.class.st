Class {
	#name : #WBTBuildAction,
	#superclass : #Object,
	#instVars : [
		'parentTarget'
	],
	#category : #'WBT-Core-Actions'
}

{ #category : #accessing }
WBTBuildAction >> buildEnvironment [
	^ parentTarget buildEnvironment
]

{ #category : #execution }
WBTBuildAction >> execute [
	^ self subclassResponsibility
]

{ #category : #accessing }
WBTBuildAction >> package [
	^ parentTarget package
]

{ #category : #accessing }
WBTBuildAction >> parentTarget [
	^ parentTarget
]

{ #category : #accessing }
WBTBuildAction >> parentTarget: anObject [
	parentTarget := anObject
]
