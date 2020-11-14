Class {
	#name : #WBTCommandLineCommandBuildAction,
	#superclass : #WBTBuildAction,
	#instVars : [
		'inputFiles',
		'outputFiles',
		'command',
		'workingDirectory',
		'variableEnvironment'
	],
	#category : #'WBT-Core-Actions'
}

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> command [
	^ command
]

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> command: anObject [
	command := anObject
]

{ #category : #execution }
WBTCommandLineCommandBuildAction >> ensureInputFilesExists [
	self inputFiles do: [ :each |
		each asFileReference exists ifFalse: [ 
			(self error: 'Required input file {1} does not exist.' format: {each asFileReference fullName})
		]
	]
]

{ #category : #execution }
WBTCommandLineCommandBuildAction >> ensureOutputDirectoryExists [
	self outputFiles do: [ :each |
		each asFileReference parent ensureCreateDirectory
	]
]

{ #category : #execution }
WBTCommandLineCommandBuildAction >> execute [
	| formattedCommand |
	self ensureInputFilesExists.
	self ensureOutputDirectoryExists.
	formattedCommand := self formattedCommand.
	self assert: formattedCommand isNotEmpty.
	^ (self buildEnvironment executeCommandLineCommand: formattedCommand inDirectory: self workingDirectory) = 0
]

{ #category : #formatting }
WBTCommandLineCommandBuildAction >> formattedCommand [
	^ (command wbtSubstituteVariablesWith: [ :varName |
		self variableEnvironment substitutionForVariable: varName
	]) withUnixLineEndings copyReplaceAll: String lf with: String space
]

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> inputFiles [
	^ inputFiles ifNil: [ ^ #() ]
]

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> inputFiles: anObject [
	inputFiles := anObject
]

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> outputFiles [
	^ outputFiles ifNil: [ outputFiles := #() ]
]

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> outputFiles: anObject [
	outputFiles := anObject
]

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> variableEnvironment [
	^ variableEnvironment ifNil: [ variableEnvironment := WBTVariableSubstitutionEnvironment empty ]
]

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> variableEnvironment: anObject [
	variableEnvironment := anObject
]

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> workingDirectory [
	^ workingDirectory ifNil: [
		inputFiles
			ifEmpty: [ FileSystem workingDirectory ]
			ifNotEmpty: [ inputFiles first asFileReference parent ]
		]
]

{ #category : #accessing }
WBTCommandLineCommandBuildAction >> workingDirectory: anObject [
	workingDirectory := anObject
]
