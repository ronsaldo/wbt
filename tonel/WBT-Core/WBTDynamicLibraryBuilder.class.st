Class {
	#name : #WBTDynamicLibraryBuilder,
	#superclass : #WBTLibraryBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTDynamicLibraryBuilder >> createTargetNamed: moduleName [
	^ WBTDynamicLibraryTarget new
		name: moduleName;
		yourself
]
