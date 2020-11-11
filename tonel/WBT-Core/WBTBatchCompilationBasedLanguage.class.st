Class {
	#name : #WBTBatchCompilationBasedLanguage,
	#superclass : #WBTLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> buildActionCommand [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> createBuildActionForDynamicLibrary: staticLibrary [
	^ staticLibrary
		addCommandLineCommandBuildAction: self linkDynamicLibraryCommand
			inputFiles: staticLibrary allObjectFiles outputFile: staticLibrary outputFileReference
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> createBuildActionForExecutableProgram: executableProgram [
	| toolchain |
	toolchain := executableProgram platform toolchain.
	^ executableProgram
		addCommandLineCommandBuildAction: self linkExecutableCommand
			inputFiles: executableProgram allObjectFiles outputFile: executableProgram outputFileReference
			variables: {
				#WBT_LINK_LIBRARIES . [toolchain formatLinkerArgumentsForLibrariesDirectories: executableProgram allLinkLibrariesDirectories libraries: executableProgram allLinkLibraries].
			}
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> createBuildActionForStaticLibrary: staticLibrary [
	^ staticLibrary
		addCommandLineCommandBuildAction: self linkStaticLibraryCommand
			inputFiles: staticLibrary allObjectFiles outputFile: staticLibrary outputFileReference
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> createIntermediateObjectFilesFor: sourceFile module: targetModule [
	| sourceRelativeFileRef objectFileRelativeFileRef objectFileReference |
	sourceRelativeFileRef := sourceFile relativeFileReference.
	objectFileRelativeFileRef := sourceRelativeFileRef parent / (sourceFile platform formatObjectFileName: sourceRelativeFileRef basename).
	objectFileReference := (sourceFile package validBuildObjectDirectory resolve: objectFileRelativeFileRef) asAbsolute canonicalize.

	targetModule addIntermediateObjectFile: (WBTFileTarget new
		language: WBTObjectFileLanguage uniqueInstance;
		relativeFileReference: objectFileRelativeFileRef;
		fileReference: objectFileReference;
		addBuildAction: (sourceFile package newCommandLineCommandBuildAction: self buildActionCommand inputFiles: {sourceFile} outputFile: objectFileReference
		variables: {
			#WBT_POSITION_INDEPENDENT_CODE_ENABLED . [targetModule requiresPositionIndependentCode
				ifTrue: [ 'YES' ]
				ifFalse: [ 'NO' ] ]
		});
		yourself)

]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> linkDynamicLibraryCommand [
	^ '$(WBT_C_LINK_DYNAMIC_LIBRARY)'
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> linkExecutableCommand [
	^ '$(WBT_C_LINK_EXECUTABLE)'
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> linkPriority [
	^ 2
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> linkStaticLibraryCommand [
	^ '$(WBT_C_LINK_STATIC_LIBRARY)'
]
