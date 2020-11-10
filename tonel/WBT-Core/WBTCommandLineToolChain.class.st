Class {
	#name : #WBTCommandLineToolChain,
	#superclass : #WBTToolChain,
	#instVars : [
		'importLibraryFolderArgumentPrefix',
		'importLibraryArgumentPrefix',
		'importLibraryArgumentSuffix',
		'includeDirectoryArgumentPrefix'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> formatIncludeDirectoryArgument: includeDirectory [
	^ includeDirectoryArgumentPrefix , includeDirectory asWBTVarSubstitution
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLibrariesDirectories: librariesDirectories libraries: libraries [
	| result |
	result := OrderedCollection new.
	librariesDirectories do: [ :each | result add: each asFileReference fullPath fullName ].
	self formatLinkerArgumentsForLinkingLibraries: libraries into: result.
	^ result
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLinkingLibraries: libraries [
	^ self formatLinkerArgumentsForLibrariesDirectories: #() libraries: libraries
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLinkingLibraries: libraries into: out [
	libraries detect: [ :each | each requiresLocalRPath ] ifFound: [:f |
		self rpathLocalLinkerArgument ifNotNil: [ :arg | out add: arg ].
	].

	libraries do: [ :each |
		self formatLinkerArgumentsForLinkingLibrary: each into: out
	].
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLinkingLibrary: library into: out [
	library importLibFolder ifNotNil: [:folder |
		out add: self importLibraryFolderArgumentPrefix , (folder asFileReference asAbsolute canonicalize fullName).
	].

	library importLibName ifNotNil: [ :lib |
		out add: self importLibraryArgumentPrefix , ((lib endsWith: importLibraryArgumentSuffix)
			ifTrue: [ lib ] ifFalse: [ lib , importLibraryArgumentSuffix ])
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
WBTCommandLineToolChain >> importLibraryArgumentSuffix [
	^ importLibraryArgumentSuffix
]

{ #category : #accessing }
WBTCommandLineToolChain >> importLibraryArgumentSuffix: anObject [
	importLibraryArgumentSuffix := anObject
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
