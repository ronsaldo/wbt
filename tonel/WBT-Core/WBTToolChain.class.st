Class {
	#name : #WBTToolChain,
	#superclass : #Object,
	#classVars : [
		'ClangIsPresent',
		'LLCIsPresent',
		'LastLLCAndClangSessionCheck'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #utilities }
WBTToolChain class >> checkLLCAndClangPresence [
	LastLLCAndClangSessionCheck == Smalltalk session ifTrue: [ ^ self ].

	LLCIsPresent := (LibC resultOfCommand: self llcProgram  , ' --version') isNotEmpty.
	ClangIsPresent := (LibC resultOfCommand: self clangProgram  , ' --version') isNotEmpty.
	LastLLCAndClangSessionCheck := Smalltalk session

]

{ #category : #utilities }
WBTToolChain class >> clangProgram [
	| clangProgram |
	clangProgram := OSEnvironment current at: 'CLANG' ifAbsent: [nil].
	clangProgram ifNil: [
		(Smalltalk os isWin32 or: [ Smalltalk os isWin64 ]) ifTrue: [
			clangProgram := 'clang.exe'
		].
	
		clangProgram ifNil: [ clangProgram := 'clang' ].
	].

	^ clangProgram
]

{ #category : #utilities }
WBTToolChain class >> hasClang [
	self checkLLCAndClangPresence.
	^ ClangIsPresent
]

{ #category : #utilities }
WBTToolChain class >> hasLLC [
	self checkLLCAndClangPresence.
	^ LLCIsPresent
]

{ #category : #construction }
WBTToolChain class >> linuxClang [
	^ self unixClang
		rpathLocalLinkerArgument: '-Wl,-rpath=.';
		yourself
]

{ #category : #construction }
WBTToolChain class >> linuxGCC [
	^ self unixGCC
		rpathLocalLinkerArgument: '-Wl,-rpath=.';
		yourself
]

{ #category : #utilities }
WBTToolChain class >> llcProgram [
	| llcProgram |
	llcProgram := OSEnvironment current at: 'LLC' ifAbsent: [nil].
	llcProgram ifNil: [
		(Smalltalk os isWin32 or: [ Smalltalk os isWin64 ]) ifTrue: [
			llcProgram := 'llc.exe'
		].
	
		llcProgram ifNil: [llcProgram := 'llc']
	].

	^ llcProgram
]

{ #category : #construction }
WBTToolChain class >> osxClang [
	^ self unixClang
]

{ #category : #construction }
WBTToolChain class >> unixClang [
	^ WBTUnixStyleCommandLineToolChain new setForClang
]

{ #category : #construction }
WBTToolChain class >> unixGCC [
	^ WBTUnixStyleCommandLineToolChain new setForGCC
]

{ #category : #construction }
WBTToolChain class >> windowsClang [
	^ WBTUnixStyleCommandLineToolChain new setForWindowsClang
]

{ #category : #construction }
WBTToolChain class >> windowsClangCL [
	^ WBTMSVCStyleCommandLineToolChain new setForClangCL
]

{ #category : #construction }
WBTToolChain class >> windowsMSVC [
	^ WBTMSVCStyleCommandLineToolChain new setForMSVC
]

{ #category : #testing }
WBTToolChain >> isCommandLineToolChain [
	^ false
]

{ #category : #testing }
WBTToolChain >> isMSVCStyle [
	^ false
]

{ #category : #testing }
WBTToolChain >> isUnixStyle [
	^ false
]

{ #category : #'as yet unclassified' }
WBTToolChain >> substitutionVariables [
	^ #()
]

{ #category : #'as yet unclassified' }
WBTToolChain >> substitutionVariablesForPlatform: aPlatform [
	^ self substitutionVariables
]
