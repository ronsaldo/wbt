Class {
	#name : #WBTCommandLineToolChain,
	#superclass : #WBTToolChain,
	#instVars : [
		'importLibraryFolderArgumentPrefix',
		'importLibraryArgumentPrefix',
		'importLibraryArgumentSuffix',
		'includeDirectoryArgumentPrefix',
		'cmake'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #adding }
WBTCommandLineToolChain >> addBuildActionsForLinkingDynamicLibrary: dynamicLibrary withLanguage: language [
	^ dynamicLibrary
		addEnsureOutputDirectoryCreationBuildAction;
		addCommandLineCommandBuildAction: language linkExecutableCommand
			inputFiles: dynamicLibrary allObjectFiles outputFile: dynamicLibrary outputFileReference
			variables: {
				#WBT_LINK_LIBRARIES . [self formatLinkerArgumentsForLibrariesDirectories: dynamicLibrary allLinkLibrariesDirectories libraries: dynamicLibrary allLinkLibraries extraArguments: dynamicLibrary allLinkerArguments].
			}
]

{ #category : #adding }
WBTCommandLineToolChain >> addBuildActionsForLinkingExecutableProgram: executableProgram withLanguage: language [
	^ executableProgram
		addEnsureOutputDirectoryCreationBuildAction;
		addCommandLineCommandBuildAction: language linkExecutableCommand
			inputFiles: executableProgram allObjectFiles outputFile: executableProgram outputFileReference
			variables: {
				#WBT_WIN32_SUBSYSTEM . [executableProgram win32Subsystem].
				#WBT_LINK_LIBRARIES . [self formatLinkerArgumentsForLibrariesDirectories: executableProgram allLinkLibrariesDirectories libraries: executableProgram allLinkLibraries extraArguments: executableProgram allLinkerArguments].
			}
]

{ #category : #adding }
WBTCommandLineToolChain >> addBuildActionsForLinkingStaticLibrary: staticLibrary withLanguage: language [
	^ staticLibrary
		addEnsureOutputDirectoryCreationBuildAction;
		addCommandLineCommandBuildAction: language linkStaticLibraryCommand
			inputFiles: staticLibrary allObjectFiles outputFile: staticLibrary outputFileReference
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> cmake [
	^ cmake ifNil: [ cmake := self class cmakeProgram ]
]

{ #category : #accessing }
WBTCommandLineToolChain >> cmake: aProgramName [
	^ cmake := aProgramName
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> formatIncludeDirectoryArgument: includeDirectory [
	^ includeDirectoryArgumentPrefix , includeDirectory asWBTVarSubstitution
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLibrariesDirectories: librariesDirectories libraries: libraries [
	^ self formatLinkerArgumentsForLibrariesDirectories: librariesDirectories libraries: libraries extraArguments: #()
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLibrariesDirectories: librariesDirectories libraries: libraries extraArguments: extraArguments [
	| result visited |
	result := OrderedCollection new.
	visited := Set new.
	librariesDirectories do: [ :each | result add: each asFileReference fullPath fullName ].
	self formatLinkerArgumentsForLinkingLibraries: libraries into: result visited: visited.
	result addAll: extraArguments.
	^ result
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLinkingLibraries: libraries [
	^ self formatLinkerArgumentsForLibrariesDirectories: #() libraries: libraries
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLinkingLibraries: libraries into: out visited: visited [
	libraries do: [ :each |
		self formatLinkerArgumentsForLinkingLibrary: each into: out visited: visited
	].
]

{ #category : #formatting }
WBTCommandLineToolChain >> formatLinkerArgumentsForLinkingLibrary: library into: out visited: visited [
	(visited includes: library) ifTrue: [ ^ self ].
	visited add: library.
	
	library requiresLocalRPath ifTrue: [
		self rpathLocalLinkerArgument ifNotNil: [ :arg |
			(visited includes: arg) ifFalse: [ 
				out add: arg.
				visited add: arg
			].
		].
	].

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
		library allLinkLibraries do: [ :each | self formatLinkerArgumentsForLinkingLibrary: each into: out visited: visited ]
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
	| targetFlags |
	targetFlags := OrderedCollection new.
	aPlatform triple ifNotNil: [ :triple | targetFlags add: '-target ' , triple ].
	aPlatform cpu ifNotNil: [ :cpu | targetFlags add: '-mcpu=' , cpu ].
	aPlatform fpu ifNotNil: [ :fpu | targetFlags add: '-mfpu=' , fpu ].
	aPlatform floatAbiName ifNotNil: [ :floatAbiName | targetFlags add: '-mfloat-abi=' , floatAbiName ].
	aPlatform floatingPointModel ifNotNil: [ :floatingPointModel | targetFlags add: '-ffp-model=' , floatingPointModel ].
	
	^ {
		"TODO: Allow disabling these flags."
		#WBT_LLVM_CLANG_FLAGS . '-fdata-sections -ffunction-sections'.

		#WBT_LLVM_CLANG_DEBUG_FLAGS . ''.
		#WBT_LLVM_CLANG_MINSIZE_FLAGS . '-Os'.
		#WBT_LLVM_CLANG_ASSERT_FLAGS . '-O2'.
		#WBT_LLVM_CLANG_RELWITHDEBINFO_FLAGS . '-O2'.
		#WBT_LLVM_CLANG_RELEASE_FLAGS . '-O2'.

		#WBT_LLVM_CLANG_TARGET_FLAGS . targetFlags.

		#WBT_LLVM_COMPILE_OBJECT . [self class clangProgram  , ' $(WBT_LLVM_CLANG_TARGET_FLAGS) $(WBT_LLVM_CLANG_FLAGS) $(WBT_LLVM_CLANG_$(WBT_BUILD_MODE)_FLAGS) -Wno-override-module -c -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) '].
		#WBT_LLVM_COMPILE_ASSEMBLY . [self class clangProgram  , ' $(WBT_LLVM_CLANG_TARGET_FLAGS) $(WBT_LLVM_CLANG_FLAGS) $(WBT_LLVM_CLANG_$(WBT_BUILD_MODE)_FLAGS) -Wno-override-module -S -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) '].
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
	| targetFlags |
	targetFlags := OrderedCollection new.
	aPlatform cpu ifNotNil: [ :cpu | targetFlags add: '-mcpu=' , cpu ].
	aPlatform fpu ifNotNil: [ :fpu | targetFlags add: '-mattr=' , fpu ].
	aPlatform floatAbiName ifNotNil: [ :floatAbiName | targetFlags add: '-mfloat-abi==' , floatAbiName ].
	aPlatform floatingPointModel ifNotNil: [ :floatingPointModel | self halt ].
	
	^ {
		#WBT_LLVM_LLC_FLAGS . '--data-sections --function-sections'.

		#WBT_LLVM_LLC_DEBUG_FLAGS . ''.
		#WBT_LLVM_LLC_ASSERT_FLAGS . '-O=2'.
		#WBT_LLVM_LLC_MINSIZE_FLAGS . '-O=1'.
		#WBT_LLVM_LLC_RELWITHDEBINFO_FLAGS . '-O=2'.
		#WBT_LLVM_LLC_RELEASE_FLAGS . '-O=2'.

		#WBT_LLVM_LLC_TARGET_FLAGS . targetFlags.
		
		#WBT_LLVM_COMPILE_OBJECT . [self class llcProgram  , ' $(WBT_LLVM_LLC_TARGET_FLAGS) $(WBT_LLVM_LLC_FLAGS) $(WBT_LLVM_LLC_$(WBT_BUILD_MODE)_FLAGS) -filetype=obj -o $(WBT_OUTPUT_FILE) $(WBT_INPUT_FILES) ']
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
		#WBT_CMAKE . [self cmake].
		#WBT_CMAKE_CONFIGURE . '$(WBT_CMAKE) $(WBT_SOURCE_DIRECTORY) $(WBT_CMAKE_PLATFORM_SETTINGS) -D CMAKE_BUILD_TYPE=$(WBT_CMAKE_BUILD_MODE) -D CMAKE_INSTALL_PREFIX=$(WBT_INSTALL_DIRECTORY)'.
		#WBT_CMAKE_BUILD . '$(WBT_CMAKE) --build $(WBT_BUILD_DIRECTORY) --config $(WBT_CMAKE_BUILD_MODE)'.
		#WBT_CMAKE_INSTALL . '$(WBT_CMAKE) --build $(WBT_BUILD_DIRECTORY) --config $(WBT_CMAKE_BUILD_MODE) --target install'.

		#WBT_C_INCLUDE_DIRECTORIES_FLAGS . includeDirectoriesBlock. 
		#WBT_CXX_INCLUDE_DIRECTORIES_FLAGS . includeDirectoriesBlock.
	 }
]

{ #category : #'as yet unclassified' }
WBTCommandLineToolChain >> substitutionVariablesForPlatform: aPlatform [
	^ (self llvmCompilationCommandsFor: aPlatform) , (super substitutionVariablesForPlatform: aPlatform)
]
