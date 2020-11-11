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
WBTCommandLineToolChain >> formatLinkerArgumentsForLibrariesDirectories: librariesDirectories libraries: libraries extraArguments: extraArguments [
	| result |
	result := OrderedCollection new.
	librariesDirectories do: [ :each | result add: each asFileReference fullPath fullName ].
	self formatLinkerArgumentsForLinkingLibraries: libraries into: result.
	result addAll: extraArguments.
	^ result
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLinkingLibraries: libraries [
	^ self formatLinkerArgumentsForLibrariesDirectories: #() libraries: libraries
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLinkingLibraries: libraries into: out [
	(libraries anySatisfy: [ :each | each requiresLocalRPath ]) ifTrue: [
		self rpathLocalLinkerArgument ifNotNil: [ :arg | out add: arg ].
	].

	libraries do: [ :each |
		self formatLinkerArgumentsForLinkingLibrary: each into: out
	].
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLinkingLibrary: library into: out [
	library isString ifTrue: [ out nextPut: library ].
	library isObjectLibrary ifTrue: [
		out addAll: library allObjectFiles
	] ifFalse: [ 
		library importLibFolder ifNotNil: [:folder |
			out add: self importLibraryFolderArgumentPrefix , (folder asFileReference asAbsolute canonicalize fullName).
		].

		library importLibName ifNotNil: [ :lib |
			out add: self importLibraryArgumentPrefix , ((lib endsWith: importLibraryArgumentSuffix)
				ifTrue: [ lib ] ifFalse: [ lib , importLibraryArgumentSuffix ])
		].
	].

	library isDynamicLibrary ifFalse: [ 
		library allLinkLibraries do: [ :each | self formatLinkerArgumentsForLinkingLibrary: each into: out ]
	].

	out addAll: library allLinkerArguments

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
WBTCommandLineToolChain >> llvmClangCompilationCommandsFor: aPlatform [
	^ {
		#WBT_LLVM_CLANG_DEBUG_FLAGS . ''.
		#WBT_LLVM_CLANG_MINSIZE_FLAGS . '-Os'.
		#WBT_LLVM_CLANG_RELWITHDEBINFO_FLAGS . '-O2'.
		#WBT_LLVM_CLANG_RELEASE_FLAGS . '-O2'.

		#WBT_LLVM_CLANG_TARGET_FLAGS . [#()].

		#WBT_LLVM_COMPILE_OBJECT . [self class clangProgram  , ' $(WBT_LLVM_CLANG_TARGET_FLAGS) $(WBT_LLVM_CLANG_FLAGS) $(WBT_LLVM_CLANG_$(WBT_BUILD_TYPE)_FLAGS) -Wno-override-module -c -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) '].
		#WBT_LLVM_COMPILE_ASSEMBLY . [self class clangProgram  , ' $(WBT_LLVM_CLANG_TARGET_FLAGS) $(WBT_LLVM_CLANG_FLAGS) $(WBT_LLVM_CLANG_$(WBT_BUILD_TYPE)_FLAGS) -Wno-override-module -S -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) '].
	}
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> llvmCompilationCommandsFor: aPlatform [
	self class hasLLC ifTrue: [ ^ self llvmLLCCompilationCommandsFor: aPlatform].
	self class hasClang ifTrue: [ ^ self llvmClangCompilationCommandsFor: aPlatform].
	^ #()

]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> llvmLLCCompilationCommandsFor: aPlatform [
	^ {
		#WBT_LLVM_LLC_DEBUG_FLAGS . ''.
		#WBT_LLVM_LLC_MINSIZE_FLAGS . '-O=1'.
		#WBT_LLVM_LLC_RELWITHDEBINFO_FLAGS . '-O=2'.
		#WBT_LLVM_LLC_RELEASE_FLAGS . '-O=2'.

		#WBT_LLVM_LLC_TARGET_FLAGS . [#()].
		
		#WBT_LLVM_COMPILE_OBJECT . [self class llcProgram  , ' $(WBT_LLVM_LLC_TARGET_FLAGS) $(WBT_LLVM_LLC_FLAGS) $(WBT_LLVM_LLC_$(WBT_BUILD_TYPE)_FLAGS) -filetype=obj -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) ']
	}
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

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> substitutionVariablesForPlatform: aPlatform [
	^ (self llvmCompilationCommandsFor: aPlatform) , (super substitutionVariablesForPlatform: aPlatform)
]
