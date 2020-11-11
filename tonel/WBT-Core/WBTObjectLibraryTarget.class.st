Class {
	#name : #WBTObjectLibraryTarget,
	#superclass : #WBTLibraryTarget,
	#category : #'WBT-Core-Targets'
}

{ #category : #converting }
WBTObjectLibraryTarget >> asWBTVarSubstitution [
	^ self allObjectFiles asWBTVarSubstitution
]

{ #category : #testing }
WBTObjectLibraryTarget >> isObjectLibrary [
	^ true
]

{ #category : #'as yet unclassified' }
WBTObjectLibraryTarget >> selectBuildAction [
	"Nothing is required here."
]
