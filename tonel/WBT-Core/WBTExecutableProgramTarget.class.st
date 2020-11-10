Class {
	#name : #WBTExecutableProgramTarget,
	#superclass : #WBTModuleTarget,
	#category : #'WBT-Core-Targets'
}

{ #category : #'as yet unclassified' }
WBTExecutableProgramTarget >> executeAndReadStdout [
	^ self buildEnvironment executeCommandAndReadStdout: ('cd "{1}" && {2}' format: {self outputFileReference parent fullName . self outputFileReference fullName})
]

{ #category : #testing }
WBTExecutableProgramTarget >> isExecutableProgram [
	^ true
]

{ #category : #'as yet unclassified' }
WBTExecutableProgramTarget >> outputFileName [
	^ self platform formatExecutableFileName: name
]

{ #category : #'as yet unclassified' }
WBTExecutableProgramTarget >> selectBuildAction [
	self validLinkerLanguage createBuildActionForExecutableProgram: self
]
