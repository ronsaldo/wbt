Class {
	#name : #WBTObjectLibraryBuilder,
	#superclass : #WBTLibraryBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTObjectLibraryBuilder >> createModuleNamed: moduleName [
	^ WBTObjectLibraryTarget new
		name: moduleName;
		yourself
]
