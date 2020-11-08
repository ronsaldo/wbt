Class {
	#name : #WBTStaticLibraryBuilder,
	#superclass : #WBTLibraryBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTStaticLibraryBuilder >> createModuleNamed: moduleName [
	^ WBTStaticLibraryTarget new
		name: moduleName;
		yourself
]
