Class {
	#name : #WBTLibraryBuilder,
	#superclass : #WBTModuleBuilder,
	#category : #'WBT-Core-Builder'
}

{ #category : #'as yet unclassified' }
WBTLibraryBuilder >> createModuleNamed: moduleName [
	^ WBTLibraryTarget new
		name: moduleName;
		yourself
]
