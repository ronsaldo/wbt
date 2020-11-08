Class {
	#name : #WBTStaticLibraryTarget,
	#superclass : #WBTLibraryTarget,
	#category : #'WBT-Core-Targets'
}

{ #category : #testing }
WBTStaticLibraryTarget >> isStaticLibrary [
	^ true
]

{ #category : #'as yet unclassified' }
WBTStaticLibraryTarget >> outputFileName [
	^ self platform formatStaticLibraryFileName: name
]

{ #category : #'as yet unclassified' }
WBTStaticLibraryTarget >> selectBuildAction [
	self validLinkerLanguage createBuildActionForStaticLibrary: self
]
