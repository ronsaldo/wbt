Class {
	#name : #WBTMainElementTarget,
	#superclass : #WBTPackageElementTarget,
	#instVars : [
		'name'
	],
	#category : #'WBT-Core-Targets'
}

{ #category : #testing }
WBTMainElementTarget >> isMainElementTarget [
	^ true
]

{ #category : #accessing }
WBTMainElementTarget >> name [
	^ name
]

{ #category : #accessing }
WBTMainElementTarget >> name: anObject [
	name := anObject
]
