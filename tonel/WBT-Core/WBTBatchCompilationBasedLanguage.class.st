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
WBTBatchCompilationBasedLanguage >> createBuildActionForExecutableProgram: executableProgram [
	^ executableProgram
		addCommandLineCommandBuildAction: '$(WBT_C_LINK_EXECUTABLE)'
			inputFiles: executableProgram allObjectFiles outputFile: executableProgram outputFileReference
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedLanguage >> createIntermediateObjectFilesFor: sourceFile [
	| sourceRelativeFileRef objectFileRelativeFileRef objectFileReference |
	sourceRelativeFileRef := sourceFile relativeFileReference.
	objectFileRelativeFileRef := sourceRelativeFileRef parent / (sourceFile platform formatObjectFileName: sourceRelativeFileRef basename).
	objectFileReference := (sourceFile package validBuildObjectDirectory resolve: objectFileRelativeFileRef) asAbsolute canonicalize.
	^ {WBTFileTarget new
		language: WBTObjectFileLanguage uniqueInstance;
		relativeFileReference: objectFileRelativeFileRef;
		fileReference: objectFileReference;
		addBuildAction: (sourceFile package newCommandLineCommandBuildAction: self buildActionCommand inputFiles: {sourceFile} outputFile: objectFileReference);
		yourself}
]
