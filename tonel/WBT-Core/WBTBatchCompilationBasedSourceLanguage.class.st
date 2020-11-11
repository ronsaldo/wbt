Class {
	#name : #WBTBatchCompilationBasedSourceLanguage,
	#superclass : #WBTBatchCompilationBasedLanguage,
	#category : #'WBT-Core-Language'
}

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedSourceLanguage >> buildActionCommand [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WBTBatchCompilationBasedSourceLanguage >> createIntermediateObjectFilesFor: sourceFile module: targetModule [
	| sourceRelativeFileRef objectFileRelativeFileRef objectFileReference |
	sourceRelativeFileRef := sourceFile relativeFileReference.
	objectFileRelativeFileRef := sourceRelativeFileRef parent / (sourceFile platform formatObjectFileName: sourceRelativeFileRef basename).
	objectFileReference := (sourceFile package validBuildObjectDirectory resolve: objectFileRelativeFileRef) asAbsolute canonicalize.

	targetModule addIntermediateObjectFile: (WBTFileTarget new
		language: WBTObjectFileLanguage uniqueInstance;
		relativeFileReference: objectFileRelativeFileRef;
		fileReference: objectFileReference;
		addDependency: sourceFile;
		addBuildAction: (sourceFile package newCommandLineCommandBuildAction: self buildActionCommand inputFiles: {sourceFile} outputFile: objectFileReference
		variables: {
			#WBT_POSITION_INDEPENDENT_CODE_ENABLED . [targetModule requiresPositionIndependentCode
				ifTrue: [ 'YES' ]
				ifFalse: [ 'NO' ] ]
		});
		yourself)

]
