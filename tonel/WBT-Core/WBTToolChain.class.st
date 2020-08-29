Class {
	#name : #WBTToolChain,
	#superclass : #Object,
	#category : #'WBT-Core'
}

{ #category : #'as yet unclassified' }
WBTToolChain class >> unixClang [
	^ WBTUnixStyleCommandLineToolChain new setForClang
]

{ #category : #'as yet unclassified' }
WBTToolChain class >> unixGCC [
	^ WBTUnixStyleCommandLineToolChain new setForGCC
]

{ #category : #'as yet unclassified' }
WBTToolChain >> formatDynamicLibraryFileName: libraryName [
	^ libraryName
]

{ #category : #'as yet unclassified' }
WBTToolChain >> formatDynamicLibraryImportFileName: libraryName [
	^ libraryName
]

{ #category : #testing }
WBTToolChain >> isCommandLineToolChain [
	^ false
]

{ #category : #testing }
WBTToolChain >> isUnixStyle [
	^ false
]
