Class {
	#name : #WBTDynamicLibraryTarget,
	#superclass : #WBTLibraryTarget,
	#category : #'WBT-Core-Targets'
}

{ #category : #testing }
WBTDynamicLibraryTarget >> isDynamicLibrary [
	^ true
]

{ #category : #'as yet unclassified' }
WBTDynamicLibraryTarget >> outputFileName [
	^ self platform formatDynamicLibraryFileName: name
]

{ #category : #testing }
WBTDynamicLibraryTarget >> requiresLocalRPath [
	^ true
]

{ #category : #testing }
WBTDynamicLibraryTarget >> requiresPositionIndependentCode [
	^ true
]

{ #category : #'as yet unclassified' }
WBTDynamicLibraryTarget >> selectBuildAction [
	self validLinkerLanguage createBuildActionForDynamicLibrary: self
]
