Class {
	#name : #WBTToolChain,
	#superclass : #WBTObject,
	#classVars : [
		'ClangIsPresent',
		'LLCIsPresent',
		'LastLLCAndClangSessionCheck'
	],
	#category : #'WBT-Core-Environment'
}

{ #category : #utilities }
WBTToolChain class >> checkLLVMPresence [
	"LastLLCAndClangSessionCheck := nil"
	LastLLCAndClangSessionCheck == Smalltalk session ifTrue: [ ^ self ].

	LLCIsPresent := (LibC resultOfCommand: self llcProgram  , ' --version') isNotEmpty.
	ClangIsPresent := (LibC resultOfCommand: self clangProgram  , ' --version') isNotEmpty.
	LastLLCAndClangSessionCheck := Smalltalk session.

]

{ #category : #utilities }
WBTToolChain class >> clangCLProgram [
	^ OSEnvironment current at: 'CLANG_CL' ifAbsent: [ self computeLLVMProgramNameFor: 'clang-cl' ]

]

{ #category : #utilities }
WBTToolChain class >> clangProgram [
	^ OSEnvironment current at: 'CLANG' ifAbsent: [ self computeLLVMProgramNameFor: 'clang' ]

]

{ #category : #utilities }
WBTToolChain class >> clangppProgram [
	^ OSEnvironment current at: 'CLANGPP' ifAbsent: [ self computeLLVMProgramNameFor: 'clang++' ]
]

{ #category : #utilities }
WBTToolChain class >> cmakeProgram [
	| program |
	(Smalltalk os isWin32 or: [ Smalltalk os isWin64 ]) ifTrue: [
		program := 'cmake.exe'.
		('c:\Program Files\CMake\bin\' , program) asFileReference exists ifTrue: [ 
			program := '"' , 'c:\Program Files\CMake\bin\' , program , '"'
		]
	].

	program ifNil: [ program := 'cmake' ].
	^ program

]

{ #category : #utilities }
WBTToolChain class >> computeLLVMProgramNameFor: programName [
	| program |
	(Smalltalk os isWin32 or: [ Smalltalk os isWin64 ]) ifTrue: [
		program := programName , '.exe'.
		('c:\Program Files\LLVM\bin\' , program) asFileReference exists ifTrue: [ 
			program := '"' , 'c:\Program Files\LLVM\bin\' , program , '"'
		]
	].

	program ifNil: [ program := programName ].
	^ program

]

{ #category : #utilities }
WBTToolChain class >> hasClang [
	self checkLLVMPresence.
	^ ClangIsPresent
]

{ #category : #utilities }
WBTToolChain class >> hasLLC [
	self checkLLVMPresence.
	^ LLCIsPresent
]

{ #category : #utilities }
WBTToolChain class >> ldlldProgram [
	^ OSEnvironment current at: 'LD_LLD' ifAbsent: [ self computeLLVMProgramNameFor: 'ld.lld' ]
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
	^ OSEnvironment current at: 'LLC' ifAbsent: [
		Smalltalk os isLinux ifTrue: [ 
			self computeLLVMProgramNameFor: 'llc-10'
		] ifFalse: [
			self computeLLVMProgramNameFor: 'llc'
		]
	]
]

{ #category : #utilities }
WBTToolChain class >> lldLinkProgram [
	^ OSEnvironment current at: 'LLD_LINK' ifAbsent: [ self computeLLVMProgramNameFor: 'lld-link' ]
]

{ #category : #utilities }
WBTToolChain class >> lldProgram [
	^ OSEnvironment current at: 'LLD' ifAbsent: [ self computeLLVMProgramNameFor: 'lld' ]
]

{ #category : #'as yet unclassified' }
WBTToolChain class >> llvmObjcopyProgram [
	^ self computeLLVMProgramNameFor: 'llvm-objcopy'
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

{ #category : #construction }
WBTToolChain class >> windowsMSVC_LLD [
	^ WBTMSVCStyleCommandLineToolChain new setForMSVC_LLD
]

{ #category : #adding }
WBTToolChain >> addBuildActionsForLinkingDynamicLibrary: dynamicLibrary withLanguage: language [
	self subclassResponsibility
]

{ #category : #adding }
WBTToolChain >> addBuildActionsForLinkingExecutableProgram: executableProgram withLanguage: language [
	self subclassResponsibility
]

{ #category : #adding }
WBTToolChain >> addBuildActionsForLinkingStaticLibrary: staticLibrary withLanguage: language [
	self subclassResponsibility
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
	^ self substitutionVariables , { 
		#WBT_BUILD_MODE . [aPlatform environment buildMode asUppercase].
		#WBT_CMAKE_BUILD_MODE . [ aPlatform environment buildMode first asUppercase asString, aPlatform environment buildMode allButFirst ]
	}
]
