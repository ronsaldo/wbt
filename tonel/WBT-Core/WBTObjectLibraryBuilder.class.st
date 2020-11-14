Class {
	#name : #WBTObjectLibraryBuilder,
	#superclass : #WBTLibraryBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTObjectLibraryBuilder >> createTargetNamed: moduleName [
	^ WBTObjectLibraryTarget new
		name: moduleName;
		yourself
]
