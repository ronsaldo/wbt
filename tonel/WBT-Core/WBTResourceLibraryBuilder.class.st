Class {
	#name : #WBTResourceLibraryBuilder,
	#superclass : #WBTLibraryBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTResourceLibraryBuilder >> createTargetNamed: moduleName [
	^ WBTResourceLibraryTarget new
		name: moduleName;
		yourself
]
