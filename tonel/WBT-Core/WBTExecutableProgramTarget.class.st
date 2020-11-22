Class {
	#name : #WBTExecutableProgramTarget,
	#superclass : #WBTModuleTarget,
	#category : #'WBT-Core-Targets'
}

{ #category : #'as yet unclassified' }
WBTExecutableProgramTarget >> executeAndReadStdout [
	^ self buildEnvironment executeCommandAndReadStdout: self programExecutionScript
]

{ #category : #'as yet unclassified' }
WBTExecutableProgramTarget >> executeSilently [
	^ self buildEnvironment executeCommandSilently: self programExecutionScript
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
WBTExecutableProgramTarget >> programExecutionScript [
	^ 'cd "{1}" && {2}' format: {self outputFileReference parent fullName . self outputFileReference fullName}
]

{ #category : #'as yet unclassified' }
WBTExecutableProgramTarget >> selectBuildAction [
	self validLinkerLanguage createBuildActionForExecutableProgram: self
]

{ #category : #'as yet unclassified' }
WBTExecutableProgramTarget >> win32Subsystem [
	^ self propertyAt: #win32Subsystem ifAbsentPut: [ #CONSOLE ]
]

{ #category : #'as yet unclassified' }
WBTExecutableProgramTarget >> win32Subsystem: newSubsystemName [
	^ self propertyAt: #win32Subsystem put: newSubsystemName
]
