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
WBTObjectLibraryTarget >> outputFileName [
	^ name , '.stamp'
]

{ #category : #accessing }
WBTObjectLibraryTarget >> outputFileReference [
	^ outputFileReference ifNil: [ outputFileReference := self package validBuildObjectDirectory / self outputFileName ]
]

{ #category : #'as yet unclassified' }
WBTObjectLibraryTarget >> selectBuildAction [
	self addBuildAction: (WBTTouchFileBuildAction new fileReference: self outputFileReference)
]
