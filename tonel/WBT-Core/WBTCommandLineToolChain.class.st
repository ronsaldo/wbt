Class {
	#name : #WBTCommandLineToolChain,
	#superclass : #WBTToolChain,
	#instVars : [
		'importLibraryFolderArgumentPrefix',
		'importLibraryArgumentPrefix'
	],
	#category : #'WBT-Core'
}

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForImportingLibraries: libraries [
	| result |
	result := OrderedCollection new.
	self formatLinkerArgumentsForImportingLibraries: libraries into: result.
	^ result
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForImportingLibraries: libraries into: out [
	libraries do: [ :each |
		self formatLinkerArgumentsForImportingLibrary: each into: out
	].
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForImportingLibrary: library into: out [
	library importLibFolder ifNotNil: [:folder |
		out add: self importLibraryFolderArgumentPrefix , folder.
		self rpathLocalLinkerArgument ifNotNil: [ :arg | out add: arg ].
	].

	library importLibName ifNotNil: [ :lib |
		out add: self importLibraryArgumentPrefix , lib
	].
]

{ #category : #accessing }
WBTCommandLineToolChain >> importLibraryArgumentPrefix [
	^ importLibraryArgumentPrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> importLibraryArgumentPrefix: anObject [
	importLibraryArgumentPrefix := anObject
]

{ #category : #accessing }
WBTCommandLineToolChain >> importLibraryFolderArgumentPrefix [
	^ importLibraryFolderArgumentPrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> importLibraryFolderArgumentPrefix: anObject [
	importLibraryFolderArgumentPrefix := anObject
]

{ #category : #testing }
WBTCommandLineToolChain >> isCommandLineToolChain [
	^ true
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> rpathLocalLinkerArgument [
	^ nil
]
