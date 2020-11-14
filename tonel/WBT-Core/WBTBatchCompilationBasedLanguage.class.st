Class {
	#name : #WBTBatchCompilationBasedLanguage,
	#superclass : #WBTLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> createBuildActionForDynamicLibrary: dynamicLibrary [
	^ dynamicLibrary platform toolchain addBuildActionsForLinkingDynamicLibrary: dynamicLibrary withLanguage: self
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> createBuildActionForExecutableProgram: executableProgram [
	^ executableProgram platform toolchain addBuildActionsForLinkingExecutableProgram: executableProgram withLanguage: self

]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> createBuildActionForStaticLibrary: staticLibrary [
	^ staticLibrary platform toolchain addBuildActionsForLinkingStaticLibrary: staticLibrary withLanguage: self
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
