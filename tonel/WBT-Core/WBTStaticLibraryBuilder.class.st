Class {
	#name : #WBTStaticLibraryBuilder,
	#superclass : #WBTLibraryBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTStaticLibraryBuilder >> createTargetNamed: moduleName [
	^ WBTStaticLibraryTarget new
		name: moduleName;
		yourself
]
