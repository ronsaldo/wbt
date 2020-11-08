Class {
	#name : #WBTCppLanguage,
	#superclass : #WBTBatchCompilationBasedLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #testing }
WBTCppLanguage class >> isSupported [
	^ true
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> buildActionCommand [
	^ '$(WBT_CXX_COMPILE_OBJECT)'
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> createBuildActionForExecutableProgram: executableProgram [
	^ executableProgram
		addCommandLineCommandBuildAction: '$(WBT_CXX_LINK_EXECUTABLE)'
			inputFiles: executableProgram allObjectFiles outputFile: executableProgram outputFileReference
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> handlesFileExtension: extension [
	^ #(cc cpp c++) includes: extension
]

{ #category : #'as yet unclassified' }
WBTCppLanguage >> linkPriority [
	^ 3
]
