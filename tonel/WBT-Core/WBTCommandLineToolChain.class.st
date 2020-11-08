Class {
	#name : #WBTCommandLineToolChain,
	#superclass : #WBTToolChain,
	#instVars : [
		'importLibraryFolderArgumentPrefix',
		'importLibraryArgumentPrefix',
		'includeDirectoryArgumentPrefix'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> formatIncludeDirectoryArgument: includeDirectory [
	^ includeDirectoryArgumentPrefix , includeDirectory asWBTVarSubstitution
]

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

{ #category : #accessing }
WBTCommandLineToolChain >> includeDirectoryArgumentPrefix [
	^ includeDirectoryArgumentPrefix
]

{ #category : #accessing }
WBTCommandLineToolChain >> includeDirectoryArgumentPrefix: anObject [
	includeDirectoryArgumentPrefix := anObject
]

{ #category : #testing }
WBTCommandLineToolChain >> isCommandLineToolChain [
	^ true
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> rpathLocalLinkerArgument [
	^ nil
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> substitutionVariables [
	| includeDirectoriesBlock |
	includeDirectoriesBlock := [:env |
		(env evaluateVariableValue: #WBT_ACTIVE_INCLUDE_DIRECTORIES ifAbsent: [#()])
			collect: [ :each | self formatIncludeDirectoryArgument: each ]
	].

	^ super substitutionVariables , { 
		#WBT_C_INCLUDE_DIRECTORIES_FLAGS . includeDirectoriesBlock. 
		#WBT_CXX_INCLUDE_DIRECTORIES_FLAGS . includeDirectoriesBlock.
	 }
]
