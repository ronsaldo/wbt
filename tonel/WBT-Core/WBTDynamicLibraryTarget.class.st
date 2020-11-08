Class {
	#name : #WBTDynamicLibraryTarget,
	#superclass : #WBTLibraryTarget,
	#category : #'WBT-Core-Targets'
}

{ #category : #'as yet unclassified' }
WBTDynamicLibraryTarget >> outputFileName [
	^ self platform formatDynamicLibraryFileName: name
]

{ #category : #'as yet unclassified' }
WBTDynamicLibraryTarget >> selectBuildAction [
	self validLinkerLanguage createBuildActionForDynamicLibrary: self
]
