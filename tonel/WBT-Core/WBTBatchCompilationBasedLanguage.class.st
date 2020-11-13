Class {
	#name : #WBTBatchCompilationBasedLanguage,
	#superclass : #WBTLanguage,
	#category : #'WBT-Core-Language'
}

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
				#WBT_LINK_LIBRARIES . [toolchain formatLinkerArgumentsForLibrariesDirectories: executableProgram allLinkLibrariesDirectories libraries: executableProgram allLinkLibraries extraArguments: executableProgram allLinkerArguments].
			}
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> createBuildActionForStaticLibrary: staticLibrary [
	^ staticLibrary
		addCommandLineCommandBuildAction: self linkStaticLibraryCommand
			inputFiles: staticLibrary allObjectFiles outputFile: staticLibrary outputFileReference
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
