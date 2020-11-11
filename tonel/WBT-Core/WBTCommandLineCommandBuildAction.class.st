Class {
	#name : #WBTCommandLineCommandBuildAction,
	#superclass : #WBTBuildAction,
	#instVars : [
		'inputFiles',
		'outputFiles',
		'command',
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
	^ (self buildEnvironment executeCommandLineCommand: formattedCommand) = 0
]

{ #category : #formatting }
WBTCommandLineCommandBuildAction >> formattedCommand [
	^ command wbtSubstituteVariablesWith: [ :varName |
		self variableEnvironment substitutionForVariable: varName
	]
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
